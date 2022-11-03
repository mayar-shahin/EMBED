%% Figure 2b
load Fig2a_results 


%% Sorting Analysis for multisubject diet
S=5;O = size(x,1)/S;
for s = 1:S
    phi_per_sub{s} = Phi([(s-1)*O+1:s*O],:);
    % gives a 74x5 Phi matrix for each subject s 
end

for s=1:5
    phi_mat = phi_per_sub{s};
    [a{s},i{s}] = sort(phi_mat);
end
%% getting OTU abundances for Highest and Lowest Phi4 and Phi5 indices 

clear phi_5_ind phi_4_ind


for s  = 1:5
    phi_5_ind{s} = i{s}([1:10],5)';
    phi_4_ind{s} = i{s}([1:10],4)';
    indices_hi_phi_4{s} = setdiff(phi_4_ind{s},[phi_5_ind{s},74],'stable');
    if length(indices_hi_phi_4{s})<5
        indices_hi_phi_4{s} = indices_hi_phi_4{s}(1:length(indices_hi_phi_4{s}));
    else 
        indices_hi_phi_4{s} = indices_hi_phi_4{s}(1:5);
    end
end


clear phi_5_ind phi_4_ind


for s  = 1:5
    phi_5_ind{s} = i{s}([1:10],5)';
    phi_4_ind{s} = i{s}([1:10],4)';
    indices_hi_phi_5{s} = setdiff(phi_5_ind{s},[phi_4_ind{s},74],'stable');
    if length(indices_hi_phi_5{s})<5
        indices_hi_phi_5{s} = indices_hi_phi_5{s}(1:length(indices_hi_phi_5{s}));
    else 
        indices_hi_phi_5{s} = indices_hi_phi_5{s}(1:5);
    end
end

clear phi_5_ind phi_4_ind


for s  = 1:5
    phi_5_ind{s} = i{s}([end-10:end],5)';
    phi_4_ind{s} = i{s}([end-10:end],4)';
    indices_lo_phi_4{s} = setdiff(phi_4_ind{s},[phi_5_ind{s},74],'stable');
    if length(indices_lo_phi_4{s})<5
        indices_lo_phi_4{s} = indices_lo_phi_4{s}(1:length(indices_lo_phi_4{s}));
    else 
        indices_lo_phi_4{s} = indices_lo_phi_4{s}(1:5);
    end
  end

  
clear phi_5_ind phi_4_ind


for s  = 1:5
    phi_5_ind{s} = i{s}([end-10:end],5)';
    phi_4_ind{s} = i{s}([end-10:end],4)';
    indices_lo_phi_5{s} = setdiff(phi_5_ind{s},[phi_4_ind{s},74],'stable');
    if length(indices_lo_phi_5{s})<5
        indices_lo_phi_5{s} = indices_lo_phi_5{s}(1:length(indices_lo_phi_4{s}));
    else 
        indices_lo_phi_5{s} = indices_lo_phi_5{s}(1:5);
    end
  end






