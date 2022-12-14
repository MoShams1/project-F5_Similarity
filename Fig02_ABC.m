

clc
clear
close all

monkey = '1';

% select a neuron ID
ID = '2015_02_10_S2_T4';  % elife 2nd submission (Fig2A)
% ID = '2014_07_09_S1_T4';  % elife 2nd submission (Fig2B)
% ID = '2014_06_13_S2_T4';  % elife 2nd submission (Fig2C)

% ID = '2014_08_30_S2_T4';
% ID = '2014_06_15_S2_T4';
% ID = '2014_06_15_S3_T4';

figure('Units','normalized','OuterPosition',[.1 .1 .11 .6])
% plot execution task
load(['S001_M',monkey,'_info'], 'minfoID', 'mevent', 'mcnd')
infoID = minfoID;
event = mevent;
cnd = mcnd;
clear minfoID mevent mcnd
load(['S002_M',monkey,'_neuron'], 'mneuron', 'mneuronID', 'mind_valid_neurons')
mind_valid_trials = mind_valid_neurons;
neuron = mneuron;
neuronID = mneuronID;
ind_valid_trials = mind_valid_neurons;
clear mneurons mneuronID mind_valid_neurons
plot_kon(infoID,event,cnd, neuron,neuronID,ind_valid_trials, ID, 0);
% plot observation task
load(['S001_M',monkey,'_info'], 'vinfoID', 'vevent', 'vcnd')
infoID = vinfoID;
event = vevent;
cnd = vcnd;
clear vinfoID vevent vcnd
load(['S002_M',monkey,'_neuron'], 'vneuron', 'vneuronID', 'vind_valid_neurons')
vind_valid_trials = vind_valid_neurons;
neuron = vneuron;
neuronID = vneuronID;
ind_valid_trials = vind_valid_neurons;
clear mneurons mneuronID mind_valid_neurons
plot_kon(infoID,event,cnd, neuron,neuronID,ind_valid_trials, ID, 1);
% ============================================================================== functions
function plot_kon(infoID, event, cnd, neuron, neuronID, ind_valid_trials, ID, kk)
i_neuron = find(strcmp(ID,neuronID));
i_info = find(strcmp(ID(1:end-3),infoID));
% remove invalid trials
rmv = ~ind_valid_trials{i_neuron};
neuron{i_neuron}(rmv,:) = [];
cnd_current = cnd(i_info);
cnd_current.TL(rmv) = [];
cnd_current.TR(rmv) = [];
cnd_current.SL(rmv) = [];
cnd_current.LR(rmv) = [];
event_current = event(i_info);
event_current.startButton_start(rmv) = [];
event_current.LED_start(rmv) = [];
event_current.startButton_end(rmv) = [];
event_current.touch_start(rmv) = [];
event_current.touch_end(rmv) = [];
event_current.hold_start(rmv) = [];
event_current.reward_start_nrec(rmv) = [];
event_current.hold_end(rmv) = [];
% extract neural data and event times
T_before = 500; % time (in samples) before touch
T_after  = 750; % time (in samples) after touch
FR = nan(size(neuron{i_neuron},1),T_before+T_after);
for it = 1:size(neuron{i_neuron},1)
    % NOTE: t_[event]s are in samples
    t(it,1).LED = round(event_current.LED_start(it)/2);
    t(it,1).rls = round(event_current.startButton_end(it)/2);
    t(it,1).tch = round(event_current.touch_start(it)/2);
    t(it,1).hld = round(event_current.hold_start(it)/2);
    t(it,1).rew = round(event_current.reward_start_nrec(it)/2);
    try
        FR(it,:) = neuron{i_neuron}(it,t(it).tch-(T_before-1):t(it).tch+T_after);
    catch
        FR(it,:) = nan;
    end    
end
% extract action conditions
twist = cnd_current.TL | cnd_current.TR;
shift = cnd_current.SL;
lift = cnd_current.LR;
% group trials that belong to the same manipulation
FR_b{1}  = FR(lift,:);
FR_b{2} = FR(twist,:);
FR_b{3} = FR(shift,:);
% group event times
fields = {'LED','rls','tch','hld','rew'};
for ifield = 1:numel(fields)
    t_b{1}(:,ifield) = [t(lift).(fields{ifield})]';
    t_b{2}(:,ifield) = [t(twist).(fields{ifield})]';
    t_b{3}(:,ifield) = [t(shift).(fields{ifield})]';
end
% find nan trials
for iblock = 1:3
    nan_ind = all(isnan(FR_b{iblock}),2);
    FR_b{iblock}(nan_ind,:) = [];
    t_b{iblock}(nan_ind,:) = [];
end
% plot raster
w = 0:250:T_before+T_after; % in samples
c = lines(7);
cmap = [c(7,:);c(1,:);c(5,:)];
ax2 = subplot(4,1,kk*2+2);
plotRaster(FR_b,cmap,1)
add_events(t_b,T_before)
set(gca,'xtick',w,'xticklabel',(w-T_before).*2/1000)
ylabel('Trials')
xlabel('Time from touch (sec)')
cleanplot
% plot PSTH
kstd = 12; % std of the smoothing kernel in samples
ax1 = subplot(4,1,kk*2+1);
hold on
for iblock = 1:3
    FR = raster2fr(FR_b{iblock},kstd)*500;
    plot3line([],FR,cmap(iblock,:),1,kstd);
end
set(gca,'xtick',w,'xticklabel',(w-T_before).*2/1000)
set(gca,'xcolor','none')
ylim([0 80])
xlim([w(1) w(end)])
ylabel('Discharge rate (spks/s)')
cleanplot
linkaxes([ax1, ax2],'x')
end
% ---------------------------------------------------------------------------------------
function add_events(t,T_before)
rng('default')
mark_vector = {'s','^',[],'o','*'};
hold on
t_mat = cell2mat(t');
ntrials = size(t_mat,1);
y = 1:ntrials;
for ifield = [1 2 4 5]
    x = t_mat(:,ifield)-t_mat(:,3)+T_before;
%     rnd_vec = round(linspace(1,ntrials,.2*ntrials)); % draw events on a subset of trials
    rnd_vec = round(linspace(1,ntrials,20)); % draw events on a subset of trials
    y_sub = y(rnd_vec);
    x_sub = x(rnd_vec);
    plot(x_sub,y_sub,'color',[.2 .2 .2],'linestyle','none',...
        'marker',mark_vector{ifield},'markersize',6)
end
end
