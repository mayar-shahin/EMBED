% clear 
% clc
% pwd
% addpath '..\source_codes\'
% pd =  '..\..\python_directory\Data\real_data\Absolute_Abundances_Data';
% fn = fullfile(pd,'absolute_abundances_data.mat')
% load(fn)
% whos 
% S = 1;
% K=5;
% learn_z = 0.01;learn_the = 0.01;max_steps = 100000;min_fitting = 0; min_gradients = 1e-4;
% days = [1:20];
% 
% for i =1:2
% 	[z,th,kl] = TMI_absolute(relX,S,K,learn_z, learn_the,max_steps,min_fitting,min_gradients,absX);
% 	[y,phi] = Rotating(z,th,days,max_steps);
% 	Z{i} = z; Th{i} = th;
% 	Y{i} = y; Phi{i} = phi;
% 	[z,th,kl] = TMI(relX,S,K,learn_z, learn_the,max_steps,min_fitting,min_gradients);
% 	[y,phi] = Rotating(z,th,days,max_steps);
% 	Z_rel{i} = z; Th_rel{i} = th;
% 	Y_rel{i} = y; Phi_rel{i} = phi;
% end

% figure 
% plot(Y{1}',Y{2}','o')
% title('abs')
% figure
% plot(Y_rel{1}',Y_rel{2}','o')
% title('rel')

recons_abs = absX.*normalize(exp(-Th{1}*Z{1}),'norm',1);
recons_rel = normalize(exp(-Th_rel{1}*Z_rel{1}),'norm',1);
col = rand(1,3);
figure    
subplot(1,2,1)
plot(X,recons_abs,'o','MarkerEdgeColor',col,'MarkerFaceColor',col,'MarkerSize',3);
grid on 
xlabel('Absolute Abundances')
ylabel('EMBED reconstruction')
title('c = 0.88 \pm 0.12')
subplot(1,2,2)
plot(relX,recons_rel,'o','MarkerEdgeColor',col,'MarkerFaceColor',col,'MarkerSize',3);
grid on 
xlabel('Relative Abundances')
ylabel('EMBED reconstruction')
title('c = 0.83 \pm 0.16')

[kl,mse,otuc,otus] = Evaluate_reconstruction(X, recons_abs)
[kl_rel,mse_rel,otuc_rel,otus_rel] = Evaluate_reconstruction(relX, recons_rel)


    
   