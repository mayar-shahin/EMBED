%% function [z,theta,KL]  = TMI(X,N,K,learn_z, learn_the,max_steps,min_fitting,min_gradients)
%
% Author 1: Mayar Shahin
% Author 2: Brian Ji
% Author 3: Purushottam Dixit
% Date: 10/11/2021

% Description: TMI takes in a data table X and brings out z and theta 
% matrices learned from fitting the data on a Gibbs-Boltzmann distribution 
% q = exp(-z.theta)

%% Inputs: 
%{ 

X - an OTU matrix of size N*O x T, eac row is an OTU and each column 
is a time point.  
N - number of subjects in the study.
K - number of desired features and ECNs. K<<O,T for dimensionality
reduction 
learn_z - learning rate of the gradient ascent algorithm for updating 
the z-matrix, typically 0.001 - 0.1
learn_the - learning rate of the gradient ascent algorithm for updating 
the theta-matrix, typically 0.001 - 0.1
max_steps - The maximum number of learning steps in the gradient descent 
min_fitting - The minimum you set the model prediction to be, this
condition allows for early stopping to avoid over-fitting zero data.
(set to zero if not interested in early stopping)
min_gradients - The stopping criteria for the relative gradients of z and
theta (set close to zero)
%}

%% Outputs
%{
z - learned temporal latents matrix (K x T)
theta - learned loadings/features matrix (N*O x K)
KL - KL-divergence between the model and the data.
%}
function [z,theta,KL]  = TMI_masked_samples(X,N,K,mask,learn_z, learn_the,max_steps,min_fitting,min_gradients)
    [O,T] = size(X);
    
    o=O/N; % o is the number of OTUs per subject
    mask_exp = zeros(o,T);
    
    for s = 1:N
        mask_exp([(s-1)*o+1:s*o],:) = repmat(mask(s,:),o,1);
    end 
            disp(size(mask_exp))

    % Ensure subject specific normalization of the data
    for n=1:N
%         inc_t = setdiff([1:T],ind{n});
        X([(n-1)*o+1:o*n],:) = normalize(X([(n-1)*o+1:o*n],:),'norm',1);
    end
    X=X/N;
%     X = X./sum(X);
    % Initialize the inference with random matrices z and theta
    z = rand(K,T);
    
    theta = rand(O,K);
    
    % Define the Gibbs-Boltzmann probabilities q   
    function [Q] = q(z,theta)
        Q = exp(-theta*z);
        for n=1:N
%             inc_t = setdiff([1:T],ind{n});
            Q([(n-1)*o+1:o*n],:) = normalize(Q([(n-1)*o+1:o*n],:),'norm',1);
        end
        Q = Q/N;
%         Q = Q./sum(Q);

    end

    % The gradient ascent loop
    for t = 1:max_steps
        Q = q(z,theta);
        tmp = mask_exp.*(Q-X);
        gr_L_z = theta'*tmp;
        gr_L_theta = tmp*z';
        
        % Updating the z and theta matrices in the direction that ...
        % maximizes likelihood 
        z = z + learn_z*gr_L_z;
        theta = theta + learn_the*gr_L_theta;
        
        % Calculate the relative gradients of the likelihood
        
        rel_theta(t) = norm(gr_L_theta)/norm(theta);
        rel_z(t) = norm(gr_L_z)/norm(z);
        KL = nansum(nansum(X.*log(X./Q)));
        if mod(t,1000)==0
            [KL rel_z(t) rel_theta(t) min(min(Q))]
        end
        if min(min(Q)) < min_fitting || rel_theta(t)  < min_gradients
            break
        end
        
    end

end

