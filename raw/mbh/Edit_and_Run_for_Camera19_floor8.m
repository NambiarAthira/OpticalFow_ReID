%% Edit and run for each camera separatly
% 1) Take one snapshot from camera
CameraName = 'IP19'
addpath(genpath('/home/dario/Desktop/Dropbox/Dario/Work/Archiveofunusedcode/camnet'))

%%

clear CameraPoints CameraImage
if strcmp(CameraName,'IP19')
    CameraImagePath = 'I03006.jpeg';
    display('Camera 19, in the 8th floor, looking at entrance of snacks room')
    CameraPoints = [
        -5.773  -1.904
        -5.021  -2.019
        -5.021  -1.979
        -4.191  -1.979
        -4.191  -1.904
        0.225   -1.904
        1.903   -1.904
        1.866   -1.8
        1.94    -1.011
        -2.058  -0.222
    ];
end

%-------------------------------------------------------------------------%
CameraImage=imread(CameraImagePath);
figure(2), imshow(CameraImage)
% Choose from map the points where you're going to click, and fill in
% CameraPoints matrix
drawCorridor8thFloor(),
% drawVascoGamaFloor(),
title('Choose from map the points where youre going to click, and fill in CameraPoints matrix')
    
%% Save homography
% CameraImage = imread('Laser_blueprint_overlay_small.png'); % DEBUG, COMMENT
[Homography ginputPoints] = computeHomography(CameraPoints, CameraImage)
save([CameraName 'homography.dat'], 'Homography', '-ASCII', '-DOUBLE'); 
eval([CameraName 'points = CameraPoints']) 
eval([CameraName 'clickedPoints = ginputPoints']) 
save([CameraName 'points.mat'], [CameraName 'points'], [CameraName 'clickedPoints'])

fid = fopen([CameraName 'homography.txt'],'w');
fprintf(fid,['h11 = ' num2str(Homography(1,1)) '\n']);
fprintf(fid,['h12 = ' num2str(Homography(1,2)) '\n']);
fprintf(fid,['h13 = ' num2str(Homography(1,3)) '\n']);
fprintf(fid,['h21 = ' num2str(Homography(2,1)) '\n']);
fprintf(fid,['h22 = ' num2str(Homography(2,2)) '\n']);
fprintf(fid,['h23 = ' num2str(Homography(2,3)) '\n']);
fprintf(fid,['h31 = ' num2str(Homography(3,1)) '\n']);
fprintf(fid,['h32 = ' num2str(Homography(3,2)) '\n']);
fprintf(fid,['h33 = ' num2str(Homography(3,3)) '\n']);
fclose(fid);

