clc
close all
clear all

MainImg = imread('2.jpg');
figure,imshow(MainImg);
title('INPUT IMAGE')
I = rgb2gray(MainImg);

I2 = imtophat(I, strel('disk', 10));
figure,imshow(I2);
title('MORPHOLOGICAL FILTERED IMAGE')
mor=I2;
% SI2 = imtophat(I, strel('disk', 5));


level = graythresh(I2);
BW = im2bw(I2,level);
%%D = -st(~BW);
D(~BW) = -Inf;
L = watershed(D);
%%figure,imshow(label2rgb(L,'jet','w'))
%%title('OBJECTS DETECTION');
L = watershed(imcomplement(I));
 I2 = imcomplement(I);
I3 = imhmin(I2,100); %20 is the height threshold for suppressing shallow minima
% L = watershed(I3);
  figure,imshow(I2)
title('SHARPENING');
  figure,imshow(I3)
title('FILTERING');



imagen=I2;

if size(imagen,3)==3 % RGB image
    imagen=rgb2gray(imagen);
end
%% Convert to binary image
threshold = 0.3;%graythresh(imagen);
imagen =~im2bw(imagen,threshold);
%% Remove all object containing fewer than 30 pixels
imagen = bwareaopen(imagen,1);
pause(1)
%% Show image binary image
figure,imshow(imagen);
title('GRAINS DETECTION WITH BLACK AND WHITE')
figure,
imshow(~imagen);
title('GRAINS DETECTION')
%% Label connected components
[ff, Ne]=bwlabel(imagen);
%% Measure properties of image regions
propied=regionprops(ff,'BoundingBox');
 prop=regionprops(ff,'Area','Centroid');
xi=[0;1];
 yi=[1;0];
hold on
 
for n=1:size(propied,1)
 
    po=rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2);
 
end
hold off
pause (1)
 
figure
for n=1:Ne
    [r,c] = find(ff==n);
    n1=imagen(min(r):max(r),min(c):max(c));
     
end
svip=size(propied,1);
imshow(~imagen);
hold on

 

 svop = svmtrain(xi,yi,'showplot','true');


 cwit = svmclassify(svop, (xi));



         for n=1:Ne
     [r,c] = find(L==n);
 n1=imagen(min(r):max(r),min(c):max(c));
 ddare(n)=prop(n).Area;
       
 

 if(ddare(n)<470)
 
    po=rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2);
title('SHAPE BASED SEGREGATION USING SVM');

 else
     po=rectangle('Position',propied(n).BoundingBox,'EdgeColor','r','LineWidth',2);
title('SHAPE BASED SEGREGATION USING SVM');
     
 end
         end
         
         
         

  



