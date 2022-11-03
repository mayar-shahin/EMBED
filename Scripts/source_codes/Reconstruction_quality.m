%% Calculating Pearson correlation for each OTU time series 
O=41;N=6;

recons4 = exp(-Phi4*Y4);

for n=1:N
    recons4([(n-1)*O+1:O*n],:) = normalize(recons4([(n-1)*O+1:O*n],:),'norm',1);
end

recons4 = recons4/N;

clear c p

for n = 1:N
    for o=[1:size(x_norm,1)/N]
        [c(o,n),p(o,n)] = corr(recons4(n*o,:)',x_norm(n*o,:)','Type','Pearson');
    end
end

av_corr_of_OTUs_per_sub = mean(c)
av_corr_of_OTUs_across_subs = mean(av_corr_of_OTUs_per_sub)
av_std_of_OTUs_across_sub = sqrt(mean(var(c)))

%% Community correlation
clear c p 
for n=1:N
    [c{n} p{n}] = corrcoef(recons4([(n-1)*O+1:O*n],:)',x_norm([(n-1)*O+1:O*n],:)')
end

clear pearson_community_c 
for n = 1:N
    pearson_community_c(n) = c{n}(1,2)
end
pearson_community_c_avg = mean(pearson_community_c)
pearson_community_c_std = std(pearson_community_c)

%% Phi1 Correlation

O=size(x_norm,1)/N;
for n=1:N
    tst = mean(x_norm([(n-1)*O+1:O*n],:)');
    tst_phi = Phi4([(n-1)*O+1:O*n],1);
    [corr_phi1(n),p_phi1(n)] = corr(tst',tst_phi,'Type','Spearman');
end

