# Python Scripts Directory 
* my_functions and my_fuctions_gemelli have all source functions needed to produce GLV simulations and run CTF, EMBED and Lasso
* run_GLV_sim.py is used to make 50 glv simulations, filters out noisy OTUs at 0.1% mean abundance cutoff, and samples at 1000,2500,5000,10000 sequencing depths and save the data.
const_K can be changed to false for oscillating cararrying capacities in the simulations.
Different parameters can be changed but might affect stability
* run_tmi_on_* runs the data fitting part of EMBED, without the reorientation of the ECNs and the loadings.
* run_lasso_* runs Lasso with a lagrange multiplier lambda that is tuned such that the number of parameters in the model is equal to the number in EMBED K*(O+T).
