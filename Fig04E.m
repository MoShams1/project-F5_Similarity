

clc
clear
close all

load stat_for_fig04E.mat

%% PLOT
c = lines(7);
figure('Units','normalized','OuterPosition',[.1 .1 .06 .14])
x = thresholds;
hold on
h(1) = plot_stats(x,m2,c(5,:));
h(2) = plot_stats(x,boundary,'k');
h(3) = plot_stats(x,m1,c(7,:));
xlim([4.5 15])
ylim([-20-5 50])
xlabel({'o2o threshold wrt', 'chance performance (%)'})
ylabel("Angle (deg)")
% legend(h,{'upper peak','boundary','lower peak'}, 'Location','northwest')
set(gca,'xtick',5:5:15)
set(gca,'YTick',-20:20:100)
cleanplot

disp(['failed fits: ', num2str(err_count)])
disp(['failed fits: ', num2str(err_count/numel(boundary)*100),'%'])
disp(['average boundary: ', num2str(nanmean(boundary(:))),'deg'])


%% FUNCTIONs
function h = plot_stats(x,M,color)
cmap = parula(size(M,2)+1);
for icol = 1:size(M,2)
    data = sort(M(:,icol));
    data(isnan(data)) = [];
    up(icol) = prctile(data,97.5);
    lw(icol) = prctile(data,2.5);
end
hold on
h = plot(x,nanmean(M,1),'-o','markerfacecolor',color,...
    'markeredgecolor','none','color',color,'linewidth',1,...
    'MarkerSize',4);
plot(x,up,'Color',color,'linewidth',.5)
plot(x,lw,'Color',color,'linewidth',.5)
end