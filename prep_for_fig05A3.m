
clc
clear
close all

%% preparation
n_neurons = 177;
n_bins = 12;

% load classification performance as plotted in fig.4A
load xx_108_4_single_e2o_perf
exe2obs_cell = cellfun(@mean, test,'UniformOutput',false);
exe2obs = cell2mat(exe2obs_cell);
exe2obs = exe2obs-100/3;
load xx_108_4_single_o2o_perf
obs2obs_cell = cellfun(@mean, verif,'UniformOutput',false);
obs2obs = cell2mat(obs2obs_cell);
obs2obs = obs2obs-100/3;
% cropt the desired bin range
exe2obs(:,[1:8,21:24]) = [];
obs2obs(:,[1:8,21:24]) = [];
% calculate angles (arctan(e2o/o2o) in degrees for each bin
angle_map = atand(exe2obs./obs2obs);
% define the 10% o2o threshold filter(criterion map of 10% threshold)
crit_map_10 = obs2obs >= 10;
% apply the angle boundary filter (criterion angle boundary)
crit_map_bound_above = angle_map >= 25.8965;  % read from Fig04E.m
% apply the angle boundary filter (criterion angle boundary)
crit_map_bound_below = angle_map < 25.8965;  % read from Fig04E.m
% filter out the survived angles above the boundary with o2o above 10
crit_map_10_above = crit_map_10 & crit_map_bound_above;
% filter out the survived angles above the boundary with o2o above 10
crit_map_10_below = crit_map_10 & crit_map_bound_below;
% find neurons that have bins above but not below
ind_neurons = any(crit_map_10_above,2) & ~any(crit_map_10_below,2);

%% create the figure
figure
hold on
map = zeros(177,12);
map(crit_map_10_above) = 1; % matched
map(crit_map_10_below) = -1; % nonmatched

[x,y] = ind2sub(size(map),find(map==1));
plot(y,x,'o','MarkerFaceColor','r')
[x,y] = ind2sub(size(map),find(map==-1));
plot(y,x,'o','MarkerFaceColor','k')
[x,y] = ind2sub(size(map),find(map==0));
plot(y,x,'o','MarkerFaceColor','w')

% axis([-4 n_bins+1, 1, cnt+1])
% xlim([-4 12.5])
% set(gca,'XTick',(0:4:12)+.5,'XTickLabel',...
%     {'REL','TCH','HLD','REW'})
% fill([.5 .5 4.5 4.5],[2 129 129 2], 'k',...
%     'EdgeColor','none','FaceAlpha',.1)
% fill([.5 .5 4.5 4.5]+8,[2 129 129 2], 'k',...
%     'EdgeColor','none','FaceAlpha',.1)
% set(gca,'YColor','none')
% cleanplot2

% function cleanplot2
% set(gca,'tickdir','out','color','none')
% box off
% ax = gca;
% if ~isempty(ax.Legend)
%     legend boxoff
% end
% fontsize(gca,6,"points")
% set(gca,'FontSize',8)
% end
