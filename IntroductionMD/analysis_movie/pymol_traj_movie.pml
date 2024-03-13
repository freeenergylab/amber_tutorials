load prod_solute_rms.pdb

A/preset/pretty
S/side chain/sticks
H/hydrogens/all

## refer to https://pymol.org/tutorials/moviemaking/
mset 1x201
mview store, 1, state=1, object=prod_solute_rms
mview store, 201, state=201, object=prod_solute_rms
# Workaround for a known bug (otherwise molecule might disappear when playing the movie):
rebuild
intra_fit prod_solute_rms
smooth

one_letter ={'VAL':'V', 'ILE':'I', 'LEU':'L', 'GLU':'E', 'GLN':'Q', \
'ASP':'D', 'ASN':'N', 'HIS':'H', 'TRP':'W', 'PHE':'F', 'TYR':'Y',    \
'ARG':'R', 'LYS':'K', 'SER':'S', 'THR':'T', 'MET':'M', 'ALA':'A',    \
'GLY':'G', 'PRO':'P', 'CYS':'C'}
label n. ca, one_letter[resn]
