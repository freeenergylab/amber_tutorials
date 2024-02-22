## refer to https://pymol.org/tutorials/moviemaking/
mset 1x800
mview store, 1, state=1, object=prods_solute_rms
mview store, 800, state=800, object=prods_solute_rms
# Workaround for a known bug (otherwise molecule might disappear when playing the movie):
rebuild
intra_fit prods_solute_rms
smooth
