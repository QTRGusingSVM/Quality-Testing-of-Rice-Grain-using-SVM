clc
clear all
close all

%% image read
%%[fname, path] = uigetfile('*.*','Enter an image');
%%fname = strcat(path,fname);
%%I = imread(fname);
I = imread('rice image.jpg');
figure(1),imshow(I), title('INPUT IMAGE');

%% PREPROCESSING STAGE -1 Gray conversion
GI = rgb2gray(I); %%Coverting RGB image to Grayscale Image
figure(2), imshow(GI), title('GRAY IMAGE');

%% PREPROCESSING STAGE -2 Extracting Grain Features
BGI = imopen(GI,strel('disk',15)); %%Performs Morphologically Opening with a Disk-Shaped Structuring Element of 15 pixels
figure(3), imshow(BGI), title('BINARY IMAGE');
%% PREPROCESSING STAGE -3 Optimization
I2 = GI - BGI; 
% I2(:,:,2) = I(:,:,2) - BGI;
% I2(:,:,3) = I(:,:,3) - BGI;

figure(4), imshow(I2), title('DATA EXTRACTED IMAGE');

%% PREPROCESSING STAGE -4 Gray Color adjustment
I3 = imadjust(I2); %% Maps the intensity values in the grayscale image I2 to the new values in I3
figure(5),imshow(I3),title('GRAY COLOR ADJUSTED IMAGE');


%% PREPROCESSING STAGE -5 Back Ground subtraction
level = graythresh(I3); %%Computes a global threshold T from grayscale image I3, using otsu's image
bw = im2bw(I3,level); %%Converts the graysacle image to binary image. 1 - White, 0 - Black 
bw = bwareaopen(bw, 50); %%Removes all connected components that have fewer than 50 pixels from the binary image.
figure(6),imshow(bw),title('BINARY IMAGE');
bwg = zeros(453,439); %%Creates a array of zeros
for i = 1:size(bw,1)
    for j = 1:size(bw,2)
        if bw(i,j) == 1
            bwg(i,j)=0;
        else
            bwg(i,j)=100;
        end
    end
end
I4(:,:,1) = I(:,:,1) - uint8(bwg);%%Unit8 is unsigned 8 bit character, Contains all the whole numbers from 0 to 255.
I4(:,:,2) = I(:,:,2) - uint8(bwg);
I4(:,:,3) = I(:,:,3) - uint8(bwg);
figure(7),imshow(I4),title('BACKGROUND SUBSTRACTED IMAGE');

%% PREPROCESSING STAGE - 6 Feature Extraction for SVM classification process
I5 = zeros(size(I4));
I6 = zeros(size(I4));
for i = 1:size(I4,1)
    for j = 1:size(I,2)
        if(I4(i,j,1)>85 && I4(i,j,1) <= 240 && I4(i,j,2) > 34 && I4(i,j,2) <=220 && I4(i,j,3) > 15 && I4(i,j,3)<=200)
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
    

figure(8),imshow(I5),title('RED GRAINS IMAGE');
figure(9),imshow(I6),title('WHITE GRAINS IMAGE');


%% SVM TRAINING

svm_red = svmtrain(double([I5(1:50) I5(51:100)]),[ones([1 50]) (ones([1 50])*2)]);
svm_white = svmtrain(double(I6(1:100)),[ones([1 50]) (ones([1 50])*3)]);



%% SVM CLASSIFICATION

for r=1:size(I,1)
    for c=1:size(I,2)
         red = I4(r,c,1);
        green = I4(r,c,2);
        blue = I4(r,c,3);
        if(c == 1 && mod(r,50) == 0)
            svm_img = I4(r:r+49);
            cred = svmclassify(svm_red,double(svm_img'));
            cwhite = svmclassify(svm_white,double(svm_img'));
            total_class = [cred; cwhite];
            length_red = length(find(total_class == 1));
            length_white = length(find(total_class == 2));
            if(length_red>length_white)
                red = 255;
                green = 0;
                blue = 0;
            elseif(length_white>length_red)
                red = 255;
                green = 255;
                blue = 255;
            else
                red = I4(r,c,1);
                green = I4(r,c,2);
                blue = I4(r,c,3);
                
            end
        end
        
        I4(r,c,1) = red; %Cotton in Red Color
        I4(r,c,2) = green; %Wheat in Green Color
        I4(r,c,3) = blue; %Gram in Blue Color
    end
end


figure,
imshow(I4);
title('CLASSIFIED IMAGE');