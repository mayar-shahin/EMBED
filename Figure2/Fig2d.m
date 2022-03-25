load Fig2a_results 

%% Creating OTU tables 
S=5;O = size(x,1)/S;
for s = 1:S
    phi_per_sub{s} = Phi([(s-1)*O+1:s*O],:);
    % gives a 74x5 Phi matrix for each subject s 
end 
clear mat
for o = 1:O
    for s = 1:N
        sub = cell2mat(phi_per_sub(s)); 
        mat(s,:) = sub(o,:);
    end
    OTU_phi_table{o} = mat;
end
%% Calculating pair-wise distances between subjects
for o=1:O
    tst = cell2mat(OTU_phi_table(o));
    tst = pdist(tst(:,[2:end]));
    av_pdist(o) = mean(tst);
end

%% Calculating pairwise distance between subjects based on full vector
%1) Scale each OTU by its own mean 
x_sc = x./mean(x')';

for s = 1:S
    x_sc_per_sub{s} = x_sc([(s-1)*O+1:s*O],:);
    % gives a 74x31 scaled data matrix for each subject s 
end 
clear mat2
for o = 1:O
    for s = 1:N
        sub = x_sc_per_sub{s}; 
        mat2(s,:) = sub(o,:);
    end
    OTU_sc_traj_table{o} = mat2;
end
for o=1:O
    tst = cell2mat(OTU_sc_traj_table(o));
    tst = pdist(tst(:,[2:end]));
    av_pdist_traj(o) = mean(tst);
end

[a,ind] = sort(av_pdist);


% Small plot for correlation of phi distances and full traj distances
% regular plot
ms = 7;
col.gr = [0 128 0]/255;
col.purp = [160 44 137]/255;
col.orange = [255 102 0]/255;

semilogx(av_pdist(ind(2:11)),av_pdist_traj(ind(2:11)),'o','MarkerEdgeColor',col.gr,'MarkerFaceColor',col.gr,'MarkerSize',ms)
hold on
semilogx(av_pdist(ind(12:64)),av_pdist_traj(ind(12:64)),'o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',ms)
semilogx(av_pdist(ind(65:end)),av_pdist_traj(ind(65:end)),'o','MarkerEdgeColor',col.orange,'MarkerFaceColor',col.orange,'MarkerSize',ms)
% title('Average pair-wise distance between subjects')
xlabel('\Phi Distance')
ylabel('Trajectory Distance')
box off
set(gca,'FontSize',20,'FontWeight','bold','LineWidth',0.5,'XMinorTick',...
'on','YMinorTick','on');
  
%% Plotting highest and lowest varying OTUs across subjects 
[a,ind] = sort(av_pdist);
%Lowest var
non_var_ind = ind(2:11);
hi_var_ind = ind(end-9:end);
tst_lo = zeros(5,31);
for i=non_var_ind
tst_lo = tst_lo + OTU_sc_traj_table{i};
end
tst_lo = tst_lo/length(non_var_ind);
tst_hi = zeros(5,31);
for i=hi_var_ind
tst_hi = tst_hi + OTU_sc_traj_table{i};
end
tst_hi = tst_hi/length(non_var_ind);

figure
ax1 = subplot(2,1,1)
plot(days,tst_hi,'-k')
xlim([days(1) days(end)])
hold on
plot(days,mean(tst_hi),'Color',col.orange,'LineWidth',2.5)
xticks([])
set(gca,'FontSize',14,'FontWeight','bold','LineWidth',0.5,'XMinorTick',...
'on','YMinorTick','on');
box off

subplot(2,1,2)
plot(days,tst_lo,'-k')
hold on
plot(days,mean(tst_lo),'Color',col.gr,'LineWidth',2.5)
xlim([days(1) days(end)])
xlabel('Time (Days)')
% ylabel('Mean Relative Abundance (across OTUs)')
xticks([0:5:35])
box off
set(gca,'FontSize',14,'FontWeight','bold','LineWidth',0.5,'XMinorTick',...
'on','YMinorTick','on');
ax1.XAxis.Visible = 'off'; % remove x-axis







