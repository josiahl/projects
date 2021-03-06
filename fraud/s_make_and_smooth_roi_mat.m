function s_make_and_smooth_roi
%
% This script loads a NIFTI ROI, tranforms it into a mat ROI and 
% Applies some operations to it, such as smoothing, dilation and 
% removal of satellites.
%
% Copyright Franco Pestilli (c) Stanford University, 2014
datapath = '/media/storg/matlab_proc';
subjects = {'ab071412_mrdiff','bc050913_mrdiff','bk032113_mrdiff','bk053012_mrdiff','ch101612_mrdiff', ...
            'cs050813_mrdiff','dc050213_mrdiff','dp092612_mrdiff','ds080712_mrdiff','ec081912_mrdiff', ...
            'en062813_mrdiff','fg092712_mrdiff','gr051513_mrdiff','hg101012_mrdiff','hm062513_mrdiff', ...
            'jh042913_mrdiff','jl071912_mrdiff','jo081312_mrdiff','jt062413_mrdiff','jw072512_mrdiff', ...
            'jw101812_mrdiff','kr030113_mrdiff','lc052213_mrdiff','lf052813_mrdiff','lw061713_mrdiff', ...
            'md072512_mrdiff','mk021913_mrdiff','ml061013_mrdiff','mn052313_mrdiff','ms082112_mrdiff', ...
            'na060213_mrdiff','np072412_mrdiff','pf020113_mrdiff','pl061413_mrdiff','ps022013_mrdiff', ...
            'pw060713_mrdiff','pw061113_mrdiff','ra053013_mrdiff','rb073112_mrdiff','rb082212_mrdiff', ...
            'sd040313_mrdiff','sh010813_mrdiff','sl080912_mrdiff','sn061213_mrdiff','sp061313_mrdiff', ...
            'tr101312_mrdiff','tw062113_mrdiff','vv060313_mrdiff','wb071812_mrdiff'};

for iSubj = 1:length(subjects)
    roiPath = fullfile(datapath, subjects{iSubj}, 'ROIs');
    roi = dir(fullfile(roiPath,'lh_antins_short_merge.mat'));
    oldRoi = roi.name;
    oldRoiPath = fullfile(roiPath, oldRoi)
    outRoi = [roiPath '/lh_antins_short_merge_fds.mat'];
    smoothKernel = 0; % size of the 3D smoothing Kernel in mm
    %operations   = ['fillholes', 'dilate', 'removesat']; 
    operations   = [1, 1, 1]; 

    % fillholes = fill any hole in the ROI. Pass '' to not apply this
    %             operation
    % dilate     = expand the ROI in 3D. Pass '' to not apply this
    %             operation
    % removesat  = remove any voxel disconnected from the rest of the voxels. 
    %              Pass '' to not apply this operation
    oldRoiLoad = dtiReadRoi(oldRoiPath);
    newRoi = dtiRoiClean(oldRoiLoad, smoothKernel, operations);
    dtiWriteRoi(newRoi, outRoi);
end