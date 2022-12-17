

%% calculate the mean angle of the right most cluster

c = lines(7);

thresh = 10;

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
[fitresult, gof, out] = fit( edges', count', ft, opts);

display(gof.adjrsquare)

xx = -90:.1:90;
yy = feval(fitresult,xx);

h = histogram(angle,-90:binsize:90);
h.FaceAlpha = 1;
h.FaceColor = [.5 .5 .5];
set(gca,'YTick',0:10:100)
cleanhist(h)

hold on
plot(xx,yy,'color',c(3,:),'linewidth',2)
set(gca,'xtick',-90:45:90)
xlim([-90 90])
xlabel('Angle (deg)')
ylabel('Bin count')

pbaspect([1 .4 1])
