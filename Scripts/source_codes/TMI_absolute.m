%% function [z,theta,KL]  = TMI(X,S,K,learn_z, learn_the,max_steps,min_fitting,min_gradients)
%
% Author 1: Mayar Shahin
% Author 2: Brian Ji
% Author 3: Purushottam Dixit
% Date: 11/10/2021

% Description: TMI takes in a data table X and brings out z and theta 
% matrices learned from fitting the data on a Gibbs-Boltzmann distribution 
% q = exp(-z.theta)

%% Inputs: 
%{ 

X - an OTU matrix of size S*O x T, eac row is an OTU and each column 
is a time point.  
S - number of subjects in the study.
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
theta - learned loadings/features matrix (S*O x K)
KL - KL-divergence between the model and the data.
%}
function [z,theta,KL]  = TMI(X,S,K,learn_z, learn_the,max_steps,min_fitting,min_gradients,absolute_abundances)
    [O,T] = size(X);
    N = absolute_abundances;
    if sum(size(N) == [T 1]) == 2
        N = N';
    end
    
    
    o=O/S; % o is the number of OTUs per subject
    
    % Ensure subject specific normalization of the data
    for s=1:S
        X([(s-1)*o+1:o*s],:) = normalize(X([(s-1)*o+1:o*s],:),'norm',1);
    end
    X=X/S;
    
    % Initialize the inference with random matrices z and theta
    z = rand(K,T);
    
    theta = rand(O,K);
    
    % Define the Gibbs-Boltzmann probabilities q   
    function [Q] = q(z,theta)
        Q = exp(-theta*z);
        for s=1:S
            Q([(s-1)*o+1:o*s],:) = normalize(Q([(s-1)*o+1:o*s],:),'norm',1);
        end
        Q = Q/S;
    end

    % The gradient ascent loop
    for t = 1:max_steps
        Q = q(z,theta);
        gr_L_z = N.*(theta'*(Q-X));
        gr_L_theta = (N.*(Q-X))*z';
        
        % Updating the z and theta matrices in the direction that ...
        % maximizes likelihood 
        z = z + learn_z*gr_L_z;
        theta = theta + learn_the*gr_L_theta;
        
        % Calculate the relative gradients of the likelihood
        
        rel_theta(t) = norm(gr_L_theta)/norm(theta);
        rel_z(t) = norm(gr_L_z)/norm(z);
        KL = nansum(nansum(X.*log(X./Q)));

        if min(min(Q)) < min_fitting || rel_theta(t)  < min_gradients
            break
        end
        
    end

end

