

clc
clear
close all

% load
load xx_108_4_single_e2o_perf
exe2obs_cell = cellfun(@mean, test,'UniformOutput',false);
exe2obs = cell2mat(exe2obs_cell);
exe2obs = exe2obs-100/3;

load xx_108_4_single_o2o_perf
obs2obs_cell = cellfun(@mean, verif,'UniformOutput',false);
obs2obs = cell2mat(obs2obs_cell);
obs2obs = obs2obs-100/3;

% crop irrelevant time-bins
exe2obs(:,[1:8,21:24]) = [];
obs2obs(:,[1:8,21:24]) = [];

% plot
figure('Units','normalized','OuterPosition',[.1 .1 .13 .4])
subplot(3,2,1)
prep_for_fig04B

clearvars -except obs2obs exe2obs
subplot(3,2,2)
prep_for_fig04E

clearvars -except obs2obs exe2obs
prep_for_fig04CD

clearvars -except obs2obs exe2obs
prep_for_fig04FG