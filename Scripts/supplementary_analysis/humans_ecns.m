clear 
clc
% addpath '..\data\real_data\Humans\'
% 
%% Loading EMBED results for human Data
parent_method_folder =  '..\..\Results\methods_results\';
addpath '..\..\Scripts\source_codes';
fn = fullfile(parent_method_folder,'human_ecn_results.mat')
load(fn)
% ds_names = {'davA','davB','capF4','capM3'};
% 
% learn_z = 0.01;learn_the = 0.01;max_steps = 2500000;min_fitting = 0; min_gradients = 1e-4;
% %     
% k=3;
% 
% addpath '..\Functions_Matlab'
% 
% for i = 1:length(ds_names)
%     dn = ds_names{i};
%     fn = sprintf('%s.mat',dn);
%     disp(fn)
%     load(fn)
%     X.(dn) = x;
%     Days.(dn) = days;
%     [z.(dn),th.(dn),KL.(dn)]  = TMI(X.(dn),1,k,learn_z, learn_the,max_steps,min_fitting,min_gradients);
%     [z2.(dn),th2.(dn),KL2.(dn)]  = TMI(X.(dn),1,k,learn_z, learn_the,max_steps,min_fitting,min_gradients);
%     max_steps = 2500000;
%     [Y.(dn),Phi.(dn)] = Rotating(z.(dn),th.(dn),Days.(dn), X.(dn),max_steps);
%     [Y2.(dn),Phi2.(dn)] = Rotating(z2.(dn),th2.(dn),Days.(dn), X.(dn),max_steps); 
% end
% 
% save('..\Methods_Results\human_ecn_results.mat')
% % 
% 
% dn = 'davB2'
% % X.(dn) = x;
% Days.(dn) = days;
% [z.(dn),th.(dn),KL.(dn)]  = TMI(X.(dn),1,k,learn_z, learn_the,max_steps,min_fitting,min_gradients);
% [z2.(dn),th2.(dn),KL2.(dn)]  = TMI(X.(dn),1,k,learn_z, learn_the,max_steps,min_fitting,min_gradients);
% max_steps = 2500000;
% [Y.(dn),Phi.(dn)] = Rotating(z.(dn),th.(dn),Days.(dn), X.(dn),max_steps);
% [Y2.(dn),Phi2.(dn)] = Rotating(z2.(dn),th2.(dn),Days.(dn), X.(dn),max_steps); 
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 
nDS = length(ds_names);
titles = {'David A','David B','Caporaso F4','Caporaso M3'};
% nK = length(Klist);

for s = 1:nDS
    subplot(2,2,s)
    dn = ds_names{s};
    plot(Days.(dn),Y.(dn)','LineWidth',2)
    box on
    set(gca,'FontSize',12)
    xlabel('Time (Days)')
    ylabel('Y')
    if s==1
        legend('y1','y2','y3','Orientation','horizontal')
    end
    ax = gca
    ax.FontWeight = 'bold';
    title(titles{s})
    ylim([-0.5 0.5])
    xlim([Days.(dn)(1), Days.(dn)(end)])

end



% 
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Uniqueness plots
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% figure 
% nDS = length(ds_names);
% for s = 1:nDS
%     subplot(2,2,s)
%     dn = ds_names{s};
%     plot(Y.(dn)',Y2.(dn)','o')
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
