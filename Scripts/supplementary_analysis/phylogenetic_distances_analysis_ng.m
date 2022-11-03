%% In group vs out group phi distances 
clear 
clc
addpath '..\Methods_Results\'
whos
load Ng_EMBED_results

%% Build a 2d cell with dimensions OTU x classification 
phy = ['p','c','o','f','g'];
% phy = ['p'];
phylogeny= cell(41,length(phy));
for i = 1:length(phy)
    tmp = eval(strcat(phy(i),'tax_upd'));
    phylogeny(:,i)= tmp;
end

%% Hierarchical Clustering og Phi 2 & 3
[O,T] = size(x_norm);S = 6;
K = size(Phi4,2); O = O/S;
% 
for k=1:K %storing each phi as SxO matrix
    phi{k} = reshape(Phi4(:,k),[O,S]);
    
end

clust_phi = [phi{2},phi{3},phi{4}];
% remove the noise OTU from clustering
clust_phi(end,:) =[];


% % Forming the Clustergram 

cg_v = clustergram(clust_phi,'Cluster','column','Linkage','Ward',...
    'Colormap','redbluecmap','RowLabels',[1:O-1])
% cg_h = clustergram(clust_phi','Cluster','row','Linkage','Ward',...
%     'DisplayRange',8,'Colormap','redbluecmap','ColumnLabels',[1:73])

for k = 1:O-2
    clust{k} = str2num(cell2mat(clusterGroup(cg_v,k,'row').RowLabels));
end
%Clusters identified by eye to plot
l_clust = [10,14,24,26,32,30,37]; %03

%% Performing Phylogeny analysis on identified clusters

clusters = clust(l_clust);
% 
for i = 1:O
    for j = 1:O
        mat(i,j) = hamming(i,j,phylogeny);
    end
end
% % 
% 
% % triu(mat)
for c = 1:numel(clusters)
    otus = clusters{c};
    
    for i = 1:length(otus)
        o = otus(i);
        in_group_otus = setdiff(otus,o);
        in_group(o) = mean(mat(o,in_group_otus));
        out_group_otus = setdiff([1:O-1],o);
        out_group(o) = mean(mat(o,out_group_otus));
    end
end
% 

[p,h] = ranksum(in_group,out_group)



% 0.382087529915881
