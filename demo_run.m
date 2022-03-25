%% DEMO on Carmody Diet Oscillation Data Set 
clear
clc

format shortG
format compact 

main_folder = cd;
cd Main_Source_Codes\
addpath(pwd)

cd(main_folder)

cd Data_Sets

load Carmody_diet_multi_subject 

x = diet_data;

cd(main_folder)


% Running TMI for k = 5 runs each
K=5;N=5;
learn_z = 0.06;learn_the = 0.06;
max_steps = 150000;
min_fitting = 0; 
min_gradients = 1e-6;

% 
% 
[z,th,KL]  = TMI(x,N,K,learn_z, learn_the,max_steps,min_fitting,min_gradients);
[z2,th2,KL2]  = TMI(x,N,K,learn_z, learn_the,max_steps,min_fitting,min_gradients);
% 
max_steps = 1000000;
% 
[Y,Phi] = Rotating(z,th,days,x,max_steps);
[Y2,Phi2] = Rotating(z2,th2,days,x,max_steps);
% 

%% Plotting the two runs 

figure    
plot(Y',Y2','o')
grid on 
xlabel('Run1')
ylabel('Run2')
box on 
legend on 
legend('y_1','y_2','y_3','y_4','Orientation','horizontal')




%% Plotting ECNs 


c = struct('rr', [0.9047, 0.1918, 0.1988], ...  %Your required color
    'bb', [0.2941, 0.5447, 0.7494], ... %Your required color
    'um', [0.0824, 0.1294, 0.4196], ... %ultra marine
    'br', [0.6510, 0.5725, 0.3412], ... %bronze
    'wr', [0.5804, 0, 0.1059] ); 

figure
yLabels = {'y_1','y_2','y_3','y_4','y_5'};
for i= 1:5
  
        subplot(1,5,i)
        plot(days,Y2(i,:),'k','LineWidth',1.75)
        patch([0 3.5 3.5 0],[-0.5 -0.5 0.5 0.5],c.bb,'EdgeColor','none')
        alpha(0.3)
        set(gca,'children',flipud(get(gca,'children')))

        k=0;

        while k<20
            patch([k+3.5 k+6.5 k+6.5 k+3.5],[-0.5 -0.5 0.5 0.5],c.wr,'EdgeColor','none')
            alpha(0.3)
            set(gca,'children',flipud(get(gca,'children')))
            k=k+6;
        end
        k=3;
        while k<25
            patch([k+3.5 k+6.5 k+6.5 k+3.5],[-0.5 -0.5 0.5 0.5],c.bb,'EdgeColor','none')
            alpha(0.3)
            set(gca,'children',flipud(get(gca,'children')))
            k=k+6;
        end

        patch([27.5 36 36 27.5],[-0.5 -0.5 0.5 0.5],c.wr,'EdgeColor','none')
        alpha(0.3)
        set(gca,'children',flipud(get(gca,'children')))

        axis([0 36 -0.5 0.5])
        xlabel('Time (Days)','FontWeight','bold')
        ylabel(yLabels{i},'FontWeight','bold')
        set(gca,'linewidth',1)
        pbaspect([1 1 1])
        set(gca,'FontSize',12,'FontWeight','bold','LineWidth',2,'XMinorTick',...
        'on','YMinorTick','on');
end












