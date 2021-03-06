%life lesion analysis presma-stn lh/rh no WBC

%set up script for LiFE
%
%MAKE SURE TO EDIT HEMISPHERE
        
baseDir = '/media/storg/matproc/';
subjects = {'lf052813','sn061213','tw062113'};
        
for isubj = 1:length(subjects)
    %% (0) Set up paths and filenames
    % Base subject folder
    subjectDir    = [subjects{isubj}];
    subjectFolder = fullfile(baseDir, subjectDir);
    
    % make life folder if doesn't exist
    lifeFolder    = fullfile(subjectFolder, '/dti96trilin/fibers/life/presmastn/lh_nowbc');
        if ~exist(lifeFolder,'dir'); mkdir(lifeFolder); end 
        
    % T1 high resolution anatomy
    subjectRefImg = [subjects{isubj} '_t1_acpc.nii.gz'];
    sub_t1w_acpc  = fullfile(subjectFolder, subjectRefImg);
    
    % Fibers and tracts
    fibersFolder  = fullfile(baseDir, subjectDir, '/dti96trilin/fibers/mrtrix');
    sub_wbc       = fullfile(fibersFolder, 'lmax10_wbc.mat');
    sub_roi2roi_track = fullfile(fibersFolder, 'clean_lh_presma_stn.mat');
       
    % ROIs and WM masks
    roiFolder        = fullfile(baseDir, subjectDir, '/ROIs');
    sub_wmmask_track = fullfile(roiFolder, 'lh_wmmask_clip_presmastn.nii.gz');
    %sub_roi1 = fullfile(roiFolder, 'rh_frontorb_a2009s_fd.nii.gz');
    %sub_roi2 = fullfile(roiFolder, 'rh_shortins_a2009s_fd.nii.gz');
    
    % DWI files
    fullsubjectAcqName = dir(fullfile(subjectFolder, '*.bvals'));
    [~, subAcqName,~]  = fileparts(fullsubjectAcqName.name);
    sub_dwi_bvec       = fullfile(subjectFolder, [subAcqName, '.bvecs']);
    sub_dwi_bval       = fullfile(subjectFolder, [subAcqName, '.bvals']);
    sub_dwi_processed  = fullfile(subjectFolder, [subAcqName, '.nii.gz']);
    
    %% (1) Find fibers in WB-connectome between ROI1 and ROI2
    % Find the fascicles in the connectome that touch both ROIs.
    %roi1 = dtiImportRoiFromNifti(sub_roi1,'ROI1');
    %roi2 = dtiImportRoiFromNifti(sub_roi2,'ROI2');
    %roi_combined = dtiNewRoi('combined_roi');
    %roi_combined.coords   = [roi1.coords;roi2.coords];
    wbc          = fgRead(sub_wbc);
      
    tract = fgRead(sub_roi2roi_track);

    TOI = tract;
    nTOIfibers = fefgGet(TOI,'nfibers');
    
    % (5) Clip the connectome to the WM-mask
    fprintf('[%s] Intersecting WB connectome with WM mask', mfilename)
    wm  = dtiImportRoiFromNifti(sub_wmmask_track,'WM');
    wbc = dtiIntersectFibersWithRoi([], 'and', [], wm, wbc);
    fprintf('[%s] Clipping WB connectome to WM mask', mfilename)
    wbc = feClipFibersToVolume(wbc,wm.coords,.83);
    % Show the ROI to catch any potential problems:
    % roi = dtiCreateRoiFromFibers(fg);toc
    % plot3(roi.coords(:,1),roi.coords(:,2),roi.coords(:,3),'g.');
    
    % (6) Merge the new TOI with the clipped WB-connectome
    nWBCfibers = fefgGet(wbc,'nfibers');
    wbcMerged  = fgMerge(wbc,TOI,'WBC and TOI');
    
    % (7) Build the LiFE model
    fe = feConnectomeInit(sub_dwi_processed, ...
        wbcMerged,'WBC_TOI', ...
        fibersFolder, ...
        sub_dwi_processed, ...
        sub_t1w_acpc);
    
    % (8) Fit the LiFE model
    fit = feFitModel(feGet(fe,'mfiber'), ...
                     feGet(fe,'dsigdemeaned'), ...
                     'bbnnls');
    fe  = feSet(fe,'fit',fit);
    clear fit
    feConnectomeSave(fe);
    
    % (9) Perform a virtual lesion (note the indices of the fibers to tract are
    %     number of fibers in the tract to lesion are nFibers_in_clipped_WB_connectome+1:end
    indices2toi = (nWBCfibers+1) : (nWBCfibers+nTOIfibers);
    
    % set up display information, we want to show plots of the results:
    display.tract         = true;
    display.distributions = true;
    display.evidence      = true;
    [se, fig] = feVirtualLesion(fe, indices2toi', display, false);
    
    % saves figures for subject
    for ifig = 1:length(fig)
        feSavefig(fig(ifig).h, ...
            'figType', fig(ifig).type, ...
            'figDir', fullfile(lifeFolder), ...
            'figName',fig(ifig).name)
    end
    
    % saves strength of evidence for subject
    subjectSeName = fullfile(lifeFolder,[subjects{isubj} '_lh_se_nowbc.mat']);
    save(subjectSeName, 'se');
    
    % close figures for subject
    close all
    
    % clear variables to save RAM
    clear se fe wbc TOI
    
  
end

return