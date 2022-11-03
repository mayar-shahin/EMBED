import numpy as np 
from my_functions import *  
import scipy.io as spio
import sys, os


folder_direct = "../Data/in_silico_data/"
const_K = str(sys.argv[4]) ################# Change this for constant/oscillating carrying capacities#################

if const_K=='True':
    folder_sub = "constant_carrying_capacity/"
    state = "constant"
    tscale = 10
elif const_K=='False':
    folder_sub = "oscillating_carrying_capacity/"
    state = "oscillating"
    tscale = 1

print(state)
reps = 50
days =30


nRead = int(sys.argv[1])
K = int(sys.argv[2])
n = int(sys.argv[3])
print(nRead,K)


basename =  "GLV_" + str(reps) + "_runs_" +str(state) + "_K_" + str(tscale*days)+ "_days_multinomial_sampling_" + str(nRead) + "_reads_" + str(n)

print(basename)

data = spio.loadmat(folder_direct + folder_sub + basename + ".mat")
data = data['xs'][0]


reconstructions=[]
zs=[]
ths=[]

for rep in range(reps):

    x = data[rep]
    x = x/np.sum(x, axis=0)
    z,th,_ = TMI(x,K,lr_z=0.05, lr_th=0.05, max_iter=10000,min_fitting = 0, min_gradients=1e-3)
    recons_tmi = q(z,th)

    reconstructions.append(recons_tmi)
    zs.append([z])
    ths.append([th])





dict= {'TMI_recon':reconstructions, 'Zs':zs,'Thetas': ths}




folder_direct = "../Results/in_silico/"

result_folder= folder_direct + folder_sub + "tmi/K" + str(K) + "/"

filename_result = basename + '_tmi_K' + str(K) + '_results'

print(filename_result)
spio.savemat(result_folder + filename_result + '.mat', dict)



