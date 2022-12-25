clear
close all
clc

alpha_level = 0.05;

load xx_108_4_single_e2e_perf
e2e = cell2mat(cellfun(@mean,verif,'UniformOutput',false));
load xx_108_4_single_e2o_perf
e2o = cell2mat(cellfun(@mean,test,'UniformOutput',false));
load xx_108_4_single_o2o_perf
o2o = cell2mat(cellfun(@mean,verif,'UniformOutput',false));
load xx_108_4_single_o2e_perf
o2e = cell2mat(cellfun(@mean,test,'UniformOutput',false));

%% figure
c = lines(7);
figure('units','normalized','outerposition',[.1 .1 .1 .25])
hold on

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