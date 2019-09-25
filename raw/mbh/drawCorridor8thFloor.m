function drawCorridor8thFloor(IP)

%draws map of the corridors of 8th floor and coffee room
%connects lines between all points which are corners

%error: the wall in the end of elevator's hall should not be diagonal, but
%straight. not sure why it isn't, repeated all the measurements at the hall
%and found no measurement errors  

WallsMeasuredByTiago = [
    -12.488	7.844
	-12.488	4.894
	-12.396	4.894
	-12.396	-0.222
	-7.179	-0.222
	-7.179	-0.13
	-6.279	-0.13
	-6.279	-0.222
	-5.74	-0.222
	-5.74	-0.13
	-4.966	-0.13
	-4.966	-0.222
	-2.832	-0.222
	-2.832	-0.13
	-2.058	-0.13
	-2.058	-0.222
	0       -0.222
	0       -0.1300
    0.268	-0.1300
    0.268	-0.0560 
    % Inside of LRM Lab
	0.268	0
	0       0
	0       12.71
	-10.214	12.71
	-10.214	19.77
	7.38	19.77 %The x value used to be 6.996, but after measure again, I got the value of 7.38m.
	7.38	0
% 	6.996	-0.056 % DUNNO WTF MEASUREMENT IS THIS
    % It's 1.69 in X from the Wall to the line in the floor, and then it's
    % 2,01 meters to the next line, and 2 meters to the next, and 2 meters
    % to the wall
    
    % Outside of LRM Lab
    1.846	0
    %     	1.846	-0.0560 % DUNNO WTF MEASUREMENT IS THIS
    1.846	-0.1300
    1.866	-0.1300
    1.866	-0.2220
    1.940	-0.2220
    1.940	-1.8000
    1.866	-1.8000
    1.866	-1.9040
    1.093	-1.9040
    1.093	-1.9780
    0.225	-1.9780
    0.225	-1.9040
    -4.191	-1.9040
    %Update area near the door
    -4.191  -1.979
    -5.021  -1.979
    -5.021  -2.019
    -4.191  -2.019
    -4.191  -2.949
    %%
    %-4.191	-1.9780
	%-4.191	-2.051
	%-4.16	-2.051
	%-4.16	-2.034
	%-4.109	-2.034
	%-4.109	-2.969
	-4.01	-2.949
	-4.01	-2
	-0.176	-2
	-0.176	-7.948
	-6.123	-7.948
	-6.123	-2.034
	-5.804	-2.034
	-5.804	-2.051
	-5.773	-2.051
   	-5.773	-1.9780
   	-5.773	-1.9040
   	-7.886	-1.9040
   	-7.886	-1.9780
   	-8.754	-1.9780
   	-8.754	-1.9040
  	-10.892	-1.9040
  	-10.892	-1.9780
  	-11.764	-1.9780
  	-11.764	-1.9040
	-13.138	-1.9040
  	-13.138	-1.9780
 	-14.006	-1.9780
  	-14.006	-1.904
	-14.102	-1.904
	-14.102	-1.8
	-14.176	-1.8
	-14.176	-0.214
	-14.102	-0.214
	-14.102	1.597
	-14.176	1.597
	-14.176	2.469
	-14.102	2.469
	-14.102	4.595
	-14.176	4.595
	-14.176	5.471
	-14.102	5.471
	-14.102	7.605
	-14.176	7.605
	-14.176	8.477
	-14.102	8.477
	-14.102	9.824
	-14.176	9.824
	-14.176	10.684
	-14.102	10.684
	-14.102	12
	-14.056	12
	-14.056	12.074
	-12.484	12.074
	-12.484	12
	-12.438	12
	-12.438	10.73
	-12.575	10.73
	-12.575	10.597
	-12.438	10.597
	-12.438	10.502
	-12.552	10.435
	-12.438	10.435
	-12.438	10.343
	-12.038	10.343
	-12.038	10.452
	-11.992	10.452
	-11.992	10.427
	-11.134	10.427
	-11.134	10.452
	-10.769	10.452
	-10.769	9.895
	-9.519	9.895
	-9.519	10.452
	-7.367	10.452
	-7.206	7.575
	-7.926	7.575
	-7.926	7.272
	-8.103	7.272
	-8.103	7.204
	-8.5665	7.204
	-8.5665	7.164
	-9.12	7.164
	-9.12	7.272
	-9.207	7.272
	-9.207	7.575
	-9.862	7.575
	-9.862	7.272
	-9.949	7.272
	-9.949	7.164
	-10.5025 7.164
	-10.5025 7.204
	-11.056	7.204
	-11.056	7.272
	-11.143	7.272
	-11.143	7.575
	-11.896	7.575
	-11.896	7.844
	-12.396	7.844
	-12.488	7.844
];

try
    close 1 %closing figure 1 to re-plot without worry about Hold on
catch       %inside a try-catch because Matlab stops with an error if you 
end         %try to close a figure that doesn't exist
figure(8), hold on
p = WallsMeasuredByTiago;
for i=1:size(p,1)-1
	line([p(i,1),p(i+1,1)], [p(i,2),p(i+1,2)]);
end
axis equal

littleWhitePlasticThingNearFloor = [
    1.9    0
    1.9    0.05
    7      0.05       % wall at X~7m ? seems to be bad measured
];
p = littleWhitePlasticThingNearFloor; % calha
for i=1:size(p,1)-1
	line([p(i,1),p(i+1,1)], [p(i,2),p(i+1,2)]);
