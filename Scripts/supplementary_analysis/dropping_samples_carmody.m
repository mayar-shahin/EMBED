% clear 
% clc
% addpath '..\..\Results\methods_results\multi_subject_data_embed_results'
% addpath '..\source_codes'
% format shortG
% format compact 
% load Carmody_EMBED_results
% %% Prepare the data
% S=5;
% O = size(x_norm,1)/S;
% T = size(x_norm,2);
% 
% for s = 1:S
%     x_norm_per_sub{s} = x_norm([(s-1)*O+1:s*O],:);
%     days_s{s} = days;
% end 
% %% Randomly delete a percentage of the data 
% perc=[0.1,0.2,0.3,0.4,0.5]; 
% for p = 1:length(perc)
% 
%     disp(p)
%     
%     mask = zeros(S,T);
%     k=0;
%     while sum(sum(mask)==0)~=0 % make sure at least 1 subject is present everyday 
%         k=k+1;
%         mask = rand(S,T)> perc(p);
%     end
%     mask_p{p} = mask; 
%     
%     K=5;S=5;
%     learn_z = 0.01;learn_the = 0.01;max_steps = 1000000;min_fitting = 0; min_gradients = 1e-4;
%     [z,th,KL]  = TMI_masked_samples(x_norm,S,K,mask,learn_z, learn_the,max_steps,min_fitting,min_gradients);
%     [Y,Phi] = Rotating(z,th,days,x_norm,max_steps);
%     Ys{p} = Y;
%     Phis{p} = Phi;
% %     KLs(p) = KL;
% end
% 
% clear *_upd 
% 
% %% Doing the cosine similarity analysis on ECNs and switching them to maximize the cosine similarities
% x = Y5;
% % 
% poss_perms = perms([1:5]);
% for j = 1:length(perc)
%     for i = 1:size(poss_perms,1)
%         [yTemp,phiTemp]= Switcher(Ys{j},Phis{j},1,poss_perms(i,:),0,[]);
%         y = yTemp;
%         xy   = dot(x',y');
%         sumCosineSim(i)= sum(abs(xy));
%     end
%     [val, good_perm_ind] = max(sumCosineSim);
%     good_perm = poss_perms(good_perm_ind,:);
%     [Ys{j},Phis{j}] = Switcher(Ys{j},Phis{j},1,good_perm,0);
%     y = Ys{j};
%     Cs(j,:) = dot(x',y');
% end

%% Flipping ECNs with negative cosine similarities for proper overlay
% for j =1:length(perc)
%     for i = 1:5
%         if Cs(j,i)<0
%             [Ys{j},Phis{j}] = Switcher(Ys{j},Phis{j},0,[],1,[i]);
%             
%         end
%         
%     end
%     y = Ys{j}
%     Cs(j,:) = dot(x',y');
% end

load('..\..\Results\supplementary_results\dropping_samples_carmody_results.mat')

%% Plotting an overlay of ECNs

c = struct('rr', [0.9047, 0.1918, 0.1988], ...  %Your required color
    'bb', [0.2941, 0.5447, 0.7494], ... %Your required color
    'um', [0.0824, 0.1294, 0.4196], ... %ultra marine
    'br', [0.6510, 0.5725, 0.3412], ... %bronze
    'wr', [0.5804, 0, 0.1059] ); 
lc = {[180,0,0]/255,[0,103,0]/255,[249,191,56]/255,[170,0,212]/255,[0,204,255]/255};
% 
figure
yLabels = {'y_1','y_2','y_3','y_4','y_5'};
for i= 1:5
        subplot(1,5,i)
        plot(days,Y5(i,:),'k','LineWidth',1.75)
        hold on 
        for k=1:length(perc)
            plot(days,Ys{k}(i,:),'Color',lc{k},'LineWidth',1.75)
        end
        patch([0 3.5 3.5 0],[-0.5 -0.5 0.5 0.5],c.bb,'EdgeColor','none')
        alpha(0.3)
        set(gca,'children',flipud(get(gca,'children')))

        k=0;

        while k<20
            patch([k+3.5 k+6.5 k+6.5 k+3.5],[-0.5 -0.5 0.5 0.5],c.wr,'EdgeColor','none')
            alpha(0.3)
            set(gca,'children',flipud(get(gca,'children')))
            k=k+6;
        end
        k=3;
        while k<25
            patch([k+3.5 k+6.5 k+6.5 k+3.5],[-0.5 -0.5 0.5 0.5],c.bb,'EdgeColor','none')
            alpha(0.3)
            set(gca,'children',flipud(get(gca,'children')))
            k=k+6;
        end

        patch([27.5 36 36 27.5],[-0.5 -0.5 0.5 0.5],c.wr,'EdgeColor','none')
        alpha(0.3)
        set(gca,'children',flipud(get(gca,'children')))

        axis([0 36 -0.5 0.5])
        xlabel('Time (Days)','FontWeight','bold')
        ylabel(yLabels{i},'FontWeight','bold')
        set(gca,'linewidth',1)
        pbaspect([1 1 1])
        set(gca,'FontSize',12,'FontWeight','bold','LineWidth',2,'XMinorTick',...
        'on','YMinorTick','on');
end


% save('..\..\Results\supplementary_results\dropping_samples_carmody_results.mat')
