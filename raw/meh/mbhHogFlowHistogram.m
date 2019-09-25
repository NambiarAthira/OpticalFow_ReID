function [hist] = mbhHogFlowHistogram(vx,vy,meanVel)
% Receives flow of an image, assumes flow is already subtracted of the mean
% "velocity"
% Receives mean velocity of the detection, so we normalize the histogram of
% the flow directions by the velocity direction

hist=[];
if(meanVel == 0)
    display('Box didnt move, not computing features')
    return;
end

%%% Lines below commented out because of feature alignment 22/01/2014
% flowMagnitude = sqrt(vx.^2+vy.^2);
% checkFlow=sum(sum(flowMagnitude))/(size(flowMagnitude,1)*size(flowMagnitude,1));
% if checkFlow < 0.0000001
%     display('Zero flow');
%     return;
% end


%removing noisy flow values with a median filter
% vx = medfilt2(vx,[5 5]);
% vy = medfilt2(vy,[5 5]);
flowXRemovedVel = vx - meanVel(1);
flowYRemovedVel = vy - meanVel(2);
[linesFlow colsFlow]=size(vx);

for i=2:linesFlow-1
    for j=2:colsFlow-1
        gradFlowXMag(i-1,j-1)=sqrt((flowXRemovedVel(i+1,j)-flowXRemovedVel(i-1,j))^2+(flowXRemovedVel(i,j+1)-flowXRemovedVel(i,j-1))^2);
        gradFlowXOri(i-1,j-1)=atan2(-flowXRemovedVel(i+1,j)+flowXRemovedVel(i-1,j),flowXRemovedVel(i,j+1)-flowXRemovedVel(i,j-1));
        gradFlowYMag(i-1,j-1)=sqrt((flowYRemovedVel(i+1,j)-flowYRemovedVel(i-1,j))^2+(flowYRemovedVel(i,j+1)-flowYRemovedVel(i,j-1))^2);
        gradFlowYOri(i-1,j-1)=atan2(-flowYRemovedVel(i+1,j)+flowYRemovedVel(i-1,j),flowYRemovedVel(i,j+1)-flowYRemovedVel(i,j-1));
    end;
end;


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

subImageSizeX = floor(size(gradFlowXMag,1)/3);
subImageSizeY = floor(size(gradFlowXMag,2)/3);

for i=1:3
    for j=1:3
        currAngle = gradFlowXOri((i-1)*subImageSizeX+1:i*subImageSizeX,(j-1)*subImageSizeY+1:j*subImageSizeY);
        currMag = gradFlowXMag((i-1)*subImageSizeX+1:i*subImageSizeX,(j-1)*subImageSizeY+1:j*subImageSizeY);
        for cont=2:length(anglesDelta)
            index=(currAngle*180/pi<anglesDelta(cont) & currAngle*180/pi>=anglesDelta(cont-1));
            weighedEntries=currMag(index);
            featVect=[featVect sum(weighedEntries)];
        end
    end
end
for i=1:3
    for j=1:3
        currAngle = gradFlowYOri((i-1)*subImageSizeX+1:i*subImageSizeX,(j-1)*subImageSizeY+1:j*subImageSizeY);
        currMag = gradFlowYMag((i-1)*subImageSizeX+1:i*subImageSizeX,(j-1)*subImageSizeY+1:j*subImageSizeY);
        for cont=2:length(anglesDelta)
            index=(currAngle*180/pi<anglesDelta(cont) & currAngle*180/pi>=anglesDelta(cont-1));
            weighedEntries=currMag(index);
            featVect=[featVect sum(weighedEntries)];
        end
    end
end
if norm(featVect,1)==0
    hist=featVect;
    display('Not norm');
    %display('Zero flow, not computing features')
    %return;
else
    hist=featVect;
    %%%Separate normalization of the two images (grad flow x and grad flow
    %%%y
%     featVectLength=length(featVect);
%     if norm(featVect(1:featVectLength/2))==0
%         norm1=zeros(1,featVectLength/2);
%     else
%         norm1=featVect(1:featVectLength/2)./norm(featVect(1:featVectLength/2));
%     end
%     if norm(featVect(featVectLength/2+1:end))==0
%         norm2 =zeros(1,featVectLength/2);
%     else
%         norm2=featVect(featVectLength/2+1:end)./norm(featVect(featVectLength/2+1:end));
%     end
%     hist=[norm1 norm2];
    %normalization of the whole vector
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