% single neuron classification performance plus bootstrap
% response to eLife's revision
% here, in each bootstrap resample, a set of trials is selected, trained in
% observation and tested in observation (o2o), and also trained in
% execution and tested in observation (e2o). The result should allow a
% better statistic for finding matching and nonmathcing bins (fig.5 in the
% submitted version)
%
% 2022-06-15
% Mohammad Shams
% m.shams.ahmar@gmail.com

tic

clear

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

nneurons = length(IDs_match_crit);

% set number of bins per segment
nbins = 4;


% for each neuron
for in = 1:nneurons
    
    % create exe sets (for train and verification)
    twist_exe{in,1} = bintime(FR_twist{in,2},nbins);
    shift_exe{in,1} = bintime(FR_shift{in,2},nbins);
    lift_exe{in,1} = bintime(FR_lift{in,2},nbins);
    
    
    % create obs sets (for test)
    twist_obs{in,1} = bintime(FR_twist{in,1},nbins);
    shift_obs{in,1} = bintime(FR_shift{in,1},nbins);
    lift_obs{in,1} = bintime(FR_lift{in,1},nbins);
    
end

for in = 1:nneurons
        
    % find the smallest number of trials across action types and tasks
    ntrial_min = min([size(twist_exe{in,1},1), size(shift_exe{in,1},1), size(lift_exe{in,1},1),...
        size(twist_obs{in,1},1),size(shift_obs{in,1},1),size(lift_obs{in,1},1)]);
    % adjust the minimum number of trials to a factor of eight
    ntrial(in) = floor(ntrial_min/8) * 8;

    % create train labels
    labels_train{in} = [repmat({'twist'},ntrial(in),1);...
        repmat({'shift'},ntrial(in),1);...
        repmat({'lift'},ntrial(in),1)];
    
    % create test labels
    labels_test{in} = [repmat({'twist'},ntrial(in),1);...
        repmat({'shift'},ntrial(in),1);...
        repmat({'lift'},ntrial(in),1)];

end


% classify
% randomly select ntrial from each manipulation per neuron in execution task
parfor in = 1:nneurons
    
    disp([in nneurons])
    
    [verif{in,1}, test{in,1},...
    CM_verif{in,1}, CM_test{in,1}] = ...
        ...
        run_class(twist_exe{in}, shift_exe{in}, lift_exe{in},...
        twist_obs{in}, shift_obs{in}, lift_obs{in},...
        ntrial(in), labels_train{in}, labels_test{in});
    
end

% save results
save('xx_108_4_single_o2o_perf.mat', 'verif');
save('xx_108_4_single_e2o_perf.mat', 'test');
save('xx_108_4_single_o2o_CM.mat', 'CM_verif');
save('xx_108_4_single_e2o_CM.mat', 'CM_test');

toc

%#########################################################################################
% FUNCTIONS
%#########################################################################################
% ----------------------------------------- create classifier input

function FR_binned_mat = bintime(FR,nbins)


% extract number of trials and segments
[ntrials, nsegs]= size(FR);


% for each element in the input cell (FR)
for itrial = 1:ntrials
    for iseg = 1:nsegs
        
        % extract the spike train of in a given trial and segment
        spike_train = FR{itrial,iseg};
        
        
        % make sure the spike train is at least "nbins"+1 samples long
        % for a reasonable binning
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

%#########################################################################################

function [verif,test, CM_verif,CM_test] = ...
    ...
    run_class(twist_exe, shift_exe, lift_exe,...
    twist_obs, shift_obs, lift_obs,...
    ntrial, labels_train, labels_test)

nrep = 1000;

for irep = 1:nrep
 
    % in execution task
    % randomly sample 'ntrial' unique trials from each action type
    sampletrials1 = datasample(1:size(twist_exe),ntrial,'rep',true);
    sampletrials2 = datasample(1:size(shift_exe),ntrial,'rep',true);
    sampletrials3 = datasample(1:size(lift_exe),ntrial,'rep',true);

    sample_twist_exe = twist_exe(sampletrials1,:);
    sample_shift_exe = shift_exe(sampletrials2,:);
    sample_lift_exe  = lift_exe(sampletrials3,:);
    
    % in observation task
    % randomly sample 'ntrial' unique trials from each action type
    sampletrials1 = datasample(1:size(twist_obs),ntrial,'rep',true);
    sampletrials2 = datasample(1:size(shift_obs),ntrial,'rep',true);
    sampletrials3 = datasample(1:size(lift_obs),ntrial,'rep',true); 

    sample_twist_obs = twist_obs(sampletrials1,:);
    sample_shift_obs = shift_obs(sampletrials2,:);
    sample_lift_obs  = lift_obs(sampletrials3,:);
    
        
    % concatenate trials of all the three action types
    mat_exe = [sample_twist_exe; sample_shift_exe; sample_lift_exe];
    mat_obs = [sample_twist_obs; sample_shift_obs; sample_lift_obs];
      
    % count number of time bins
    nallbins = size(mat_exe,2);

    % for each time bin
    for ibin = 1:24

        % train and test with the exe trials (verify the model)
        [verif(irep,ibin), CM_verif{irep,ibin}]...
            = cross_validate(mat_exe(:,ibin), labels_train);

        % train with exe trials and test with obs trails (test the model)
        [test(irep,ibin), CM_test{irep,ibin}]...
            = classify(mat_obs(:,ibin), labels_train,...
            mat_exe(:,ibin), labels_test);

    end
    
end

end

%#########################################################################################
% ----------------------------------------- verify (cross validate)

function [perf, CM] = cross_validate(mat, labels)

ntrials = length(labels);
all_trials = reshape(1:ntrials, [], 3)';
k = ntrials/3/8;

for icv = 1:8
    test_trials = reshape(all_trials(:, (icv-1)*k+1:(icv-1)*k+k), 1, []);   
    train_trials = setdiff(all_trials, test_trials);
    
    % build the model
    model = fitcdiscr(mat(train_trials,:), labels(train_trials),...
        'discrimType','diagLinear');
    
    % test the model
    pred_labels = predict(model,mat(test_trials,:));
    
    % calculate the accuracy of the predictions
    cmp = strcmp(labels(test_trials), pred_labels);
    perf(icv) = sum(cmp)/length(cmp)*100;
    
    % calculate the confusion matrix
    CM(:,:,icv) = confusionmat(labels(test_trials), pred_labels);
end

% average the accuracy across folds
perf = mean(perf);

% average the confusion matrix across folds
CM = mean(CM,3);

end

%#########################################################################################
% ----------------------------------------- test
function [perf, CM] = classify(mat_train,labels_train, mat_test,labels_test)

ntrials = length(labels_train);
all_trials = reshape(1:ntrials, [], 3)';
k = ntrials/3/8;

for icv = 1:8
    test_trials = reshape(all_trials(:, (icv-1)*k+1:(icv-1)*k+k), 1, []);   
    train_trials = setdiff(all_trials, test_trials);
    
    % build the model
    model = fitcdiscr(mat_train(train_trials,:), labels_train(train_trials),...
        'discrimType','diagLinear');

    % test the model
    pred_labels = predict(model, mat_test(test_trials,:));

    % calculate the precision of the predictions
    cmp = strcmp(labels_test(test_trials), pred_labels);
    perf(icv) = sum(cmp)/length(cmp)*100;

    % calculate the confusion matrix
    CM(:,:,icv) = confusionmat(labels_test(test_trials), pred_labels);

end

% average across folds
perf = mean(perf);

% average the confusion matrix across folds
CM = mean(CM,3);

end















