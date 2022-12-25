clear
close all
clc

%% settings
alpha_level = 0.05;
correction_type = 'BH'; % options: 'uncorrected', 'Bonferroni', 'BH' 

bins_to_test = 1:24; % bins in which the significance test should be done

save_figure = 'off';

%% load data
load data_Fig3A.mat

%% prepare data for figure
x = 1:24;
y = NaN(4,24); % rows: mean of exe2obs.verif, exe2obs.test, obs2exe.verif
z = NaN(4,24); % rows: sem of exe2obs.verif, exe2obs.test, obs2exe.verif
n_neurons = size(data.exe2obs.perf.verif,1); 

y(1,:) = nanmean(data.exe2obs.perf.verif);
y(2,:) = nanmean(data.exe2obs.perf.test);
y(3,:) = nanmean(data.obs2exe.perf.verif);
y(4,:) = nanmean(data.obs2exe.perf.test);

z(1,:) = nanstd(data.exe2obs.perf.verif)/sqrt(n_neurons);
z(2,:) = nanstd(data.exe2obs.perf.test)/sqrt(n_neurons);
z(3,:) = nanstd(data.obs2exe.perf.verif)/sqrt(n_neurons);
z(4,:) = nanstd(data.obs2exe.perf.test)/sqrt(n_neurons);

if strcmp(correction_type, 'Bonferroni')
    alpha_level_adjusted = alpha_level/length(bins_to_test); % Bonferroni correction for number of bins to test
else
    alpha_level_adjusted = alpha_level;
end
P = NaN(3,24); H = NaN(3,24);
for i = bins_to_test
    [P(1,i),H(1,i)] = signrank(data.exe2obs.perf.verif(:,i), 1/3*100, 'alpha', alpha_level_adjusted,'tail','right');
    [P(2,i),H(2,i)] = signrank(data.exe2obs.perf.test(:,i), 1/3*100, 'alpha', alpha_level_adjusted,'tail','right');
    [P(3,i),H(3,i)] = signrank(data.obs2exe.perf.verif(:,i), 1/3*100, 'alpha', alpha_level_adjusted,'tail','right');
    [P(4,i),H(4,i)] = signrank(data.obs2exe.perf.test(:,i), 1/3*100, 'alpha', alpha_level_adjusted,'tail','right');
    
    [p_BG(1,i),H_BG(1,i)] = signrank(data.exe2obs.perf.verif(:,i), data.obs2exe.perf.verif(:,i), 'alpha', alpha_level_adjusted);
    [p_GR(1,i),H_GR(1,i)] = signrank(data.exe2obs.perf.test(:,i), data.obs2exe.perf.verif(:,i), 'alpha', alpha_level_adjusted);
    [p_RO(1,i),H_RO(1,i)] = signrank(data.exe2obs.perf.test(:,i), data.obs2exe.perf.test(:,i), 'alpha', alpha_level_adjusted);
end
if strcmp(correction_type, 'BH')
    H = NaN(3,24);
    H(1,bins_to_test) = BH_correct(P(1,bins_to_test), alpha_level, 1);
    H(2,bins_to_test) = BH_correct(P(2,bins_to_test), alpha_level, 1);
    H(3,bins_to_test) = BH_correct(P(3,bins_to_test), alpha_level, 1);
    H(4,bins_to_test) = BH_correct(P(4,bins_to_test), alpha_level, 1);
    
    H_BG(1,bins_to_test) = BH_correct(p_BG(bins_to_test), alpha_level, 2);
    H_GR(1,bins_to_test) = BH_correct(p_GR(bins_to_test), alpha_level, 2);
    H_RO(1,bins_to_test) = BH_correct(p_RO(bins_to_test), alpha_level, 2);
end

%% figure
c = lines(7);
figure('units','normalized','outerposition',[.2 .2 .4 .4])
hold on
plotkon(y(1,:),z(1,:),c(1,:));
plotkon(y(2,:),z(2,:),c(7,:));
plotkon(y(4,:),z(4,:),c(3,:));
plotkon(y(3,:),z(3,:),c(5,:));

events = {'Prs','LED','Rel',...
    'Tch','Hld','Rew','Wdr'};
set(gca,'xtick',(1:4:25)-.5,'xticklabel',events)
ylabel('classifier perf. (%)')
pbaspect([.7 1 1])
cleanplot

plot(x(find(H(1,:) == 1)), 47.0, '.', 'markersize', 15, 'color', c(1,:))
plot(x(find(H(3,:) == 1)), 46.5, '.', 'markersize', 15, 'color', c(5,:))
plot(x(find(H(4,:) == 1)), 46.0, '.', 'markersize', 15, 'color', c(3,:))
plot(x(find(H(2,:) == 1)), 45.5, '.', 'markersize', 15, 'color', c(7,:))

plot(x(find(H_BG == 1)), 44.5, '^', 'markersize', 5, 'markeredgecolor', c(1,:), 'markerfacecolor', c(5,:));
plot(x(find(H_GR == 1)), 44.0, '^', 'markersize', 5, 'markeredgecolor', c(5,:), 'markerfacecolor', c(7,:));
try
    plot(x(find(H_RO == 1)), 43.5, '^', 'markersize', 5, 'markeredgecolor', c(7,:), 'markerfacecolor', c(3,:));
end

%%
function h = plotkon(m,err,color)

hold on
h = plot(m,'color',color,'linewidth',2);
plot(m-err,'color',color,'linewidth',.5)
plot(m+err,'color',color,'linewidth',.5)

line([0 size(m,2)+1],[100/3 100/3],'color','k')
xlim([0 size(m,2)+1])

end