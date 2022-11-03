
function[h] = Phi1_corr_plotter(Phi,x_norm,N,Title)
    o=size(x_norm,1)/N;
    h = figure 
    for n=1:N
        col = rand(1,3);
        tst = mean(x_norm([(n-1)*o+1:o*n],:)');
        tst_phi = Phi([(n-1)*o+1:o*n],1);
        semilogy(tst_phi,tst,'o','MarkerEdgeColor',col,'MarkerFaceColor',col,'MarkerSize',8)
        hold on
    end
    legend("Subject " + string([1:N]),'Location','southwest')
    grid on 
    ax = gca;
    ax.FontSize = 20;
    xlabel('\Phi_1','FontSize',18,'fontweight','bold')
    ylabel('Mean Abundance','FontSize',20,'fontweight','bold')
    title(Title,'FontSize',20)
end