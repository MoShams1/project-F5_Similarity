clear
close all
clc

figure('Units','normalized','OuterPosition',[.1 .1 .08 .2])

isubplot = 0;
prep4fig5D('action_preference',isubplot)

isubplot = 1;
prep4fig5D('LDA',isubplot)


function prep4fig5D(type_of_method,isubplot)
%% settings
c = lines(7);
color_match = c(2,:);
marker_size = 2;
line_width = 1;
color_nonmatch = 'k';

%% load data
% obs only
filename_p_values = 'p_kruskalwallis_per_bin_and_neuron';
load(filename_p_values)
sig_exe = data.sig_exe(:,9:20);
sig_obs = data.sig_obs(:,9:20);
clear data
obs_only = sig_obs - sig_exe; % only +1 is meaningful: obs only

% matched and non-matched (same or diff)
filename_same_or_diff = ['same_or_diff_' type_of_method];
load(filename_same_or_diff)
same_diff = same_or_diff; clear same_or_diff

% obs only bins are added to non-shared bins
for each_neuron = 1:size(obs_only,1)
    idx = find(obs_only(each_neuron,:) == 1);
    same_diff(each_neuron, idx) = -1;
end

%% preparation
n_neurons = size(same_diff,1);
n_bins = size(same_diff,2);
n_cons = n_bins/2*(n_bins+1); % possible periods with consecutive bins

%% consecutive bin count and first bin of consecutive bins (also two or three consecutive bin periods allowed)
%% figure out the possible segments
% each row of columns 1-3 of cons_time contains one out of 78 possible segments of consecutive
% bins
% first column: position of first bin of a period of consecutive bins
% second column: position of last bin of a period of consecutive bins
% third column: duration (in bins) of a period
cons_time = zeros(n_cons,5);
cnt = 0;
for each_bin = 1:n_bins % put in all first bins and duration (number of consecutive bins)
    remaining_bins = n_bins-each_bin+1;
    cons_time(cnt+1:cnt+remaining_bins,1) = repmat(each_bin,remaining_bins,1); % first bin
    cons_time(cnt+1:cnt+remaining_bins,3) = (remaining_bins:-1:1)'; % duration
    cnt = cnt + remaining_bins;
end
cons_time(:,2) =  cons_time(:,1) + cons_time(:,3) - 1; % last bin

%% count the neurons per segment
% fourth column of cons_time: number of MATCHED neurons with a certain segment
% fifth column of cons_time: number of NON-MATCHED neurons with a certain segment
for each_neuron = 1:n_neurons
    x = same_diff(each_neuron,:);
    x_NaN = find(isnan(x) == 1);
    x(x_NaN) = 0;
    x_m1 = find(x == -1);
    x(x_m1) = 0;
    [starts, ends] = consecutive_ones(x);
    for each_start = 1:length(starts)
        idx = find(cons_time(:,1) == starts(each_start) & cons_time(:,2) == ends(each_start));
        cons_time(idx,4) = cons_time(idx,4) + 1;
    end
end
for each_neuron = 1:n_neurons
    x = same_diff(each_neuron,:);
    x_NaN = find(isnan(x) == 1);
    x(x_NaN) = 0;
    % set 1 to 0, but -1 to 1
    x_m1 = find(x == 1);
    x(x_m1) = 0;
    x_m1 = find(x == -1);
    x(x_m1) = 1;
    [starts, ends] = consecutive_ones(x);
    for each_start = 1:length(starts)
        idx = find(cons_time(:,1) == starts(each_start) & cons_time(:,2) == ends(each_start));
        cons_time(idx,5) = cons_time(idx,5) + 1;
    end
end

%% prepare datapoints
n_match = sum(cons_time(:,4));
n_nonmatch = sum(cons_time(:,5));
x = [repmat(1,n_match,1); repmat(2,n_nonmatch,1)]; % 1 for matched, 2 for nonmatched
y_start = NaN(n_match+n_nonmatch, 1);
y_dura = NaN(n_match+n_nonmatch, 1);
cnt_start = 0;
for each_profile = 1:n_cons
    if cons_time(each_profile,4) >= 1
        tmp_n = cons_time(each_profile,4);
        y_start(cnt_start+1 : cnt_start+tmp_n,1) =  cons_time(each_profile,1);
        y_dura(cnt_start+1 : cnt_start+tmp_n,1) =  cons_time(each_profile,3);
        cnt_start = cnt_start + tmp_n;
    end
end
for each_profile = 1:n_cons
    if cons_time(each_profile,5) >= 1
        tmp_n = cons_time(each_profile,5);
        y_start(cnt_start+1 : cnt_start+tmp_n,1) =  cons_time(each_profile,1);
        y_dura(cnt_start+1 : cnt_start+tmp_n,1) =  cons_time(each_profile,3);
        cnt_start = cnt_start + tmp_n;
    end
end
assert(cnt_start == n_match + n_nonmatch)

%% figure
subplot(2,2,2*isubplot+1)
[h1,~] = histcounts(y_start(x==1), 0:12,'normalization', 'probability');
[h2,~] = histcounts(y_start(x==2), 0:12,'normalization', 'probability');
xx = (1:length(h1)) - .5;
plot(xx,h1,'-o', 'color', color_match,'MarkerEdgeColor',...
    color_match, 'MarkerFaceColor', color_match,...
    'MarkerSize', marker_size,'linewidth',line_width);
hold on
plot(xx, h2,'-o', 'color', color_nonmatch,'MarkerEdgeColor',...
    color_nonmatch, 'MarkerFaceColor', color_nonmatch,...
    'MarkerSize', marker_size,'linewidth',line_width);
axis([0 n_bins+1, get(gca,'ylim')])
set(gca,'xtick',(0:4:12),'XTicklabel',{'REL','TCH','HLD','REW'})
yticks(0:.1:.5)
ymax = .3;
ylim([-ymax/10/2 ymax])
xlim([-1 12])
add_shades(ymax)
ylabel('Relative frequency')
xlabel('Starting bin')
cleanplot

subplot(2,2,2*isubplot+2)
[h1,~] = histcounts(y_dura(x==1), 0:12,'normalization', 'probability');
[h2,~] = histcounts(y_dura(x==2), 0:12,'normalization', 'probability');
xx = (1:length(h1)) - .5;
plot(xx,h1,'-o', 'color', color_match,'MarkerEdgeColor',...
    color_match, 'MarkerFaceColor', color_match,...
    'MarkerSize', marker_size,'linewidth',line_width);
hold on
plot(xx, h2,'-o', 'color', color_nonmatch,'MarkerEdgeColor',...
    color_nonmatch, 'MarkerFaceColor', color_nonmatch,...
    'MarkerSize', marker_size,'linewidth',line_width);
axis([0 n_bins+1, get(gca,'ylim')])
set(gca,'xtick',(0:4:12),'XTicklabel',{'REL','TCH','HLD','REW'})
yticks(0:.2:.8)
ymax = .8;
ylim([-ymax/10/2 ymax])
xlim([-1 12])
add_shades(ymax)
ylabel('Relative frequency')
xlabel('Duration (bins)')
cleanplot
end


function add_shades(ymax)
onsets = 0:8:12;
ymin = 0;
for t = onsets
    fill([t t t+4 t+4],[ymin ymax ymax ymin],...
        'k','EdgeColor','none','FaceAlpha',.1)
end
end