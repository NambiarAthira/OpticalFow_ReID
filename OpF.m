
%% Author: Athira 
% Date: 24/7/2015
clc;
close all;
clear all;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is an adaptation of the one found in:
% http://www.mathworks.com/matlabcentral/fileexchange/44400-tutorial-on-real-time-optical-flow
% version 1.01
% Authors: Stefan M. Karlsson, Josef Bigun

mode=2; 
% addpath of the functions 
dirData = 'C:\Users\Athira Nambiar\Dropbox\2015\opticFlow\opticflow\code'; 
cd(dirData)
addpath(genpath(dirData))

%%%%% argument 'movieType' %%%%%%%%
switch mode
    
    % Computer vision toolbox for optic flow; motion boundaries
    case 1 
        cd('OpticalFlowWithComputerVisionToolbox\OpticalFlowWithComputerVisionToolbox');
        movieType = 'walking2.avi';
    
        %%%%% argument 'method'      %%%%%%%%
%             method = 'Horn-Schunck';
              method = 'Lucas-Kanade';

        %%% see documentation on "vision.OpticalFlow" for a large amount of tunable settings
        opticalFlow = vision.OpticalFlow('Method',method,'OutputValue','Horizontal and vertical components in complex form');

        %scale the flow for visualization. Different methods and settings puts the
        %flow vectors in different ranges. Change if you see no or little color
        sc = 1; 
        [curIm, V] = myvidProcessingToolbox(movieType, opticalFlow,sc);
        grad=real(gradient(V));
        break;
      
     % Dense Optic flow code from Stefan; flow1   
      case 2
          cd('tutorialOpticalFlowPart1_v1.04_release\tutorialOpticalFlowPart1_v1.04_release')
          in.movieType = 'walking2.avi';
          in.method = 'flow1';
          in.tIntegration = 0.25;
          in.sc=10;

%           disp('Shut down figure to stop.');
          [HOF,MBH,U,V,rect,upper,lower] = myvidProcessing(in);
        
end
close all
%% Get the count of the gait cycle 
    % Selected Areas 2 and 3
     cycle1= [];
     cycle2=[];
     gaitCount1=HOF(:,9:16)  % crop the selected area 2 and 3 HOF's from the polar cells of 
                             % Selected area 1 to 8,  conributing thr whole HOF.
     gaitCount2=HOF(:,17:24)
     x=1:1:size(gaitCount1,2)
    
    % HOF's obtained for consecutive frames for right leg
     for i=1:size(gaitCount1,1)
         y=HOF(i,9:16);
%          figure(i);plot(y);
%          xlabel('bins in HOF on SA2 and SA3') % 8 bins for SA2 and the next 8 bins are for SA3.
%          ylabel('HOF values')
         output=smooth(y,'moving'); % 'moving': Moving average (default). A lowpass filter with 
                                    % filter coefficients equal to the reciprocal of the span. 
%          hold on,plot(output,'r--')
         [ymax,imax,ymin,imin] = extrema(output);
%          hold on
%          plot(x(imax),ymax,'m*',x(imin),ymin,'g*')
             %Select the maximum value/peak value movements
                 movement=[i ymax(find(max(imax)))] % right leg movement indicator at ith frame
                 cycle1=[cycle1; movement]  % combine movements to make the periodic cycle of motion   
     end
      cycle=cycle1
      cycle1=(cycle1(:,2)/sum(cycle1(:,2)))
      close all
      
     % HOF's obtained for consecutive frames for left leg
      x=1:1:size(gaitCount2,2)
     for i=1:size(gaitCount2,1)
         y=HOF(i,17:24);
%          figure(i);plot(y);
%          xlabel('bins in HOF on SA2 and SA3') % 8 bins for SA2 and the next 8 bins are for SA3.
%          ylabel('HOF values')
         output=smooth(y,'moving'); % 'moving': Moving average (default). A lowpass filter with 
                                    % filter coefficients equal to the reciprocal of the span. 
%          hold on,plot(output,'r--')
         [ymax,imax,ymin,imin] = extrema(output);
%          hold on
%          plot(x(imax),ymax,'m*',x(imin),ymin,'g*')
             %Select the maximum value/peak value movements
                 movement=[i ymax(find(max(imax)))] % right leg movement indicator at ith frame
                 cycle2=[cycle2; movement]  % combine movements to make the periodic cycle of motion   
      end
      cycle2=(cycle2(:,2)/sum(cycle2(:,2)))
      close all
    %% plot the optic flow pattern for both legs
    close all;
    figure;
    colormap(gray)
    subplot(1,2,1)
    imagesc(cycle1);
    title('Flow pattern of right leg')
    xlabel('flow magnitude')
    ylabel('<---- time (frame no.)')
    colorbar
    subplot(1,2,2)
    imagesc(cycle2)
    title('Flow pattern of left leg')
    xlabel('flow magnitude')
    ylabel('<---- time (frame no.)')
    colorbar
    set(gcf,'color','w');

     %% Estimation of the gait period
      figure;plot(cycle(:,1),cycle(:,2))
      output2=smooth(cycle(:,2),'sgolay');
      hold on; plot(output2,'g--','LineWidth',2.5);
      [ymax2,imax2,ymin2,imin2] = extrema(output2);
      hold on
      plot(cycle(imax2),ymax2,'m*',cycle(imin2),ymin2,'c*')
      Sorted_max=sort(imax2);
      gaitCycle_pts=sort(imax2);
      title('HOF feature of leg movement over frames')
      xlabel('time(frame no.)')
      ylabel('HOF\_max (peak value)')
    
