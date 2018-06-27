%%%%%%%%%% naiveSLam: Mono vision Odometry %%%%%%%%%%%
% Author: zqs
% Mail: zqsh19970218@sjtu.edu.cn

%% Clearing workspaces, Closing windows & Clearing commandwindow
clear all;
close all;
clc;
%% initialize variables
format shortG
% warning off
dataset = 0; % 0: KITTI, 1: others.//todo
last_frame = 1000;
tic
%rng(1);
global dataBaseSize;

%% set up relevant paths

kitti_path = 'G:\data_odometry_gray\dataset\sequences';

if exist(kitti_path) == 7
    videoName = 'kitti';
    run kittiParameters
    ground_truth = load([kitti_path '\pose\00.txt']);
    ground_truth = ground_truth(:, [end-8 end]);
else
    assert(false);
end
v = VideoWriter(videoName,'MPEG-4');
v.FrameRate = 5;
open(v)
%tmp
K = K1;
%% bootstrap / initialization of keypoint matching between adjacent frames
 fprintf('\n\nProcessing frame %d\n=====================\n', 1);
[firstKeypoints,firstLandmarks] = autoMonoInitialization(dataset,K,eye(3,4));
prevState = [firstKeypoints;firstLandmarks(1:3,:)];
prevImage = imread([kitti_path '/00/image_0/' sprintf('%06d.png',1)]);

%% Continuous operation
dataBase = cell(3,dataBaseSize);
for ii = 2:last_frame
    fprintf('\n\nProcessing frame %d\n=====================\n', ii);
    if dataset == 0
        currImage = imread([kitti_path '/00/image_0/' sprintf('%06d.png',ii)]);
        [currState, currPose, dataBase] = processFrame(prevState, prevImage, currImage, K, dataBase);
    else
        assert(false);
    end

    %check to see if we're close and if so, re initialize
    if(isempty(currState))
        disp('Lost, will have to reinitialize from last pose')
        if dataset == 0
            twoImagesAgo = imread([kitti_path '/00/image_0/' sprintf('%06d.png',ii-2)]);
        else
            assert(false);
        end

        emptyColumns = find(cellfun(@isempty,dataBase(1,:)));
        if(isempty(emptyColumns))
            idx = dataBaseSize-1;
        else
            idx = min(emptyColumns) - 1;
        end

        currPose = reshape(dataBase{3,idx},3,4);%two poses ago
        [firstKeypoints,firstLandmarks] = monoInitialization(twoImagesAgo,currImage,K,currPose);
        currState = [firstKeypoints;firstLandmarks(1:3,:)];
        dataBase = cell(3,dataBaseSize);
    end

    R_C_W = currPose(:,1:3);
    t_C_W = currPose(:,4);

    prevState = currState;
    prevImage = currImage;

    if ii> 5
    run plotAll
    end

    % Makes sure that plots refresh.
    pause(0.01);

end

toc
close(v)
