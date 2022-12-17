

clc
close all
clear

figure('Units','normalized','OuterPosition',[.1 .1 .05 .2])
hold on

[perc(1), CI(:,1)] = prep4cibra('discharge');
[perc(2), CI(:,2)] = prep4cibra('action_preference');
[perc(3), CI(:,3)] = prep4cibra('LDA');

for i = 1:3
    line([i i],[CI(1,i) CI(2,i)],'color',[.7 .7 .7],...
        'linewidth',3)
end

plot(1:3,perc,'color','k','linewidth',2,'LineStyle','none',...
    'marker','o','markerfacecolor','k',...
    'markeredgecolor','none','MarkerSize',5)

set(gca,'xtick',1:3,'XTickLabel',{'Dis','Pref', 'LDA'})
xlim([.5 3.5])
set(gca,'ytick',0:5:25)
ylabel({'Percentage of MNs with','at least one matched bin (%)'})
cleanplot



function [perc, CI] = prep4cibra(type_of_method)
%% load data
filename_same_or_diff_Csibra = ['same_or_diff_' type_of_method '_Csibra'];
load(filename_same_or_diff_Csibra)
same_diff_perm = same_or_diff; clear same_or_diff

filename_same_or_diff = ['same_or_diff_' type_of_method];
load(filename_same_or_diff)
same_diff = same_or_diff; clear same_or_diff

%% preparation
n_neurons = size(same_diff,1);
n_bins = size(same_diff,2);
n_perms = size(same_diff_perm,3);

%% calculate the percentage of MNs with at least one matched bin
n_matched_bins_per_neuron = NaN(n_neurons,1);
for each_neuron = 1:n_neurons
    n_matched_bins_per_neuron(each_neuron,1) = length(find(same_diff(each_neuron,:) == 1));
end
n_at_least_one_matched_bin = length(find(n_matched_bins_per_neuron >= 1))
perc = n_at_least_one_matched_bin / n_neurons * 100

%% calculate the CI of percentage of MNs with at least one matched bin
n_matched_bins_per_neuron_perm = NaN(n_neurons, n_perms);
for each_neuron = 1:n_neurons
    for each_perm = 1:n_perms
        n_matched_bins_per_neuron_perm(each_neuron,each_perm) = length(find(same_diff_perm(each_neuron,:,each_perm) == 1));
    end
end
perc_at_least_one_matched_bin_perm = NaN(1, n_perms);
for each_perm = 1:n_perms
    perc_at_least_one_matched_bin_perm(1,each_perm) = length(find(n_matched_bins_per_neuron_perm(:,each_perm) >= 1)) / n_neurons * 100;
end
CI(:,1) = prctile(perc_at_least_one_matched_bin_perm, [2.5 97.5]);
end