
clc
clear
close all


load xx_108_4_single_e2o_perf
exe2obs_cell = cellfun(@mean, test,'UniformOutput',false);
exe2obs = cell2mat(exe2obs_cell);
exe2obs = exe2obs-100/3;

load xx_108_4_single_o2o_perf
obs2obs_cell = cellfun(@mean, verif,'UniformOutput',false);
obs2obs = cell2mat(obs2obs_cell);
obs2obs = obs2obs-100/3;

%% crop irrelevant time-bins
exe2obs(:,[1:8,21:24]) = [];
obs2obs(:,[1:8,21:24]) = [];

%% plot obs2obs vs exe2obs scatter
c = lines(7);
sz = 20;
x = obs2obs;
y = exe2obs;

figure('Units','normalized','OuterPosition',[.1 .1 .09 .18])
plotit(x(:),y(:),sz*.7,.5,[.5 .5 .5],0)
h = lsline;
h.Color = 'k';
xlabel('Relative o2o performance (%)')
ylabel('Relative e2o performance (%)')
set(gca,'XTick',-100:10:100,'YTick',-100:10:100)

axis([-20 50 -30 40])
axis square

line([-100 100],[-100 100],'color','k','linestyle','--')
line([0 0],[-100 100],'color','k','linestyle','--')
line([-100 100],[0 0],'color','k','linestyle','--')
line([10 10],[-100 100],'color','k','linestyle','--')

%% calculate least square line slope
hold on
line(h.XData(:),h.YData(:),'color','k','LineWidth',1)
slope = (h.YData(2) - h.YData(1)) / (h.XData(2) - h.XData(1));
display(atand(slope))
 
%% add exemplary neurons
plotit(obs2obs(72,:),exe2obs(72,:),sz,1,'k',1)

%% functions
function plotit(A,B,sz,alpha,color,out)
hold on
scatter(A,B,sz,'MarkerEdgeColor','none', ...
    'MarkerFaceColor',color, 'MarkerFaceAlpha',alpha)
if out
    scatter(A,B,sz,'MarkerEdgeColor','k','MarkerFaceColor','none')
end
cleanplot
end

