"""
This module contains code useful for parsing energy terms out of an mdout file
and exposing the data (numpy arrays) for various analyses. It will also figure
out what kind of simulation is being run based on the input variables

It does NOT do:

   o  Store decomp data when idecomp != 0
"""

from .dataset import DataSet
import numpy as np
import os
import re
import warnings

#~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~

class MdoutError(Exception):
   def __init__(self, msg='Mdout error!'):
      self.msg = msg
   def __str__(self):
      return self.msg

#~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~

class AmberMdout(object):
   """ Class for Mdout object """
   # If we don't know how many terms we have, just make it a million, since
   # that's (should be!) more data than we could possibly have. We can reshape
   # it afterwards
   UNKNOWN = 1000000

   #================================================

   def __init__(self, filename, numexchg=0):
      # Make sure our file exists first of all
      if not os.path.exists(filename):
         raise MdoutError('%s does not exist!' % filename)
      self.filename = filename # File name of mdout file
      self.data = {}           # Dict that matches mdout term names to arrays
      self.properties = {}     # List of input variables with their values
      self.get_properties()    # Get properties of output file
      keys = list(self.properties.keys())
      # Figure out if we're a minimization or an MD
      if 'imin' in keys:
         self.is_md = self.properties['imin'] == 0 # This is MD iff imin == 0
         self.is_min = not self.is_md
      else:
         self.is_min = True
         self.is_md = False

      # Figure out if we're a restart or not
      if 'irest' in keys:
         self.is_restart = self.properties['irest'] != 0
      else:
         self.is_restart = False

      # Determine how many steps we've done
      if (self.is_min and 'maxcyc' in keys)or(self.is_md and 'nstlim' in keys):
         if self.is_min:
            self.num_steps = max(self.properties['maxcyc'], 1)
         if self.is_md:
            self.num_steps = self.properties['nstlim']
            if 'numexchg' in keys:
               self.num_steps *= self.properties['numexchg']
            elif numexchg:
               self.num_steps *= numexchg
         # If maxcyc and nstlim are in properties, then ntpr HAS to be
         self.num_terms = int(self.num_steps // self.properties['ntpr']) + 1
         # Now adjust if imin == 5
         if self.properties['imin'] == 5:
            self.num_steps *= self._get_imin5_nsteps()
            self.num_terms *= self._get_imin5_nsteps()
         # For restart, we don't have that extra term at the beginning
         if self.is_restart or (self.is_min and self.properties['maxcyc'] <= 1):
            self.num_terms -= 1
      else:
         if self.properties['imin'] == 5:
            self.num_steps = self.num_terms = self._get_imin5_nsteps()
         else:
            self.num_steps = AmberMdout.UNKNOWN
            self.num_terms = AmberMdout.UNKNOWN
      self.get_data()

   #================================================

   def get_properties(self):
      """ Searches through and finds properties """
      fl = open(self.filename, 'r')
      rawline = fl.readline()
      get_prop = re.compile(r"""(\w+ *= *[\w\.'"]+),*""")
      amber_comment = re.compile(r'^\|')
      while rawline:
         # Get up to where we want to go
         if rawline[:35] != '   2.  CONTROL  DATA  FOR  THE  RUN':
            rawline = fl.readline()
            continue
         # Skip over comments
         if amber_comment.match(rawline):
            rawline = fl.readline()
            continue
         # Now we start reading in the
         while rawline:
            # If we've reached the end, stop
            if rawline[:40] == '   3.  ATOMIC COORDINATES AND VELOCITIES':
               break
            # Ignore amber comments
            if amber_comment.match(rawline):
               rawline = fl.readline()
               continue
            items = get_prop.findall(rawline)
            # Now get all of the individual items and add them to the prop dict
            for item in items:
               var, val = item.split('=')
               var, val = var.strip(), val.strip()
               # See if we can make it an int, then a float, or just a string
               try:
                  self.properties[var] = int(val)
               except ValueError:
                  # Now try float
                  try:
                     self.properties[var] = float(val)
                  except ValueError:
                     # Finally, it's just a string
                     self.properties[var] = str(val)
               # end except
            # Get the next line
            rawline = fl.readline()
         # We only reach here if we broke out of the while loop above
         break
      # end while rawline
      # Close out the file now
      fl.close()

   #================================================

   def get_data(self):
      """ Extracts the data from the mdout file """
      energy_fields = re.compile(r'([A-Za-z\(\) 0-9\-\.\/\#]+ *= *\-*\d*[.\d]*(?:E[+-]*\d+)?)')
      if self.is_md:
         start_of_record = energy_fields
         ignore_record = re.compile(r'^      A V E R A G E S   O V E R|^      R M S  F L U C T U A T I O N S|^      DV/DL, AVERAGES OVER')
      elif self.is_min:
         start_of_record = re.compile(r'^   NSTEP       ENERGY          RMS            GMAX         NAME    NUMBER')
         if self.properties['imin'] == 1:
            ignore_record = re.compile(r'^                    FINAL RESULTS')
         else:
            # imin == 5, don't ignore any records
            ignore_record = Exception()
            setattr(ignore_record, 'match', lambda *args, **kwargs: False)
      fl = open(self.filename, 'r')
      rawline = fl.readline()
      first_record_done = False
      num_record = 0
      ignore_this_record = False
      ignore_next_record = False
      n_omitted = 0

      while rawline:
         # First find the Results section
         if rawline[:14] != '   4.  RESULTS':
            rawline = fl.readline()
            continue
         # Now that we've found our results section, start parsing it
         while rawline and rawline[:14] != '   5.  TIMINGS':
            # See if we hit a line that says we need to ignore the next group
            # of terms. We construct it like this since there are blank lines
            # between the ignore marker and the terms, so once the re.match
            # becomes true (and toggles ignore_this_record to True), we don't
            # want future misses of this re.match to turn this to False. All
            # is set well for the next record by setting ignore_this_record to
            # False at the end of the while loop
            if rawline[0] == '|':
               rawline = fl.readline()
               continue
            # See if we found the start of the record
            items = start_of_record.findall(rawline)
            # If items is blank, read the next line and continue
            if not items:
               rawline = fl.readline()
               continue
            # If we are doing a minimization, the format is different -- the
            # starting line is by itself, and their values are right below them
            used_terms = []
            if self.is_min:
               terms = items[0].split()
               term_vals = fl.readline().split()
               for i, term in enumerate(terms):
                  # Skip over NAME since it has no value
                  if term == 'NAME': continue
                  if not ignore_this_record:
                     try:
                        self.data[term].add_value(float(term_vals[i]))
                     except KeyError:
                        self.data[term] = np.zeros(self.num_terms).view(DataSet)
                        self.data[term].add_value(float(term_vals[i]))
                     used_terms.append(term)
               # Eat the next line (it's blank)
               fl.readline()
               # The next line has stuff on it
               rawline = fl.readline()
               items = energy_fields.findall(rawline)
            # Now if we've found a record, cycle through it
            try:
               while items:
                  # Load the items into their respective places in the data dict
                  for item in items:
                     term, term_val = item.split('=')
                     term, term_val = term.strip(), term_val.strip()
                     if term in used_terms:
                        raise StopIteration
                     else:
                        used_terms.append(term)
                     # If we're on our first one, we need to create the data array
                     if not ignore_this_record:
                        try:
                           self.data[term].add_value(float(term_val))
                        except KeyError:
                           self.data[term] = np.zeros(self.num_terms).view(DataSet)
                           self.data[term].add_value(float(term_val))
                        except Exception as err:
                           n_omitted += 1
                  # Now we're done with the terms, get the next line
                  rawline = fl.readline()
                  items = energy_fields.findall(rawline)
                  while not items and rawline[:14] != '   5.  TIMINGS':
                     if self.is_min and start_of_record.findall(rawline):
                        raise StopIteration
                     rawline = fl.readline()
                     if not rawline:
                        raise StopIteration
                     ignore_next_record = (ignore_next_record or
                                           bool(ignore_record.match(rawline)))
                     items = energy_fields.findall(rawline)
            except StopIteration:
               pass
            # We do not want to off-hand ignore the next record
            ignore_this_record = ignore_next_record
            ignore_next_record = False
#           rawline = fl.readline()
         # end while rawline and rawline[:14] != '   5.  TIMINGS':
         # Once we get here, we're done.
         break
      # end while rawline
      # Our num_record has been incremented past the last entry, so it should
      # be accurate if we're indexing from 1 (i.e. it should reflect the full
      # size of each data array). In cases where we didn't know how many terms
      # to start with, or when simulations didn't finish, we resize/reshape the
      # arrays to remove extra zeros
      for key in list(self.data.keys()):
         self.data[key] = self.data[key].truncate()
         # Update the number of terms and the number of steps
      self.num_terms = len(self.data[list(self.data.keys())[0]])
      if 'ntpr' in self.properties:
         self.num_steps = self.num_terms * self.properties['ntpr']

      if n_omitted > 0:
         warnings.warn(('Omitted %d data points (%d total data fields) '
                        'at the end of %s!') % (n_omitted, len(self.data),
                       self.filename))

   #================================================

   def __iadd__(self, other):
      """ In-place addition -- concatenate data from one mdout to another """
      # Compare the keys to make sure they're the same
      selfkeys, otherkeys = list(self.data.keys()), list(other.data.keys())
      selfkeys.sort()
      otherkeys.sort()
      # Find out how many terms we have (it's not always num_terms...)
      size1, size2 = len(self.data[selfkeys[0]]), len(other.data[otherkeys[0]])
      if selfkeys != otherkeys:
         raise TypeError('Mismatch in data keys. Incompatible AmberMdouts!')
      # Create a new array that's as big as the other 2 together, then copy
      # them both into that new array one after another. Then put it into
      # self.data[key] to complete the in-place addition
      for key in selfkeys:
         tmp = np.zeros(size1 + size2).view(DataSet)
         for i, j in enumerate(self.data[key]): tmp[i] = j
         for i, j in enumerate(other.data[key]): tmp[i+size1] = j
         self.data[key] = tmp
      # Update or num_terms
      self.num_terms += other.num_terms
      self.num_steps += other.num_steps

      return self

   #================================================

   def _get_imin5_nsteps(self):
      """ Get the total number of steps if imin == 5 """
      # Cache the result so we don't have to keep
      try:
         return self._nsets
      except AttributeError:
         pass
      fl = open(self.filename, 'r')
      self._nsets = 0
      for line in fl:
         if line.startswith('minimizing coord set #'):
            self._nsets += 1
      fl.close()
      if self._nsets == 0:
         raise MdoutError('Could not find number of frames for imin=5!')
      return self._nsets


if __name__ == '__main__':
   """ Test our code """
   from optparse import OptionParser
   from subprocess import Popen
   import sys
   parser = OptionParser()
   parser.add_option('--mdout', dest='mdout', help='Input mdout to analyze',
                     default=None)
   parser.add_option('--next-mdout', dest='mdout2', default=None,
                     help='A second mdout to test in-place addition')
   parser.add_option('--check-file', dest='check', default=None,
                     help='Output file to check diff against.')
   opt, args = parser.parse_args()
   if not opt.mdout:
      parser.print_help()
      quit()

   # Redirect all stdout to here
   if opt.check: sys.stdout = open('__mdoutcheck__', 'w')

   my_mdout = AmberMdout(opt.mdout)
   longest_option = max([len(it) for it in list(my_mdout.properties.keys())])
   print('Testing get_properties() (Check with mdout file)')
   print(('-'*longest_option + '------------'))
   for prop in list(my_mdout.properties.keys()):
      print(('  %%%ds | %%s' % longest_option % (prop, my_mdout.properties[prop])))

   print('')
   if my_mdout.is_md:
      print('This mdout file is a MOLECULAR DYNAMICS calculation')
   if my_mdout.is_min:
      print('This mdout file is a MINIMIZATION calculation')
   if my_mdout.is_restart:
      print('This mdout file is from a RESTARTED simulation')
   if not my_mdout.is_restart:
      print('This mdout file is NOT a restarted simulation')

   print('Testing get_data()')
   print(('Found data keys:', ', '.join(list(my_mdout.data.keys()))))
   print('Averages of each are:')
   keys = list(my_mdout.data.keys())
   keys.sort()
   for key in keys:
      print(('   %10s : %15.4f' % (key, np.average(my_mdout.data[key]))))

   # Test the in-place addition
   if opt.mdout2:
      print('Testing __iadd__:')
      my_mdout += AmberMdout(opt.mdout2)

      for key in keys:
         print(('   %10s : %15.4f' % (key, np.average(my_mdout.data[key]))))

   print('\nDone testing.')

   # Close our stdout if we opened something in its place
   if sys.stdout != sys.__stdout__: sys.stdout.close()

   # Now we diff the checks, but only if we were given a check file
   if not opt.check: sys.exit(0)
   # First restore stdout
   sys.stdout = sys.__stdout__
   # Next, open a diff process
   process = Popen(['diff', '__mdoutcheck__', opt.check])
   if process.wait():
      print('TEST FAILED')
   else:
      print('TEST PASSED. yay')
      os.remove('__mdoutcheck__')
