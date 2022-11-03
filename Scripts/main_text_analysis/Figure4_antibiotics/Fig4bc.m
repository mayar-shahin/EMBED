clear
clc
load Fig3a_results

%% Clustering Analysis - Figure 3 panel B 
S=6;O = size(x,1)/S;D = size(x,2);


for o =1:O
    tmp=[];
    for s = 1:N
       tmp(s,:) = Phi((s-1)*O+o,:);
       OTU_phi_table{o}=tmp;
    end    
end
clustphi=[];

% Forming the Clustergram 
for o=1:O-1
    clustphi(o,:) = reshape(OTU_phi_table{o}(:,[2:4]),[18,1]);
end

cg_h = clustergram(clustphi','Cluster','row','Linkage','Ward',...
    'DisplayRange',50,'Colormap','redbluecmap','ColumnLabels',[1:O-1]);
for k = 1:O-2
    clust{k} = str2num(cell2mat(clusterGroup(cg_h,k,'column').ColumnLabels'));
end

% ------------------------------------------------------------
% ------------------------------------------------------------
% ------------------------------------------------------------
%% CHANGE for each run!
l_clust = [10,14,24,26,32,30,37]; %% Should change by eye balling the clusters 
% ------------------------------------------------------------
% ------------------------------------------------------------
% ------------------------------------------------------------

%Colors 
col_clust{1} = [0,128,128]/255;
col_clust{2} = [0,128,0]/255;
col_clust{3} = [255,117,0]/255;
col_clust{4} = [212,0,0]/255;
col_clust{5} = [0,214,255]/255;
col_clust{6} = [0,85,247]/255;
col_clust{7} = [0,0,128]/255;



%Adding colors to the clustergram
nCl = numel(l_clust);
rm = struct('GroupNumber',mat2cell(l_clust,[1],ones(1,nCl)),...
     'Annotation',cellstr(num2str([1:nCl]'))', ...
     'Color',col_clust(1:nCl));
 
set(cg_h,'ColumnGroupMarker',rm);
%-------------------------------------------------------------------------%
% Averaging out all scaled OTUs across subjects
x_sc = x./mean(x')';
for s = 1:S
    x_sc_per_sub{s} = x_sc([(s-1)*O+1:s*O],:);
    % gives a 74x31 scaled data matrix for each subject s 
end 
mean_x_sc = zeros(O,D);
for s = 1:S
    mean_x_sc = mean_x_sc + x_sc_per_sub{s};
end
mean_x_sc = mean_x_sc/S; %mean_x_sc is abndances scaled by ...
                         %their own mean and then averaged over all
                         %subjects
%% Creating subject specific average of clusters 
for s= 1:S
    for i = 1:length(l_clust)
        mean_clusters_per_sub{i,s} = mean(x_sc_per_sub{s}(clust{l_clust(i)},:));
    end
end

%-------------------------------------------------------------------------%
%% Plot 2 - Figure 3 panel C


% %Means of OTU abundances in each cluster 
% %Abundances already averaged over subjects 
% %with errorbars being std error across OTUS in the cluster not across
% %subjects

gr = [0 0.250980392156863 0.113725490196078];

figure
for i=1:length(l_clust)
    sp = subplot(4,2,i);
    for s = 1:S
        plot(days,mean_clusters_per_sub{i,s},'Color',[128 128 128]/255, ...
        'LineWidth',0.3);
        hold on 
    end
    hold on 
    tst = mean_x_sc(clust{l_clust(i)},:);
    no_OTUs = size(tst,2);
    avg = mean(tst);
    err_bars = std(tst)/sqrt(no_OTUs);
    ymin = 0; 
    [mx,mxi] = max(avg);ymax = ceil(mx+err_bars(mxi));
    errorbar(days,avg,err_bars,'Color',col_clust{i},'linewidth',1.75)
    patch('Parent',sp,'YData',[ymin ymin ymax ymax],'XData',[0.5 4.5 4.5 0.5],'FaceAlpha',0.2,'FaceColor',gr,'EdgeColor','none')
    patch('Parent',sp,'YData',[ymin ymin ymax ymax],'XData',[14.5 18.5 18.5 14.5],'FaceAlpha',0.2,'FaceColor',gr,'EdgeColor','none')
    ylim([ymin ymax])
%     pbaspect([1 1 1])
    set(gca,'FontSize',12,'FontWeight','bold','LineWidth',0.5,'XMinorTick',...
        'on','YMinorTick','on');
    xlabel('Time (Days)')
end
%-----------------------%
ticks = [1:nCl];
tst = clust(l_clust);
suptitle('Mean Relative Abundance')


% Get a list of all variables
allvars = whos;

% Identify the variables that ARE NOT graphics handles. This uses a regular
% expression on the class of each variable to check if it's a graphics object
tosave = cellfun(@isempty, regexp({allvars.class}, '^matlab\.(ui|graphics)\.|clustergram'));

% Pass these variable names to save
save('fig3bc_results.mat', allvars(tosave).name)
