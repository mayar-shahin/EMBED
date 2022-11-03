import numpy as np 
from my_functions import * 
import scipy.io as spio
import sys, os
from my_functions_gemelli import * 
import warnings
warnings.filterwarnings("ignore")


folder_direct = "../Data/real_data/"
K = int(sys.argv[1])


subject = str(sys.argv[2]) ################# Change this for different data sets #####
if subject=='Humans':
    folder_sub = "Humans/"
    state = "Humans"
    ds_names = ['capF4','capM3','humD','humE','humF','davA','davB']

elif subject=='Mice':
    folder_sub = "Mice/"
    state = "Mice"
    ds_names = ['carm_hf1', 'carm_hf2','carm_hf3','carm_lf1','carm_lf2','carm_lf3']




for d,dataset in enumerate(ds_names):
    reconstructions=[]
    U=[]
    S=[]
    V=[]
    filename = folder_direct + folder_sub + dataset + '.mat'
    data = spio.loadmat(filename)
    x = data['x']
    x = x/np.sum(x,axis=0)
    print(x.shape)
    #CTF  
    
    u,s,v, _, recons_ctf = ctf(x,K)    
    reconstructions.append(recons_ctf)
    U.append(u)
    S.append(s)
    V.append(v)

    
    dict= {'CTF_recon':reconstructions, 'U':U,'S': S,'V':V}

    folder_direct_res = "../Results/real/ctf/K" + str(K) + "/"

    filename_result = str(state) + '_' + str(dataset) + '_ctf_K' + str(K) + '_results'

    print(folder_direct_res + filename_result + '.mat')
    spio.savemat(folder_direct_res + filename_result + '.mat', dict)