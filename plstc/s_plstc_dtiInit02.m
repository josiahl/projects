function s_plstc_dtiInit02
%
% This function loads a series of subjects and performs dtiInit for each
%

datapath = '/media/lcne/matproc';

subjects = {'yw083014_2'};

for isubj = 1:length(subjects)
    % Build the file names for dwi, bvecs/bvals, t1
    dwiPath = fullfile(datapath, subjects{isubj},'raw');
    dwiFile = fullfile(dwiPath, [subjects{isubj} '.nii.gz']);
    t1File = fullfile(datapath, subjects{isubj}, [subjects{isubj} '_t1_acpc.nii.gz']);

    dwiParams = dtiInitParams;
    dwiParams.clobber = true;
    %dwiParams.eddyCorrect = 0;
    %dwiParams.flipLrApFlag = true;
    dwiParams.dwOutMm = [2, 2, 2];
    %dwiParams.phaseEncodeDir = 1;
    %dwiParams.rotateBvecsWithRx = true;
    dwiParams.rotateBvecsWithCanXform = true;
    dtiInit(dwiFile, t1File, dwiParams);
end