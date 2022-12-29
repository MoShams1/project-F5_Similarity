

function prep_for_fig06BCDEF(e2e,e2o,o2o,o2e,N)

color = lines(7);
hold on

plotCI(e2e,color(1,:),2);
plotCI(o2o,color(5,:),2);
plotCI(o2e,color(3,:),2);
plotCI(e2o,color(7,:),2);

plot([0 25],[100/3 100/3],'k-')
events = {'Prs','LED','Rel',...
    'Tch','Hld','Rew','Wdr'};
set(gca,'xtick',(1:4:25)-.5,'xticklabel',events)
set(gca,'YTick',(0:25:100))
if ~isempty(N)
    text(0,95,['N = ',num2str(N)])
end
ylabel('Classification performance (%)')
axis([-1 25 -2 100])
pbaspect([.9 1 1])
yrange = ylim;
add_shades(yrange(2))
cleanplot


function plotCI(M,color,linewidth)
mean_M = mean(M,1);
CI_upper = prctile(M,95,1);
CI_lower = prctile(M,5,1);

plot(mean_M,'color',color,'linewidth',linewidth,'LineStyle',...
    '-','linewidth',1);
plot(CI_upper,'color',color,'linewidth',linewidth/2,'LineStyle',...
    '--','linewidth',.5);
plot(CI_lower,'color',color,'linewidth',linewidth/2,'LineStyle',...
    '--','linewidth',.5);
end


function add_shades(ymax)
onsets = (5:8:24)-.5;
ymin = 0;
for t = onsets
    fill([t t t+4 t+4],[ymin ymax ymax ymin],...
        'k','EdgeColor','none','FaceAlpha',.1)
end
end

end