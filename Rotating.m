%% function [Y,Phi]  = Rotating(z,theta,days,X,max_steps)
%
% Author 1: Mayar Shahin
% Author 2: Brian Ji
% Author 3: Purushottam Dixit
% Date: 11/10/2020

% Description: Rotating takes in latennts z and loadings theta
% matrices learned from fitting the data on a Gibbs-Boltzmann distribution 
% q = exp(-z.theta) and returns unique counterparts Y and Phi

%% Inputs: 
%{
z - learned temporal latents matrix (K x T)
theta - learned loadings/features matrix (N*O x K)
days - array of days on which the samples were taken (not necessarily
consecutive)
X - OTU table of the data (N*O x T)
max_steps - maximum number of inference steps (set to 1000000)
%}

%% Outputs
%{ 
Y - The resulting independent, orthogonal Ecological Normal Modes (ECN) (K x T)
Phi - The rotated loadings (N*O x K)
%}


function [Y,Phi] = Rotating(z,theta,days,X,max_steps)

K = size(z,1);
T = size(z,2);

%Orthonormalizing z and rotating theta accordingly

[Z B] = gschmidt(z'); 
z_or = Z'; th_or = theta*B'; 
    
%% Fitting the dynamical model 
% initial solution that doesn't account for missing days/data points
Zp = z_or;
Z0 = Zp(:,2:end);
Z1 = [ones(1,T-1);Zp(:,1:end-1)];
B = Z0*Z1'*inv(Z1*Z1');
u0 = B(:,1); A0 = B(:,2:end); 
% Inferring u and A using square error minimization
[u A] = AU_numerical(z_or',days,max_steps,A0,u0);

[v Lambda] = eig(A); %diagonalizing the dynamical matrix A into Lambda
Y = inv(v)*z_or; 
Phi = th_or*v;
end 
