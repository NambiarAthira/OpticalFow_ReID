% close all;
fclose('all');
clear all;

slash = '\';

%--- USER DEFINED ----
control_variable = 1 %1: verify validity and manually label detections, 2: show which flows will be computed after labeling, 3: compute flows
basepath = '18Jul_17h52m-18h18m_Experiment_Wave_Robot'; %experiment folder name
camera_str = 'CameraA6-4'         %camera folder name
path = ['\\10.0.3.117\database\SequencesOfImages\BarcelonaImages' slash basepath slash camera_str]; %full path

%---------------------
starting_i = 1;
it=1;
pointsForOldClassifier = 0;
pointsForNewClassifier = 0;
correctPersonClassificationsOfOld = 0;
wrongPersonClassificationsOfNew = 0;
correctPersonClassificationsOfNew = 0;
wrongPersonClassificationsOfOld = 0;
totalPersonClassificationsInDispute = 0;
correctRobotClassificationsOfOld = 0;
wrongRobotClassificationsOfNew = 0;
correctRobotClassificationsOfNew = 0;
wrongRobotClassificationsOfOld = 0;
totalRobotClassificationsInDispute = 0;

detectionStringOld = [slash 'numberFormatDetections' camera_str '_oldClassifier.txt'];
fid = fopen([path detectionStringOld]);
if fid == -1
    display(['FAIL at opening ' detectionStringOld]);
    return;
else
    display(['Sucessfully opened ' detectionStringOld]);
    fclose(fid);
end

detectionStringNew = [slash 'numberFormatDetections' camera_str '_newClassifier.txt'];
fid = fopen([path detectionStringNew]);
if fid == -1
    display(['FAIL at opening ' detectionStringNew]);
    return;
else
    display(['Sucessfully opened ' detectionStringNew]);
    fclose(fid);
end

oldC = load([path detectionStringOld]);
newC = load([path detectionStringNew]);
%C structure:
%(type 1.0) (targetID 3) (pxPerson 324.0) (pyPerson 52.400002) (pxRobot 324.0) (pyRobot 96.800004) (width 104) (height 296) (npixels 17964) (occRatio 0.58355) (hwRatio 2.846154) (seconds 1243446665) (nanoseconds 064750) (xPerson 3.150393) (yPerson 9.527) (xRobot 3.084176) (yRobot 9.202006) (person_height_in_meters 1.404956) (robot_height_in_meters 1.262454) (cov 0.004111 0.00061 0.00061 0.007838) (x 272) (y 8)


%%
if it ~= starting_i %for when we do CTRL+C in this "cell", we do not completely compute the current i
    it=it-2
    fclose('all');
end

