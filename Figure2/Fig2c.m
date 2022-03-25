%% Clustering Analysis - Figure 2 panel C 

load Fig2a_results 

O = size(x,1)/N;

for o =1:O
    tmp=[];
    for s = 1:N
       tmp(s,:) = Phi((s-1)*O+o,:);
       OTU_phi_table{o}=tmp;
    end    
end
clustphi=[];

% Forming the Clustergram based on only phi2 and phi3 values for all
% subjects

for o=1:O-1
    clustphi(o,:) = reshape(OTU_phi_table{o}(:,[2,3]),[10,1]);
end

cg_h = clustergram(clustphi','Cluster','row','Linkage','Ward',...
    'DisplayRange',8,'Colormap','redbluecmap','ColumnLabels',[1:73])

for k = 1:72
    clust{k} = str2num(cell2mat(clusterGroup(cg_h,k,'column').ColumnLabels));
end
% 
%Clusters identified by eye to plot (will change with different runs
l_clust = [68,70,69];
