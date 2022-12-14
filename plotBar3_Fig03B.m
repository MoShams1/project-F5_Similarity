

%% changes: add proportion MNs with obs only segments

% settings
type_of_method = 'LDA'; % options: discharge, action_preference, LDA
% c = lines(7);
% color_match = c(2,:);
% color_nonmatch = 'k';
% color_obsonly = [.6 .6 .6];
% color_exeobs = [.6 .3 .6];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data
filename_same_or_diff = ['same_or_diff_' type_of_method];
load(filename_same_or_diff)
same_diff = same_or_diff; clear same_or_diff

filename_p_values = 'p_kruskalwallis_per_bin_and_neuron';
load (filename_p_values)
sig_exe = data.sig_exe(:,9:20);
sig_obs = data.sig_obs(:,9:20);
sig_exeobs = data.sig_exeobs(:,9:20);
clear data
obs_only = sig_obs - sig_exe; % only +1 is meaningful: obs only

% preparation
n_neurons = size(same_diff,1);
n_bins = size(same_diff,2);
n_total_bins = n_neurons * n_bins 

% count of bins of each type
n_obs_bins = length(find(sig_obs == 1))
n_exeobs_bins = length(find(sig_exeobs == 1))
n_matched_bins = length(find(same_diff == 1))
n_nonmatched_bins = length(find(same_diff == -1))
n_obsonly_bins = length(find(obs_only == 1))

% percentage of bins of each type wrt n_total_bins
perc_matched_bins = n_matched_bins/n_total_bins * 100
perc_nonmatched_bins = n_nonmatched_bins/n_total_bins * 100;
perc_obsonly_bins = n_obsonly_bins/n_total_bins * 100;
perc_obs_bins = (n_matched_bins + n_nonmatched_bins + n_obsonly_bins) / n_total_bins * 100;

% figure
% hold on
% bar(1,perc_obs_bins,'FaceColor',color_match,'EdgeColor','none')
% bar(1,perc_nonmatched_bins+perc_obsonly_bins,'FaceColor',color_nonmatch,'EdgeColor','none')
% bar(1,perc_obsonly_bins,'FaceColor',color_obsonly,'EdgeColor','none')
