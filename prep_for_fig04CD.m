

%% calculate the mean angle of the right most cluster

cmap = parula(11+1);
ic = 0;

for thresh = 5:15
       
    x = obs2obs(:);
    y = exe2obs(:);
    
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
    ft = fittype( 'gauss1' );
    
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    
    % Fit model to data.
    [fitresult, gof] = fit( edges', count', ft, opts);
    adjR2(ic+1) = gof.adjrsquare;
    
    xx = -90:.1:90;
    yy = feval(fitresult,xx);
    
    % Set up fittype and options.
    ft = 'linearinterp'; 
    [fitresult, gof] = fit( edges', count', ft, 'Normalize', 'on' );
    yy_true = feval(fitresult,xx);
    yy_true(yy_true<0) = 0;
    
    res = yy_true - yy;
    
    ic = ic+1;
    
    subplot(3,2,3)
    hold on
    plot(xx,yy,'color',cmap(ic,:),'linewidth',1.5)

    if thresh == 15
        ylim([0 70])
        xlim([-90 90])
        set(gca,'xtick',-90:45:90)
%         legend th=5 th=6 th=7 th=8 th=9 th=10 th=11 th=12 th=13 th=14 th=15 location northwest
        xlabel('Angle (deg)')
        ylabel('Bin count')
        cleanplot
    end
    
    subplot(3,2,5)
    hold on
    plot(xx,res,'color',cmap(ic,:),'linewidth',1.5)
    if thresh == 15
        ylim([-20 40])
        xlim([-90 90])
        set(gca,'xtick',-90:45:90)
        xlabel('Angle (deg)')
        ylabel('Residuals')
        pbaspect([1 .5 1])
        cleanplot
    end
end

display(mean(adjR2))

