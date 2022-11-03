function[h] = Corr_plotter_multi(Phi,Y,X_norm,N,Title)
    clear p 
    recons = exp(-Phi*Y);
    o=size(X_norm,1)/N;
    for n=1:N
        recons([(n-1)*o+1:o*n],:) = normalize(recons([(n-1)*o+1:o*n],:),'norm',1);
    end
    recons = recons/N;
%     tst = gobjects(31,N);
    figure    
    
    for i=1:N
        col = rand(1,3);
        tst(:,i) = plot(X_norm([(i-1)*o+1:o*i],:),recons([(i-1)*o+1:o*i],:),'o','MarkerEdgeColor',col,'MarkerFaceColor',col,'MarkerSize',3);
        hold on 
    end
%     legend([tst(1,1),tst(1,2),tst(1,3),tst(1,4),tst(1,5),tst(1,6)],...
%         "Subject " + string([1:N]),'Location','southeast')

    grid on 
    xlabel('Original Data')
    ylabel('Data Reconstruction using exp(-Y \cdot \Phi)')
    title(Title)
    
    
end