clear
close all
clc

%% settings
filename_exe = 'behavioral_data_exe'; % these are duration data of all valid trials of the sessions in which mirror neurons were recorded (177 MN)
filename_obs = 'behavioral_data_obs';

save_fig = 'off';

%% load data
load (filename_exe)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 1: effect of informative vs.noninformative cue during the touch-hold period, the manipulation itself, for each monkey

%% monkey 1
idx_t1_info = find(strcmp(MonkeyName, 'Pollux') == 1 & strcmp(Period, 'Touch-Hold') == 1 & strcmp(CueType, 'Informative') == 1);
idx_t1_noninfo = find(strcmp(MonkeyName, 'Pollux') == 1 & strcmp(Period, 'Touch-Hold') == 1 & strcmp(CueType, 'Non-Informative') == 1);
[h_1,p_1,CI_1,stats_1] = ttest2(DurationSec(idx_t1_info), DurationSec(idx_t1_noninfo));

[~,~,CI_info_1] = ttest(DurationSec(idx_t1_info));
[~,~,CI_noninfo_1] = ttest(DurationSec(idx_t1_noninfo));
mean_info_1 = mean(DurationSec(idx_t1_info));
mean_noninfo_1 = mean(DurationSec(idx_t1_noninfo));

%% monkey 2
idx_t2_info = find(strcmp(MonkeyName, 'Flori') == 1 & strcmp(Period, 'Touch-Hold') == 1 & strcmp(CueType, 'Informative') == 1);
idx_t2_noninfo = find(strcmp(MonkeyName, 'Flori') == 1 & strcmp(Period, 'Touch-Hold') == 1 & strcmp(CueType, 'Non-Informative') == 1);
[h_2,p_2,CI_2,stats_2] = ttest2(DurationSec(idx_t2_info), DurationSec(idx_t2_noninfo));

[~,~,CI_info_2] = ttest(DurationSec(idx_t2_info));
[~,~,CI_noninfo_2] = ttest(DurationSec(idx_t2_noninfo));
mean_info_2 = mean(DurationSec(idx_t2_info));
mean_noninfo_2 = mean(DurationSec(idx_t2_noninfo));

%% figure of 95% confidence intervals of mean
figure('Units','normalized','OuterPosition',[.1 .1 .3 .2])
subplot(1,3,1)
Y = {DurationSec(idx_t1_info),DurationSec(idx_t1_noninfo),...
    DurationSec(idx_t2_info), DurationSec(idx_t2_noninfo)};
fun_barPlot(Y)
% axis([0 5 0.1 0.6])
xticks(1:4)
xticklabels({'M1 informative' 'M1 noninformative' 'M2 informative' 'M2 noninformative'})
xlabel('Monkey and cue types')
ylabel('Manipulation duration (s)')
% title (['manipulation period: touch to hold (95%-CI of the mean), M1 p = ' num2str(p_1) ', M2 p = ' num2str(p_2)])
y_text = range(get(gca,'ylim')) / 20;
text(1-0.5, min(get(gca,'ylim')) + y_text, [num2str(length(idx_t1_info))])
text(2, min(get(gca,'ylim')) + y_text, num2str(length(idx_t1_noninfo)))
text(3, min(get(gca,'ylim')) + y_text, num2str(length(idx_t2_info)))
text(4, min(get(gca,'ylim')) + y_text, num2str(length(idx_t2_noninfo)))
set(gca,'ytick',0:.1:1)
ylim([0 .5])
if strcmp(save_fig,'on')
    saveas(gcf,'Fig_1_informative_vs_noninformative_cue_manipulation.png','png')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 2: effect of informative cue on approach (reaching), measured as duration of reaching, done for each monkey separately

%% monkey 1
idx_m1_info = find(strcmp(MonkeyName, 'Pollux') == 1 & strcmp(Period, 'Rls-Touch') == 1 & strcmp(CueType, 'Informative') == 1);
[p_1,~,stats_1] = anova1(DurationSec(idx_m1_info), ActionType(idx_m1_info),'off');

idx_m1_lift = find(strcmp(MonkeyName, 'Pollux') == 1 & strcmp(Period, 'Rls-Touch') == 1 & strcmp(CueType, 'Informative') == 1 & strcmp(ActionType, 'Lift') == 1);
[~,~,CI_info_1_lift] = ttest(DurationSec(idx_m1_lift));
idx_m1_twist = find(strcmp(MonkeyName, 'Pollux') == 1 & strcmp(Period, 'Rls-Touch') == 1 & strcmp(CueType, 'Informative') == 1 & strcmp(ActionType, 'Twist') == 1);
[~,~,CI_info_1_twist] = ttest(DurationSec(idx_m1_twist));
idx_m1_shift = find(strcmp(MonkeyName, 'Pollux') == 1 & strcmp(Period, 'Rls-Touch') == 1 & strcmp(CueType, 'Informative') == 1 & strcmp(ActionType, 'Shift') == 1);
[~,~,CI_info_1_shift] = ttest(DurationSec(idx_m1_shift));

mean_info_lift_m1 = mean(DurationSec(idx_m1_lift));
mean_info_twist_m1 = mean(DurationSec(idx_m1_twist));
mean_info_shift_m1 = mean(DurationSec(idx_m1_shift));

%% monkey 2
idx_m2_info = find(strcmp(MonkeyName, 'Flori') == 1 & strcmp(Period, 'Rls-Touch') == 1 & strcmp(CueType, 'Informative') == 1);
[p_2,~,stats_2] = anova1(DurationSec(idx_m2_info), ActionType(idx_m2_info),'off');

