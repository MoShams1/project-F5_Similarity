

clear
close all


load xx_109_7_pop_exe2obs
% load for_fig06C_exe2obs
% load for_fig06D_exe2obs
exe2obs_verif_exe = perf.verif;
exe2obs_test_obs = perf.test;

load xx_109_7_pop_obs2exe
% load for_fig06C_obs2exe
% load for_fig06D_obs2exe
obs2exe_verif_obs = perf.verif;
obs2exe_test_exe = perf.test;


%% plot 3 lines

color = lines(7);

figure('units','normalized','outerposition',[.2 .2 .4 .4])
hold on

plotCI(exe2obs_verif_exe,color(1,:),2);
plotCI(obs2exe_verif_obs,color(5,:),2);
plotCI(obs2exe_test_exe,color(3,:),2);
plotCI(exe2obs_test_obs,color(7,:),2);

plot([0 25],[100/3 100/3],'k-')

events = {'Prs','LED','Rel',...
    'Tch','Hld','Rew','Wdr'};
set(gca,'xtick',(1:4:25)-.5,'xticklabel',events)

ylabel('classifier perf. (%)')

axis([0 25 0 100])
pbaspect([.7 1 1])
% cleanplot


%% plot filled area


figure('units','normalized','outerposition',[.2 .2 .4 .4])
hold on

plotCI2(exe2obs_verif_exe,color(1,:),2);
plotCI2(obs2exe_verif_obs,color(5,:),2);
plotCI2(obs2exe_test_exe,color(3,:),2);
plotCI2(exe2obs_test_obs,color(7,:),2);

plot([0 25],[100/3 100/3],'k-')

events = {'Prs','LED','Rel',...
    'Tch','Hld','Rew','Wdr'};
set(gca,'xtick',(1:4:25)-.5,'xticklabel',events)

ylabel('classifier perf. (%)')

axis([0 25 0 100])
pbaspect([.7 1 1])
% cleanplot



%% FUNCTIONS
function plotCI(M,color,linewidth)

mean_M = mean(M,1);
CI_upper = prctile(M,95,1);
CI_lower = prctile(M,5,1);

plot(mean_M,'color',color,'linewidth',linewidth);
plot(CI_upper,'color',color,'linewidth',linewidth/2);
plot(CI_lower,'color',color,'linewidth',linewidth/2);

end


function plotCI2(M,color,linewidth)

alpha = .1;
mean_M = mean(M,1);
CI_upper = prctile(M,95,1);
CI_lower = prctile(M,5,1);

fill([1:24,24:-1:1],[CI_lower,fliplr(CI_upper)],color,...
    'FaceAlpha',alpha,'EdgeColor','none')
plot(mean_M,'color',color,'linewidth',linewidth);

end
