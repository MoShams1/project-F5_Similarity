
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

x_source = obs2obs(:);
y_source = exe2obs(:);

nboot = 1000;
thresholds = 5:15;
boundary = nan(nboot, length(thresholds));
m1 = nan(nboot, length(thresholds));
m2 = nan(nboot, length(thresholds));
err_count = 0;

for iboot = 1:nboot

    disp(iboot)

    samples = datasample(1:length(x_source), length(x_source));
    x = x_source(samples);
    y = y_source(samples);

    ith = 0;

    for thresh = thresholds

        ith = ith+1;

        ind_min_rel = x>=thresh;
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
        opts.lower = [-inf -inf 0 -inf -inf 0];
        opts.upper = [+inf +inf +inf +inf +inf +inf];

        try
            % Fit model to data.
            [fitresult, gof] = fit( edges', count', ft, opts);
            adjR2(iboot,ith) = gof.adjrsquare;
            xx = -90:.1:90;
            yy = feval(fitresult,xx);
            % find the local minimum
            [pp,ipp] = findpeaks(yy);
            [~,idmin] = min(yy(ipp(1):ipp(2)));
            % assign values
            boundary(iboot,ith) = xx(ipp(1)+idmin);
            m1(iboot,ith) = min([fitresult.b1,fitresult.b2]);
            m2(iboot,ith) = max([fitresult.b1,fitresult.b2]);
        catch
            try
                opts.lower = [0 -inf 0 0 -inf 0];
                % Fit model to data.
                [fitresult, gof] = fit( edges', count', ft, opts);
                adjR2(iboot,ith) = gof.adjrsquare;
                xx = -90:.1:90;
                yy = feval(fitresult,xx);
                % find the local minimum
                [pp,ipp] = findpeaks(yy);
                [~,idmin] = min(yy(ipp(1):ipp(2)));
                % assign values
                boundary(iboot,ith) = xx(ipp(1)+idmin);
                m1(iboot,ith) = min([fitresult.b1,fitresult.b2]);
                m2(iboot,ith) = max([fitresult.b1,fitresult.b2]);
            catch
                % make sure all values are NaN
                boundary(iboot,ith) = nan;
                m1(iboot,ith) = nan;
                m2(iboot,ith) = nan;
                % count this case as an error
                err_count = err_count+1;
            end
        end
    end
end

%% save
save('stat_for_fig04J.mat', "thresholds","m1","m2","boundary","err_count")

