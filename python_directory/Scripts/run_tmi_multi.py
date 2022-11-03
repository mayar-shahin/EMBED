import pandas as pd
import numpy as np 
from my_functions import * 
import pickle 
import scipy.io as spio


folder_direct = "/blue/pdixit/mayar.shahin/Microbiome/Nature_Comm/Real_DS/Data_Sets/"
# sub_folder = "Humans/"
sub_folder = "Multi_Subject_Data/"

ds_names = ['Carmody_Multi_Subject','Ng_Multi_Subject']
subj = 'multi'
nSub = [5,6]
Klist = range(1,3);

mydict = {}


for a, K in enumerate(Klist):
    mydict[K] = {}

    for d,dataset in enumerate(ds_names):
        mydict[K][dataset] = {}
        filename = folder_direct + sub_folder + dataset + '.mat'
        data = spio.loadmat(filename)
        # print(data)
        x = data['X']
        #TMI  
        z,th,KL_tmi = TMI_multi(x,nSub[d],K,lr_z=0.05, lr_th=0.05, max_iter=10000,min_fitting = 0, min_gradients=1e-3)
        reconst = q_multi(z,th,nSub[d])
        mydict[K][dataset]['tmi'] = reconst

# fn = folder_direct + sub_folder + subj + '_tmi_multi_results_K' + '.mat'
# spio.savemat(fn,mydict)

for K in Klist:
    print(K)
    fn = folder_direct + sub_folder + subj + '_tmi_multi_results_K' + str(K) + '.mat'
    spio.savemat(fn,mydict[K])


