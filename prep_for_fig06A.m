
load xx_108_4_single_e2o_perf_withoutBootstrap.mat
e2e = cell2mat(verif);
e2o = cell2mat(test);
load xx_108_4_single_o2e_perf_withoutBootstrap.mat
o2o = cell2mat(verif);
o2e = cell2mat(test);

%% figure
hold on
c = lines(7);
x = 1:24;
crop = 0;
mrk = 1;  % add marker
mrksz = 3;  % marker size
plot3line(x,e2e,c(1,:),crop,[],mrk,mrksz);
plot3line(x,o2o,c(5,:),crop,[],mrk,mrksz);
plot3line(x,o2e,c(3,:),crop,[],mrk,mrksz);
plot3line(x,e2o,c(7,:),crop,[],mrk,mrksz);

line([0 24],[100/3 100/3],'color','k')

events = {'Prs','LED','Rel','Tch','Hld','Rew','Wdr'};
set(gca,'xtick',(1:4:25)-.5,'xticklabel',events)
ylabel('Classification performance (%)')
yticks(30:2:50)
ylim([100/3-.5 44])
pbaspect([.9 1 1])
add_shades
cleanplot


function add_shades
onsets = 4:8:20;
yrange = ylim;
ymin = yrange(1);
ymax = yrange(2);
for t = onsets
    fill([t t t+4 t+4],[ymin ymax ymax ymin],...
        'k','EdgeColor','none','FaceAlpha',.1)
end
end