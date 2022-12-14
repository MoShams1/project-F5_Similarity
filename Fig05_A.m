

clear
close all
clc

%% settings
type_of_method = 'action_preference'; % options: discharge, action_preference, LDA
filename_p_values = 'p_kruskalwallis_per_bin_and_neuron';
c = lines(7);
marker_size = 6;
font_size = 7;
line_color = [0.5 0.5 0.5];
color_obs_only = [.7 .7 .7];
color_match = c(2,:);
color_nonmatch = 'k';

save_fig = 'off';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load p-values (if actions are discriminated at all)
load (filename_p_values)
filename_same_or_diff = ['same_or_diff_' type_of_method];
load(filename_same_or_diff)

%% preparation
n_neurons = size(data.ID,1);
n_bins = 12;

sig_exe = data.sig_exe(:,9:20);
sig_obs = data.sig_obs(:,9:20);

clear data

%% figure out number of sig bins (or same), and the first occurrence (for sorting later)
n_first_obs = NaN(n_neurons,2); % 1: number of sig bins, 2: first sig bin
for each_neuron = 1:n_neurons
    idx_sig_obs = find(sig_obs(each_neuron,:) == 1);
    n_first_obs(each_neuron,1) = length(idx_sig_obs);
    if ~isempty(idx_sig_obs)
        n_first_obs(each_neuron,2) = min(idx_sig_obs);
    end
end
n_first_same = NaN(n_neurons,2); % 1: number of matching bins, 2: first matching bin
for each_neuron = 1:n_neurons
    idx_1 = find(same_or_diff(each_neuron,:) == 1);
    n_first_same(each_neuron,1) = length(idx_1);
    if ~isempty(idx_1)
        n_first_same(each_neuron,2) = min(idx_1);
    end
end

% sorting according to n_first_same
sorting_order = [-(n_bins*2+2), n_bins*2+1, -(n_bins*2+4), n_bins*2+3];
% 1. first matched bin (earliest in the upper row)
% 2. number of matched bins (largest in the upper row)
% 3. first obs bins (largest in the upper row)
% 4. number of obs bins (largest in the upper row)
neurons_sorted = sortrows([sig_obs, same_or_diff, n_first_same, n_first_obs, (1:n_neurons)'], sorting_order);
neuron_label = neurons_sorted(:,n_bins*2+5);
neurons_sorted(:,[n_bins*2+1, n_bins*2+2, n_bins*2+3, n_bins*2+4, n_bins*2+5]) = [];

%% create the figure
figure(1)
clf
cnt = 0;
for each_neuron = 1:n_neurons
    sig_idx_obs = find(neurons_sorted(each_neuron, 1 : n_bins) == 1);
    sig_idx_1 = find(neurons_sorted(each_neuron, n_bins+1 : 2*n_bins) == 1);
    sig_idx_m1 = find(neurons_sorted(each_neuron, n_bins+1 : 2*n_bins) == -1);
    if ~isempty(sig_idx_obs)
        cnt = cnt + 1;
        plot(sig_idx_obs, cnt,'ko','markersize',marker_size, 'MarkerFaceColor', color_obs_only) % should be partly overwritten by red or black later
        if ~isempty(sig_idx_1)
            plot(sig_idx_1, cnt,'ko','markersize',marker_size, 'MarkerFaceColor', color_match);
            hold on
        end
        if ~isempty(sig_idx_m1)
            plot(sig_idx_m1, cnt,'ko','markersize',marker_size, 'MarkerFaceColor', color_nonmatch);
            hold on
        end
        text(-3, cnt, num2str(neuron_label(each_neuron)),'fontsize',font_size)
    end
end
axis([-4 n_bins+1, 0, cnt+1])
line([0.5 0.5], get(gca,'ylim'), 'color', line_color)
line([4.5 4.5], get(gca,'ylim'), 'color', line_color)
line([8.5 8.5], get(gca,'ylim'), 'color', line_color)

set(gcf, 'position', [239 10 257 967])
if strcmp(save_fig, 'on')
    saveas(gcf,['Figures/' type_of_method '_Fig_5A_rasterplot.png'],'png')
end