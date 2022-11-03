function [frac_1_ecn,frac_more_ecn] = ECN_corr(data,latents)
[O,T] = size(data);
Y = latents;
for o = 1:O
    [c(o,:),pvals(o,:)] = corr(data(o,:)',Y','type','Spearman');
    FDR(o,:) = mafdr(pvals(o,:),'BHFDR','true');
end

no_corr_ECNS = sum((FDR<0.05)');

frac_1_ecn = sum(no_corr_ECNS==1)/O;
frac_more_ecn = sum(no_corr_ECNS>1)/O;

end