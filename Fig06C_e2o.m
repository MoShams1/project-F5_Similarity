
clc
clear
close all

load same_or_diff_LDA.mat
% find neurons with at least one matched bin
ind_bins = same_or_diff==1;
ind_neurons = any(ind_bins,2);

load x100_M1
FR_twist_M1 = FR_twist;
FR_shift_M1 = FR_shift;
FR_lift_M1 = FR_lift;
IDs_match_crit_M1 = IDs_match_crit;

load x100_M2
FR_twist = [FR_twist_M1; FR_twist];
FR_shift = [FR_shift_M1; FR_shift];
FR_lift = [FR_lift_M1; FR_lift];
IDs_match_crit = [IDs_match_crit_M1; IDs_match_crit];

clear FR_twist_M1 FR_shift_M1 FR_lift_M1 IDs_match_crit_M1

nneurons = sum(ind_neurons);
rows_neuron = find(ind_neurons);

%% average over trials and segments

% for each manipulation
% bin the discharge rate of each segment in each trial

% set number of bins per segment
nbins = 4;

% for each neuron
for in = 1:nneurons
    
    row = rows_neuron(in);

    % create exe sets (for train and verification)
    twist_exe{in,1} = bintime(FR_twist{row,1},nbins);
    shift_exe{in,1} = bintime(FR_shift{row,1},nbins);
    lift_exe{in,1} = bintime(FR_lift{row,1},nbins);
    
    
    % create obs sets (for test)
    twist_obs{in,1} = bintime(FR_twist{row,2},nbins);
    shift_obs{in,1} = bintime(FR_shift{row,2},nbins);
    lift_obs{in,1} = bintime(FR_lift{row,2},nbins);
    
end

% assign the decision
ntrial = 8;

% create train labels
labels_train = [repmat({'twist'},ntrial,1);...
    repmat({'shift'},ntrial,1);...
    repmat({'lift'},ntrial,1)];

% create test labels
labels_test = [repmat({'twist'},ntrial,1);...
    repmat({'shift'},ntrial,1);...
    repmat({'lift'},ntrial,1)];


%% classify

% because of random selection of trials, repeat the classification for several iterations
% to create multiple "perf" matrices and then average across repetitions.

nreps = 1000;

parfor irep = 1:nreps
    
    disp(irep)
    
    [verif(irep,:),test(irep,:)] = ...
        run_class(twist_exe,shift_exe,lift_exe,...
        twist_obs,shift_obs,lift_obs,...
        ntrial,labels_train,labels_test);
    
end

perf.verif = verif;
perf.test = test;


%% save results

% save the performance matrix
save('for_fig06C_exe2obs.mat', 'perf');


%% FUNCTIONS

% ----------------------------------------- create classifier input

function FR_binned_mat = bintime(FR,nbins)

% extract number of trials and segments
[ntrials, nsegs]= size(FR);

% for each element in the input cell (FR)
for itrial = 1:ntrials
    for iseg = 1:nsegs
        
        % extract the spike train of in a given trial and segment
        spike_train = FR{itrial,iseg};
        
        
        % make sure the spike train is at least "nbins"+1 long for a reasonable binning
        lspk = length(spike_train);
        
        if lspk >= nbins+1
            
            % divide the spike train into "nbins" bins
            time_marks = linspace(1,lspk,nbins+1);
            time_marks = round(time_marks);
            
            for ibin = 1:nbins
                
                FR_binned{itrial,iseg}(1,ibin)...
                    = nanmean(spike_train(time_marks(ibin):time_marks(ibin+1)));
                
            end
            
        else
            
            FR_binned{itrial,iseg} = nan(1,nbins);
            
        end
        
    end
end

% convert the binned data into a matrix
FR_binned_mat = cell2mat(FR_binned);

end

% -----------------------------------------

function [verif,test] = ...
    run_class(twist_exe,shift_exe,lift_exe,...
    twist_obs,shift_obs,lift_obs,...
    ntrial,labels_train,labels_test)

nneurons = size(twist_exe,1);

