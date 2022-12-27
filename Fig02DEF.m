

clc
close all
clear

load x108_rel_timecourse_M1M2

c = lines(7);
cmap = [c(7,:);c(1,:);c(5,:)];
sz = 3;
neuron = 12;  % 68, 28, 12

figure('Units','normalized','OuterPosition',[.1 .1 .08 .2])
% execution
ax1 = subplot(2,1,1);
hold on
plot3line((1:24)-.5,lift_exe{neuron,1}*500,cmap(1,:),0,0,1,sz);
plot3line((1:24)-.5,twist_exe{neuron,1}*500,cmap(2,:),0,0,1,sz);
plot3line((1:24)-.5,shift_exe{neuron,1}*500,cmap(3,:),0,0,1,sz);
set(gca,'xcolor','none','YTick',0:40:80)
ylabel({'Discharge rate','(spks/s)'})
xlim([-1 24])
ylim([-5 80])
add_shades
cleanplot
% observation
ax2 = subplot(2,1,2);
hold on
plot3line((1:24)-.5,lift_obs{neuron,1}*500,cmap(1,:),0,0,1,sz);
plot3line((1:24)-.5,twist_obs{neuron,1}*500,cmap(2,:),0,0,1,sz);
plot3line((1:24)-.5,shift_obs{neuron,1}*500,cmap(3,:),0,0,1,sz);
set(gca,'XTick',0:4:25,'XTickLabel',...
    {'BPR','LED','REL','TCH','HLD','REW','WDR'},'YTick',0:40:80)
ylabel({'Discharge rate','(spks/s)'})
add_shades
xlim([-1 24])
ylim([-5 80])
cleanplot


function add_shades()
onsets = 4:8:24;
ymin = 0;
ymax = 80;
for t = onsets
    fill([t t t+4 t+4],[ymin ymax ymax ymin],...
        'k','EdgeColor','none','FaceAlpha',.1)
end
end