end

WhiteArmario = [
    0.065       1.74
    0.61+0.065  1.74
    0.61+0.065  1.74+3.41
    0.065       1.74+3.41
];
p = WhiteArmario;
for i=1:size(p,1)-1
	line([p(i,1),p(i+1,1)], [p(i,2),p(i+1,2)]);
end

ClosedDoor = [
    1.08        0
    1.846       0
    1.846       -0.035
    1.08        -0.035            
    1.08        0
];
p = ClosedDoor;
for i=1:size(p,1)-1
	plot([p(i,1); p(i+1,1)], [p(i,2); p(i+1,2)],'Color', [210 105 30]/255);
end

GreyLinesOnFloor = [
    1.69    0;
    1.69    19.77-0.05;
    3.7     0+0.05;
    3.7     19.77-0.05;
    5.7     0+0.05;
    5.7     19.77-0.05;
];
p = GreyLinesOnFloor;
for i=1:2:size(p,1)-1
	plot([p(i,1); p(i+1,1)], [p(i,2); p(i+1,2)],'Color', [0.7 0.7 0.7]);
end


% Measurements taken 11 and 12/Jun/2012, mesuring the estimated position of the
% camera sensor (at the end of the black camera objective)
%    X (m)          Y(m)                    Height (m)  IP      Location
%                                               10.10.2.X
Cameras = [
    -0.78           -0.33                   2.19        59      43;
    -12.4+0.715     -0.33                   2.25        19      40;
    -14.1+0.115     4.595-0.12              2.25        20      37;
    -14.1+0.12      12-0.20                 2.25        34      NaN;%No location on map, nearest location is 36
    -12.04+0.19     10.45-0.17              2.25        40      35;
    -0.176-0.28     -7.948-0.09             2.35        18      46;
    -6.123+0.15     -7.948+0.14             2.32        57      47;
    3.79            6.47                    2.28        58     NaN;%No location on map
    5.92            6.54                    2.28        56     NaN;%No location on map
    3.7+0.05        6.47+3.07+2.0+2-0+0.37  2.28        54     NaN;%No location on map
    3.7+1.88        6.47+3.07+2.0+2-0+0.54  2.28        50     NaN;%No location on map
    -7.64-0.93      19.24-1.45              2.28        51     NaN;%No location on map
    -7.64-0.98      13.24+1.26              2.28        53     NaN;%No location on map
    5.58+1.8        14.08+0.74              2.28        55     NaN;%No location on map
    ];
plot(Cameras(:,1),Cameras(:,2), '*r')
if ~exist('IP','var') || IP
    for i=find(Cameras(:,4)~=0)'
        text(Cameras(i,1)+.2,Cameras(i,2)-.2, ['IP' int2str(Cameras(i,4))])% ' Loc' int2str(Cameras(i,5))])
    end
end

% Brown Duct tape rectangles added 12/Jun/2012
MarcadoresNoChao = [ 
    1.69            3; 
    1.69            6; 
    1.69            6.47; 
    3.7             6.47; 
    1.69            9.47; 
    ];
% Orange Markers in the ground, as old as LRM is
MarcadoresNoChaoLaranja = [
    1.69            10; 
    3.7             6.47+3.07; 
    3.7             6.47+3.07+2.0; 
    3.7             6.47+3.07+2.0+2.0; 
    3.7+0.82        6.47+3.07+2.0+2.0+1.0; 
    3.7+1.35        6.47+3.07+2.0+1.12; 
];

%Yellow duct tape
MarcadoresNoChaoAmarelo = [
    3.7             16.33;
    3.7             17.29;
    3.7             18.47;
    -2.019          -4.109;
    -5.629          -4.739;
];

plot(MarcadoresNoChao(:,1),MarcadoresNoChao(:,2), 's', 'Color', [205 133 63]/255)
plot(MarcadoresNoChaoLaranja(:,1),MarcadoresNoChaoLaranja(:,2), 'd', 'Color', [1 0.5 0])
plot(MarcadoresNoChaoAmarelo(:,1),MarcadoresNoChaoAmarelo(:,2), 'x', 'Color', 'y')

SmallSquareNearRobotParking = [
    4.12    16.29;
    4.35    16.29;
    4.35    16.52;
    4.12    16.52;
    4.12    16.29;
];

p = SmallSquareNearRobotParking;
for i=1:size(p,1)-1
	line([p(i,1),p(i+1,1)], [p(i,2),p(i+1,2)],'Color','k');
end


FootballFieldContour = [
    1.41    13.24;
    -1.58   13.24;
    -4.61   13.24;
    -7.64   13.24;
    -7.64   19.24;
    1.41    19.24;
    1.41    13.24
 ];

p = FootballFieldContour;
for i=1:size(p,1)-1
	line([p(i,1),p(i+1,1)], [p(i,2),p(i+1,2)],'Color','k');
end

BigArea = [
    -5.82     19.24;
    -5.82     17.54;
    -0.4      17.54;
    -0.4      19.24;
    -5.82     19.24;
];

p = BigArea;
for i=1:size(p,1)-1
	line([p(i,1),p(i+1,1)], [p(i,2),p(i+1,2)],'Color','k');
end

SmallArea = [
    -4.87   19.24;
    -4.87   18.49;
    -1.37   18.49;
    -1.37   19.24;
];

p = SmallArea;
for i=1:size(p,1)-1
	line([p(i,1),p(i+1,1)], [p(i,2),p(i+1,2)],'Color','k');
end