% randomly select ntrial (currently = 8)
% from each manipulation per neuron in execution task
for ineuron = 1:nneurons
    
    sampletrials1 = datasample(1:size(twist_exe{ineuron,1}),ntrial,'rep',false);
    sampletrials2 = datasample(1:size(shift_exe{ineuron,1}),ntrial,'rep',false);
    sampletrials3 = datasample(1:size(lift_exe{ineuron,1}),ntrial,'rep',false);
    
    sample_twist_exe{ineuron,1} = twist_exe{ineuron,1}(sampletrials1,:);
    sample_shift_exe{ineuron,1} = shift_exe{ineuron,1}(sampletrials2,:);
    sample_lift_exe{ineuron,1} = lift_exe{ineuron,1}(sampletrials3,:);
    
    
    
    sampletrials1 = datasample(1:size(twist_obs{ineuron,1}),ntrial,'rep',false);
    sampletrials2 = datasample(1:size(shift_obs{ineuron,1}),ntrial,'rep',false);
    sampletrials3 = datasample(1:size(lift_obs{ineuron,1}),ntrial,'rep',false);
    
    sample_twist_obs{ineuron,1} = twist_obs{ineuron,1}(sampletrials1,:);
    sample_shift_obs{ineuron,1} = shift_obs{ineuron,1}(sampletrials2,:);
    sample_lift_obs{ineuron,1} = lift_obs{ineuron,1}(sampletrials3,:);

end



% for each neuron
for in = 1:nneurons

    % extract exe trials for train
    mat_twist_exe(:,in,:) = sample_twist_exe{in,1};
    mat_shift_exe(:,in,:) = sample_shift_exe{in,1};
    mat_lift_exe(:,in,:) = sample_lift_exe{in,1};

    % extract obs trials for test
    mat_twist_obs(:,in,:) = sample_twist_obs{in,1};
    mat_shift_obs(:,in,:) = sample_shift_obs{in,1};
    mat_lift_obs(:,in,:) = sample_lift_obs{in,1};

end

% concatenate manipulations vertically
mat_exe = [mat_twist_exe; mat_shift_exe; mat_lift_exe];
mat_obs = [mat_twist_obs; mat_shift_obs; mat_lift_obs];



nallbins = size(mat_obs,3);
for ibin = 1:nallbins

    % true labels
    % train and test with the exe trials (verify the model)
    verif(1,ibin)...
        = cross_validate(mat_exe(:,:,ibin),labels_train);

    % train with exe trials and test with obs trails (test the model)
    test(1,ibin)...
        = classify(mat_exe(:,:,ibin),labels_train,...
        mat_obs(:,:,ibin),labels_test);

end

end


% ----------------------------------------- verify (cross validate)
function perf = cross_validate(mat,labels)

ntrials = length(labels);
all_trials = reshape(1:ntrials, [], 3)';
k = ntrials/3/8;

for icv = 1:8
    
    test_trials = reshape(all_trials(:, (icv-1)*k+1:(icv-1)*k+k), 1, []);   
    train_trials = setdiff(all_trials,test_trials);

    % build the model
    model = fitcdiscr(mat(train_trials,:),labels(train_trials),...
        'discrimType','diagLinear');

    % test the model
    pred_labels = predict(model,mat(test_trials,:));

    % calculate the precision of the predictions
    cmp = strcmp(labels(test_trials),pred_labels);
    perf(icv) = sum(cmp)/length(cmp)*100;

end

% average over all folds
perf = mean(perf);

end


% ----------------------------------------- classify
function perf = classify(mat_train,labels_train, mat_test,labels_test)

ntrials = length(labels_train);
all_trials = reshape(1:ntrials, [], 3)';
k = ntrials/3/8;

for icv = 1:8
    test_trials = reshape(all_trials(:, (icv-1)*k+1:(icv-1)*k+k), 1, []);
    train_trials = setdiff(all_trials,test_trials);

    % build the model
    model = fitcdiscr(mat_train(train_trials,:),labels_train(train_trials),...
        'discrimType','diagLinear');

    % test the model
    pred_labels = predict(model,mat_test);

    % calculate the precision of the predictions
    cmp = strcmp(labels_test,pred_labels);
    perf(icv) = sum(cmp)/length(cmp)*100;

end

% average over all folds
perf = mean(perf);

end


















