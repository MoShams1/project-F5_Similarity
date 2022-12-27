

%% calculate the mean angle of the right most cluster

cmap = parula(11+1);
cmap = cmap .* repmat([.9 .8 .9],size(cmap,1),1);

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
ft = fittype( 'gauss2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
% Fit model to data.
[fitresult, gof, out] = fit( edges', count', ft, opts);

adjr2 = gof.adjrsquare;
disp(['Gauss2 adjR2: ', num2str(gof.adjrsquare)])

xx = -90:.1:90;
yy = feval(fitresult,xx);

h = histogram(angle,-90:binsize:90);
h.FaceAlpha = 1;
h.FaceColor = [.5 .5 .5];
set(gca,'YTick',0:20:100)
cleanhist(h)

hold on
plot(xx,yy,'color',cmap(6,:),'linewidth',2)
set(gca,'xtick',-90:45:90)
xlim([-90-5 90])
ylim([-2 40])
% xlabel('Angle (deg)')
% ylabel('Bin count')

% find the local minimum
[pp,ipp] = findpeaks(yy);
[~,idmin] = min(yy(ipp(1):ipp(2)));
boundary = xx(ipp(1)+idmin);
% line([boundary boundary],[0 40],'color','r')
disp(['Gauss2 boundary: ', num2str(boundary),'deg'])
pbaspect([1 .5 1])
