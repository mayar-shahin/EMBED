import numpy as np 
from my_functions import * 
import scipy.io as spio
import sys, os
import warnings
warnings.filterwarnings("ignore")


folder_direct = "../Data/real_data/"
K = int(sys.argv[1])
print('impoerted K is:')
print(K)
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
    zs=[]
    ths=[]
    filename = folder_direct + folder_sub + dataset + '.mat'
    data = spio.loadmat(filename)
    x = data['x']
    x = x/np.sum(x,axis=0)
    print(x.shape)
    #TMI  
    z,th,_ = TMI(x,K,lr_z=0.02, lr_th=0.02, max_iter=50000,min_fitting = 0, min_gradients=1e-3)
    reconst = q(z,th)
    reconstructions.append(reconst)
    zs.append(z)
    ths.append(th)
    dict= {'TMI_recon':reconstructions, 'Zs':zs,'Thetas': ths}

    folder_direct_res = "../Results/real/tmi/K" + str(K) + "/"

    filename_result = str(state) + '_' + str(dataset) + '_tmi_K' + str(K) + '_results'

    print(folder_direct_res + filename_result + '.mat')
    spio.savemat(folder_direct_res + filename_result + '.mat', dict)