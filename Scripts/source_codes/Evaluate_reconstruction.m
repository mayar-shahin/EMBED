function [kl,mse_otus,otu_corr_mean,otu_corr_std] = Evaluate_reconstruction(data, reconstruction)

[nO,nT] = size(data);
tmp = (reconstruction - data).^2;
mse_otus = mean(nansum(tmp'));
mse_samples= mean(nansum(tmp));

kl = nansum(nansum(data.*log(data./reconstruction)));
kl = kl/nT;
for o=1:nO
    [c(o),p(o)] = corr(reconstruction(o,:)',data(o,:)');
end
otu_corr_mean = nanmean(c);
otu_corr_max_p = max(p);
% disp(otu_corr_max_p);
otu_corr_std = std(c);
end