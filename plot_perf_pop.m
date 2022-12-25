

clear
close all


load data_Fig3B_exe2obs
exe2obs_verif_exe = perf.verif;
exe2obs_test_obs = perf.test;

load data_Fig3B_obs2exe
obs2exe_verif_obs = perf.verif;
obs2exe_test_exe = perf.test;


%% plot

color = lines(7);

figure('units','normalized','outerposition',[.2 .2 .4 .4])
hold on

plot(exe2obs_verif_exe,'color',color(1,:),'linewidth',2);
plot(obs2exe_verif_obs,'color',color(5,:),'linewidth',2);
plot(obs2exe_test_exe, 'color',color(3,:),'linewidth',2);
plot(exe2obs_test_obs, 'color',color(7,:),'linewidth',2);
plot([0 25],[100/3 100/3],'k-')

events = {'Prs','LED','Rel',...
    'Tch','Hld','Rew','Wdr'};
set(gca,'xtick',(1:4:25)-.5,'xticklabel',events)

ylabel('classifier perf. (%)')

axis([0 25 20 100])
pbaspect([.7 1 1])
cleanplot
