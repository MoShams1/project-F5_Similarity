

clc
clear
close all

load stat_for_fig04D.mat

%%
figure('Units','normalized','OuterPosition',[.1 .1 .06 .13])
hold on
plot_stats(thresholds,adjr2,'k');
ylabel('Adj R^2')
xlabel({'o2o threshold wrt', 'chance performance (%)'})
% title('Two-Gaussian fit evaluation')
set(gca,'YTick',0:.5:1)
set(gca,'xtick',5:5:15)
xlim([4.5 15])
ylim([-.1 1])
cleanplot

disp(['average adjR2: ',num2str(mean(adjr2(:)))])

%% FUNCTIONs
function h = plot_stats(x,M,color)
cmap = parula(size(M,2)+1);
cmap = cmap .* repmat([.9 .8 .9],size(cmap,1),1);

h = plot(x,nanmean(M,1), 'linewidth',1, 'color','k');
for icol = 1:size(M,2)
    data = sort(M(:,icol));
    data(isnan(data)) = [];
    up(icol) = prctile(data,97.5);
    lw(icol) = prctile(data,2.5);
    plot(x(icol),mean(M(:,icol)),...
    'o','markeredgecolor','none','markerfacecolor',cmap(icol,:),...
    'MarkerSize',4)
end
plot(x,up,'Color',color,'linewidth',.5)
plot(x,lw,'Color',color,'linewidth',.5)
end

