
clc
%% image read
close all
clear all
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
bwg = zeros(453,439);
for i = 1:size(bw,1)
    for j = 1:size(bw,2)
        if bw(i,j) == 1
            bwg(i,j)=0;
        else
            bwg(i,j)=100;
        end
    end
end
I4(:,:,1) = I(:,:,1) - uint8(bwg);
I4(:,:,2) = I(:,:,2) - uint8(bwg);
I4(:,:,3) = I(:,:,3) - uint8(bwg);
figure(7),imshow(I4),title('Background Subtracted Image');

drawnow;

    y = deepnet(imresize(I4(:,:,1),[256,256]));
    y(isnan(y))=0;
    if (sum(y(1,:))>=0.5)
        redChannel = rgbImage(:,:, 1);
        greenChannel = rgbImage(:,:, 2);
        blueChannel = rgbImage(:,:, 3);
        % Specify the color we want to make this area.
        desiredColor = [255, 0, 0]; % RED
        % Make the red channel that color
        redChannel(MM) = desiredColor(1);
        greenChannel(MM) = desiredColor(2);
        blueChannel(MM) = desiredColor(3);
    end



rgbImage = cat(3, redChannel, greenChannel, blueChannel);
% Display the image.
figure,
imshow(rgbImage);
title('Image with color inside the mask region');