idx_m2_lift = find(strcmp(MonkeyName, 'Flori') == 1 & strcmp(Period, 'Rls-Touch') == 1 & strcmp(CueType, 'Informative') == 1 & strcmp(ActionType, 'Lift') == 1);
[~,~,CI_info_2_lift] = ttest(DurationSec(idx_m2_lift));
idx_m2_twist = find(strcmp(MonkeyName, 'Flori') == 1 & strcmp(Period, 'Rls-Touch') == 1 & strcmp(CueType, 'Informative') == 1 & strcmp(ActionType, 'Twist') == 1);
[~,~,CI_info_2_twist] = ttest(DurationSec(idx_m2_twist));
idx_m2_shift = find(strcmp(MonkeyName, 'Flori') == 1 & strcmp(Period, 'Rls-Touch') == 1 & strcmp(CueType, 'Informative') == 1 & strcmp(ActionType, 'Shift') == 1);
[~,~,CI_info_2_shift] = ttest(DurationSec(idx_m2_shift));

mean_info_lift_m2 = mean(DurationSec(idx_m2_lift));
mean_info_twist_m2 = mean(DurationSec(idx_m2_twist));
mean_info_shift_m2 = mean(DurationSec(idx_m2_shift));

%% figure of 95% confidence intervals of mean
subplot(1,3,2)
Y = {DurationSec(idx_m1_lift),DurationSec(idx_m1_twist),DurationSec(idx_m1_shift),...
    DurationSec(idx_m2_lift),DurationSec(idx_m2_twist),DurationSec(idx_m2_shift)};
fun_barPlot(Y)
xticks(1:6)
xticklabels({'M1 lift' 'M1 twist' 'M1 shift' 'M2 lift' 'M2 twist' 'M2 shift'})
xlabel('Monkey and action type')
ylabel('Monkey approach duration (s)')
% title (['approach period: button release to touch (95%-CI of the mean), M1 p = ' num2str(p_1) ', M2 p = ' num2str(p_2)])
y_text = range(get(gca,'ylim')) / 20;
text(1-0.5, min(get(gca,'ylim')) + y_text, [num2str(length(idx_m1_lift))])
text(2, min(get(gca,'ylim')) + y_text, num2str(length(idx_m1_twist)))
text(3, min(get(gca,'ylim')) + y_text, num2str(length(idx_m1_shift)))
text(4, min(get(gca,'ylim')) + y_text, num2str(length(idx_m2_lift)))
text(5, min(get(gca,'ylim')) + y_text, num2str(length(idx_m2_twist)))
text(6, min(get(gca,'ylim')) + y_text, num2str(length(idx_m2_shift)))
set(gca,'ytick',0:.025:1)
ylim([.1 .2])
if strcmp(save_fig,'on')
    saveas(gcf,'Fig_1_cue_dependent_approach.png','png')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 3: effect of informative cue on approach (reaching), measured as duration of reaching, done for human (both monkeys pooled)

clear ActionType
clear CueSide
clear CueType
clear DurationSec
clear MonkeyName
clear Period
clear SessionCnt

%% load data
load (filename_obs)

idx_m1_info = find(strcmp(Period, 'Rls-Touch') == 1 & strcmp(CueType, 'Informative') == 1);
[p_1,~,stats_1] = anova1(DurationSec(idx_m1_info), ActionType(idx_m1_info),'off');

idx_m1_lift = find(strcmp(Period, 'Rls-Touch') == 1 & strcmp(CueType, 'Informative') == 1 & strcmp(ActionType, 'Lift') == 1);
[~,~,CI_info_1_lift] = ttest(DurationSec(idx_m1_lift));
idx_m1_twist = find(strcmp(Period, 'Rls-Touch') == 1 & strcmp(CueType, 'Informative') == 1 & strcmp(ActionType, 'Twist') == 1);
[~,~,CI_info_1_twist] = ttest(DurationSec(idx_m1_twist));
idx_m1_shift = find(strcmp(Period, 'Rls-Touch') == 1 & strcmp(CueType, 'Informative') == 1 & strcmp(ActionType, 'Shift') == 1);
[~,~,CI_info_1_shift] = ttest(DurationSec(idx_m1_shift));

mean_info_lift_m1 = mean(DurationSec(idx_m1_lift));
mean_info_twist_m1 = mean(DurationSec(idx_m1_twist));
mean_info_shift_m1 = mean(DurationSec(idx_m1_shift));

%% figure of 95% confidence intervals of mean
subplot(1,3,3)
Y = {DurationSec(idx_m1_lift),DurationSec(idx_m1_twist),DurationSec(idx_m1_shift)};
fun_barPlot(Y)
% axis([0 4 0.25 0.35])
xticks(1:3)
xticklabels({'Lift' 'Twist' 'Shift'})
xlabel('Action type')
ylabel('Human approach duration (s)')
% title (['approach period: button release to touch (95%-CI of the mean), p = ' num2str(p_1)])
y_text = range(get(gca,'ylim')) / 20;
text(1-0.5, min(get(gca,'ylim')) + y_text, [num2str(length(idx_m1_lift))])
text(2, min(get(gca,'ylim')) + y_text, num2str(length(idx_m1_twist)))
text(3, min(get(gca,'ylim')) + y_text, num2str(length(idx_m1_shift)))
set(gca,'ytick',0:.025:1)
ylim([.25 .32])
if strcmp(save_fig,'on')
    saveas(gcf,'Fig_1_cue_dependent_approach_HUMAN.png','png')
end
