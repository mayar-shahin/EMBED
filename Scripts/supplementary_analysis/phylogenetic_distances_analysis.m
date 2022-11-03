%% In group vs out group phi distances 
clear 
clc
addpath '..\..\Results\methods_results\multi_subject_data_embed_results'
addpath '..\source_codes'
format shortG
format compact 
load Carmody_EMBED_results
whos

%% Hierarchical Clustering og Phi 2 & 3
[O,T] = size(x_norm);S = 5;
K = size(Phi5,2); O = O/S;
% 
for k=1:K %storing each phi as SxO matrix
    phi{k} = reshape(Phi5(:,k),[O,S]);
    
end

clust_phi = [phi{2},phi{3}];
% remove the noise OTU from clustering
clust_phi(end,:) =[];


% % Forming the Clustergram 

cg_v = clustergram(clust_phi,'Cluster','column','Linkage','Ward',...
    'Colormap','redbluecmap','RowLabels',[1:73])
% cg_h = clustergram(clust_phi','Cluster','row','Linkage','Ward',...
%     'DisplayRange',8,'Colormap','redbluecmap','ColumnLabels',[1:73])

for k = 1:72
    clust{k} = str2num(cell2mat(clusterGroup(cg_v,k,'row').RowLabels));
end
%Clusters identified by eye to plot
l_clust = [68,70,69];
% Colors 
col_clust{1} = [0.18,0.38,0.55];
col_clust{2} = [0,0,0];
col_clust{3} = [0.49,0,0.35];


%% Build a 2d cell with dimensions OTU x classification 
% phy = ['p','c','o','f','g'];
phy = ['p','c','o','f'];

phylogeny= cell(74,length(phy));
for i = 1:length(phy)
    tmp = eval(strcat(phy(i),'tax_upd'));
    phylogeny(:,i)= tmp;
end


clusters = clust(l_clust);
% 
for i = 1:O
    for j = 1:O
        mat(i,j) = hamming(i,j,phylogeny);
    end
end

%% Performing Phylogeny analysis on identified clusters
for c = 1:3
    otus = clusters{c};
    
    for i = 1:length(otus)
        o = otus(i);
        in_group_otus = setdiff(otus,o);
        in_group(o) = mean(mat(o,in_group_otus));
        out_group_otus = setdiff([1:73],o);
        out_group(o) = mean(mat(o,out_group_otus));
    end
end
% 

[p,h] = ranksum(in_group,out_group)


