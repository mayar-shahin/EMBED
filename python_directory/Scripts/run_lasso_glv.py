
from sklearn.linear_model import Lasso
import numpy as np
from gemelli.preprocessing import matrix_rclr
from gemelli.matrix_completion import MatrixCompletion
import warnings
warnings.filterwarnings("ignore")
from my_functions import *  
from my_functions_gemelli import *  
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


basename =  "GLV_" + str(reps) + "_runs_" +str(state) + "_K_" + str(tscale*days)+ "_days_multinomial_sampling_" + str(nRead) + "_reads_" + str(n)

# print(basename)

data = spio.loadmat(folder_direct + folder_sub + basename + ".mat")
data = data['xs'][0]

print('here')
recons=[]
for rep in range(reps):
    x = data[rep]
    x = x/np.sum(x,axis=0)
    """Start with removing zeros and doing clr transforms"""
    mask = (x==0)
    x_nozeros = x
    x_nozeros[mask] = 0.01/nRead
    x_nozeros = x_nozeros/np.sum(x_nozeros,axis=0)
    x_rclr = matrix_rclr(x_nozeros.T) #log transform the data
    T,O = x_rclr.shape
    num_parameters = K*(T+O) #number of parameters in embed 
    """Writing the data as an AR(1), x(t+1) = A@ x(t) + B"""
    X = x_rclr[0:-1,:]
    y = x_rclr[1::,:];  

    """Lasso parameter search"""
    for lam in np.arange(0,3,0.05):
        A = np.zeros((O,O))  #A is the OxO time interaction matrix
        B = np.zeros((O,1)) #B is the Ox1 offset vector 
        #Initialize a recontruction matrix
        y_pred = np.zeros(y.shape)

        for o in range(O):
            model = Lasso(alpha = lam, fit_intercept=True)
            model.fit(X,y[:,o])
            A[o,:] = model.coef_
            B[o] = model.intercept_
            y_pred[:,o] = model.predict(X)

        num_lasso_parameters = np.sum(A!=0) + np.sum(B!=0)
        if (num_lasso_parameters/num_parameters) <= 1.1:
            break 
    recon_lasso = np.exp(y_pred)
    recon_lasso[mask.T[1::,:]] = 0
    recon_lasso = recon_lasso.T
    recon_lasso = recon_lasso/np.sum(recon_lasso,axis=0)
    recons.append(recon_lasso)
print(recons)
mydict = {'lasso_reconstruction':recons}




folder_direct = "../Results/in_silico/"


result_folder= folder_direct + folder_sub + "lasso/K" + str(K) + "/"

filename_result = basename + '_lasso_K' + str(K) + '_results'

print(filename_result)
spio.savemat(result_folder + filename_result + '.mat', mydict)

