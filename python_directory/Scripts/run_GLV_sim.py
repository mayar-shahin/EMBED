from my_functions import run_glv_simulation, run_oscillating_K_glv_simulation, OTU_filtering, multinomial_sampling
import numpy as np 
import scipy.io as spio

#Directory to save glv simulation data
folder_direct = "../Data/in_silico_data/"
const_K = False ################# Change this for constan/oscillating carrying capacities#################

if const_K:
    folder_sub = "constant_carrying_capacity/"
    state = "constant"
    tscale = 10
else:
    folder_sub = "oscillating_carrying_capacity/"
    state = "oscillating"
    tscale = 1

reps = 50;nT = 30; 

basename = folder_direct + folder_sub + "GLV_" + str(reps) + "_runs_" + state + "_K_" + str(nT*tscale)+ "_days"


#No sparsity parameters 

nO = 200;nT = 30;sparsity = 0.0;Ascale = 0.01
muscale = 0.01;Kscale = 100;sig = 0.5
cutoff = 0.001;period = 3

# print(f"""Running {reps} GLV simulations with {state} carrying capacity. {nO} OTUs are run for {nT*tscale} days. \n 
#         Simulation parameters are: \n
#         scale of A = {Ascale}, scale of growth rate = {muscale} \n """)



simulations = []
simulation_true_abundances=[]
simulations_filtered = []
while len(simulations)<reps:
    if const_K:
        xs, abx, alpha, done= run_glv_simulation(nO,nT,sparsity,muscale,Kscale,Ascale,sig,tscale)
    else:
        xs, abx, alpha, done= run_oscillating_K_glv_simulation(nO,nT,sparsity,muscale,Kscale,Ascale,sig,tscale,period)

    if done == True:
        simulations.append(xs)  
        simulation_true_abundances.append(abx)
        xs = OTU_filtering(xs,cutoff)
        simulations_filtered.append(xs)


print("done with glv simulations")
print(len(simulations))

#Save raw simulation data
diction = {'abx':simulation_true_abundances,'xs':simulations}
filename = basename + '_raw'
spio.savemat(filename + ".mat", diction)

# Save basetruth filtered data before sampling
filename = basename + '_basetruth_filtered'
diction = {'xs_filtered':simulations_filtered}
spio.savemat(filename + ".mat", diction)

# Multinomial sampling after filteration


nReads =  [1000,2500,5000,10000]
diction={}
for i in range(2):
    for _, nRead in enumerate(nReads):
        diction={}
        sampling_list =[]
        for rep in range(reps):
            xs = simulations_filtered[rep]
            xs = xs/np.sum(xs,axis=0)
            x = multinomial_sampling(xs,nRead)
            sampling_list.append(x)
        diction['xs'] = sampling_list
        filename = basename + '_multinomial_sampling_'+str(nRead) + '_reads_' + str(i+1)
        spio.savemat(filename + ".mat", diction)

