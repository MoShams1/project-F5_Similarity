
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
c_all = [.5 .5 .5];
c_sample = [.1 .1 .1];
alpha_all = .1;
sz = 20;
x = obs2obs(:);
y = exe2obs(:);

figure('Units','normalized','OuterPosition',[.1 .1 .09 .18])
hold on
plotit(x,y,sz*.7,.5,c_all,0)

model_all = polyfit(x,y,1);

xlabel('Relative o2o performance (%)')
ylabel('Relative e2o performance (%)')
set(gca,'XTick',-100:10:100,'YTick',-100:10:100)

axis([-20-3 50 -30-3 40])
axis square

line([-100 100],[-100 100],'color','k','linestyle','--')  % unity line
line([0 0],[-100 100],'color','k','linestyle','-')  % x axis
line([-100 100],[0 0],'color','k','linestyle','-')  % y axis
line([10 10],[-100 100],'color','k','linestyle','--')  % threshold line

% plot linear model and display angles
x_all = -10:40;
y_all = polyval(model_all,x_all);
plot(x_all,y_all,'color',c_all-.1,'LineWidth',1)
slope_all = model_all(1);
disp(['ls all: ',sprintf('%0.2f',atand(slope_all)),' deg'])

% calculate average angles and draw line with that angle that goes through
% the origin
slopes = y./x;
angles = atand(slopes);
% mean_slope_all = mean(slopes);
% mean_angle_all = mean(angles);
% x = [-10 40];
% y = x .* mean_slope_all;
% plot(x,y,'-r')

 
%% exemplary neuron
x = obs2obs(72,:);
y = exe2obs(72,:);
plotit(x,y,sz,1,c_sample,1)

model_sample = polyfit(x,y,1);

% plot linear model and display angles
x_sample = -10:40;
y_sample = polyval(model_sample,x_sample);
plot(x_sample,y_sample,'color',c_sample-.1,'LineWidth',1)
slope_sample = model_sample(1);
disp(['ls sample: ',sprintf('%0.2f',atand(slope_sample)),' deg'])


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

