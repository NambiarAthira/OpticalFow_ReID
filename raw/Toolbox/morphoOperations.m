
%% Morphological operations:

BW = im2bw(grad,0.3);                %# binarize image
se = strel('disk',25);
BW = imclose(BW,se);                 % close the image
% figure;imshow(BW)
  
cc = bwconncomp(BW)
st= regionprops(cc, 'BoundingBox'); % Set for Bounding box
figure, imshow(curIm); hold on
%    rectangle('Position',[st.BoundingBox(1),st.BoundingBox(2),st.BoundingBox(3),st.BoundingBox(4)],'EdgeColor','r','LineWidth',2 )
        for k = 1 : length(st)
          thisBB = st(k).BoundingBox;
          rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
          'EdgeColor','r','LineWidth',2 )
        end