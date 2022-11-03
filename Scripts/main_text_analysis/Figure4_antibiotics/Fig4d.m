%% Figure 3d


clear
clc
load Fig3bc_results


for o=1:O
    tst = OTU_phi_table{o};
    tst = pdist(tst(:,[2:end]));
    av_pdist(o) = mean(tst);
end



figure
for i = 1:nCl
    plot(i,av_pdist(clust{l_clust(i)}),'o','MarkerSize',10,'Color',col_clust{i},'MarkerFaceColor',col_clust{i})
    hold on 
end
    xlim([0 nCl+1])
    xticks([1:nCl])
for i = 1:nCl
clust_labels{i} = sprintf('%i',i);
end
    xticklabels(clust_labels)
    set(gca,'FontSize',14,'FontWeight','bold','LineWidth',0.5,'YMinorTick','on');
xlabel('Clusters')
ylabel('Average \Phi distance')

s