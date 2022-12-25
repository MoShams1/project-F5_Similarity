
clear
close all
clc

c = lines(7);
color(1,:) = [0 0 0];
color(2,:) = [.6 .6 .6];
color(3,:) = [.6 .3 .6];
color(4,:) = c(2,:);

figure('Units','normalized','OuterPosition',[.1 .1 .05 .2])
hold on

[p_matched,p_non,p_obs,p_obsonly] = prepare_for_barplot('discharge');
keepVars()
plotkon(p_obsonly, p_obs, p_non,color,1)

[p_matched,p_non,p_obs,p_obsonly] = prepare_for_barplot('action_preference');
keepVars()
plotkon(p_obsonly, p_obs, p_non,color,2)

[p_matched,p_non,p_obs,p_obsonly] = prepare_for_barplot('LDA');
keepVars()
plotkon(p_obsonly, p_obs, p_non,color,3)

set(gca,'ytick',0:5:60)
ylabel('Percentage wrt MNs (%)')
set(gca,'xtick',1:3,'XTickLabel',{'Dis','Pref', 'LDA'})
xlim([.4 3.5])
cleanplot

function keepVars()
clearvars -except p_obs p_obsonly p_non...
    c color_match color_non color_obsonly color_exeobs
end

function plotkon(p_obsonly, p_obs, p_non,...
    color, k)
bar(k,p_obs,'FaceColor',color(4,:),'EdgeColor','none')
bar(k,p_non+p_obsonly,'FaceColor',color(1,:),...
    'EdgeColor','none')
bar(k,p_obsonly,'FaceColor',color(2,:),'EdgeColor','none')
end


function [p_matched,p_non,p_obs,p_obsonly] = prepare_for_barplot(type_of_method)
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
p_matched = n_matched_bins/n_total_bins * 100;
p_non = n_nonmatched_bins/n_total_bins * 100;
p_obsonly = n_obsonly_bins/n_total_bins * 100;
p_obs = (n_matched_bins + n_nonmatched_bins + n_obsonly_bins) / n_total_bins * 100;
end