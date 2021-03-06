function s_alc_dtiInit
%
% This function loads a series of subjects and performs dtiInit for each
%

datapath = '/media/lcne/matproc';

subjects = {'alc219','alc220','alc245', ...
            'alc257','alc262','alc269','alc274', ...
            'alc275','alc276','alc277','alc278', ...
            'alc280','alc281','alc282','alc283', ...
            'alc284','alc286','alc289','alc290', ...
            'alc291','alc293','alc294'};       
%where is raw alc187?

for isubj = 1:length(subjects)
    % Build the file names for dwi, bvecs/bvals
    %dwiPath = dir(fullfile(datapath,subjects{iSbj},'*DTI*'));
    dwiPath = fullfile(datapath,subjects{isubj},'raw');
    dwiFile = dir(fullfile(dwiPath,'*.nii.gz'));
    dwiFile = fullfile(dwiPath, dwiFile.name);
    %dwiBvec = [dwiFile(1:end-6),'bvec'];
    %dwiBval = [dwiFile(1:end-6),'bval'];
    t1Path = dir(fullfile(datapath,subjects{isubj},'*_t1_acpc.nii.gz'));
    t1File = fullfile(datapath, subjects{isubj}, t1Path.name);

    dwiParams = dtiInitParams;
    dwiParams.clobber = true;
    dwiParams.dwOutMm = [2, 2, 2];
    dwiParams.phaseEncodeDir = 2;
    dtiInit(dwiFile, t1File, dwiParams);
end