
clear
close all
clc

%% settings

filename_o2o = 'xx_108_4_single_o2o_perf';
filename_e2o = 'xx_108_4_single_e2o_perf';

filename_e2o_sig = 'same_or_diff_LDA'; % 1: e2o sig, -1: e2o n.s. but neuron was tested
bins_to_consider = 9:20;

boundary_angle = 25.99; % in deg

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
neuron_ID = ceil(bin_ID/n_bins)
angle_below

%% plot obs2obs vs exe2obs scatter
c = lines(7);
sz = 20;

figure('Units','normalized','OuterPosition',[.1 .1 .09 .18])
plotit(all_o2o_vector,all_e2o_vector,sz*.7,.5,[.5 .5 .5],0)
h = lsline;
h.Color = 'k';
xlabel('Relative o2o performance (%)')
ylabel('Relative e2o performance (%)')
set(gca,'XTick',-100:10:100,'YTick',-100:10:100)

axis([-20 50 -30 40])
axis square

line([-100 100],[-100 100],'color','k','linestyle','--')
line([0 0],[-100 100],'color','k','linestyle','--')
line([-100 100],[0 0],'color','k','linestyle','--')
line([10 10],[-100 100],'color','k','linestyle','--')

%% calculate least square line slope
hold on
line(h.XData(:),h.YData(:),'color','k','LineWidth',1)
slope = (h.YData(2) - h.YData(1)) / (h.XData(2) - h.XData(1));
display(atand(slope))
 
%% add exemplary neurons
plotit(all_o2o_vector(idx_e2o_sig), all_e2o_vector(idx_e2o_sig),...
    sz,1,c(2,:),1)

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

