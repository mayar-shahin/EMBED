%% Fig 1d: evaluating log ratios
clear
clc
state = 'constant'
ndays = 300;
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
%load TMI %%make this a for loop 
for method = {'tmi','ctf','lasso'}
method_folder =fullfile(method,'K'+string(K));
method_result_fn = sim_name + "_multinomial_sampling_" + string(nReads) + '_reads_1_' +string(method) + '_K' +string(K) +'_results.mat';
fn = fullfile(parent_methods_folder ,method_folder, method_result_fn);
load(fn)
end


dE_embed = [];dE_ctf = [];abs_data = [];dE_null = [];dE_lasso=[];

for i =1:reps
    recon_ctf = CTF_recon{i}';
    recon_embed = TMI_recon{i}';
    recon_lasso = lasso_reconstruction{i}';
    xsp = data{i}';
    [nT nO] = size(xsp);
    t = log10(recon_embed(2:end,1:end-1)./recon_embed(1:end-1,1:end-1));
    dX_embed = reshape(t,(nT-1)*(nO-1),1);
    
    t    = log10(recon_ctf(2:end,1:end-1)./recon_ctf(1:end-1,1:end-1));
    dX_ctf = reshape(t,(nT-1)*(nO-1),1);
    
    recon_lasso = [xsp(1,:);recon_lasso];
    t    = log10(recon_lasso(2:end,1:end-1)./recon_lasso(1:end-1,1:end-1));
    dX_lasso = reshape(t,(nT-1)*(nO-1),1);
    
    
    t    = log10(xsp(2:end,1:end-1)./xsp(1:end-1,1:end-1));
    dX_data = reshape(t,(nT-1)*(nO-1),1);
    
    t    = (log10(xsp(2:end,1:end-1)));
    abs_data = [abs_data;reshape(t,(nT-1)*(nO-1),1)];
    
    dE_embed = [dE_embed;abs(dX_embed - dX_data)];
    dE_ctf = [dE_ctf;abs(dX_ctf  - dX_data)];
    dE_lasso = [dE_lasso;abs(dX_lasso  - dX_data)];

  end


clear m_emd s_emd m_svd s_svd mab m_nll s_nll
for i=1:19
  st = (i-1)*5;en = st+5;
  i1 = find(abs_data > prctile(abs_data,st));
  i2 = find(abs_data < prctile(abs_data,en));
  ii = intersect(i1,i2);
  %
  mab(i) = nanmean(abs_data(ii));
  t = dE_ctf(ii);t(isinf(t)) = [];t(isnan(t)) = [];t1 = t;
  m_svd(i) = mean(abs(t));
  s_svd(i) = std(abs(t))/sqrt(length(t));
  %
  t = dE_embed(ii);t(isinf(t)) = [];t(isnan(t)) = [];t2 = t;
  m_emd(i) = mean(abs(t));
  s_emd(i) = std(abs(t))/sqrt(length(t));
  %
  t = dE_lasso(ii);t(isinf(t)) = [];t(isnan(t)) = [];t3 = t;
  m_lasso(i) = mean(abs(t));
  s_lasso(i) = std(abs(t))/sqrt(length(t));
  %
end

c = struct('c1',[26,133,255]/255, ...
          	'c2',[212,17,89]/255, ...
            'c3',[0,170,0]/255);



h = figure;
lw = 2;
hold on
grid on
box on 
errorbar(mab,m_svd,s_svd,'Color',c.c2,'LineWidth',lw)
errorbar(mab,m_emd,s_emd,'Color',c.c1,'LineWidth',lw)
errorbar(mab,m_lasso,s_lasso,'Color',c.c3,'LineWidth',lw)
% xlim([-11.5,-3.5]) -> osc
xlim([-4.5,-1])
ylim([0.1 0.3])
legend('ctf','embed','lasso')
xlabel('Daily change in bundances (log10-scale)')
ylabel('L1 error (log10-scale)')
set(gca,'FontSize',12,'FontWeight','bold');



% Saving figs 
parent_figures_folder =  ['../../Results/SIFigures/fig1d'];

% state '_carrying_capacity/'];
sim_name = append('GLV_50_runs_',state,'_K_',string(ndays),'_days');
figname = sim_name +  "_multinomial_sampling_" + string(nReads) + '_reads_1_K' +string(K) +'_daily_log';
fn = fullfile(parent_figures_folder,figname);
saveas(h, fn)
figname2 = append(figname,'.png');
fn = fullfile(parent_figures_folder,figname2);
saveas(h, fn)
figname3 = append(figname,'.pdf');
fn = fullfile(parent_figures_folder,figname3);
saveas(h, fn)