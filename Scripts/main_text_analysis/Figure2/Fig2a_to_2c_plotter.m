%%Figure 2a-2c(evaluating model performance with diff criteria)
clear
clc
parent_data_folder =  ['../../../python_directory/Data/real_data/'];
parent_methods_folder =  ['../../../python_directory/Results/real/'];
ds_names_m = {'carm_hf1','carm_hf2','carm_hf3','carm_lf1','carm_lf2','carm_lf3'};
addpath '../../source_codes/'

ds_names_h = {'davA','davB','capF4','capM3'};
ds_names = [ds_names_m,ds_names_h];

K=3;

reps = numel(ds_names);

for i = 1:numel(ds_names)
    if i<=numel(ds_names_m)
        sub = 'Mice';
    else
        sub = 'Humans';
    end
    fn = fullfile(parent_data_folder,sub,append(ds_names{i},'.mat'));
    load(fn)
    data = x;
    
    %Load TMI
    method = 'tmi';
    result_file = append(sub,'_',ds_names{i},'_',method,'_K' ,string(K) ,'_results.mat');
    fn = fullfile(parent_methods_folder ,method,'K'+string(K),result_file);
    load(fn)
    [s,o,d] = size(TMI_recon);
    TMI_recon = reshape(TMI_recon,[o,d]);
    [kl(1,i),mse_otu(1,i),otu_corr_mean(1,i)] = ...
        Evaluate_reconstruction(data, TMI_recon);
    
    % Load CTF
    method = 'ctf';
    result_file = append(sub,'_',ds_names{i},'_',method,'_K' ,string(K) ,'_results.mat');
    fn = fullfile(parent_methods_folder ,method,'K'+string(K),result_file);
    load(fn)
    [s,o,d] = size(CTF_recon);
    CTF_recon = reshape(CTF_recon,[o,d]);
    [kl(2,i),mse_otu(2,i),otu_corr_mean(2,i)] = ...
        Evaluate_reconstruction(data, CTF_recon);
    
    % Load lasso
    
    method = 'lasso';
    result_file = append(sub,'_',ds_names{i},'_',method,'_K' ,string(K) ,'_results.mat');
    fn = fullfile(parent_methods_folder ,method,'K'+string(K),result_file);
    load(fn)
    [s,o,d] = size(lasso_reconstruction);
    lasso_reconstruction = reshape(lasso_reconstruction,[o,d]);
%     lasso_reconstruction(lasso_reconstruction==0)= 0.01/25000;

    data_ar = data(:,2:end); % remove first day from evaluation
    
    [kl(3,i),mse_otu(3,i),otu_corr_mean(3,i)] = ...
    Evaluate_reconstruction(data_ar, lasso_reconstruction);
    
end

KL_mean_matrix= mean(kl');
KL_std_matrix = std(kl');
mse_otu_matrix = mean(mse_otu');
mse_otu_std_matrix = std(mse_otu');
otu_corr_matrix = mean(otu_corr_mean');
otu_corr_std_matrix = std(otu_corr_mean');    


c = struct('c1',[26,133,255]/255, ...
          	'c2',[212,17,89]/255, ...
            'c3',[0,170,0]/255);

%% Bar Graph
h = figure
% Panel 1  - kl
ax(1) = subplot(1,3,1)

b = bar([1:3],KL_mean_matrix')
b.FaceColor = 'flat';

b.CData(1,:) = c.c1;
b.CData(2,:) = c.c2;
b.CData(3,:) = c.c3;

hold on 
xticks([])
errorbar([1,2,3],KL_mean_matrix',KL_std_matrix'/sqrt(reps),'k','linestyle','none','Color', 'k','linewidth', 2);
% ylim([0 0.23])%-> K=5 
% ylim([0.07 0.13])%-> K=3 
ylim([0 0.3])%-> K=3 

axis square
title('KL-divergence')

% panel 2 - mse
ax(2) = subplot(1,3,2)
b = bar([1:3],mse_otu_matrix')
b.FaceColor = 'flat';

b.CData(1,:) = c.c1;
b.CData(2,:) = c.c2;
b.CData(3,:) = c.c3;
hold on 
xticks([])
errorbar([1,2,3],mse_otu_matrix',mse_otu_std_matrix'/sqrt(reps),'k','linestyle','none','Color', 'k','linewidth', 2);
title('Mean Squared Error')
% ylim([0,0.031])%-> K=5 
ylim([0,0.04])%-> K=3 
% ylim([0,0.04])%-> K=4 

axis square
% panel 3 otu corr 
ax(3) = subplot(1,3,3)
b = bar([1:3],otu_corr_matrix')
b.FaceColor = 'flat';

b.CData(1,:) = c.c1;
b.CData(2,:) = c.c2;
b.CData(3,:) = c.c3;

hold on 
xticks([])
errorbar([1,2,3],otu_corr_matrix',otu_corr_std_matrix'/sqrt(reps),'k','linestyle','none','Color', 'k','linewidth', 2);
% ylim([0.76,0.86])%-> K=5 const
% ylim([0.4,0.7])%-> K=4
% ylim([0.4,0.8])%-> K=5
ylim([0.4,0.7])%-> K=3


title('Mean OTU Correlation')
qw{1} = bar(nan,'FaceColor','flat')
qw{1}.CData(1,:) = c.c1;
qw{2} = bar(nan,'FaceColor','flat');
qw{2}.CData(1,:) = c.c2;
qw{3} = bar(nan,'FaceColor','flat');
qw{3}.CData(1,:) = c.c3;
legend([qw{:}], {'EMBED','CTF','Lasso'}, 'location', 'best')
axis square


% Saving figs 
parent_figures_folder =  ['../../Results/SIFigures/'];
figname = 'K' +string(K) +'_method_evaluation';
figname = append('real_data_',figname);
fn = fullfile(parent_figures_folder,figname);
saveas(h, fn)
figname2 = append(figname,'.png');
fn = fullfile(parent_figures_folder,figname2);
saveas(h, fn)
figname3 = append(figname,'.pdf');
fn = fullfile(parent_figures_folder,figname3);
saveas(h, fn)


%% Calculating p-values
for i =1:2
    pvals(i,1) = signrank(kl(1,:),kl(i+1,:));
    pvals(i,2) = signrank(mse_otu(1,:),mse_otu(i+1,:));
    pvals(i,3) = signrank(otu_corr_mean(1,:),otu_corr_mean(i+1,:));
end
