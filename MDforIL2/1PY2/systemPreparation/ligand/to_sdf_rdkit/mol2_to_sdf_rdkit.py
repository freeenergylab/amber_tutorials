import rdkit.Chem as Chem 
from rdkit.Chem import AllChem, Draw

rmol = Chem.MolFromMol2File('SP4206_sybyl.mol2', removeHs=False)
w = Chem.SDWriter('SP4206.sdf')
w.write(rmol)
w.close()

AllChem.Compute2DCoords(rmol, canonOrient=True)
drawer = Draw.rdMolDraw2D.MolDraw2DSVG(600, 600)
drawer.DrawMolecule(rmol)
drawer.FinishDrawing()
svg = drawer.GetDrawingText().replace('svg:', '')
with open('SP4206_2D.svg', 'w') as outfile:
    outfile.write(svg)
