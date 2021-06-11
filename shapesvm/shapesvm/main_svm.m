clc
clear all
close all

%% image read
I = imread('rice image.jpg');
figure(1), imshow(I), title('INPUT IMAGE');

%% PREPROCESSING STAGE -1 Gray conversion
GI = rgb2gray(I);
figure(2), imshow(GI), title('GRAY IMAGE');

%% PREPROCESSING STAGE -2 Extracting Grain Features
BGI = imopen(GI,strel('disk',15));
figure(3), imshow(BGI), title('BINARY IMAGE');
%% PREPROCESSING STAGE -3 Optimization
I2 = GI - BGI;
% I2(:,:,2) = I(:,:,2) - BGI;
% I2(:,:,3) = I(:,:,3) - BGI;

figure(4), imshow(I2), title('DATA EXTRACTED IMAGE');

%% PREPROCESSING STAGE -4 Gray Color adjustment
I3 = imadjust(I2);
figure(5),imshow(I3),title('Gray Color Adjusted Image');


%% PREPROCESSING STAGE -5 Back Ground subtraction
level = graythresh(I3);
bw = im2bw(I3,level);
bw = bwareaopen(bw, 50);
figure(6),imshow(bw),title('Binary Image');
Ibw (:,:,1) = bw;
Ibw (:,:,2) = bw;
Ibw (:,:,3) = bw;

bwg = zeros(453,439);
for i = 1:size(bw,1)
    for j = 1:size(bw,2)
        if bw(i,j) == 1
            bwg(i,j)=0;
        else
            bwg(i,j)=255;
        end
    end
end

I4(:,:,1) = I(:,:,1) - uint8(bwg);
I4(:,:,2) = I(:,:,2) - uint8(bwg);
I4(:,:,3) = I(:,:,3) - uint8(bwg);
figure(7),imshow(I4),title('Background Subtracted Image');



%% PREPROCESSING STAGE - 6 Feature Extraction for SVM classification process
I5 = zeros(size(I4));
I6 = zeros(size(I4));
for i = 1:size(I4,1)
    for j = 1:size(I,2)
        if(I4(i,j,1)>85 && I4(i,j,1) <= 200 && I4(i,j,2) > 34 && I4(i,j,2) <=210 && I4(i,j,3) > 15 && I4(i,j,3)<=190)
            I5(i,j,1) = I4(i,j,1);
            I5(i,j,2) = I4(i,j,2);
            I5(i,j,3) = I4(i,j,3);
        else
            I5(i,j,:) = I5(i,j,:);
        end
        if(I4(i,j,1)>200 && I4(i,j,1) <= 255 && I4(i,j,2) > 210 && I4(i,j,2) <=255 && I4(i,j,3) > 190 && I4(i,j,3)<=255)
            I6(i,j,1) = I4(i,j,1);
            I6(i,j,2) = I4(i,j,2);
            I6(i,j,3) = I4(i,j,3);
        else
            I6(i,j,:) = I6(i,j,:);
        end
        
    end
end

BW1(:,:,1) = edge(Ibw(:,:,1));
BW1(:,:,2) = edge(Ibw(:,:,2));
BW1(:,:,3) = edge(Ibw(:,:,3));

I7 = imclearborder(I5);
I8 = imclearborder(I6);
I9 = Ibw-I6-I8-BW1;
I10 = I6-I7-BW1;
figure(8),imshow(I9),title('Red Grains Image');
figure(9),imshow(I10),title('White Grains Image');
se = strel('disk',5);
II1(:,:,1)= imopen(I9(:,:,1),se);
II1(:,:,2)= imopen(I9(:,:,2),se);
II1(:,:,3)= imopen(I9(:,:,3),se);
figure(10),imshow(II1),title('Red Grains Image');

s = regionprops(II1(:,:,1), 'Centroid');
imshow(II1(:,:,1))
hold on
for k = 1:numel(s)
    c = s(k).Centroid
    text(c(1), c(2), sprintf('%d', k), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end
hold off
% Step 3: find the area of the object you want using its label
Obj = (II1(:,:,1) == 255) ;  % 1 is the label number of the first object. 
Area = regionprops(Obj,'Area'); % the answer
%% SVM TRAINING

xi(:,1) = reshape(I10(:,:,1),[size(I10,1)*size(I10,2),1]);
xi(:,2) = reshape(II1(:,:,1),[size(II1,1)*size(II1,2),1]);
yi=[1;0];
% svm_red = svmtrain(xi,yi,'showplot','true');
% svm_white = svmtrain(xi,yi','showplot','true');
% 
% 
% 
%% SVM CLASSIFICATION

for r=1:size(I,1)
    for c=1:size(I,2)
        red = I4(r,c,1);
        green = I4(r,c,2);
        blue = I4(r,c,3);
        if(c == 1 && mod(r,50) == 0)
            svm_img = reshape(double(I4(:,:,1)),[size(I10,1)*size(I10,2),1]);
            cred = svmclassify(svm_red,double(svm_img'));
            cwit = svmclassify(svm_white,double(svm_img'));
            class=sum(yi~= cred);
            total_class = [cred; cwit];
            length_red = length(find(total_class == 0));
            length_white = length(find(total_class == 1));
             if(length_red>length_white)
                red = 255
                green = 0;
                blue = 0;
             elseif(length_red<length_white)
                red = 255;
                green = 255
                blue = 255;
             else
                red = I4(r,c,1);
                green = I4(r,c,2);
                blue = I4(r,c,3);
                
             end
        end
        
        I4(r,c,1) = red; %Cotton in Red Color
        I4(r,c,2) = green; %Wheat in Green Color
figure,
        I4(r,c,3) = blue; %Gram in Blue Color
    end
end


imshow(I4);
title('Classified Image ');