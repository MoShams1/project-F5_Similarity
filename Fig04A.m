
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

c_all = [.5 .5 .5];
c_sample = [.1 .1 .1];
alpha_all = .1;
sz = 20;
figure('Units','normalized','OuterPosition',[.1 .1 .09 .18])
hold on

%% plot obs2obs vs exe2obs scatter
x = obs2obs(:);
y = exe2obs(:);
% plot all data
draw_edges = 0;
plotit(x,y,sz*.7,.5,c_all,draw_edges)
xlabel('Relative o2o performance (%)')
ylabel('Relative e2o performance (%)')
set(gca,'XTick',-100:10:100,'YTick',-100:10:100)
axis([-20-3 50 -30-3 40])
axis square
% calculate average angles and draw line with that angle that goes through
% the origin
slopes = y./x;
angles = atand(slopes);
disp(['average angle all = ', num2str(mean(angles)), ' deg'])
% plot the line indicating the average of all angles
xline = [-10 40];
% because of outlier slopes, angle must be calculated first for each dot
% from the mean angle then, the mean slope can be calculated
slope_mean = tand(mean(angles));
yline = xline .* slope_mean;
plot(xline,yline,'color',c_all-.1,'linewidth',1)

%% exemplary neuron
x = obs2obs(72,:);
y = exe2obs(72,:);
% plot sampel neuron
draw_edges = 1;
alpha = 1;
plotit(x,y,sz,alpha,c_sample,draw_edges)
% calculate average angles and draw line with that angle that goes through
% the origin
slopes = y./x;
angles = atand(slopes);
disp(['average agnle sample = ', num2str(mean(angles)), ' deg'])
% plot the line indicating the average of all angles
xline = [-10 40];
% because of outlier slopes, angle must be calculated first for each dot
% from the mean angle then, the mean slope can be calculated
slope_mean = tand(mean(angles));
ylin = xline .* slope_mean;
plot(xline,ylin,'color',c_sample-.1,'linewidth',1)

%% add supplementary lines
line([-100 100],[-100 100],'color','k','linestyle','--')  % unity line
line([0 0],[-100 100],'color','k','linestyle','-')  % x axis
line([-100 100],[0 0],'color','k','linestyle','-')  % y axis
line([10 10],[-100 100],'color','k','linestyle','--')  % threshold line


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

