function [dist] = hamming(O1,O2,phylogeny)
    dist=0;
    for tax =1:size(phylogeny,2)
        dist = dist + not(strcmp(phylogeny(O1,tax),phylogeny(O2,tax)));
    end
end

