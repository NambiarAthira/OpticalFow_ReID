function [l root basepath camera_str filepath] = path_strings_LRM(folder_num, cam_num)

if strcmp(version, '7.7.0.471 (R2008b)') %linux in lab PC
    l = '/';
    root = ['/media/Elements/Work/LRMimages' l ];
else                                    %windows in laptop
    l = '\';
    root = ['F:\Work\LRMimages' ];
end

camera_strs = {
    'Camera1';
    'Camera2';
    'Camera3';
    'Camera4';
    'Camera5'; 
    'Camera6';
    'Camera7';
    'Camera8';
    'Camera9';
%     'CAMERA1';
%     'CAMERA2';
%     'CAMERA3';
%     'CAMERA4';
%     'CAMERA5';
%     'CAMERA6';
%     'CAMERA7';
%     'CAMERA8';
%     'CAMERA9';
%     'CAMERA10';
    };

folder_str = {
    ['LRM_groups1' ];
    ['LRM_groups2' ];
%     ['exp-robot-new' ];
%     ['expUrusX-robot' ];
%     ['hardPersonLoitoring' ];
%     ['matiasWalking' ];
%     ['tiagoSlowWalking' ];
    };

if folder_num > length(folder_str)
    display(['Too large folder num, max is ' int2str(length(folder_str)) ]);
    filepath = '';
    camera_str = '';
    basepath = '';
    return;
end

if cam_num > length(camera_strs)
    display(['Too large camera num, max is ' int2str(length(camera_strs)) ]);
    filepath = '';
    camera_str = '';
    basepath = '';
    return;
end

filepath = [root l folder_str{folder_num} l camera_strs{cam_num, :}];
% path = [root l exp_folder l camera_str]; %full path

detectionString = [filepath l 'numberFormatDetections' camera_strs{cam_num, :} '.txt'];

fid = fopen(detectionString);
if fid == -1
     display(['FAIL at opening path/file: ' detectionString]);
    filepath = '';
    camera_str = '';
    basepath = '';
    return;
else
     display(['Existing path: ' detectionString]);
    fclose(fid);
end

BmatString = [filepath l folder_str{folder_num} 'B.mat'];
fid3 = fopen([BmatString]);
if fid3 == -1
    display(['file ' camera_strs{cam_num, :} l folder_str{folder_num} 'B.mat does not exist.  !!!! FIX IT!']);
    filepath = '';
    camera_str = '';
    basepath = '';
    return;
else
    display(['Success opening : ' folder_str{folder_num} 'B.mat']);
    fclose(fid3);
end

camera_str = camera_strs{cam_num,:};
basepath = folder_str{folder_num};

end