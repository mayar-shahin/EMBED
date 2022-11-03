%% Run EMBED on glv and save 
state = 'constant';
ndays = 300;nReads = 10000; K=3;reps =50;
parent_data_folder =  ['../../../python_directory/Data/in_silico_data/' state '_carrying_capacity/'];
parent_methods_folder =  ['../../../python_directory/Results/in_silico/' state '_carrying_capacity/'];
sim_name = append('GLV_50_runs_',state,'_K_',string(ndays),'_days');
% 
% %% load basetruth simulation data
base_truth_fn = append(sim_name,"_basetruth_filtered.mat");
fn = fullfile(parent_data_folder,base_truth_fn);
load(fn)
data = xs_filtered;
% %% load tmi results and then rotate 
% % 
% %load TMI
method = 'tmi';
method_folder =fullfile(method,'K'+string(K));
method_result_fn = sim_name + "_multinomial_sampling_" + string(nReads) + '_reads_1_' +string(method) + '_K' +string(K) +'_results.mat';
fn = fullfile(parent_methods_folder ,method_folder, method_result_fn);
load(fn)

addpath '../../source_codes/'
days = [1:30];
max_steps = 1e6;

parent_methods_folder =  ['../../../python_directory/Results/in_silico/' state '_carrying_capacity/'];
method = 'embed';
method_folder =fullfile(method,'K'+string(K));
fn = sim_name + "_multinomial_sampling_" + string(nReads) + '_reads_1_embed_K' +string(K)+'_results.mat';
fn = fullfile(parent_methods_folder ,method_folder, fn);
%
for rep =1:reps
    data = xs_filtered{rep};
    % embed from tmi
    z=Zs(rep,:,:,:);
    z = reshape(z, [K,days(end)]);
    theta = Thetas{rep};
    [Y,Phi] = Rotating(z,theta,days,max_steps);
    Ys{rep}=Y;Phis{rep} = Phi;
end
parent_methods_folder =  ['../../../python_directory/Results/in_silico/' state '_carrying_capacity/'];
method = 'embed';
method_folder =fullfile(method,'K'+string(K));
fn = sim_name + "_multinomial_sampling_" + string(nReads) + '_reads_1_embed_K' +string(K)+'_results.mat';
fn = fullfile(parent_methods_folder ,method_folder, fn);
save(fn,'Ys','Phis')
