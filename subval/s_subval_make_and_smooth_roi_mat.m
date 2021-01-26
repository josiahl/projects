function s_subval_make_and_smooth_roi_mat
%
% This script loads a NIFTI ROI, tranforms it into a mat ROI and 
% Applies some operations to it, such as smoothing, dilation and 
% removal of satellites.
%
% Copyright Franco Pestilli (c) Stanford University, 2014
datapath  = '/media/lcne/matproc/subval';

subjects = {'SV_002','SV_003','SV_005','SV_007','SV_009','SV_015','SV_016', ...
            'SV_020','SV_021','SV_025','SV_027','SV_032','SV_034','SV_035', ...
            'SV_036','SV_038','SV_041','SV_045','SV_047','SV_048','SV_061', ...
            'SV_062','SV_064','SV_065','SV_066','SV_068','SV_071','SV_073', ...
            'SV_081','SV_082','SV_086','SV_088','SV_090','SV_093','SV_096', ...
            'SV_100','SV_101','SV_103','SV_106','SV_107','SV_109','SV_111', ...
            'SV_115','SV_116','SV_119','SV_120','SV_123','SV_128','SV_129', ...
            'SV_131','SV_136','SV_139','SV_140','SV_141','SV_142','SV_145', ...
            'SV_146','SV_147','SV_149','SV_150','SV_151','SV_152','SV_153', ...
            'SV_157','SV_158','SV_161','SV_162','SV_163','SV_165','SV_166'};
        
rois = {'rh_amyg_a2009s','lh_amyg_a2009s', ...
        'rh_nacc_aseg','lh_nacc_aseg', ...
        'rh_frontorb_a2009s','lh_frontorb_a2009s', ...
        'rh_frontinfang_a2009s','lh_frontinfang_a2009s', ...
        'rh_antins_a2009s','lh_antins_a2009s', ...
        'rh_shortins_a2009s','lh_shortins_a2009s', ...
        'rh_nacc_aseg','lh_nacc_aseg', ...
        'rh_latorb_a2009s','lh_latorb_a2009s', ...
        'rh_wmmask_fs','lh_wmmask_fs', ...
        'rh_supfront_a2009s','lh_supfront_a2009s', ...
        'rh_frontmidlat_a2009s','lh_frontmidlat_a2009s', ...
        'rh_ventraldc_aseg','lh_ventraldc_aseg'};
        
for isubj = 1:length(subjects)
    roiPath = fullfile(datapath, subjects{isubj}, 'ROIs');
    for iroi = 1:length(rois)
        roi = fullfile(roiPath, [rois{iroi} '.mat']);
        outRoi = fullfile(roiPath, [rois{iroi} '_fd.mat']);
        smoothKernel = 0; % size of the 3D smoothing Kernel in mm
        %operations   = ['fillholes', 'dilate', 'removesat']; 
        operations   = [1, 1, 0]; 

        % fillholes = fill any hole in the ROI. Pass '' to not apply this
        %             operation
        % dilate     = expand the ROI in 3D. Pass '' to not apply this
        %             operation
        % removesat  = remove any voxel disconnected from the rest of the voxels. 
        %              Pass '' to not apply this operation
    
        oldRoiLoad = dtiReadRoi(roi);
        newRoi = dtiRoiClean(oldRoiLoad, smoothKernel, operations);
        dtiWriteRoi(newRoi, outRoi);
    end
end