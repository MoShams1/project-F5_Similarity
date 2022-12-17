

clc
clear
close all

load stat_for_fig04I.mat

%%
figure('Units','normalized','OuterPosition',[.1 .1 .06 .13])
hold on
plot_stats(thresholds,adjr2,'k')
ylabel('Adjusted R^2')
xlabel({'o2o threshold wrt', 'chance performance (%)'})
% title('Two-Gaussian fit evaluation')
set(gca,'YTick',0:.5:1)
set(gca,'xtick',5:2:15)
cleanplot

%% FUNCTIONs
function h = plot_stats(x,M,color)
cmap = parula(size(M,2)+1);
h = plot(x,nanmean(M,1), 'linewidth',1, 'color','k');
for icol = 1:size(M,2)
    data = sort(M(:,icol));
    data(isnan(data)) = [];
    up(icol) = prctile(data,97.5);
    lw(icol) = prctile(data,2.5);
    plot(x(icol),mean(M(:,icol)),...
    'o','markeredgecolor','none','markerfacecolor',cmap(icol,:),...
    'MarkerSize',6)
end
plot(x,up,'Color',color,'linewidth',.7)
plot(x,lw,'Color',color,'linewidth',.7)
end

