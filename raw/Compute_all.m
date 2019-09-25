for fold_numba = 1:2
%     if fold_numba == 1
%         rabo = 3:10;
%     else
        rabo = 1:9;
%     end
    for cam_numba = rabo
        
        [l root exp_folder camera_str path] = path_strings_LRM(fold_numba, cam_numba);
        if ~strcmp(path,'')
            run MainMfile;
        end
    end
end
