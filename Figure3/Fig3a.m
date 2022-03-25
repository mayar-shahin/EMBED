%% Figure 3 on Ng antibiotic response Data Set 
clear
clc

format shortG
format compact 

fig3_folder = cd;

cd ../Main_Source_Codes/
addpath(pwd)

cd ../Data_Sets/

load Ng_antibiotics_multi_subject 

x = antibiotics_data;

cd(fig3_folder)


%% Running TMI for k =3,4, 2 runs each
K=4;N=6;
learn_z = 0.02;learn_the = 0.02;max_steps = 2500000;min_fitting = 0; min_gradients = 1e-4;

[z,th,KL]  = TMI(x,N,K,learn_z, learn_the,max_steps,min_fitting,min_gradients);
[z2,th2,KL2]  = TMI(x,N,K,learn_z, learn_the,max_steps,min_fitting,min_gradients);
[Y,Phi] = Rotating(z,th,days,x,max_steps);
[Y2,Phi2] = Rotating(z2,th2,days,x,max_steps);


%% Plotting 2 runs to check for uniqueness

figure    
plot(Y',Y2','o')
grid on 
xlabel('Run1')
ylabel('Run2')
box on 
legend on 
legend('y_1','y_2','y_3','y_4','y_5','Orientation','horizontal')



%% Plotting ECNs


h4 = figure;k=4;ymin = -0.65; ymax = 0.65;
pu = [0.5216    0.0824    0.6784];
bl = [0.0980    0.4941    0.7608];
gr = [0 0.250980392156863 0.113725490196078];
transp = 0.3;


for i = 1:K
    comp = Y(i,:);
    splot = subplot(2,2,i)
    plot(days,comp,'-k','LineWidth',1.5)
    box on
    patch('Parent',splot,'YData',[ymin ymin ymax ymax],'XData',[0.5 4.5 4.5 0.5],'FaceAlpha',transp,'FaceColor',gr,'EdgeColor','none')
    patch('Parent',splot,'YData',[ymin ymin ymax ymax],'XData',[14.5 18.5 18.5 14.5],'FaceAlpha',transp,'FaceColor',gr,'EdgeColor','none')
    set(gca,'children',flipud(get(gca,'children')))
    ylim([ymin ymax])
    xlabel('Time (Days)','FontWeight','bold')
    ylabel(sprintf('y_%i', i),'FontWeight','bold')
    
    set(splot,'FontSize',14,'FontWeight','bold','LineWidth',1.5,'XMinorTick',...
    'on','XTick',[0 5 10 15 20 25],'YMinorTick','on','YTick',...
    [-0.5 -0.25 0 0.25 0.5],'YTickLabel',{'-0.5','-0.25','0','0.25','0.5'});
end














save('Fig3a_results','Phi','Y','days','x','N')










