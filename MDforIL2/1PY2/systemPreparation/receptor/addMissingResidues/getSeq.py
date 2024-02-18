# refer to this website: https://salilab.org/modeller/wiki/Missing_residues
from modeller import *
# Get the sequence of the PDB file, and write to an alignment file
code = '1PY2_amber'

e = Environ()
m = Model(e, file=code+'.pdb')
aln = Alignment(e)
aln.append_model(m, align_codes=code)
aln.write(file=code+'.seq')