for it=it:size(oldC,1)
    %my own "sign()" function
    if oldC(it,1) >= 1
        oldCtype = 1;
    elseif oldC(it,1) <= -1
        oldCtype = -1;
    end
    if newC(it,1) >= 1
        newCtype = 1;
    elseif newC(it,1) <= -1
        newCtype = -1;
    end
    if (oldC(it,1) ~= 0 || newC(it,1) ~= 0) && oldCtype ~= newCtype
        %then there was a robot/person classification, and it was different for each classifier 
        
        image_pathOld = [ path slash  int2str(oldC(it,12)) '_' sprintf('%06d',oldC(it,13)) '_' camera_str '.jpg'];

        %safety check, to see if images with detections exist ----
        fid1 = fopen(image_pathOld);
        if fid1 == -1
            display(['Image ' image_pathOld ' does not exist.']);
            continue;
        end
        fclose(fid1);
        
        figure(1)
        imshow(image_pathOld);
        hold on;
        rectangle('Position', [oldC(it,24) oldC(it,25) oldC(it,7) oldC(it,8)], 'EdgeColor', 'b')
        
        if oldC(it,1) >= 1
            text(oldC(it,24), oldC(it,25), ['Old ' int2str(oldC(it,1))], 'Color', 'r', 'FontSize',18);
        elseif oldC(it,1) <= -1
            text(oldC(it,24), oldC(it,25), ['Old ' int2str(oldC(it,1))], 'Color', 'g', 'FontSize',18);
        elseif oldC(it,1) == 0
            text(oldC(it,24), oldC(it,25), ['Old ' int2str(oldC(it,1))], 'Color', 'b', 'FontSize',18);
        end
        if newC(it,1) >= 1
            text(newC(it,24)+newC(it,7), newC(it,25)+newC(it,8), ['New ' int2str(newC(it,1))], 'Color', 'r', 'FontSize',18);
        elseif newC(it,1) <= -1
            text(newC(it,24)+newC(it,7), newC(it,25)+newC(it,8), ['New ' int2str(newC(it,1))], 'Color', 'g', 'FontSize',18);
        elseif newC(it,1) == 0
            text(newC(it,24)+newC(it,7), newC(it,25)+newC(it,8), ['New ' int2str(newC(it,1))], 'Color', 'b', 'FontSize',18);
        end
        
        xlabel(['Id: ' int2str(oldC(it,2))]);
        drawnow;
        hold off;
        
            %auto-labeling
        if oldC(it,2) == 295
            button == 49;
        else
            %manual labeling
            keydown = waitforbuttonpress;
            if (keydown == 0)
                disp('Mouse button was pressed');
            else
                button = get(figure(1), 'CurrentCharacter');
                if button == 50 % #2 button, for CROWDs
                    disp([int2str(it) ': Keyboard button ' char(get(figure(1), 'CurrentCharacter')) ' was pressed, CROWD detection.']);
                    continue;
                elseif button == 49 % #1 button, for person
                    disp([int2str(it) ': Keyboard button ' char(get(figure(1), 'CurrentCharacter')) ' was pressed, person detection.']);
                elseif button == 51 % #1 button, for robot
                    disp([int2str(it) ': Keyboard button ' char(get(figure(1), 'CurrentCharacter')) ' was pressed, robot detection.']);
                else
                    disp([int2str(it) ': WRONG Keyboard button ' char(get(figure(1), 'CurrentCharacter')) ' pressed!']);
                    return;
                end
            end
        end
        
        if button == 49
            if oldC(it,1) >= 1
                pointsForOldClassifier = pointsForOldClassifier + 1;
                correctPersonClassificationsOfOld = correctPersonClassificationsOfOld +1;
                wrongPersonClassificationsOfNew = wrongPersonClassificationsOfNew +1;
            elseif newC(it,1) >= 1
                pointsForNewClassifier = pointsForNewClassifier + 1;
                correctPersonClassificationsOfNew = correctPersonClassificationsOfNew +1;
                wrongPersonClassificationsOfOld = wrongPersonClassificationsOfOld +1;
            end
            totalPersonClassificationsInDispute = totalPersonClassificationsInDispute + 1;
        elseif button == 51
            if oldC(it,1) <= -1
                pointsForOldClassifier = pointsForOldClassifier + 1;
                correctRobotClassificationsOfOld = correctRobotClassificationsOfOld +1;
                wrongRobotClassificationsOfNew = wrongRobotClassificationsOfNew +1;
            elseif newC(it,1) <= -1
                pointsForNewClassifier = pointsForNewClassifier + 1;
                correctRobotClassificationsOfNew = correctRobotClassificationsOfNew +1;
                wrongRobotClassificationsOfOld = wrongRobotClassificationsOfOld +1;
            end
            totalRobotClassificationsInDispute = totalRobotClassificationsInDispute + 1;
        end
    end
end
disp(['Old_' int2str(pointsForOldClassifier) '_vs_' int2str(pointsForNewClassifier) '_New'])
saveString=['save ' path slash basepath 'Old_' int2str(pointsForOldClassifier) '_vs_' int2str(pointsForNewClassifier) '_New pointsForOldClassifier pointsForNewClassifier correctPersonClassificationsOfOld wrongPersonClassificationsOfNew correctPersonClassificationsOfNew wrongPersonClassificationsOfOld totalPersonClassificationsInDispute correctRobotClassificationsOfOld wrongRobotClassificationsOfNew correctRobotClassificationsOfNew wrongRobotClassificationsOfOld totalRobotClassificationsInDispute'];
eval(saveString);

