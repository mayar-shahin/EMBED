import numpy as np 


def run_glv_simulation(nO,nT,sparsity,muscale,Kscale,Ascale,sig,tscale):
    alpha = np.random.randn(nO,nO)
    alpha = alpha*(np.random.rand(nO,nO)>sparsity)
    alpha = alpha - np.diag(np.diag(alpha))
    alpha = alpha*Ascale;
    mu0   = muscale*np.random.rand(nO,1);
    K     = Kscale*np.random.rand(nO,1);
    x     = np.random.rand(nO,1);
    xt = np.zeros((nO,tscale*nT))
    xt[:,0] = x.T
    
    time = np.arange(0,nT*tscale)
    for t in range(1,tscale*nT):
        gr = (mu0.T*(1-((alpha@xt[:,t-1] + xt[:,t-1])/K.T)) + sig*np.random.randn(1,nO));
        xt[:,t] = xt[:,t-1]*np.exp(gr)
        if np.any(np.isnan(xt)):
            print("Found nan")
            done = False
            return xt, [], [], done
            break 
    abx = np.sum(xt,axis=0);
    xt = xt/abx;
    xt = xt[:,-nT::];
    abx = abx[-nT::]
    abx = abx.reshape(-1,1)
    done = True 
    return xt, abx, alpha, done

def run_oscillating_K_glv_simulation(nO,nT,sparsity,muscale,Kscale,Ascale,sig,tscale,period):
    alpha = np.random.randn(nO,nO)
    alpha = alpha*(np.random.rand(nO,nO)>sparsity)
    alpha = alpha - np.diag(np.diag(alpha))
    alpha = alpha*Ascale;
    mu0   = muscale*np.random.rand(nO,1);
    K     = Kscale*np.random.rand(nO,1);
    x     = np.random.rand(nO,1);
    xt = np.zeros((nO,tscale*nT))
    xt[:,0] = x.T
    time = np.arange(0,nT*tscale)
    # add oscillation to carring capacity
    osc = np.sin((2*np.pi/period)*time + 0.5*np.random.randn(nO,nT*tscale)) + 500*np.random.randn(nO,nT*tscale)
    K_osc = K*osc; 
    for t in range(1,tscale*nT):
        tmp = (1-((alpha@xt[:,t-1] + xt[:,t-1])/K_osc[:,t-1])).reshape(-1,1)
        gr = (mu0*tmp).T + sig*np.random.randn(1,nO)
        xt[:,t] = xt[:,t-1]*np.exp(gr)
        if np.any(np.isnan(xt)):
            done = False
            return xt, [], [], done
            break 
    abx = np.sum(xt,axis=0);
    xt = xt/abx;
    xt = xt[:,-nT::];
    abx = abx[-nT::];
    done = True 
    return xt, abx, alpha, done

def OTU_filtering(xs,cutoff):
    nO,nT = xs.shape
    xs = xs /np.sum(xs,axis=0)
    inc_otus = np.where(np.mean(xs,axis=1)>=cutoff)
    rest_otus = np.where(np.mean(xs,axis=1)<cutoff)
    fake_otu = xs[rest_otus[0],:]
    fake_otu = np.sum(fake_otu,axis=0)
    x = xs[inc_otus[0],:]
    x = np.vstack([x,fake_otu])
    x = x /np.sum(x,axis=0)
    return x

        
def multinomial_sampling(xs,nRead):
    nO,nT = xs.shape
    xs = np.array([np.random.multinomial(nRead, xs[:,i],size = 1) for i in range(nT)]).T
    xs = xs.reshape(nO,nT)
    # xs = xs /np.sum(xs,axis=0)
    return xs

# Define a KL-divergence function 
def KL(mu, sigma): 
    """Returns Kullback-Leibler divergence between N(mu, sigma) and N(0,1) for each sample"""
    kl = np.log(sigma) + (1+mu**2)/(2*sigma**2) - 0.5
    kl = np.sum(result, axis = 1)
    return result


# Define the Gibbs-Boltzmann probabilities q   
def q(z,theta):
    Q = theta @ z
    Q = np.exp(-Q);
    Q =Q/np.sum(Q,axis = 0)
    return Q


def TMI(X,K,lr_z=0.05, lr_th=0.05, max_iter=10000,min_fitting = 0, min_gradients=1e-3):
    print("imported")

    O, T = X.shape
    max_iter = int(max_iter)
    
    norm = np.sum(X,axis = 0)
    X = X/norm

    #Initialize the inference with random matrices z and theta
    z = np.random.rand(K,T)
    theta = np.random.rand(O,K)
    
    
    #Initialize lists to store errors
    rel_theta = [0]*max_iter
    rel_z = [0]*max_iter
    KL = [0]*max_iter
    print('step', 'Th gradient', 'z gradient', 'KL')

    for t in range(max_iter):
        Q = q(z,theta)
        gr_L_z = theta.T @ (Q-X)
        gr_L_theta = (Q-X) @ z.T
        
        # Updating the z and theta matrices in the direction that ...
        # maximizes likelihood 
        
        z = z + lr_z*gr_L_z
        
        theta = theta + lr_th*gr_L_theta
        
        #Calculate the relative gradients of the likelihood
        
        rel_theta[t] = np.linalg.norm(gr_L_theta)/np.linalg.norm(theta)
        rel_z[t] = np.linalg.norm(gr_L_z)/np.linalg.norm(z)
        
        kl = np.nansum(X*(np.log(X) - np.log(Q)))
        KL[t] = kl

        if np.min(Q) < min_fitting or rel_theta[t]< min_gradients:
            break
        
        # if np.mod(t,100)==0:
            # print(t, rel_theta[t], rel_z[t] , KL[t] )
    return z, theta, kl
    