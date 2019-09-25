close all;
fclose('all');
clear all;
% 
 l = '/';

%  /media/Elements/Work/LRMimages/exp-robot-new
%'F:\Work\LRMimages'
%--- USER DEFINED ----
control_variable = 2 %1: verify validity and manually label detections, 2: show which flows will be computed after labeling, 3: compute flows

lab = 'piso8corredores'; % 'BarcelonaImages', 'LRMimages', or 'piso8corredores'
[l basepath camera_str filepath] = path_strings(3, 5, lab)

% root = '/media/Elements/Work/piso8corredores/';
% basepath = 'dario_white'; %experiment folder name
% camera_str = 'CAMERA17'         %camera folder name
% filepath = [root basepath l camera_str l]; %full path
%---------------------
% /media/Elements/Work/piso8corredores/matteo_red/CAMERA17

if control_variable == 1
    show_images_or_save_flows = 1; %1: show images and not compute flows, 0: don't show anything, compute and save flows
    subsamplingDisplacement = 0; %in meters, if == 0, no subsampling is made
    maxDisplacement = 5;
    verify_detection_validity = 1; %major variable...
elseif control_variable == 2
    show_images_or_save_flows = 1; %1: show images and not compute flows, 0: don't show anything, compute and save flows
    subsamplingDisplacement = 0.2; %in meters, if == 0, no subsampling is made
    maxDisplacement = 1;
    verify_detection_validity = 0;
elseif control_variable == 3
    show_images_or_save_flows = 0; %1: show images and compute flows, 0: don't show anything, compute and save flows
    subsamplingDisplacement = 0.2; %in meters, if == 0, no subsampling is made
    maxDisplacement = 1;
    verify_detection_validity = 0;
end
sizeFactor=1/2;
expected_range = 10;
% wanted_type = 1; % -1: 'robot', 1: 'person'

starting_i = 1;
starting_camera = 1;

resize = 0;
flipImage = 0;


foaRobot=[];
foaPerson=[];

velocities = [];
% currents = {};
% nexts = {};
% flowX = {};
% flowY = {};
% flowXminusV = {};
% flowYminusV = {};

% velocitiesSubsampled = [];
% pixel2meterConstantsSubsampled = [];
% currentFrame_nextFrame_camera = [];
% flowsXsubsampled = {};
% flowsYsubsampled = {};
% 
% CROWDSvelocitiesSubsampled = [];
% CROWDSpixel2meterConstantsSubsampled = [];
% CROWDScurrentFrame_nextFrame_camera = [];
% CROWDSflowsXsubsampled = {};
% CROWDSflowsYsubsampled = {};
% 
% ROBOTSvelocitiesSubsampled = [];
% ROBOTSpixel2meterConstantsSubsampled = [];
% ROBOTScurrentFrame_nextFrame_camera = [];
% ROBOTSflowsXsubsampled = {};
% ROBOTSflowsYsubsampled = {};
% 
inter_camera_targets = {};

% PERSONhogs_imagems = {};
% PERSONmbhs_flows = {};
% ROBOTShogs_imagems = {};
% ROBOTSmbhs_flows = {};
% CROWDShogs_imagems = {};
% CROWDSmbhs_flows = {};

%for camera=starting_camera:1
    
%% 
    
