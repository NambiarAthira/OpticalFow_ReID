function [Homography ginputPoints] = computeHomography(CameraPoints, CameraImage)


%% Draw map image with indicators of where to click
% drawCorridor7thFloor(0); %draws in figure 1
% drawVascoGamaFloor;
drawCorridor8thFloor(0); %draws in figure 1
for i=1:size(CameraPoints,1)
    plot(CameraPoints(i,1),CameraPoints(i,2),'xk')
    text(CameraPoints(i,1)+0.2,CameraPoints(i,2)-0.2,int2str(i))    
end

%% Click on image in the same order as indicated in map
% Input:
%  - CameraPoints : (X,Y) points in plane of floor, in meters

figure(2); imshow(CameraImage)
title('Click on image in the same order as indicated in map image')
imgPoints = [] ; 
for i=1:size(CameraPoints,1)

    imgPoints(i,:) = [round(ginput(1)) 1] ;
    
    % Mark the point on the image
    hold on ;
    plot(imgPoints(i,1),imgPoints(i,2),'g.') ;
    hold off ;
end
ginputPoints = imgPoints;
%%-----------------------------------------------
%%
%% Compute the camera homography (code from Luis Tavares)
%%
if size(CameraPoints,2) ~= 3
    %adding the column of ones to make it homogeneous coordinates
    CameraPoints(:,3) = 1;
end

M = [] ; 
for i = 1:size(CameraPoints,1)
    M(i*2-1,:) = [-CameraPoints(i,:)   0 0 0             imgPoints(i,1)*CameraPoints(i,:)] ;
    M(i*2,:)   = [0 0 0	             -CameraPoints(i,:)	imgPoints(i,2)*CameraPoints(i,:)] ;
end

[vect val]      = eig(M'*M);
[minimo indice]	= min(diag(val));
res             = vect(:,indice)/vect(end,indice);
P               = [res(1:3)'; res(4:6)'; res(7:9)'];

invP=inv(P);
invP=invP./invP(3,3);

disp(invP);

save backupHomography.dat invP -ASCII -DOUBLE ; 
Homography = invP;

%%-----------------------------------------------
%%
%%   Show on the image where the world points are
%%  projected, given the homography
%%
hold on ;

for i = 1:size(CameraPoints,1)
    
    retro	= P*CameraPoints(i,:)' ;
    retro	= round(retro/retro(3)) ;
    plot(retro(1),retro(2),'b.') ;
end

hold off ;

%%-----------------------------------------------
%%
%%   Compute the homography error
%%

error = 0 ;

for i = 1:size(CameraPoints,1)
    directo	= inv(P)*imgPoints(i,:)' ;
    directo	= directo/directo(3) ;
    error = error + sqrt(sum((directo-CameraPoints(i,:)').^2))/size(CameraPoints,1) ;
end

disp(['--: Average projection error: ' num2str(error)]) ; 
