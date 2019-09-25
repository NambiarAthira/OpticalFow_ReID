function [hist] = hogFlowHistogram(vx,vy,meanVel,flowMagnitude)
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

% flowMagnitude = sqrt(vx.^2+vy.^2);
% checkFlow=sum(sum(flowMagnitude))/(size(flowMagnitude,1)*size(flowMagnitude,1));
% if checkFlow < 0.0000001
%     display('Zero flow');
%     return;
% end
flowAngle = atan2(vy,vx);
meanAngle = atan2(meanVel(2),meanVel(1));
flowAngle = flowAngle-meanAngle;
checkedAngle = rangeAngle(flowAngle);
% figure(1);
% subplot(3,1,1);
% imagesc(flowMagnitude),colorbar;
% subplot(3,1,2);
% imagesc(flowAngle),colorbar;
% subplot(3,1,3);
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

subImageSizeX = floor(size(vx,1)/3);
subImageSizeY = floor(size(vx,2)/3);

for i=1:3
    for j=1:3
        currAngle = checkedAngle((i-1)*subImageSizeX+1:i*subImageSizeX,(j-1)*subImageSizeY+1:j*subImageSizeY);
        currMag = flowMagnitude((i-1)*subImageSizeX+1:i*subImageSizeX,(j-1)*subImageSizeY+1:j*subImageSizeY);
        for cont=2:length(anglesDelta)
            if cont==length(anglesDelta)
                index=(currAngle*180/pi<=anglesDelta(cont) & currAngle*180/pi>=anglesDelta(cont-1));
            else
                index=(currAngle*180/pi<anglesDelta(cont) & currAngle*180/pi>=anglesDelta(cont-1));
            end
            weighedEntries=currMag(index);
            featVect=[featVect sum(weighedEntries)];
        end
    end
end
if norm(featVect,1)==0
    hist=featVect;
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
indexEqual=find(flowAngle==pi);
flowAngle(indexEqual)=-pi;

end