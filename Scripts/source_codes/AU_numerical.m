% function [u,A] = AU_numerical(Z,days,max_steps,A0,u0)
% Author 1: Mayar Shahin
% Author 2: Brian Ji
% Author 3: Purushottam Dixit
% Date: 11/10/2021


%% Inputs: 
%{
z - learned temporal latents matrix (K x T)
days - array of days on which the samples were taken (not necessarily
consecutive)
max_steps - maximum number of inference steps (set to 1000000)
A0 - initialization of A
u0 - initialization of u 
%}

%% Outputs
%{ 
u - vector (K x 1)
A - matrix (K x K)
in z_k(t+1) = sum_k'[A_kk' z_k'(t)] + u_k
%}

function [u,A] = AU_numerical(Z,days,max_steps,A0,u0)
%

[T K] = size(Z);
AOld = A0;uOld = u0;
eOld = 1e10;
iter = 1;
Atst = zeros(K,K);
tstOld = 0;
while eOld > 0.00001
    %
    %perturbing A and u
    ANew = AOld + 0.005*randn(K,K).*(rand(K,K)>0.95); 
    ANew = 0.5*(ANew + ANew'); %imposing symmetric A
    uNew = uOld + 0.005*randn(K,1).*(rand(K,1)>0.95);
    eNew = 0;
    for t=2:length(days) % calculating missing days
        Z0 = Z(t-1,:)';Zt = Z0;
        dt = days(t) - days(t-1);
        for j=1:dt
            Zt = ANew*Zt + uNew;
        end
        eNew = eNew + norm(Zt - Z(t,:)')^2;
    end
    %
      
    if eNew < eOld %admit the perturbation if it reduces error
        eOld = eNew;
        AOld = ANew;
        uOld = uNew;
    end
    %
    
    ext(iter) = eOld;
    iter = iter + 1;
    if iter > max_steps
        break
    end
    
    if mod(iter,10000)==0
         %stops learning when every 10000 iterations the error doesn't
         %decrease significantly
        if abs(tstOld - eNew)<1e-06
            break
        end
        tstOld = eNew;
    end
    

end
%
u = uOld;
A = AOld;
end

