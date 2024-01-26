# refer to this website: https://salilab.org/modeller/wiki/Missing_residues
from modeller import *
from modeller.automodel import *    # Load the AutoModel class

log.verbose()
env = Environ()

# directories for input atom files
env.io.atom_files_directory = ['.', '../atom_files']

# Because either AutoModel or LoopModel will build a comparative model using your input PDB as a template, potentially all of the atoms in your final model could move. If you really don't want the non-missing residues to move, you can override the select_atoms method to select only the missing residues with a script similar to that below (note that the residue numbers are off by 1, since Modeller numbers the model starting at 1 in chain A, while the original PDB started numbering at 2):
class MyModel(LoopModel):
    def select_atoms(self):
        return Selection(self.residue_range('27:A', '28:A'),
                         self.residue_range('69:A', '72:A'),
                         self.residue_range('74:A', '75:A'),
                         self.residue_range('93:A', '94:A'))

a = MyModel(env, alnfile = 'alignment.ali',
            knowns = '1PY2_amber', sequence = '1PY2_amber_fill')
a.starting_model= 1
a.ending_model  = 1

a.loop.starting_model = 1
a.loop.ending_model   = 2
a.loop.md_level       = refine.fast

a.make()
