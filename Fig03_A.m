

clear
close all
clc

%% changes: total number of obs segments calculated

% settings
filename_p_values = 'p_kruskalwallis_per_bin_and_neuron';
marker_size = 5;
line_width = 2;
histo_width = 0.2;
c = lines(7);
line_color = [0.5 0.5 0.5];
color_exe = [.2 .2 .6];
color_obs = [.3 .6 .3];
color_obs_only = [.6 .6 .6];
% color_exeobs = [.6 .3 .6];
color_exeobs = [.9 .6 0];

save_fig = 'off';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load data
load (filename_p_values)

%% preparation
n_neurons = size(data.ID,1);
n_bins = 24;

sig_exe = data.sig_exe;
sig_obs = data.sig_obs;
sig_exeobs = data.sig_exeobs;
sig_obs_only = sig_obs - sig_exeobs;

%% bin counts in the period between bins 9 to 20
n_total_bins = n_neurons * length(9:20) 
n_obs_bins = length(find(sig_obs(:,9:20) == 1))
n_exeobs_bins = length(find(sig_exeobs(:,9:20) == 1))

%% neuron count with at least one bin of a certain kind (in the period between bins 9 to 20)
n_bins_per_neuron_9_20_exe = NaN(n_neurons,1);
n_bins_per_neuron_9_20_obs = NaN(n_neurons,1);
n_bins_per_neuron_9_20_exeobs = NaN(n_neurons,1);
n_bins_per_neuron_9_20_obs_only = NaN(n_neurons,1);
for each_neuron = 1:n_neurons
    n_bins_per_neuron_9_20_exe(each_neuron,1) = length(find(sig_exe(each_neuron,9:20) == 1)); 
    n_bins_per_neuron_9_20_obs(each_neuron,1) = length(find(sig_obs(each_neuron,9:20) == 1)); 
    n_bins_per_neuron_9_20_exeobs(each_neuron,1) = length(find(sig_exeobs(each_neuron,9:20) == 1)); 
    n_bins_per_neuron_9_20_obs_only(each_neuron,1) = length(find(sig_obs_only(each_neuron,9:20) == 1)); 
end
n_neurons_at_least_one_bin_9_20_obs = length(find(n_bins_per_neuron_9_20_obs >= 1))
n_neurons_at_least_one_bin_9_20_exeobs = length(find(n_bins_per_neuron_9_20_exeobs >= 1))
n_neurons_at_least_one_bin_9_20_obs_only_and_exe_but_no_exeobs = length(find(n_bins_per_neuron_9_20_obs_only >= 1 & n_bins_per_neuron_9_20_exeobs == 0 & n_bins_per_neuron_9_20_exe >= 1))
n_neurons_at_least_one_bin_9_20_obs_only_and_no_exe = length(find(n_bins_per_neuron_9_20_obs_only >= 1 & n_bins_per_neuron_9_20_exe == 0))


%% figure neuron count per bin
n_sig_exe = sum(sig_exe);
n_sig_obs = sum(sig_obs);
n_sig_exeobs = sum(sig_exeobs);
n_sig_obs_only = sum(sig_obs) - sum(sig_exeobs);
% save ('n_sig.mat', 'n_sig_exe', 'n_sig_obs',  'n_sig_exeobs', 'n_sig_obs_only')

%% figure
figure('Units','normalized','OuterPosition',[.1 .1 .11 .2])
hold on
h = [];
x = (1:24)-.5;
h(1) = plot(x, 100*n_sig_exe/n_neurons,'o','color',color_exe, 'markersize', marker_size, 'MarkerFaceColor', color_exe);
plot((1:24)-.5,100*n_sig_exe/n_neurons,'-', 'color',color_exe,'linewidth',line_width);
h(2) = plot(x, 100*n_sig_obs/n_neurons,'o','color',color_obs, 'markersize', marker_size, 'MarkerFaceColor', color_obs);
plot(x,100*n_sig_obs/n_neurons,'-', 'color',color_obs,'linewidth',line_width);
h(4) = plot(x, 100*n_sig_obs_only/n_neurons,'o','color',color_obs_only, 'markersize', marker_size, 'MarkerFaceColor', color_obs_only);
plot(x,100*n_sig_obs_only/n_neurons,'-', 'color',color_obs_only,'linewidth',line_width);
h(3) = plot(x, 100*n_sig_exeobs/n_neurons,'o','color',color_exeobs, 'markersize', marker_size, 'MarkerFaceColor', color_exeobs);
plot(x,100*n_sig_exeobs/n_neurons,'-', 'color',color_exeobs,'linewidth',line_width);

axis([0, n_bins+1, 0, 1+max(get(gca,'ylim'))])
% line([4.5 4.5], get(gca,'ylim'), 'color', line_color)
% line([8.5 8.5], get(gca,'ylim'), 'color', line_color)
% line([12.5 12.5], get(gca,'ylim'), 'color', line_color)
% line([16.5 16.5], get(gca,'ylim'), 'color', line_color)
% line([20.5 20.5], get(gca,'ylim'), 'color', line_color)
set(gca,'XTick',0:4:25,'XTickLabel',...
    {'BPR','LED','REL','TCH','HLD','REW','WDR'})
ylabel('Percentage wrt MNs (%)')
% title('task-dependent action type response per time bin')
legend(h,{'Exe' 'Obs' 'Exe&Obs', 'ObsOnly'}, 'location', 'best')
set(gca,'ytick',0:20:60)
ylabel('Percentage of MNs (%)')
ylim([0 60])
xlim([0 24])
cleanplot

if strcmp(save_fig, 'on')
    saveas(gcf,'Fig_3A_timecourse.png','png')
end