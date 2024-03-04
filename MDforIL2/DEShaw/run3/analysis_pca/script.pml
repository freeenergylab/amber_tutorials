load projection_mode1.pdb, pc1
run modevectors.py
split_states pc1, 1, 041
modevectors pc1_0001, pc1_0041, cutoff=.0, head_length=2, head=0.4, headrgb=(1,.2,.1), tailrgb=(1,.2,.1), notail=0
set cartoon_trace, 1
set cartoon_tube_radius, 0.3
cmd.disable('all')
cmd.enable('pc1_0001', 1)
cmd.enable('modevectors', 1)
set ray_shadow, 0
save PCA_pc1_Porcupine_plot.pse, format=pse
