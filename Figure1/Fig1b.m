%% To produce fig 1a, you need to run tmi on all single subject datasets as follows

K=5;
learn_z = 0.005;learn_the = 0.005;max_steps= 2e6,min_fitting=0;min_gradients = 1e-4;
[z,th,kl_tmi] = TMI(x,K,1,learn_z, learn_the,max_steps,min_fitting,min_gradients);