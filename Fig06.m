

clc
clear
close all

stat_for_fig06
% keep n6c n6d n6e n6f

figure('Units','normalized','OuterPosition',[.1 .1 .15 .7])

subplot(4,2,1)
prep_for_fig06A

subplot(4,2,2)
load xx_109_7_pop_exe2obs
e2e = perf.verif;
e2o = perf.test;
load xx_109_7_pop_obs2exe
o2o = perf.verif;
o2e = perf.test;
prep_for_fig06BCDEF(e2e,e2o,o2o,o2e,177)

subplot(4,2,3)
load for_fig06C_exe2obs
e2e = perf.verif;
e2o = perf.test;
load for_fig06C_obs2exe
o2o = perf.verif;
o2e = perf.test;
prep_for_fig06BCDEF(e2e,e2o,o2o,o2e,n6c)

subplot(4,2,4)
load for_fig06D_exe2obs
e2e = perf.verif;
e2o = perf.test;
load for_fig06D_obs2exe
o2o = perf.verif;
o2e = perf.test;
prep_for_fig06BCDEF(e2e,e2o,o2o,o2e,n6d)

subplot(4,2,5);
plot_n(n6e)

subplot(4,2,6)
plot_n(n6f)


subplot(4,2,7)
load for_fig06E_exe2obs
e2e = perf.verif;
e2o = perf.test;
load for_fig06E_obs2exe
o2o = perf.verif;
o2e = perf.test;
prep_for_fig06BCDEF(e2e,e2o,o2o,o2e,[])

subplot(4,2,8)
load for_fig06F_exe2obs
e2e = perf.verif;
e2o = perf.test;
load for_fig06F_obs2exe
o2o = perf.verif;
o2e = perf.test;
prep_for_fig06BCDEF(e2e,e2o,o2o,o2e,[])


function plot_n(N)
bar(N,'facecolor','k','EdgeColor','w')
set(gca,'XColor','none')
ylabel Count
yticks(0:10:50)
ylim([0 25])
xlim([-1 25])
pbaspect([1 .3 1])
add_shades_bar
cleanplot
end


function add_shades_bar
hold on
onsets = (4:8:20)+.5;
yrange = ylim;
ymin = yrange(1);
ymax = yrange(2);
for t = onsets
    fill([t t t+4 t+4],[ymin ymax ymax ymin],...
        'k','EdgeColor','none','FaceAlpha',.1)
end
end