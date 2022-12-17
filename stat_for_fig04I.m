
clc
clear
close all


load xx_108_4_single_e2o_perf
exe2obs_cell = cellfun(@mean, test,'UniformOutput',false);
exe2obs = cell2mat(exe2obs_cell);
exe2obs = exe2obs-100/3;

load xx_108_4_single_o2o_perf
obs2obs_cell = cellfun(@mean, verif,'UniformOutput',false);
obs2obs = cell2mat(obs2obs_cell);
obs2obs = obs2obs-100/3;


%% crop irrelevant time-bins
exe2obs(:,[1:8,21:24]) = [];
obs2obs(:,[1:8,21:24]) = [];

%% calculate the mean angle of the right most cluster

nboot = 1000;
thresholds = 5:15;

x_source = obs2obs(:);
y_source = exe2obs(:);

for iboot = 1:nboot

    disp(iboot)

    samples = datasample(1:length(x_source), length(x_source));
    x = x_source(samples);
    y = y_source(samples);

    it=0;
    for ithresh = thresholds
        it = it+1;

        ind_min_rel = x>=ithresh;
        x = x(ind_min_rel);
        y = y(ind_min_rel);

        % convert to angle
        angle = atand(y./x);
        n = sum(~isnan(angle));
        nbins = round(sqrt(length(angle)));
        [count, edges] = histcounts(angle,nbins);
        binsize = edges(2)-edges(1);
        edges = mean(edges([1 2])):binsize:edges(end);

        % Set up fittype and options.
        ft = fittype( 'gauss2' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        % Fit model to data.
        [fitresult, gof, out] = fit( edges', count', ft, opts);
        adjr2(iboot,it) = gof.adjrsquare;
    end
end
%% save
save('stat_for_fig04I.mat', "thresholds","adjr2")





