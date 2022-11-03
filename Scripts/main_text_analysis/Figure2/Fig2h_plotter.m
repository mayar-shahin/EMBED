%% Fig 2h plotter - load embed results 
clear 
clc

state = 'constant'
ndays = 300;
parent_data_folder =  ['../../../python_directory/Data/in_silico_data/' state '_carrying_capacity/'];
parent_methods_folder =  ['../../../python_directory/Results/in_silico/' state '_carrying_capacity/'];

%load basetruth simulation data
sim_name = append('GLV_50_runs_',state,'_K_',string(ndays),'_days');
base_truth_fn = append(sim_name,"_basetruth_filtered.mat");
fn = fullfile(parent_data_folder,base_truth_fn);
load(fn)
state = 'oscillating';ndays = 30;K=4;     
folder =  ['../../python_directory/Results/precision_results/' state '_carrying_capacity/'];
basename = append('GLV_50_runs_',state,'_K_',string(ndays),'_days_multinomial_sampling_');
reps=50;nRead = 10000;K=4;

load GLV_20_reps_const_K300_days_10000_embed_K4_ECNs.mat
sim_name = "GLV_20_reps_const_K300_days_"
nReads = 10000;
filename = sim_name + string(nReads) + "_tmi_ctf_K4_results.mat"
load(filename)   
load GLV_100_reps_const_K300_days_10000

K=4;
for rep =1:20
    data = sampling_list{rep}
    Y = Ys{rep};
    [corr_embed(rep,1),corr_embed(rep,2)] = ECN_corr(data,Y);
    Y = CTF_vs(rep,:,:);
    Y = reshape(Y,30,4)';
    [corr_ctf(rep,1),corr_ctf(rep,2)] = ECN_corr(data,Y);
    % load recos_embed 
    zth = Thetas{rep}*reshape(Zs(rep,:,:),4,30);
%     zth = normalize(zth,'norm',1);
    [u,s,v] = svd(zth');
    Y = u(:,[1:K])';
    [corr_embed_svd(rep,1),corr_embed_svd(rep,2)] = ECN_corr(data,Y);    
end

y = [mean(corr_embed);mean(corr_ctf);mean(corr_embed_svd)]'
err = [std(corr_embed);std(corr_ctf);std(corr_embed_svd)]'
p1 = signrank(corr_embed(:,1),corr_ctf(:,1));
p2 = signrank(corr_embed(:,1),corr_embed_svd(:,1));
p3 = signrank(corr_embed(:,2),corr_ctf(:,2));
p4 = signrank(corr_embed(:,2),corr_embed_svd(:,2));

b = bar([1:2],y);
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(y);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

% b(1).FaceColor = c.c1;
% b(2).FaceColor = c.c2;



% 
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% % Plot the errorbars
errorbar(x',y,err/sqrt(20),'k','linestyle','none','Color', 'k','linewidth', 2);
hold off

ylabel('Fraction of OTUs','FontSize',14)
% xlabel('Correlated with only 1 ECN','FontSize',14)
% first column is fraciton of OTUs correlated with only 1 ECN
% sceond column is the fraction correlated with more than 1
xticks([1,2])
xticklabels({'Corr ~ 1 ECN','Corr ~ > 1 ECN'})
xlabel('K=4')
legend('EMBED','CTF','SVD','Orientation','horizontal')
set(gca,'FontSize',12,'FontWeight','bold');
