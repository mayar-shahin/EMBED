import numpy as np
from my_functions_gemelli import * 
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


reps = 50
days =30


nRead = int(sys.argv[1])
K = int(sys.argv[2])
n = int(sys.argv[3])

print(nRead,K)


basename =  "GLV_" + str(reps) + "_runs_" +str(state) + "_K_" + str(tscale*days)+ "_days_multinomial_sampling_" + str(nRead) + "_reads_" + str(n)

data = spio.loadmat(folder_direct + folder_sub + basename + ".mat")
data = data['xs'][0]


reconstructions=[]
U=[]
S=[]
V=[]

for rep in range(reps):

    x = data[rep]
    x = x/np.sum(x, axis=0)
    print(x.shape)

    u,s,v, _, recons_ctf = ctf(x,K)    


    
    reconstructions.append(recons_ctf)
    U.append(u)
    S.append(s)
    V.append(v)





dict= {'CTF_recon':reconstructions, 'U':U,'S': S, 'V':V}




folder_direct = "../Results/in_silico/"

result_folder= folder_direct + folder_sub + "ctf/K" + str(K) + "/"

filename_result = basename + '_ctf_K' + str(K) + '_results'

print(filename_result)
spio.savemat(result_folder + filename_result + '.mat', dict)



