function [cont i] = reject(camera_str, B, i, lab)
cont = 0;

if strcmp(lab, 'BarcelonaImages') && B(i,8) < -1 %yy outside of campus
    disp(['Detection ' int2str(i) ' with yy=' num2str(B(i,8)) ' outside of campus.']);
    pause(0.1);
    B(i,11) = -1; i=i+1; cont = 1; return;
end

% CameraA6-1
if strcmp(camera_str , 'CameraA6-1')
    l1 = [1 137 47 265];
    l2 = [375 449 55 57];
    l3 = [487 497 279 289];
    l4 = [135 153 333 409];
    % CameraA6-1
    if B(i,2) > l1(1) && B(i,2) < l1(2) && B(i,3) > l1(3) && B(i,3) < l1(4)
        hold on
        rectangle('Position',[l1(1), l1(3), l1(2)-l1(1), l1(4)-l1(3)],'LineWidth',3,'EdgeColor','r');
        drawnow;
        hold off,
        B(i,11) = -1; i=i+1; cont = 1; return;
    elseif B(i,2) > l2(1) && B(i,2) < l2(2) && B(i,3) > l2(3) && B(i,3) < l2(4)
        hold on
        rectangle('Position',[l2(1), l2(3), l2(2)-l2(1), l2(4)-l2(3)],'LineWidth',3,'EdgeColor','r');
        drawnow;
        hold off,
        B(i,11) = -1; i=i+1; cont = 1; return;
    elseif B(i,2) > l3(1) && B(i,2) < l3(2) && B(i,3) > l3(3) && B(i,3) < l3(4)
        hold on
        rectangle('Position',[l3(1), l3(3), l3(2)-l3(1), l3(4)-l3(3)],'LineWidth',3,'EdgeColor','r');
        drawnow;
        hold off,
        B(i,11) = -1; i=i+1; cont = 1; return;
    elseif B(i,2) > l4(1) && B(i,2) < l4(2) && B(i,3) > l4(3) && B(i,3) < l4(4)
        hold on; rectangle('Position',[l4(1), l4(3), l4(2)-l4(1), l4(4)-l4(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [519 529 71 137];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [535 639 20 100];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
end

% CameraA6-4
if strcmp(camera_str , 'CameraA6-4')
    %                    l = [290 321 150 401];
    %                     if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
    %                         hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
    %                         B(i,11) = -1; i=i+1; cont = 1; return;
    %                     end
    %                     l = [175 225 367 425];
    %                     if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
    %                         hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
    %                         B(i,11) = -1; i=i+1; cont = 1; return;
    %                     end
    %                     l = [95 121 207 225];
    %                     if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
    %                         hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
    %                         B(i,11) = -1; i=i+1; cont = 1; return;
    %                     end
end

% CameraA6-5
if strcmp(camera_str , 'CameraA6-5')
    if B(i,8) > 11
        disp(['Detection ' int2str(i) ' with yy=' num2str(B(i,8)) ' inside of wall.']);
        hold on; text(B(i,2),B(i,3),'Wall', 'Color', 'r', 'FontSize',18); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
end

%camera A6-8
if strcmp(camera_str , 'CameraA6-8')
    l1 = [375 393 7 9];
    l2 = [367 385 71 73];
    if B(i,2) > l1(1) && B(i,2) < l1(2) && B(i,3) > l1(3) && B(i,3) < l1(4)
        hold on; rectangle('Position',[l1(1), l1(3), l1(2)-l1(1), l1(4)-l1(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    if B(i,2) > l2(1) && B(i,2) < l2(2) && B(i,3) > l2(3) && B(i,3) < l2(4)
        hold on; rectangle('Position',[l2(1), l2(3), l2(2)-l2(1), l2(4)-l2(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l3 = [183 201 7 9];
    if B(i,2) > l3(1) && B(i,2) < l3(2) && B(i,3) > l3(3) && B(i,3) < l3(4)
        hold on; rectangle('Position',[l3(1), l3(3), l3(2)-l3(1), l3(4)-l3(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [7 9 55 57];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [159 169 31 33];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
end

%camera A6-9
if strcmp(camera_str , 'CameraA6-9')
    l = [471 505 255 305];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [359 361 263 265];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [367 369 239 273];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [343 345 191 193];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [350 540 140 348];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [1 479 1 100];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [190 273 130 161];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
end

%camera B6-5
%                 if strcmp(camera_str , 'CameraB6-5')
%                     l = [210 599 1 479];
%                     if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
%                         hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
%                         B(i,11) = -1; i=i+1; cont = 1; return;
%                     end
%                     l = [7 97 7 73];
%                     if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
%                         hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
%                         B(i,11) = -1; i=i+1; cont = 1; return;
%                     end
%                     l = [63 281 120 353];
%                     if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
%                         hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
%                         B(i,11) = -1; i=i+1; cont = 1; return;
%                     end
%                     l = [271 281 111 185];
%                     if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
%                         hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
%                         B(i,11) = -1; i=i+1; cont = 1; return;
%                     end
%                 end

%camera B6-6
if strcmp(camera_str , 'CameraB6-6')
    l = [1 600 1 320];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [15 73 55 81];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [580 593 335 337];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [170 257 310 337];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
end

%camera B6-7
if strcmp(camera_str , 'CameraB6-7')
    l = [1 640 1 300];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
    l = [120 130 340 350];
    if B(i,2) > l(1) && B(i,2) < l(2) && B(i,3) > l(3) && B(i,3) < l(4)
        hold on; rectangle('Position',[l(1), l(3), l(2)-l(1), l(4)-l(3)],'LineWidth',3,'EdgeColor','r'); drawnow; hold off;
        B(i,11) = -1; i=i+1; cont = 1; return;
    end
end


end