%     basepath = ['PersonA6-4_17Jul_18h_17m-20m'];
%     camera_str = 'CameraA6-4';
%     filepath = ['\\10.0.3.117\database\SequencesOfImages\BarcelonaImages\PersonA6-4\17Jul_18h_17m-20m\' camera_str];


    
    detectionString = [l 'numberFormatDetections' camera_str '.txt'];
    fid = fopen([filepath detectionString]);
    if fid == -1
        display(['FAIL at opening camera:' camera_str]);
        return;
        %continue;
    else
        display(['Starting the images from camera:' camera_str]);
        fclose(fid);
    end

    %[filepath detectionString]
    C = load([filepath detectionString]);
    if isempty(C)
        display('No valid detections.');
        return;
    end

    %C structure:
    %(type 1.0) (targetID 3) (pxPerson 324.0) (pyPerson 52.400002) (pxRobot 324.0) (pyRobot 96.800004) (width 104) (height 296) (npixels 17964) (occRatio 0.58355) (hwRatio 2.846154) (time "1243446665:064750") (xPerson 3.150393) (yPerson 9.527) (xRobot 3.084176) (yRobot 9.202006) (person_height_in_meters 1.404956) (robot_height_in_meters 1.262454) (cov 0.004111 0.00061 0.00061 0.007838) (x 272) (y 8)
    clear B;
    
    fid3 = fopen([filepath basepath '_' camera_str '_B.mat']);
    if fid3 == -1
        B = zeros(size(C,1), 13);
        display(['file ' filepath basepath '_' camera_str '_B.mat does not exist.']);
        B(:,1) = C(:,2); %id
        B(:,2:3) = C(:,24:25); %x,y of top-left corner of bounding box
        B(:,4:5) = C(:,7:8); %width, height
        B(:,6) = C(:,1); %type
        B(:,7:8) = C(:,14:15); %x,y in the world
        B(:,9:10) = C(:,12:13); %timestamp
        %B(i,11) = 1; %1 is valid person, 2 valid robot, -1 is invalid and 0 non-verified, -2 is crowd
        %B(i,12) %camera number
        %B(i,13) %inter camera track id       
    else
        load([filepath basepath '_' camera_str '_B.mat']);
%          starting_i = iterator; %  NECESSARY TO BE ABLE TO STOP AND CONTINUE A LONG LABELING JOB  
        starting_i = 1;
        fclose(fid3);
        load([filepath 'inter_camera_targets.mat']);
    end 
    
    % Load detectionMasks to help with the labeling
    BGStype = 'BackTD_LINUX';
    fid4 = fopen([filepath basepath '_' camera_str '_detectionMasks_' BGStype '.mat' ]);
    if fid4 ~= -1
        load([filepath basepath '_' camera_str '_detectionMasks_' BGStype '.mat' ])
    end
    
    %     B(size(B,1),7:8) = [0 0];
    %     for i = starting_i:size(B,1)-1
    %         %filling in B the detection's position in the floor
    %         if C(i,1) >=1
    %             B(i,7:8) = C(i,14:15);
    %         elseif C(i,1) <=-1
    %             B(i,7:8) = C(i,16:17);
    %         end
    %     end

    i=starting_i;
%%  
    if i ~= starting_i %for when we do CTRL+C in this "cell", we do not completely compute the current i
        i=i-3
        fclose('all');
    end
    while(1)
        j=i+1;
        lostTarget = 0;
        if(i >= size(B,1)-1) %end of vector
            display([int2str(i) ': i reached end of vector'])
            break;
        end
        %             if B(i,6)*wanted_type >= 1
        %                 %very well, detection of wanted type (robot/person)
        %             else
        %                 i=i+1;
        %                 continue
        %             end

        if control_variable == 1 
            while B(i,1) ~= B(j,1)  ||  norm(B(j,7:8) - B(i,7:8)) < subsamplingDisplacement
                j=j+1;
                if(j >= size(B,1) || j-i > 50) %end of vector
                    lostTarget = 1;
                    break;
                end
            end
            if(lostTarget == 1)
                display([int2str(i) ': lost target ' num2str(B(i,1)) ' but run anyway.'])
%                 display([int2str(i) ': lost target ' num2str(B(i,1))])
%                 i=i+1;
%                 continue;
            end
            
%             if B(i,8) < -1 %yy outside of campus
%                 disp(['Detection ' int2str(i) ' with yy=' num2str(B(i,8)) ' outside of campus.']);
%                 i=i+1;
%                 continue;
%             end

%             if B(i,9) < 1247910083
%                 disp(['too youngS']);
%                 i=i+1;
%                 continue;
%             end
            
        elseif control_variable == 2 || control_variable == 3
            while B(i,1) ~= B(j,1) || B(i,13) ~= B(j,13)  ||  norm(B(j,7:8) - B(i,7:8)) < subsamplingDisplacement
                j=j+1;
                if(j >= size(B,1) || j-i > 50) %end of vector
                    lostTarget = 1;
                    break;
                end
            end
            if(lostTarget == 1)
                display([int2str(i) ': lost target ' num2str(B(i,1))])
                i=i+1;
                continue;
            end

        end        
        %else
        %very well, same target id for detections i and j AND their
        %ground displacement is large enough.
        if norm(B(j,7:8) - B(i,7:8)) > maxDisplacement
            display([int2str(i) ': too large a displacement: ' num2str(norm(B(j,7:8) - B(i,7:8)))]);
            i=i+1;
            continue;
        end

%         control_variable == 1 : LABEL DATA
%         control_variable == 2 and 3 : data should be labeled, so look into B(i,13)
%         control_variable == 2 : show the flows that will be computed
%         control_variable == 3 : compute flows
        if (B(i,1) == B(j,1) && control_variable == 1) || (B(i,13) == B(j,13) && (control_variable == 2 || control_variable == 3)) || lostTarget %but run anyway
            %&& B(j,6)*wanted_type >= 1 %confirming bot detections to be the same target and of the expected type
            
            if ~verify_detection_validity
                if B(i,11) ~= -1 && B(i,11) ~= 0
                    %carry on
                else
                    i=i+1; continue; %is trash or unlabeled
                end
            end
            
            image_pathCurr = [ filepath  int2str(B(i,9)) '_' sprintf('%06d',B(i,10)) '_' camera_str '.jpg'];
            image_pathNext = [ filepath  int2str(B(j,9)) '_' sprintf('%06d',B(j,10)) '_' camera_str '.jpg'];

            %safety check, to see if images with detections exist ----
            fid1 = fopen(image_pathCurr);
            if fid1 == -1
                display(['Image ' image_pathCurr ' does not exist.']);
                i=i+1;
                continue;
            end
            fid2 = fopen(image_pathNext);
            if fid2 == -1
                display(['Image ' image_pathNext ' does not exist.']);
                i=i+1;
                continue;
            end
            fclose(fid1);
            fclose(fid2);
            % ----

            currentBoundingBox = floor(sizeFactor*[B(i,2) B(i,2)+B(i,4) B(i,3) B(i,3)+B(i,5)]);
            nextBoundingBox = floor(sizeFactor*[B(j,2) B(j,2)+B(j,4) B(j,3) B(j,3)+B(j,5)]);
            topLeftPoint = [ min([currentBoundingBox(1) nextBoundingBox(1)]) min([currentBoundingBox(3) nextBoundingBox(3)])];
            botRightCurr = [ currentBoundingBox(2) currentBoundingBox(4) ];
            botRightNext = [ nextBoundingBox(2) nextBoundingBox(4) ];
            botRightPoint = max( [botRightCurr; botRightNext]);

            %cutting box if it extends outside the image (because, we think, of approximation errors ) ----
            if (botRightNext(1)>640*sizeFactor)
                botRightNext(1)=640*sizeFactor;
            end
            if (botRightNext(2)>480*sizeFactor)
                botRightNext(2)=480*sizeFactor;
            end

            if (botRightPoint(1)>640*sizeFactor)
                botRightPoint(1)=640*sizeFactor;
            end
            if (botRightPoint(2)>480*sizeFactor)
                botRightPoint(2)=480*sizeFactor;
            end

            if (topLeftPoint(1)<1)
                topLeftPoint(1)=1;
            end
            if (topLeftPoint(2)<1)
                topLeftPoint(2)=1;
            end
            % ----

            %velocity (or more accuratly: displacement) computation
            centerPointCurrent = [(currentBoundingBox(1)+currentBoundingBox(2))/2 (currentBoundingBox(3)+currentBoundingBox(4))/2];
            centerPointNext = [(nextBoundingBox(1)+nextBoundingBox(2))/2 (nextBoundingBox(3)+nextBoundingBox(4))/2];
            targetVelocity = centerPointNext - centerPointCurrent;
            targetVelocityInMeters = B(j,7:8) - B(i,7:8);
            pixel2meterConstant = norm(targetVelocityInMeters)/norm(targetVelocity);

%             clear imread_image_pathCurr imread_image_pathNext;
            imread_image_pathCurr = imread(image_pathCurr);
            imread_image_pathNext = imread(image_pathNext);
            if flipImage == 1
                imgCurr = imrotate(imresize(rgb2gray(imread_image_pathCurr),sizeFactor), 180);
                imgNext = imrotate(imresize(rgb2gray(imread_image_pathNext),sizeFactor), 180);
            else
                imgCurr = imresize(rgb2gray(imread_image_pathCurr),sizeFactor);
                imgNext = imresize(rgb2gray(imread_image_pathNext),sizeFactor);
            end
            currentImage = imgCurr(topLeftPoint(2):botRightPoint(2),topLeftPoint(1):botRightPoint(1));
            nextImage = imgNext(topLeftPoint(2):botRightPoint(2),topLeftPoint(1):botRightPoint(1));

            %change rage dinamicly according to velocity in pixels
            expected_range = ceil(min(min(size(currentImage))/2 , 25)); %25 is the maximum that we can reasonably fast compute in the C++ implementation

            %show detections ----
            if show_images_or_save_flows
%                 close hidden
                figure(1),
                if exist('detectionMasks','var') % also show the pixel masks
                    subplot(1,2,1);
                end
                if flipImage == 1
                    if resize == 1
                        imshow(imrotate(imresize(imread_image_pathCurr,sizeFactor), 180));
                    elseif resize == 0
                        imshow(imrotate(imread_image_pathCurr, 180));
                    end
                else
                    if resize == 1
                        imshow(imresize(imread_image_pathCurr,sizeFactor));
                    elseif resize == 0
                        imshow(imread_image_pathCurr);
                    end
                end
                hold on,
%                 title(image_pathCurr);
                xlabel({[int2str(B(i,9)) '\_' sprintf('%06d',B(i,10)) ' H=' num2str(C(i,18))]; ...
                    ['flow ' int2str(i) ' to ' int2str(j) ' pos: ' num2str(B(i,7)) ';' num2str(B(i,8)) ' top-left: ' num2str(B(i,2)) ';' num2str(B(i,3)) ]; ...
                    ['displacement (' num2str(targetVelocityInMeters(1)) ',' num2str(targetVelocityInMeters(2)) ') ' num2str(norm(targetVelocityInMeters)) 'm']}); 
                if resize == 1
                    copyB(1) = currentBoundingBox(1);
                    copyB(2) = currentBoundingBox(3);
                    copyB(3) = currentBoundingBox(2)-currentBoundingBox(1);
                    copyB(4) = currentBoundingBox(4)-currentBoundingBox(3);
                elseif resize == 0
                    copyB(1) = round(currentBoundingBox(1)/sizeFactor);
                    copyB(2) = round(currentBoundingBox(3)/sizeFactor);
                    copyB(3) = round((currentBoundingBox(2)-currentBoundingBox(1))/sizeFactor);
                    copyB(4) = round((currentBoundingBox(4)-currentBoundingBox(3))/sizeFactor);                  
                end
                text(copyB(1)+copyB(3)/2,copyB(2)+copyB(4)/2,int2str(B(i,1)), 'Color', 'r', 'FontSize',18);
                if B(i,13) ~= 0 %if already identified, write name of labeled person
                    text(copyB(1)+copyB(3)/10,copyB(2)+copyB(4)/10,[title_image(B(i,13),lab) ' - ' char(B(i,13))], 'Color', 'b', 'FontSize',18);
                end

                %draw detection type color
                if B(i,6) > 0
                    rectangle('Position',copyB,'LineWidth',2,'EdgeColor','r');               
                elseif B(i,6) < 0
                    rectangle('Position',copyB,'LineWidth',2,'EdgeColor','g');                                   
                else 
                    rectangle('Position',copyB,'LineWidth',2,'EdgeColor','b');
                end
                drawnow;
                hold off,
                if exist('detectionMasks','var') % also show the pixel masks
                    currentImage_detMasks = imread(image_pathCurr);
                    croppedImage = currentImage_detMasks(B(i,3):B(i,3)+B(i,5), B(i,2):B(i,2)+B(i,4), :);
                    dBox = detectionMasks{i};
                    clear maskedImage;
                    maskedImage(:,:,1) = min(croppedImage(:,:,1),dBox);
                    maskedImage(:,:,2) = min(croppedImage(:,:,2),dBox);
                    maskedImage(:,:,3) = min(croppedImage(:,:,3),dBox);
                    subplot(1,2,2), imshow(maskedImage, 'InitialMagnification', 100), 
                    if exist('waist','var')
                        rectangle('Position',[0 waist size(maskedImage,2) 1],'LineWidth',1,'EdgeColor','r');
                    else
                        rectangle('Position',[0 size(maskedImage,1)*.35 size(maskedImage,2) 1],'LineWidth',1,'EdgeColor','b');
                        rectangle('Position',[0 size(maskedImage,1)*.55 size(maskedImage,2) 1],'LineWidth',1,'EdgeColor','b');
                    end
                end
                
                if 0 %show figure optical flow pair (2)
                    figure(2),
                    if flipImage == 1
                        if resize == 1
                            imshow(imrotate(imresize(imread_image_pathNext,sizeFactor), 180));
                        elseif resize == 0
                            imshow(imrotate(imread_image_pathNext, 180));
                        end
                    else
                        if resize == 1
                            imshow(imresize(imread_image_pathNext,sizeFactor));
                        elseif resize == 0
                            imshow(imread_image_pathNext);
                        end
                    end
                    hold on,
                    %                 title(image_pathNext);
                    xlabel(['displacement (' num2str(targetVelocityInMeters(1)) ',' num2str(targetVelocityInMeters(2)) ') ' num2str(norm(targetVelocityInMeters)) 'm'])
                    if resize == 1
                        copyB(1) = nextBoundingBox(1);
                        copyB(2) = nextBoundingBox(3);
                        copyB(3) = nextBoundingBox(2)-nextBoundingBox(1);
                        copyB(4) = nextBoundingBox(4)-nextBoundingBox(3);
                    elseif resize == 0
                        copyB(1) = round(nextBoundingBox(1)/sizeFactor);
                        copyB(2) = round(nextBoundingBox(3)/sizeFactor);
                        copyB(3) = round((nextBoundingBox(2)-nextBoundingBox(1))/sizeFactor);
                        copyB(4) = round((nextBoundingBox(4)-nextBoundingBox(3))/sizeFactor);
                    end
                    rectangle('Position',copyB,'LineWidth',2,'EdgeColor','r');
                    drawnow;
                    hold off,
                end
                %                 figure(1) %bringing figure 1 to the fore
                
                %Pre-determined rejection areas for detections
                [cont i] = reject(camera_str, B, i, lab);
                if cont == 1
                    continue;
                end
                 

%                  elseif B(i,8) < 0.2 %yy outside of campus CameraA6-4
%                     B(i,11) = -1;
%                  elseif B(i,8) > 33.15 %yy outside of camera view CameraA6-6
%                     B(i,11) = -1;
%                  elseif B(i,7) > 47.59 %yy outside of camera view CameraA6-6
%                     B(i,11) = -1;
                %verify detection validity

                if B(i,1) == -357 %REMOVE THIS AFTERWARDS
                    rabo = 'come�ando'
                    B(i,11) = -1;
                elseif B(i,1) == -1388 %REMOVE THIS AFTERWARDS
                    B(i,11) = -2; %CROWD
                    B(i,12) = which_camera(camera_str); %camera number
                    B(i,13) = 48; 
                elseif B(i,1) == -18 %REMOVE THIS AFTERWARDS
                    B(i,11) = 1;
                    B(i,12) = which_camera(camera_str); %camera number
                    B(i,13) = 50;
                elseif B(i,1) == -1
                    B(i,11) = 2; %ROBOT!
                    B(i,12) = which_camera(camera_str); %camera number
                    B(i,13) = 114;
                elseif verify_detection_validity == 1
                    
                    keydown = waitforbuttonpress;
                    if (keydown == 0)
                        disp('Mouse button was pressed'); %bad
                        B(i,11) = -1;
                        i=i+1;
                        continue;
                    else
                        disp(['Key: ' num2str(keydown) '  was pressed :' char(get(figure(1), 'CurrentCharacter'))]); %good
                        B(i,12) = which_camera(camera_str); %camera number
                        B(i,13) = get(figure(1), 'CurrentCharacter'); %target inter-camera tracking id
                        if B(i,13) == 48 %zero key
                            B(i,11) = -2; %crowd
                        elseif B(i,13) == 114 %'r' key
                            B(i,11) = 2; %robot
                        else
                            B(i,11) = 1; %1 is valid person, 2 valid robot, -1 is invalid and 0 non-verified, -2 is crowd
                        end
                        if size(inter_camera_targets, 2)<B(i,13) || isempty(inter_camera_targets{B(i,13)})
%                             raboim = imread_image_pathCurr;
                            if flipImage == 1
                                if resize == 1
                                    raboim = imrotate(imresize(imread_image_pathCurr,sizeFactor), 180);
                                elseif resize == 0
                                    raboim = imrotate(imread_image_pathCurr, 180);
                                end
                            else
                                if resize == 1
                                    raboim = imresize(imread_image_pathCurr,sizeFactor);
                                elseif resize == 0
                                    raboim = imread_image_pathCurr;
                                end
                            end
                            inter_camera_targets{B(i,13)} = raboim(B(i,3):B(i,3)+B(i,5), B(i,2):B(i,2)+B(i,4),:);
                            for it=1:size(inter_camera_targets, 2)
                               if ~isempty(inter_camera_targets{it})
                                  figure(it), imshow(inter_camera_targets{it}, 'InitialMagnification', 100),%truesize, 
                                  xlabel(['key ' char(it) ])
                                  title_image(it, lab)
                               end
                            end
                        end
                        figure(3); imshow(inter_camera_targets{B(i,13)})
                        xlabel(['target ' int2str(B(i,13)) ', key ' char(B(i,13)) ])
                        title_image(B(i,13), lab)
                    end
                end
                % ----

            end
            if control_variable == 2
%                 keydown = waitforbuttonpress;
            end
            % ----


            %verifying the minimum detection size to compute flow
            range = min([min(size(currentImage)) min(size(nextImage)) expected_range]) ;
            shiftrangeX = -range:range;
            shiftrangeY = -range:range;
            if(range<expected_range)
                display('Small image, reducing range.');
            end

            if ~show_images_or_save_flows
                %if the data has been manually labeled (there already exists a
                %B that we loaded, then verify if the data is what we want
                %person/robot and not garbage
                if ~verify_detection_validity
                    if (B(i,11) == 1 && B(j,11) == 1) || (B(i,11) == 2 && B(j,11) == 2) %person or robot, because some robots were still '1'
                        if B(i,13) ~= 114 && B(j,13) ~= 114
                            %compute flow
                            [flowXsubsampled, flowYsubsampled, occlL, bestshiftsRX, bestshiftsRY, occlR] = flow (currentImage, nextImage, shiftrangeX, shiftrangeY);
                                                        
                            %                 flowXnormalized=flowXsubsampled*pixel2meterConstant;
                            %                 flowYnormalized=flowYsubsampled*pixel2meterConstant;
                            % figure,imagesc(flowXsubsampled),colorbar
                            % figure,imagesc(flowYsubsampled),colorbar
                            %                 figure,imagesc(flowXnormalized),colorbar
                            %                 figure,imagesc(flowYnormalized),colorbar

                            velocitiesSubsampled = [velocitiesSubsampled; targetVelocity];
                            pixel2meterConstantsSubsampled = [ pixel2meterConstantsSubsampled; pixel2meterConstant];
                            currentFrame_nextFrame_camera = [currentFrame_nextFrame_camera; i j];

                            flowsXsubsampled = {flowsXsubsampled{:} flowXsubsampled};
                            flowsYsubsampled = {flowsYsubsampled{:} flowYsubsampled};
                            
                            %compute gradient
                            [BW,thresh,gv,gh] = edge(currentImage,'sobel');
                            gradMagnitude = sqrt(gh.^2+gv.^2);
                            gradOrientation = atan2(gv,gh);
                            %comput HOG da imagem
                            HOGpolar = polarGradientHistogram(gradMagnitude,gradOrientation,8 , 0);
                            %compute features from flow
                            MBHpolar = mbhFoaFlowHistogram(flowXsubsampled, flowYsubsampled, targetVelocity);

                            PERSONhogs_imagems = {PERSONhogs_imagems{:} HOGpolar};
                            PERSONmbhs_flows = {PERSONmbhs_flows{:} MBHpolar};
                            
                        elseif B(i,13) == 114 && B(j,13) == 114 %ROBOTS
                            [flowXsubsampled, flowYsubsampled, occlL, bestshiftsRX, bestshiftsRY, occlR] = flow (currentImage, nextImage, shiftrangeX, shiftrangeY);
                            ROBOTSvelocitiesSubsampled = [ROBOTSvelocitiesSubsampled; targetVelocity];
                            ROBOTSpixel2meterConstantsSubsampled = [ ROBOTSpixel2meterConstantsSubsampled; pixel2meterConstant];
                            ROBOTScurrentFrame_nextFrame_camera = [ROBOTScurrentFrame_nextFrame_camera; i j];

                            ROBOTSflowsXsubsampled = {ROBOTSflowsXsubsampled{:} flowXsubsampled};
                            ROBOTSflowsYsubsampled = {ROBOTSflowsYsubsampled{:} flowYsubsampled};

                            %compute gradient
                            [BW,thresh,gv,gh] = edge(currentImage,'sobel');
                            gradMagnitude = sqrt(gh.^2+gv.^2);
                            gradOrientation = atan2(gv,gh);
                            %comput HOG da imagem
                            HOGpolar = polarGradientHistogram(gradMagnitude, gradOrientation,8, 0);
                            %compute features from flow
                            MBHpolar = mbhFoaFlowHistogram(flowXsubsampled, flowYsubsampled, targetVelocity);

                            ROBOTShogs_imagems = {ROBOTShogs_imagems{:} HOGpolar};
                            ROBOTSmbhs_flows = {ROBOTSmbhs_flows{:} MBHpolar};

                        end
                    elseif B(i,11) == -2 && B(j,11) == -2 %crowd
                        [flowXsubsampled, flowYsubsampled, occlL, bestshiftsRX, bestshiftsRY, occlR] = flow (currentImage, nextImage, shiftrangeX, shiftrangeY);
                        CROWDSvelocitiesSubsampled = [CROWDSvelocitiesSubsampled; targetVelocity];
                        CROWDSpixel2meterConstantsSubsampled = [ CROWDSpixel2meterConstantsSubsampled; pixel2meterConstant];
                        CROWDScurrentFrame_nextFrame_camera = [CROWDScurrentFrame_nextFrame_camera; i j];

                        CROWDSflowsXsubsampled = {CROWDSflowsXsubsampled{:} flowXsubsampled};
                        CROWDSflowsYsubsampled = {CROWDSflowsYsubsampled{:} flowYsubsampled};
                        
                             %compute gradient
                            [BW,thresh,gv,gh] = edge(currentImage,'sobel');
                            gradMagnitude = sqrt(gh.^2+gv.^2);
                            gradOrientation = atan2(gv,gh);
                            %comput HOG da imagem
                            HOGpolar = polarGradientHistogram(gradMagnitude, gradOrientation,8, 0);
                            %compute features from flow
                            MBHpolar = mbhFoaFlowHistogram(flowXsubsampled, flowYsubsampled, targetVelocity);

                            CROWDShogs_imagems = {CROWDShogs_imagems{:} HOGpolar};
                            CROWDSmbhs_flows = {CROWDSmbhs_flows{:} MBHpolar};
                   else
                        i=i+1;
                        continue
                    end
                end
            end



        end
        i=i+1; %more flows this way
        display([int2str(i) ' of ' int2str(length(B))])
    end
    
    if verify_detection_validity == 1
        iterator = i;
        saveString=['save ' filepath basepath '_' camera_str '_B.mat B iterator'];
        eval(saveString);
        saveString=['save ' filepath 'inter_camera_targets.mat inter_camera_targets'];
        eval(saveString);
    end
    
    %     printing the inter_camera_targets
%     if size(inter_camera_targets, 2)<B(i,13) || isempty(inter_camera_targets{B(i,13)})
        %                             image = imread_image_pathCurr;
        for it=1:size(inter_camera_targets, 2)
            if ~isempty(inter_camera_targets{it})
                figure(it), imshow(inter_camera_targets{it}, 'InitialMagnification', 100),%truesize,
                xlabel(['key ' char(it) ])
                title_image(it, lab)
            end
        end
        %     end
    for it=1:size(inter_camera_targets, 2)
        if ~isempty(inter_camera_targets{it})
%             print(['-f' int2str(it)], '-djpeg', '-noui', ['C:\Documents and Settings\Dario\Desktop\inter_camera_targets\' int2str(it) ' ' basepath ' ' camera_str])
            print(['-f' int2str(it)], '-djpeg', '-noui', [root l 'inter_camera_targets' l int2str(it) '_' basepath '_' camera_str])
        end
    end

%%    
%end
if ~show_images_or_save_flows
    saveString=['save ' filepath basepath '_' int2str(size(flowsXsubsampled,2)) '_PERSON_Flows_imresize=' num2str(sizeFactor) '_flowDynamicRange' '_subsampling=' num2str(subsamplingDisplacement) camera_str '.mat velocitiesSubsampled pixel2meterConstantsSubsampled currentFrame_nextFrame_camera flowsXsubsampled flowsYsubsampled'];
    eval(saveString);
    
    saveString=['save ' filepath basepath '_' int2str(size(CROWDSflowsXsubsampled,2)) '_CROWDS_Flows_imresize=' num2str(sizeFactor) '_flowDynamicRange' '_subsampling=' num2str(subsamplingDisplacement) camera_str '.mat CROWDSvelocitiesSubsampled CROWDSpixel2meterConstantsSubsampled CROWDScurrentFrame_nextFrame_camera CROWDSflowsXsubsampled CROWDSflowsYsubsampled'];
    eval(saveString);

    saveString=['save ' filepath basepath '_' int2str(size(ROBOTSflowsXsubsampled,2)) '_ROBOTS_Flows_imresize=' num2str(sizeFactor) '_flowDynamicRange' '_subsampling=' num2str(subsamplingDisplacement) camera_str '.mat ROBOTSvelocitiesSubsampled ROBOTSpixel2meterConstantsSubsampled ROBOTScurrentFrame_nextFrame_camera ROBOTSflowsXsubsampled ROBOTSflowsYsubsampled'];
    eval(saveString);

    saveString=['save ' filepath basepath '_' camera_str '_' ...
        int2str(size(flowsXsubsampled,2)) '_Person_' ...
        int2str(size(ROBOTSflowsXsubsampled,2)) '_Robot_' ...
        int2str(size(CROWDSflowsXsubsampled,2)) '_Crowds_' ...
        '_Flows+HOGimagem+MBHflow_imresize=' num2str(sizeFactor) '_flowDynamicRange' '_subsampling=' num2str(subsamplingDisplacement) ...
        '.mat ROBOTSvelocitiesSubsampled ROBOTSpixel2meterConstantsSubsampled ROBOTScurrentFrame_nextFrame_camera ROBOTSflowsXsubsampled ROBOTSflowsYsubsampled ' ... 
        'CROWDSvelocitiesSubsampled CROWDSpixel2meterConstantsSubsampled CROWDScurrentFrame_nextFrame_camera CROWDSflowsXsubsampled CROWDSflowsYsubsampled ' ... 
        'velocitiesSubsampled pixel2meterConstantsSubsampled currentFrame_nextFrame_camera flowsXsubsampled flowsYsubsampled ' ...
        'PERSONhogs_imagems PERSONmbhs_flows ROBOTShogs_imagems ROBOTSmbhs_flows CROWDShogs_imagems CROWDSmbhs_flows'];
    eval(saveString);
else
    if verify_detection_validity == 1
        iterator = i;
        saveString=['save ' filepath basepath '_' camera_str '_B.mat B iterator'];
        eval(saveString);
        saveString=['save ' filepath 'inter_camera_targets.mat inter_camera_targets'];
        eval(saveString);
    end
end

% %compute std and var for flow directions
% variances = [];
% for i = 1:size(flowX,2)
%     variances = [variances var(flowAnalysis(flowX{i},flowY{i}))];
% end
% display(['Mean and Var of variance of regular flow: ' num2str(mean(variances)) ' ' num2str(var(variances))])
%
% variances = [];
% for i = 1:size(flowX,2)
%     variances = [variances var(flowAnalysis(flowXminusV{i},flowYminusV{i}))];
% end
% display(['Mean and Var of variance of flow minus box displacement: ' num2str(mean(variances)) ' ' num2str(var(variances))])

%% correcting mistakes
% for it=1:size(B,1)
%     if B(it,13) == 50
%         B(it,13) = 51;
% %         B(it,11) = 2;
%         display(int2str(it))
%     end
% end
%         iterator = 1;
%         saveString=['save ' filepath basepath 'B.mat B iterator'];
%         eval(saveString);

