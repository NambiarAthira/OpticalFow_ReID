%% author: Athira
% date: 16/7/2015
%% To convert a set of frames to video file

% Select the frames
cd('testcams\person8')
workingDir=pwd;
imageNames = dir(fullfile(workingDir,'*.jpeg'));
imageNames = {imageNames.name}';

% Create New Video with the Image Sequence
outputVideo = VideoWriter(fullfile(workingDir,'testwalking8.avi'));
outputVideo.FrameRate = 5;
open(outputVideo)

% Loop through the image sequence, load each image, and then write it to the video.
for ii = 1:length(imageNames)
   img = imread(fullfile(workingDir,imageNames{ii}));
   writeVideo(outputVideo,img)
end
close(outputVideo) % finalise the video file

% View the final video
walkingAvi = VideoReader(fullfile(workingDir,'testwalking8.avi'))
implay('testwalking8.avi')