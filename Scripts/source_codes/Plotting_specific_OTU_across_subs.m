figure
N=6;O=41;o=2;
tst = zeros(1,31);
for s = 1:N
    x_s = x_norm([(s-1)*O+1:s*O],:);
    otu_series = x_s(o,:);
%     tst = tst + otu_series;
    subplot(2,3,s)
    plot(days,otu_series,'-k','linewidth',1.5)
    xlim([days(1) days(end)])
    xlabel('Time(Days)','FontWeight','bold')
    ylabel(' Relative Abundance','FontWeight','bold')
end
% tst = tst/N;
% subplot(2,3,6)
% plot(days,tst,'-k','linewidth',1.5)
% xlim([days(1) days(end)])
% xlabel('Time(Days)','FontWeight','bold')
% ylabel('Mean Relative Abundance','FontWeight','bold')
% title('Averaged over subjects')
% 
% 




tst = [x1(o,:);x2(o,:);x3(o,:);x4(o,:);x5(o,:)];
[c,p] = corr(tst','Type','Spearman')


figure
for s = 1:5
    tst = x_norm([(s-1)*74+1:s*74],:);
    tst = tst(clust42,:);
    tst = tst./mean(tst,2);
    avg = mean(tst)
    subplot(2,3,s)
    plot(days,avg,'-k','linewidth',4)
    xlim([days(1) days(end)])
    xlabel('Time(Days)','FontWeight','bold')
    ylabel('Mean Relative Abundance','FontWeight','bold')
end