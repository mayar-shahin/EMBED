import numpy as np 
from gemelli.preprocessing import matrix_rclr
from gemelli.matrix_completion import MatrixCompletion

def ctf(x,K):
    X_rclr = matrix_rclr(x.T)
    u,s,v, solu= MatrixCompletion(n_components=K).fit_transform(X_rclr.T) #Source file has to be edited to output u,s,v
    recon_svd = np.matmul(np.matmul(u,s),v.T) 
    exp_svd = np.exp(recon_svd)
    norm_recon = exp_svd/np.sum(exp_svd,axis=0)

    KL_svd = (x*np.log(x/norm_recon))
    KL_svd = np.nansum(KL_svd)
    KL_svd = KL_svd/np.shape(x)[1]
    return u,s,v,KL_svd,norm_recon

