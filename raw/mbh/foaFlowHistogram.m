function [hist] = foaFlowHistogram(vx,vy,meanVel) % Polar histogram of flow
% Receives flow of an image, assumes flow is already subtracted of the mean
% "velocity"
% Receives mean velocity of the detection, so we normalize the histogram of
% the flow directions by the velocity direction

hist=[]; 
if(meanVel == 0)
    display('Box didnt move, not computing features')
    return;
end


%removing noisy flow values with a median filter
% vx = medfilt2(vx,[5 5]);
% vy = medfilt2(vy,[5 5]);

%%% Lines below commented out because of feature alignment 22/01/2014
 flowMagnitude = sqrt(vx.^2+vy.^2);
%  meanMagnitude = sum(sum(flowMagnitude))/(size(flowMagnitude,1)*size(flowMagnitude,1));
% if meanMagnitude < 0.0000001
%     display('Noisy optical flow');
%     return;
% end

flowAngle = atan2(vy,vx);
meanAngle = atan2(meanVel(2),meanVel(1));
flowAngle = flowAngle-meanAngle;
checkedAngle = rangeAngle(flowAngle);
% figure(1);
% subplot(1,3,1);
% imagesc(flowMagnitude),colorbar;
% subplot(1,3,2);
% imagesc(flowAngle),colorbar;
% subplot(1,3,3);
% imagesc(checkedAngle);,colorbar;


anglesDelta=-180:45:180;
%centerValue=-157.5:45:157.5;
featVect=[];
histOri=zeros(1,8);

numberOfAngles=4;
angleDelta=-pi:pi/numberOfAngles:pi;
halfDelta=pi/(numberOfAngles*2);
[X,Y]=meshgrid(1:size(vy,2),1:size(vy,1));
X=X-ceil(size(vy,2)/2);%ceil(size(vy{countTargets},2)/2);
Y=-1.*Y+ceil(size(vy,1)/2);
angles=atan2(Y,X);

for cont=1:length(angleDelta)-1
    selectedAreaInd = find(angles>angleDelta(cont) & angles<=angleDelta(cont+1));
    currAngle=checkedAngle(selectedAreaInd);
    currMag=flowMagnitude(selectedAreaInd);
    for cont2=2:length(anglesDelta)
        if cont2==length(anglesDelta)
            index=(currAngle*180/pi<=anglesDelta(cont2) & currAngle*180/pi>=anglesDelta(cont2-1));
        else
            index=(currAngle*180/pi<anglesDelta(cont2) & currAngle*180/pi>=anglesDelta(cont2-1));
        end
        weighedEntries=currMag(index);
        featVect=[featVect sum(weighedEntries)];
    end
end
if norm(featVect,1)==0
    hist=featVect;
    display('Not norm');
    %display('Zero flow, not computing features')
    %return;
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
%indexEqual=find(abs(flowAngle-pi)<0.001);
%flowAngle(indexEqual)=-pi;
end