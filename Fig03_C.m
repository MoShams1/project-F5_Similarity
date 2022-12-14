

clc
close all
clear

figure('Units','normalized','OuterPosition',[.1 .1 .11 .2])
hold on

[perc(1), CI(:,1)] = prep4cibra('discharge');
[perc(2), CI(:,2)] = prep4cibra('action_preference');
[perc(3), CI(:,3)] = prep4cibra('LDA');

x = [1:3 3:-1:1];
y = [CI(1,:) fliplr(CI(2,:))];
fill(x,y,'k','FaceAlpha',.15,'linestyle','none')

plot(1:3,perc,'color','k','linewidth',2,...
    'marker','o','markerfacecolor','k',...
    'markeredgecolor','none','MarkerSize',5)

set(gca,'xtick',1:3,'XTickLabel',{'Dis','Pref', 'LDA'})
xlim([.5 3.5])
set(gca,'ytick',0:4)
ylabel('Percentage of matched bins wrt all bins (%)')
cleanplot

function [perc, CI] = prep4cibra(type_of_method)
% load data
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
n_total_bins = n_neurons * n_bins; 

%% percentage of matched bins wrt n_total_bins
n_matched_bins = length(find(same_diff == 1));
perc = n_matched_bins/n_total_bins * 100;

%% calculate the CI of percentage of matched bins wrt n_total_bins
perc_matched_bins_perm = NaN(n_perms,1);
for each_bin = 1:n_bins
    for each_perm = 1:n_perms
        n_matched_bins_perm = length(find(same_diff_perm(:,:,each_perm) == 1));
        perc_matched_bins_perm(each_perm,1) = n_matched_bins_perm/n_total_bins * 100;
    end
end
CI = prctile(perc_matched_bins_perm, [2.5 97.5]);
end