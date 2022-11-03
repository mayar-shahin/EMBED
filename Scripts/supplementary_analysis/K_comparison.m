clear 
clc 
 
%% Load Data from subfolder data
parent_data_folder =  '..\..\python_directory\Data\real_data\Multi_Subject_Data\';

ds_names = {'Carmody','Ng'};

for d = 1:length(ds_names)
    basename = strcat(ds_names{d},'_Multi_Subject.mat');
    fn = fullfile(parent_data_folder, basename);
    load(fn)
    x.(ds_names{d}) = X;
end
disp(x)


%% Loading TMI results for the Multi Subject Data
parent_method_folder =  '..\..\Results\methods_results\tmi_multi_subject_results_K\';
addpath '..\..\Scripts\source_codes';



%% Plotting method evaluation plots for all Ks

Klist = [1:12];

for d = 1:length(ds_names)
    data = x.(ds_names{d});
    for K = Klist
        
        basename = strcat('multi_tmi_multi_results_K',string(K),'.mat');    
        fn = fullfile(parent_method_folder, basename);
        load(fn)
        xtmi = eval(strcat(ds_names{d},'_Multi_Subject.tmi'));
%         [kl(d,K-2),mse_otu(d,K-2),otu_corr_mean(d,K-2)] = ...
%         Evaluate_reconstruction(data, xtmi);
            [kl(d,K),mse_otu(d,K),otu_corr_mean(d,K)] = ...
        Evaluate_reconstruction(data, xtmi);

    end
end

del = 0.5;
uK = [5,4];
fs = 10;fs2=14;

figure 
for d = 1:2
    subplot(2,3,(d-1)*3+1)
    plot(Klist,kl(d,:),'-bo',...
    'LineWidth',2,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor','b',...
    'MarkerSize',7)
    hold on 
%     plot(uK(d),kl(d,uK(d)-2),'ro',...
%             'LineWidth',2,...
%         'MarkerEdgeColor','r',...
%         'MarkerFaceColor','r',...
%         'MarkerSize',7)
        plot(uK(d),kl(d,uK(d)),'ro',...
            'LineWidth',2,...
        'MarkerEdgeColor','r',...
        'MarkerFaceColor','r',...
        'MarkerSize',7)

    xlim([Klist(1)-1,Klist(end)+1])
%     xlabel('K','FontSize',fs,'fontweight','bold')
    xticks(Klist)    
%     ylim("padded")
    ylabel('KL Divergence','FontSize',fs,'fontweight','bold')

        
    ax = gca;
    ax.FontSize = fs;
        ax.FontWeight = 'bold';

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(2,3,(d-1)*3+2)
    plot(Klist,mse_otu(d,:),'-bo',...
    'LineWidth',2,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor','b',...
    'MarkerSize',7)

    hold on 
%     plot(uK(d),mse_otu(d,uK(d)-2),'ro',...
%             'LineWidth',2,...
%         'MarkerEdgeColor','r',...
%         'MarkerFaceColor','r',...
%         'MarkerSize',7)
plot(uK(d),mse_otu(d,uK(d)),'ro',...
            'LineWidth',2,...
        'MarkerEdgeColor','r',...
        'MarkerFaceColor','r',...
        'MarkerSize',7)


    xlim([Klist(1)-1,Klist(end)+1])
%     xlabel('K','FontSize',fs,'fontweight','bold')
    xticks(Klist)
%     ylim(padded)

    ylabel('Mean Squared Error','FontSize',fs,'fontweight','bold')
      
    ax = gca;
    ax.FontSize = fs;
        ax.FontWeight = 'bold';

    if d==1
        title(['Carmody Diet Oscillation Data' newline ],'FontSize',fs)
    else
        title(['Ng Antibiotics Data' newline ],'FontSize',fs)
    end
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    subplot(2,3,(d-1)*3+3)
    
    plot(Klist,otu_corr_mean(d,:),'-bo',...
    'LineWidth',2,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor','b',...
    'MarkerSize',7)

    hold on 
%     plot(uK(d),otu_corr_mean(d,uK(d)-2),'ro',...
%             'LineWidth',2,...
%         'MarkerEdgeColor','r',...
%         'MarkerFaceColor','r',...
%         'MarkerSize',7)
    plot(uK(d),otu_corr_mean(d,uK(d)),'ro',...
            'LineWidth',2,...
        'MarkerEdgeColor','r',...
        'MarkerFaceColor','r',...
        'MarkerSize',7)


    xlim([Klist(1)-1,Klist(end)+1])
%     xlabel('K','FontSize',fs,'fontweight','bold')
    xticks(Klist)
    
%     ylim(padded)
    ylabel('Mean OTU Correlation','FontSize',fs,'fontweight','bold')
    
    sgtitle('Model Accuracy vs. Number of latents (K)','FontSize',fs2,'fontweight','bold')
    ax = gca;
    ax.FontSize = fs;
    ax.FontWeight = 'bold';
    
    
    
    end
