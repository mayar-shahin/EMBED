%% z-scoring the ECNs
clear 
clc
addpath '..\Methods_Results\'
whos
load Carmody_EMBED_results

T = size(Y5,2);
for i = 1:size(Y5,1)
    ind{i} = randperm(T);
    Y5_shuffled(i,:) = Y5(i,ind{i});
    mean(zscore(Y5_shuffled(i,:))/zscore(Y5(i,:)))
end

load Ng_EMBED_results.mat
T = size(Y4,2);
for i = 1:size(Y4,1)
    ind{i} = randperm(T);
    Y4_shuffled(i,:) = Y4(i,ind{i});
    mean(zscore(Y4_shuffled(i,:))/zscore(Y4(i,:)))
end
