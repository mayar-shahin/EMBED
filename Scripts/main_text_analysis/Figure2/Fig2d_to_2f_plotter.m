%% Figure 1b 
% Evaluating model performance with 3 different criteria, mse, mean OTU correlation coefficient)
clear
clc
state = 'oscillating'
ndays = 30;
parent_data_folder =  ['../../python_directory/Data/in_silico_data/' state '_carrying_capacity/'];
parent_methods_folder =  ['../../python_directory/Results/in_silico/' state '_carrying_capacity/'];

%load basetruth simulation data
sim_name = append('GLV_50_runs_',state,'_K_',string(ndays),'_days');
base_truth_fn = append(sim_name,"_basetruth_filtered.mat");
fn = fullfile(parent_data_folder,base_truth_fn);
load(fn)

data = xs_filtered;
% 
nReads = 10000; K = 5;reps = 50;
%load TMI
method = 'tmi';
method_folder =fullfile(method,'K'+string(K));
method_result_fn = sim_name + "_multinomial_sampling_" + string(nReads) + '_reads_1_' +string(method) + '_K' +string(K) +'_results.mat';
fn = fullfile(parent_methods_folder ,method_folder, method_result_fn);
load(fn)
%load ctf
method = 'ctf';
method_folder =fullfile(method,'K'+string(K));
method_result_fn = sim_name + "_multinomial_sampling_" + string(nReads) + '_reads_1_' +string(method) + '_K' +string(K) +'_results.mat';
fn = fullfile(parent_methods_folder ,method_folder, method_result_fn);
load(fn)
%load lasso results
method = 'lasso';
method_folder =fullfile(method,'K'+string(K));
method_result_fn = sim_name + "_multinomial_sampling_" + string(nReads) + '_reads_1_' +string(method) + '_K' +string(K) +'_results.mat';
fn = fullfile(parent_methods_folder ,method_folder, method_result_fn);
load(fn)

% clearvars -except  TMI_recon CTF_recon lasso_reconstruction data K


%% Evaluation
addpath '../source_codes/'
for i = 1:50
    [kl(1,i),mse_otu(1,i),otu_corr_mean(1,i)] = ...
    Evaluate_reconstruction(data{i}, TMI_recon{i});

    [kl(2,i),mse_otu(2,i),otu_corr_mean(2,i)] = ...
    Evaluate_reconstruction(data{i}, CTF_recon{i});

    data_ar{i} = data{i}(:,2:end); % remove first day from evaluation
    tmp = lasso_reconstruction{i};
    tmp(tmp==0)= 0.01/10000;
    [kl(3,i),mse_otu(3,i),otu_corr_mean(3,i)] = ...
    Evaluate_reconstruction(data_ar{i}, tmp);
end

whos


KL_mean_matrix= mean(kl');
KL_std_matrix = std(kl');
mse_otu_matrix = mean(mse_otu');
mse_otu_std_matrix = std(mse_otu');
otu_corr_matrix = mean(otu_corr_mean');
otu_corr_std_matrix = std(otu_corr_mean');    


%% Plotting aids
% col sstructure
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
ylim([0 0.15])
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
ylim([0e-3,9e-3])


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
ylim( [0.6,0.9])



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
parent_figures_folder =  ['../../Results/SIFigures/fig1b/'];

sim_name = append('GLV_50_runs_',state,'_K_',string(ndays),'_days');
figname = sim_name +  "_multinomial_sampling_" + string(nReads) + '_reads_1_K' +string(K) +'_method_evaluation';
fn = fullfile(parent_figures_folder,figname);
saveas(h, fn)
figname2 = append(figname,'.png');
fn = fullfile(parent_figures_folder,figname2);
saveas(h, fn)
figname3 = append(figname,'.pdf');
fn = fullfile(parent_figures_folder,figname3);
saveas(h, fn)

for i =1:2
    pvals(i,1) = signrank(kl(1,:),kl(i+1,:));
    pvals(i,2) = signrank(mse_otu(1,:),mse_otu(i+1,:));
    pvals(i,3) = signrank(otu_corr_mean(1,:),otu_corr_mean(i+1,:));
end
disp(pvals)