## refer to https://pymol.org/tutorials/moviemaking/
mset 1x1000
mview store, 1, state=1, object=prod-2_solute_rms
mview store, 1000, state=1000, object=prod-2_solute_rms
# Workaround for a known bug (otherwise molecule might disappear when playing the movie):
rebuild
intra_fit prod-2_solute_rms
smooth