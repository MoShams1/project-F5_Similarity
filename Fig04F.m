
clear
close all
clc

%% settings

filename_o2o = 'xx_108_4_single_o2o_perf';
filename_e2o = 'xx_108_4_single_e2o_perf';

filename_e2o_sig = 'same_or_diff_LDA'; % 1: e2o sig, -1: e2o n.s. but neuron was tested
bins_to_consider = 9:20;

boundary_angle = 25.9; % in deg (read from Fig04E command win output)

c = lines(7);
c_all = [.5 .5 .5];
c_sample = c(2,:);
alpha_all = .1;
sz = 20;
figure('Units','normalized','OuterPosition',[.1 .1 .09 .18])
hold on

%% load data
load (filename_o2o)
o2o = verif;
clear verif
load (filename_e2o)
e2o = test;
clear test

load (filename_e2o_sig)
e2o_sig = same_or_diff;
clear same_or_diff

%% preparation
n_neurons = size(e2o,1); % 177
n_bins = length(bins_to_consider); % 12
assert(n_neurons == 177)
chance_level =1/3*100;

%% prepare scatter plot
all_o2o = NaN(n_neurons, n_bins);
all_e2o = NaN(n_neurons, n_bins);
for each_neuron = 1:n_neurons
    for each_bin = 1:n_bins
        bootstr_distrib_o2o = o2o{each_neuron}(:,bins_to_consider(each_bin));
        all_o2o(each_neuron, each_bin) = nanmean(bootstr_distrib_o2o);
        bootstr_distrib_e2o = e2o{each_neuron}(:,bins_to_consider(each_bin));
        all_e2o(each_neuron, each_bin) = nanmean(bootstr_distrib_e2o);
    end
end
all_o2o_vector = reshape(all_o2o',[],1);
all_e2o_vector = reshape(all_e2o',[],1);
all_o2o_vector = all_o2o_vector-chance_level;
all_e2o_vector = all_e2o_vector-chance_level;

e2o_sig_vector = reshape(e2o_sig',[],1); % vector with significant e2o bins
idx_e2o_sig = find(e2o_sig_vector == 1);

%% find neuron ID of bins below boundary
bin_ID = [];
angle_below = [];
for i = 1:length(idx_e2o_sig)
    angle = atand(all_e2o_vector(idx_e2o_sig(i)) / all_o2o_vector(idx_e2o_sig(i)));
    if angle < boundary_angle
        bin_ID = [bin_ID; idx_e2o_sig(i)];
        angle_below = [angle_below; angle];
    end
end
% neuron_ID = ceil(bin_ID/n_bins)
% angle_below

%% plot obs2obs vs exe2obs scatter
x = all_o2o_vector;
y = all_e2o_vector;
% plot all data
draw_edges = 0;
plotit(x,y,sz*.7,.5,c_all,draw_edges)

xlabel('Relative o2o performance (%)')
ylabel('Relative e2o performance (%)')
set(gca,'XTick',-100:10:100,'YTick',-100:10:100)
axis([-20-3 50 -30-3 40])
axis square
boundary_angle = 26;
disp(['boundary angle = ', num2str(boundary_angle), ' deg'])
% plot the line indicating the average of all angles
xline = [-10 40];
slope_bound = tand(boundary_angle);
yline = xline .* slope_bound;
plot(xline,yline,'color',c_all-.1,'linewidth',1)

 
%% add selected bins
x = all_o2o_vector(idx_e2o_sig);
y = all_e2o_vector(idx_e2o_sig);
% plot sampel neuron
draw_edges = 1;
alpha = 1;
plotit(x,y,sz,alpha,c_sample,draw_edges)
% calculate average angles and draw line with that angle that goes through
% the origin
slopes = y./x;
angles = atand(slopes);
disp(['avg sig bin angle = ', num2str(mean(angles)), ' deg'])
% plot the line indicating the average of all angles
xline = [-10 40];
% because of outlier slopes, angle must be calculated first for each dot
% from the mean angle then, the mean slope can be calculated
slope_mean = tand(mean(angles));
yline = xline .* slope_mean;
plot(xline,yline,'color',c_sample,'linewidth',1,'linestyle','-')

%% add supplementary lines
line([-100 100],[-100 100],'color','k','linestyle','--')  % unity line
line([0 0],[-100 100],'color','k','linestyle','-')  % x axis
line([-100 100],[0 0],'color','k','linestyle','-')  % y axis
line([10 10],[-100 100],'color','k','linestyle','--')  % threshold line

%% functions
function plotit(A,B,sz,alpha,color,out)
hold on
scatter(A,B,sz,'MarkerEdgeColor','none',...
    'MarkerFaceColor',color, 'MarkerFaceAlpha',alpha)
if out
    scatter(A,B,sz,'MarkerEdgeColor','k','MarkerFaceColor','none')
end
cleanplot
end

