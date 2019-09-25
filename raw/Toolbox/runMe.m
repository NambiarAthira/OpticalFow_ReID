% Authors:
% Stefan M. Karlsson, Josef Bigun

% This function is an adaptation of the one found in:
% http://www.mathworks.com/matlabcentral/fileexchange/44400-tutorial-on-real-time-optical-flow
% version 1.01

% Instead of being a tutorial, this is an illustration of the built in
% optical flow in the computer vision toolbox. Feel free to play around
% with the parameters, and do compare it with the flow output from the
% above matlab file exchange submission.

% This script calls the function 'vidProcessing'. vidProcessing is our main
% entry point for all video processing. Once its called, a
% figure will open and display the video together the motion estimate,
% encoded as color. see the attached file for explanation of the visualization:

% imshow('motionColorCoding.jpg')

% Once you have finished viewing the results of the video processing,
% simply close the window to return back from the function. 

%%%%% argument 'movieType' %%%%%%%%
% This indicates the source of the video to process. You may choose from a
% synthetic video sequence(created on the fly), or load a video through a
% video file (such as 'LipVid.avi'), or to capture video from a connected
% camera(requires the image acquisition toolbox). 
%  movieType = 'lipVid.avi'; %assumes a file 'LipVid.avi' in current folder
% Convert2Video; % Convert a set of frames to a video
 movieType = 'walking2.avi';
%  movieType = 'camera'; %assumes a camera available in the system.
%  movieType = 'camera2'; %for any integer, use when choosing between several cameras
%  movieType = 'synthetic'; %generate synthetic video
    
%%%%% argument 'method'      %%%%%%%%
%%%%%  optical flow method.  %%%%%%%
%%
% 
%   for x = 1:10
%       disp(x)
%   end
% 
%    method = 'Horn-Schunck';
     method = 'Lucas-Kanade';


%%% see documentation on "vision.OpticalFlow" for a large amount of tunable
%%% settings
opticalFlow = vision.OpticalFlow('Method',method,'OutputValue','Horizontal and vertical components in complex form');


%scale the flow for visualization. Different methods and settings puts the
%flow vectors in different ranges. Change if you see no or little color
sc = 1; 

disp('Shut down figure to stop.');
[curIm, V] = vidProcessingToolbox(movieType, opticalFlow,sc);
u = real(V);
v = imag(V);


figure;
subplot(2,2,1);imshow(curIm); title('original Image')
subplot(2,2,2);imshow(V); title('Optical flow estimate')
% grad_u=gradient(u);
% grad_v=gradient(v);
% subplot(2,2,3);imshow(grad_u); title('gradient magnitude of horizontal flow field (Ix)')
% subplot(2,2,4);imshow(grad_v); title('gradient magnitude of vertical flow field (Iy)')
% 
% 






