

function [x, Alpha] = GLV_run(nO,nT,sparsity,muscale,Kscale,Ascale,sig,ctf)

Alpha = rand(nO,nO);Alpha = Alpha.*(rand(nO,nO)>sparsity);
Alpha = Alpha + Alpha';Alpha = Alpha - diag(diag(Alpha));
Alpha = Alpha*Ascale;
mu0   = muscale*rand(nO,1);K = rand(nO,1);

x = rand(nO,1);
xt(:,1) = x;
for t=2:100*nT
    gr = mu0.*(1-((Alpha*x(:,t-1) + x(:,t-1))./K)) + sig*randn(nO,1);
    x(:,t) = x(:,t-1).*exp(gr);
end
x = x';
x = normalize(x,2,'norm',1);
x = x(end-nT+1:end,:);




end


