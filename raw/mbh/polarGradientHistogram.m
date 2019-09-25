function [hist] = polarGradientHistogram(gradMagnitude,gradOrientation,numberOfBins,magThreshold)
% Receives flow of an image, assumes flow is already subtracted of the mean
% "velocity"
% Receives mean velocity of the detection, so we normalize the histogram of
% the flow directions by the velocity direction

hist=[];
% if(meanVel == 0)
%     display('Box didnt move, not computing features');
%     hist=zeros(1,numberOfBins*numberOfBins);
%     return;
% end


%removing noisy flow values with a median filter
% vx = medfilt2(vx,[5 5]);
% vy = medfilt2(vy,[5 5]);

meanMagnitude = sum(sum(gradMagnitude))/(size(gradMagnitude,1)*size(gradMagnitude,1));
if meanMagnitude < 0.00000000001
    display('Noisy optical flow');
    hist=zeros(1,numberOfBins*numberOfBins);
    return;
end

% flowAngle = atan2(vy,vx);
% meanAngle = atan2(meanVel(2),meanVel(1));
% flowAngle = flowAngle-meanAngle;
% checkedAngle = rangeAngle(flowAngle);
% figure(1);
% subplot(3,1,1);
% imagesc(flowMagnitude),colorbar;
% subplot(3,1,2);
% imagesc(flowAngle),colorbar;
% subplot(3,1,3);
% imagesc(checkedAngle);,colorbar;

anglesStep=360/numberOfBins;
anglesDelta=-180:anglesStep:180;
%centerValue=-157.5:45:157.5;
featVect=[];
histOri=zeros(1,numberOfBins);

numberOfAngles=numberOfBins/2;
angleDelta=-pi:pi/numberOfAngles:pi;
halfDelta=pi/(numberOfAngles*2);
[X,Y]=meshgrid(1:size(gradMagnitude,2),1:size(gradMagnitude,1));
X=X-ceil(size(gradMagnitude,2)/2);%ceil(size(vy{countTargets},2)/2);
Y=-1.*Y+ceil(size(gradMagnitude,1)/2);
angles=atan2(Y,X);

for cont=1:length(angleDelta)-1
    selectedAreaInd = find(angles>angleDelta(cont) & angles<=angleDelta(cont+1));
    currAngle=gradOrientation(selectedAreaInd);
    currMag=gradMagnitude(selectedAreaInd);
    for cont=2:length(anglesDelta)
        index=(currAngle*180/pi<anglesDelta(cont) & currAngle*180/pi>=anglesDelta(cont-1));
        weighedEntries=currMag(index);
        indexThresholded=find(weighedEntries>=magThreshold);
        weighedThresholdedEntries=weighedEntries(indexThresholded);
        featVect=[featVect sum(weighedThresholdedEntries)];
        %featVect=[featVect sum(weighedEntries)];
    end
end
if norm(featVect)==0
    display('Zero flow, not computing features');
    hist=zeros(1,numberOfBins*numberOfBins);
    return;
else
    hist=featVect;
    hist=hist./norm(hist);
end
end

function checkedAngle = rangeAngle(flowAngle)
indexGreater=find(flowAngle>pi);
flowAngle(indexGreater)=flowAngle(indexGreater)-2*pi;
indexLesser=find(flowAngle<-pi);
flowAngle(indexLesser)=flowAngle(indexLesser)+2*pi;
checkedAngle=flowAngle;
end