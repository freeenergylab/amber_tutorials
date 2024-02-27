import rdkit.Chem as Chem 
from rdkit.Chem import AllChem, Draw

rmol = Chem.MolFromMol2File('IXO_ligand_sybyl.mol2', removeHs=False)
w = Chem.SDWriter('IXO_ligand.sdf')
w.write(rmol)
w.close()

AllChem.Compute2DCoords(rmol, canonOrient=True)
drawer = Draw.rdMolDraw2D.MolDraw2DSVG(600, 600)
drawer.DrawMolecule(rmol)
drawer.FinishDrawing()
svg = drawer.GetDrawingText().replace('svg:', '')
with open('IXO_ligand_2D.svg', 'w') as outfile:
    outfile.write(svg)
