

clc
clear
close all

figure('Units','normalized','OuterPosition',[.1 .1 .13 .4])

isubplot = 1;
plotlegend = 0;
prep_for_fig05B('action_preference','count',...
    isubplot,plotlegend)

isubplot = 2;
plotlegend = 0;
prep_for_fig05B('action_preference','relative',...
    isubplot,plotlegend)

isubplot = 3;
plotlegend = 0;
prep_for_fig05B('LDA','count',...
    isubplot,plotlegend)

isubplot = 4;
plotlegend = 1;
prep_for_fig05B('LDA','relative',...
    isubplot,plotlegend)

% add shades
yshade = [0 8];
xshade = [0 89];
color = 'k';
alpha = .1;
for ishade = 1:length(yshade)
    fill([xshade(1) xshade(1) xshade(2) xshade(2)],...
        [yshade(ishade) yshade(ishade)+4 yshade(ishade)+4 yshade(ishade)], ...
        color,'edgecolor','none','facealpha',alpha);
end