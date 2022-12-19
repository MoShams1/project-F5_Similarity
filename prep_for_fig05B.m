

function fun_fig05B(type_of_method,count_or_relative,isubplot,legend_flag)
marker_size = 2;
plot_linewith = 1;
% line_color = [0.5 0.5 0.5];

c = lines(7);
color_match = c(2,:);
color_nonmatch = 'k';
color_segment_exist = [0.5 0.5 0.5];
color_segment_nonexist = [.85 .85 .85];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data
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

% preparation
n_neurons = size(same_diff,1);
n_bins = size(same_diff,2);
n_cons = n_bins/2*(n_bins+1); % possible periods with consecutive bins

% consecutive bin count and first bin of consecutive bins (also two or three consecutive bin periods allowed)
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

% count the neurons per segment
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
    
% calculate the relative proportions
if strcmp(count_or_relative,'relative')
    cons_time(:,4) = cons_time(:,4) / sum(cons_time(:,4));
    cons_time(:,5) = cons_time(:,5) / sum(cons_time(:,5));
end

% figure
% figure('Units','normalized','OuterPosition',[.1 .1 .14 .2])
% subplot(2,1,2)

cons_time = sortrows(cons_time,[3,1]); % sorting: first: duration, second: position of first bin
x = [];
for i = 12:-1:1
    if i == 12
        x_end = -1;
    else
        x_end = max(x);
    end
    x_start = x_end + 2;
    x_end = x_start + (i-1);
    x = [x, x_start:x_end];
end
if legend_flag
    subplot(5,1,5)
    for each_cons = 1:n_cons
        if cons_time(each_cons,4) > 0 || cons_time(each_cons,5) > 0
            line([x(each_cons),x(each_cons)], [cons_time(each_cons,1)-1, cons_time(each_cons,2)+0], 'color', color_segment_exist, 'linewidth', 2)
            hold on
        else
            line([x(each_cons),x(each_cons)], [cons_time(each_cons,1)-1, cons_time(each_cons,2)+0], 'color', color_segment_nonexist, 'linewidth', 2)
            hold on
        end
    end
    % line(get(gca,'xlim'), [0.5 0.5], 'color', line_color)
    % line(get(gca,'xlim'), [4.5 4.5], 'color', line_color)
    % line(get(gca,'xlim'), [8.5 8.5], 'color', line_color)
    % line(get(gca,'xlim'), [12.5 12.5], 'color', line_color)

    xticklabels([])
    xticks([])
    xlim([-2 89])
    yticks(0:4:12)
    ylim([0 12])
    ylabel('Action segments')
    pbaspect([1 .15 1])
    set(gca,'XColor','none')
    cleanplot
end

%% plot data
h = [];
subplot(5,1,isubplot)
cnt = 0;
for i=12:-1:1
    plot(x(cnt+1:cnt+i), cons_time(cnt+1:cnt+i,5),'-', 'color', color_nonmatch,'linewidth',plot_linewith)
    hold on
    plot(x(cnt+1:cnt+i), cons_time(cnt+1:cnt+i,4),'-', 'color', color_match,'linewidth',plot_linewith)
    cnt = cnt + i;
end
h(2) = plot(x, cons_time(:,5),'o', 'MarkerEdgeColor', color_nonmatch, 'MarkerFaceColor', color_nonmatch, 'MarkerSize', marker_size);
hold on
h(1) = plot(x, cons_time(:,4),'o', 'MarkerEdgeColor', color_match, 'MarkerFaceColor', color_match, 'MarkerSize', marker_size);
xticklabels([])
xticks([])
xlim([-2 89])
if strcmp(count_or_relative,'count')
    yticks(0:10:20)
    ylim([0 25])
else
    yticks(0:.1:.2)
    ylim([0 .2])
end
% legend(h,{'matched', 'non-matched'},'location','north')

% if strcmp(count_or_relative,'relative')
%     title('proportion of cases relative to total number of cases with a certain segment')
% elseif strcmp(count_or_relative,'count')
%     title('count of MNs with a certain segment')
% end
cleanplot