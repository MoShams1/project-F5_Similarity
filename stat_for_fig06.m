

clc
clear
close all


load same_or_diff_LDA.mat
% find neurons with at least one matched bin
ind_bins = same_or_diff==1;
ind_neurons = any(ind_bins,2);
n6c = sum(ind_neurons);
disp(['N_Fig06C: ',num2str(n6c)])


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
n6d = sum(ind_neurons);
disp(['N_Fig06D: ',num2str(n6d)])


load same_or_diff_LDA_24bins.mat
% find neurons with at least one matched bin
ind_bins = same_or_diff==1;
ind_neurons = ind_bins;
n6e = sum(ind_neurons);
disp(['N_Fig06E: ',num2str(n6e)])


% load classification performance as plotted in fig.4A
load xx_108_4_single_e2o_perf
exe2obs_cell = cellfun(@mean, test,'UniformOutput',false);
exe2obs = cell2mat(exe2obs_cell);
exe2obs = exe2obs-100/3;
load xx_108_4_single_o2o_perf
obs2obs_cell = cellfun(@mean, verif,'UniformOutput',false);
obs2obs = cell2mat(obs2obs_cell);
obs2obs = obs2obs-100/3;
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
ind_neurons = crit_map_10_above & ~crit_map_10_below;
n6f = sum(ind_neurons);
disp(['N_Fig06F: ',num2str(n6f)])