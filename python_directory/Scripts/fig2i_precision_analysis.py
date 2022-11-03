import numpy as np 
from my_functions import *
import scipy.io as spio


folder_direct = "/blue/pdixit/mayar.shahin/Microbiome/Nature_Comm/GLV_runs/"

const_K = True ################# Change this for constan/oscillating carrying capacities#################

if const_K==True:
    folder_sub = "GLV_no_sparsity/basetruth_filteration/const_K/"
    state = "const"
    tscale = 10
else:
    folder_sub = "GLV_no_sparsity/basetruth_filteration/osc_K/"
    state = "osc"
    tscale = 1


reps = 20 
nReads =  [1000,2500,5000,10000]
Klist = [3]
nT = 30





for nread in nReads:
    
    filename = folder_direct + folder_sub + "GLV_" + str(reps) + "_reps_" + state + "_K" + str(nT*tscale)+ "_days_" + str(nread)

    filename2 = filename+ '_' + str(2)

    data = spio.loadmat(filename+".mat")
    data = data['sampling_list'][0]
    data2 = spio.loadmat(filename2+".mat")
    data2 = data2['sampling_list'][0]
    for a, K in enumerate(Klist):

        JSD = np.zeros((reps,3))
        MSE = np.zeros((reps,3))
        for rep in range(reps):
    

            x1 = data[rep]
            x2 = data2[rep]
            print(x1.shape)
            print(x2.shape)
            print(K)
            
            #Run EMBED
            z,th, kl  = TMI(x1,K,lr_z=0.05, lr_th=0.05, max_iter=10000,min_fitting = 0, min_gradients=1e-3)
            z2,th2, kl2 = TMI(x2,K,lr_z=0.05, lr_th=0.05, max_iter=10000,min_fitting = 0, min_gradients=1e-3)

            recons_tmi1 = q(z,th)
            recons_tmi2 = q(z2,th2)

            JSD_tmi = JS_Div(recons_tmi1,recons_tmi2)
            MSE_tmi = np.mean(np.sum((recons_tmi1-recons_tmi2)**2,axis = 0))

            #Run CTF
            u1,s1,v1, KL_ctf1, recons_ctf1 = ctf(x1,K)
            u2,s2,v2, KL_ctf2, recons_ctf2 = ctf(x2,K)

            JSD_ctf = JS_Div(recons_ctf1,recons_ctf2)
            MSE_ctf = np.mean(np.sum((recons_ctf1-recons_ctf2)**2,axis = 0))

            #Run Lasso
            print(f'For rep: {rep}')
            print(f'read depth: {nread}')
            print('Lambda is')
            recons_lasso1 = my_lasso(x1,K,nread)
            recons_lasso2 = my_lasso(x2,K,nread)
            print(recons_lasso1)
            print(recons_lasso2)
            JSD_lasso = JS_Div(recons_lasso1,recons_lasso2)
            MSE_lasso = np.mean(np.sum((recons_lasso1-recons_lasso2)**2,axis = 0))


            JSD[rep,:] = [JSD_tmi,JSD_ctf,JSD_lasso]
            MSE[rep,:] = [MSE_tmi,MSE_ctf,MSE_lasso]      


        dict= {'JSD':JSD, 'MSE':MSE}



        filename = folder_direct + folder_sub + "GLV_" + str(reps) + "_reps_" + state + "_K"+  str(nT*tscale)+ "_days_" + str(nread)
        filename_result = filename + f'_tmi_ctf_K{K}_precision_results.mat'

        spio.savemat(filename_result, dict)




