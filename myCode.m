%% Author: Athira 
% Date: 24/7/2015
clc;
close all;
clear all;
%% Authors:
% Stefan M. Karlsson, Josef Bigun
% This function is an adaptation of the one found in:
% http://www.mathworks.com/matlabcentral/fileexchange/44400-tutorial-on-real-time-optical-flow
% version 1.01
mode=2;
dirData = 'C:\Users\Athira Nambiar\Desktop\opticflow\code'; 
addpath(genpath(dirData))

%%%%% argument 'movieType' %%%%%%%%
switch mode
    % Computer vision toolbox for optic flow; motion boundaries
    case 1 
        cd('OpticalFlowWithComputerVisionToolbox\OpticalFlowWithComputerVisionToolbox');
        movieType = 'walking2.avi';
    
        %%%%% argument 'method'      %%%%%%%%
%            method = 'Horn-Schunck';
             method = 'Lucas-Kanade';

        %%% see documentation on "vision.OpticalFlow" for a large amount of tunable settings
        opticalFlow = vision.OpticalFlow('Method',method,'OutputValue','Horizontal and vertical components in complex form');

        %scale the flow for visualization. Different methods and settings puts the
        %flow vectors in different ranges. Change if you see no or little color
        sc = 1; 
        [curIm, V] = myvidProcessingToolbox(movieType, opticalFlow,sc);
        grad=real(gradient(V));
        figure;imshow(grad);
        morphoOperations; % Conduct rmorphological operations on the binary image and
                          %finally plot the BB above the moving objects (in the original image).
   
%         figure;imshow(BW);hold on;
%         plot(centroids(:,1), centroids(:,2), 'b*')
      case 2
          % Optic flow code from Stefan; flow1
          cd('tutorialOpticalFlowPart1_v1.04_release\tutorialOpticalFlowPart1_v1.04_release')
          in.movieType = 'walking2.avi';
%           in.movieType = 'testwalking8.avi';
          in.method = 'flow1';
          in.tIntegration = 0.25;
          in.sc=10;

          disp('Shut down figure to stop.');
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
     for i=1:size(gaitCount1,1)
         y=HOF(i,9:16);
         figure(i);plot(y);
         xlabel('bins in HOF on SA2 and SA3') % 8 bins for SA2 and the next 8 bins are for SA3.
         ylabel('HOF values')
         output=smooth(y,'moving'); % 'moving': Moving average (default). A lowpass filter with 
                                    % filter coefficients equal to the reciprocal of the span. 
         hold on,plot(output,'r--')
         [ymax,imax,ymin,imin] = extrema(output);
         hold on
         plot(x(imax),ymax,'m*',x(imin),ymin,'g*')
             %Select the maximum value/peak value movements
                 movement=[i ymax(find(max(imax)))] % right leg movement indicator at ith frame
                 cycle1=[cycle1; movement]  % combine movements to make the periodic cycle of motion   
     end
      cycle=cycle1
      cycle1=(cycle1(:,2)/sum(cycle1(:,2)))
%       figure;plot(cycle(:,1),cycle(:,2))
%       output2=smooth(cycle(:,2),'sgolay');
%       hold on; plot(output2,'g--','LineWidth',2.5);
%       [ymax2,imax2,ymin2,imin2] = extrema(output2);
%       hold on
%       plot(cycle(imax2),ymax2,'m*',cycle(imin2),ymin2,'c*')
%       Sorted_max=sort(imax2);
%       gaitCycle_pts=sort(imax2);
%       title('HOF feature of leg movement over frames')
%       xlabel('time(frame no.)')
%       ylabel('HOF\_max (peak value)')
close all
      
      x=1:1:size(gaitCount2,2)
     for i=1:size(gaitCount2,1)
         y=HOF(i,17:24);
         figure(i);plot(y);
         xlabel('bins in HOF on SA2 and SA3') % 8 bins for SA2 and the next 8 bins are for SA3.
         ylabel('HOF values')
         output=smooth(y,'moving'); % 'moving': Moving average (default). A lowpass filter with 
                                    % filter coefficients equal to the reciprocal of the span. 
         hold on,plot(output,'r--')
         [ymax,imax,ymin,imin] = extrema(output);
         hold on
         plot(x(imax),ymax,'m*',x(imin),ymin,'g*')
             %Select the maximum value/peak value movements
                 movement=[i ymax(find(max(imax)))] % right leg movement indicator at ith frame
                 cycle2=[cycle2; movement]  % combine movements to make the periodic cycle of motion   
      end
      cycle2=(cycle2(:,2)/sum(cycle2(:,2)))
      close all
    %% plot the colorbar
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
    
%% HOF over a gait cycle

%Then, get the corresponding HOF and concatenate them as the descriptor
% Gaitcycle1
field1 = 'f1';  
HOF_gait=HOF(gaitCycle_pts(1):gaitCycle_pts(2),:);
% HOF_desp= reshape(HOF_gait.',1,[]); % descriptor vector of the HOF of the OpF over a gait cycle
HOF_desp=mean(HOF_gait);
HOF_desp1=HOF_desp./sum(HOF_desp) % Normalize the flow descriptor over a gait cycle
% MBH_gait=MBH(gaitCycle_pts(1):gaitCycle_pts(2),:);
% MBH_desp1 = reshape(MBH_gait.',1,[]); % descriptor vector of the MBH of the OpF over a gait cycle

% % Gaitcycle2
field2 = 'f2';  
HOF_gait=HOF(gaitCycle_pts(2):gaitCycle_pts(3),:);
HOF_desp=mean(HOF_gait);
% HOF_desp = reshape(HOF_gait.',1,[]); % descriptor vector of the HOF of the OpF over a gait cycle
HOF_desp2=HOF_desp./sum(HOF_desp)
% MBH_gait=MBH(gaitCycle_pts(2):gaitCycle_pts(3),:);
% MBH_desp2 = reshape(MBH_gait.',1,[]); % descriptor vector of the MBH of the OpF over a gait cycle

% % Gaitcycle3
field3 = 'f3';  
HOF_gait=HOF(gaitCycle_pts(3):gaitCycle_pts(4),:);
HOF_desp=mean(HOF_gait);
% HOF_desp = reshape(HOF_gait.',1,[]); % descriptor vector of the HOF of the OpF over a gait cycle
HOF_desp3=HOF_desp./sum(HOF_desp)
% MBH_gait=MBH(gaitCycle_pts(2):gaitCycle_pts(3),:);
% MBH_desp3 = reshape(MBH_gait.',1,[]); % descriptor vector of the MBH of the OpF over a gait cycle

% s = [HOF_desp1;HOF_desp2]
s = [HOF_desp1;HOF_desp2;HOF_desp3]
% save('2.mat','s')
% nearest_Neighbor;

% %% TEST!!
% %HOF over a gait cycle
% 
% %Then, get the corresponding HOF and concatenate them as the descriptor
% % gaitCycle_pts= [1; 6]
% % Gaitcycle
% HOF_gait=HOF(gaitCycle_pts(1):gaitCycle_pts(2),:);
% % HOF_desp= reshape(HOF_gait.',1,[]); % descriptor vector of the HOF of the OpF over a gait cycle
% HOF_desp=mean(HOF_gait);
% HOF_desp=HOF_desp./sum(HOF_desp) % Normalize the flow descriptor over a gait cycle
% save('test8.mat','HOF_desp')
% % MBH_gait=MBH(gaitCycle_pts(1):gaitCycle_pts(2),:);
% % MBH_desp1 = reshape(MBH_gait.',1,[]); % descriptor vector of the MBH of the OpF over a gait cycle
