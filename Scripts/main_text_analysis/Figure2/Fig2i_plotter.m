%% Figure 2i - precision
clear 
clc
state = 'constant' 
parent_directory =  ['../../../python_directory/Results/precision_results/' state '_carrying_capacity/'];
ndays = 300;reps=50;K=5;
basename = append('GLV_50_runs_',state,'_K_',string(ndays),'_days_multinomial_sampling_');
% 
c = struct('c1',[26,133,255]/255, ...
          	'c2',[212,17,89]/255, ...
            'c3',[0,170,0]/255);
% 
% 
nReads = [1000,2500,5000,10000];
KL_mean=[];
KL_std = [];
m=1;
for nRead = nReads
    res_name = string(nRead)+ '_reads_K'+string(K)+'_precision_results.mat';
    fn = fullfile(parent_directory, append(basename,res_name));
    load(fn)
    JSD = JSD/30;   
    pvals(1,m) = signrank(JSD(:,1),JSD(:,2));
    pvals(2,m) = signrank(JSD(:,1),JSD(:,3));
    m=m+1;
    KL_mean = [KL_mean;mean(JSD)];
    KL_std = [KL_std;std(JSD)];
end
%     p(i) = signrank(JSD(:,1),JSD(:,2));
%     i=i+1;
% end
% 
figure
b = bar([1:4],KL_mean);
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(KL_mean);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

b(1).FaceColor = c.c1;
b(2).FaceColor = c.c2;
b(3).FaceColor = c.c3;



% 
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% % Plot the errorbars
errorbar(x',KL_mean,KL_std/sqrt(reps),'k','linestyle','none','Color', 'k','linewidth', 2);
hold off
ylabel('Symmetric KL Divergence','FontSize',14)
xlabel('Sequencing Depth','FontSize',14)

xticks([1:4])
xticklabels([1000,2500,5000,10000])
ylim([0,0.1])
legend('EMBED','CTF','Lasso')
title(strcat('K=',string(K)))
set(gca,'FontSize',12,'FontWeight','bold');

disp(pvals)