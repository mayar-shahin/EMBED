% clear 
% clc
% addpath '..\..\Results\methods_results\multi_subject_data_embed_results'
% addpath '..\source_codes'
% format shortG
% format compact 
% load Ng_EMBED_results
% 
% %% Prepare the data
% S=6;
% O = size(x_norm,1)/S;
% T = size(x_norm,2);
% % 
% for s = 1:S
%     x_norm_per_sub{s} = x_norm([(s-1)*O+1:s*O],:);
%     days_s{s} = days;
% end 
%  
% %% Randomly delete a percentage of the data 
% perc=[0.1,0.2,0.3,0.4,0.5]; 
% for p = 1:length(perc)
% 
%     disp(p)
%     mask = zeros(S,T);
%     k=0;
%     while sum(sum(mask)==0)~=0 % make sure at least 1 subject is present everyday 
%         k=k+1;
%         mask = rand(S,T)> perc(p);
%     end
%     mask_p{p} = mask; 
%     disp(size(mask))
% 
% %% Running EMBED for k = 4
%     
%     K=4;
%     learn_z = 0.005;learn_the = 0.005;max_steps = 2500000;min_fitting = 1e-30; min_gradients = 1e-4;
%     [z,th,KL]  = TMI_masked_samples(x_norm,S,K,mask,learn_z, learn_the,max_steps,min_fitting,min_gradients);
%     [Y,Phi] = Rotating(z,th,days,x_norm,max_steps);
%     Ys{p} = Y;
%     Phis{p} = Phi;
%     KLs(p) = KL;
% 
% end
% 
% %% Loading the regular cutoff ECNs 
% load Ng_EMBED_results
% clear *_upd
% 
%% Doing the cosine similarity analysis on ECNs and switching them to maximize the cosine similarities

x = Y4;
% 
poss_perms = perms([1,2,3,4]);
for j = 1:length(perc)
    for i = 1:size(poss_perms,1)
        [yTemp,phiTemp]= Switcher(Ys{j},Phis{j},1,poss_perms(i,:),0,[]);
        y = yTemp;
        xy   = dot(x',y');
        sumCosineSim(i)= sum(abs(xy));
    end
    [val, good_perm_ind] = max(sumCosineSim);
    good_perm = poss_perms(good_perm_ind,:);
    [Ys{j},Phis{j}] = Switcher(Ys{j},Phis{j},1,good_perm,0);
    y = Ys{j};
    Cs(j,:) = dot(x',y');
end
% 
%% Flipping ECNs with negative cosine similarities for proper overlay
for j =1:length(perc)
    for i = 1:4
        if Cs(j,i)<0
            [Ys{j},Phis{j}] = Switcher(Ys{j},Phis{j},0,[],1,[i]);
        end
    end
    y = Ys{j}
    Cs(j,:) = dot(x',y');
end

%% Plotting an overlay of ECNs

c = struct('rr', [0.9047, 0.1918, 0.1988], ...  %Your required color
    'bb', [0.2941, 0.5447, 0.7494], ... %Your required color
    'um', [0.0824, 0.1294, 0.4196], ... %ultra marine
    'br', [0.6510, 0.5725, 0.3412], ... %bronze
    'wr', [0.5804, 0, 0.1059] ); 
lc = {[180,0,0]/255,[0,103,0]/255,[249,191,56]/255,[170,0,212]/255,[0,204,255]/255};

figure
k=4;ymin = -0.65; ymax = 0.6;
gr = [0 0.250980392156863 0.113725490196078];
yLabels = {'y_1','y_2','y_3','y_4'};
for i = 1:4
    comp = Y4(i,:);
    splot = subplot(1,4,i);
    plot(days,comp,'-k','LineWidth',1.5)
    hold on 
    for k=1:length(perc)
        plot(days,Ys{k}(i,:),'Color',lc{k},'LineWidth',1.75)
    end
    box on
    patch('Parent',splot,'YData',[ymin ymin ymax ymax],'XData',[0.5 4.5 4.5 0.5],'FaceAlpha',0.2,'FaceColor',gr,'EdgeColor','none')
    patch('Parent',splot,'YData',[ymin ymin ymax ymax],'XData',[14.5 18.5 18.5 14.5],'FaceAlpha',0.2,'FaceColor',gr,'EdgeColor','none')
    set(gca,'children',flipud(get(gca,'children')))
    xlim([0 27])
    ylim([ymin ymax])
    if i==4
        xlabel('Time (Days)','FontWeight','bold')
    end
    title(sprintf('y_%i', i),'FontWeight','bold')
    set(splot,'FontSize',10,'FontWeight','bold','LineWidth',1.5,'XMinorTick',...
    'on','XTick',[0 5 10 15 20 25],'YMinorTick','on','YTick',...
    [-0.5 -0.25 0 0.25 0.5],'YTickLabel',{'-0.5','-0.25','0','0.25','0.5'});
    pbaspect([1 1 1])
    set(gca,'FontSize',12,'FontWeight','bold','LineWidth',0.75,'XMinorTick',...
    'on','YMinorTick','on');
end
% save('..\..\Results\supplementary_results\dropping_samples_ng_results.mat')

% load('..\..\Results\supplementary_results\dropping_samples_ng_results.mat')






