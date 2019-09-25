function [rect,upper,lower]=BoundingBox(t,sc,U,V,curIm,BB)
switch BB
    case  'Opticflow'
%%  BB based on Optic flow:
        thresh=8
        [r,c]=find(abs(sc*U)>thresh|abs(sc*V)>thresh);   
        x_min=min(c)-1
        x_max=max(c)
        y_min=min(r)-1
        y_max=max(r)
        x_grid=size(curIm,2)/160
        y_grid=size(curIm,1)/120
        rect=[x_min*x_grid,y_min*y_grid,(x_max-x_min)*x_grid,(y_max-y_min)*y_grid];
        rectangle('Position',rect,'EdgeColor','r','LineWidth',2 );
        upper=[];
        lower=[];
%   Enable the following part if we wanna see the upper and lower torso cells
          upper=[rect(1) rect(2) rect(3) rect(4)/2];
          rectangle('Position',upper,'EdgeColor','b','LineWidth',2 );
          lower=[rect(1) (rect(2)+rect(4)/2) rect(3) rect(4)/2];
          rectangle('Position',lower,'EdgeColor','c','LineWidth',2 );
 
    case 'Groundtruth' 
%%  BB based on Groundtruth:
          M = csvread('frames2.txt',t,2);
%           M = csvread('testframe8.txt',t,2);
          rect=M(1,1:4);
          rectangle('Position',rect,'EdgeColor','r','LineWidth',2 );
          upper=[];
          lower=[];
% Enable the following part if we wanna see the upper and lower torso cells
%           upper=[rect(1) rect(2) rect(3) rect(4)/2];
%           rectangle('Position',upper,'EdgeColor','b','LineWidth',2 );
%           lower=[rect(1) (rect(2)+rect(4)/2) rect(3) rect(4)/2];
%           rectangle('Position',lower,'EdgeColor','c','LineWidth',2 );
 
end
end