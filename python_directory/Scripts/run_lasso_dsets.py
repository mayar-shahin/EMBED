
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



folder_direct = "../Data/real_data/"
K = int(sys.argv[1])


subject = str(sys.argv[2]) ################# Change this for different data sets #####
if subject=='Humans':
    folder_sub = "Humans/"
    state = "Humans"
    ds_names = ['capF4','capM3','davA','davB']
    nReads = [25000,25000,25000,25000]

elif subject=='Mice':
    folder_sub = "Mice/"
    state = "Mice"
    ds_names = ['carm_hf1', 'carm_hf2','carm_hf3','carm_lf1','carm_lf2','carm_lf3']
    nReads = [25000]*6



for d,dataset in enumerate(ds_names):
    reconstructions=[]
    filename = folder_direct + folder_sub + dataset + '.mat'
    data = spio.loadmat(filename)
    x = data['x']
    x = x/np.sum(x,axis=0)
    print(x.shape)
   
    """Start with removing zeros and doing clr transforms"""
    mask = (x==0)
    x_nozeros = x
    x_nozeros[mask] = 0.01/nReads[d]
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
    reconstructions.append(recon_lasso)
    dict = {'lasso_reconstruction':reconstructions}


    folder_direct_res = "../Results/real/lasso/K" + str(K) + "/"

    filename_result = str(state) + '_' + str(dataset) + '_lasso_K' + str(K) + '_results'

    print(folder_direct_res + filename_result + '.mat')
    spio.savemat(folder_direct_res + filename_result + '.mat', dict)