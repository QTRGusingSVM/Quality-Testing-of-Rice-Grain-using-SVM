function [Container,Label]=createdb(nsamples,bTest)
%addpath('\curvlets');
%block=4;
% Container = [];
disp('creating data base')
if nargin==0 %default value
    nsamples=5;
    bTest = 0;
elseif nargin < 2
    bTest = 0;
end
img=imread('D:\ECE\B.Tech\SUCCESS TECHONOLOGY\IMAGE PROCESSING\RICE GRAIN\CODE\TRAINING IMAGES\1.jpg');
[imgRow,imgCol]=size(img);



if bTest == 0 
        strPath='D:\ECE\B.Tech\SUCCESS TECHONOLOGY\IMAGE PROCESSING\RICE GRAIN\CODE\TRAINING IMAGES\';
else
        strPath='D:\ECE\B.Tech\SUCCESS TECHONOLOGY\IMAGE PROCESSING\RICE GRAIN\CODE\TRAINING IMAGES\';
end
disp('Process Started');
for i = 1:nsamples
    strpath=strcat(strPath,num2str(i),'.jpg');
    I1=imread(strpath);
    IR = imresize(I1(:,:,1),[32,32]);
    IG = imresize(I1(:,:,2),[32,32]);
    IB = imresize(I1(:,:,2),[32,32]);
    
    I = zeros(32,32,3);
    I(:,:,1) = IR;
    I(:,:,2) = IG;
    I(:,:,3) = IB;
    
%% PREPROCESSING STAGE -1 Gray conversion
GI = rgb2gray(I);
GI = imresize(GI,[32,32]);
%% PREPROCESSING STAGE -2 Extracting Grain Features
BGI = imopen(GI,strel('disk',15));
%% PREPROCESSING STAGE -3 Optimization
I2 = GI - BGI;
% I2(:,:,2) = I(:,:,2) - BGI;
% I2(:,:,3) = I(:,:,3) - BGI;


%% PREPROCESSING STAGE -4 Gray Color adjustment
I3 = imadjust(I2);

%% PREPROCESSING STAGE -5 Back Ground subtraction
level = graythresh(I3);
bw = im2bw(I3,level);
bw = bwareaopen(bw, 50);
bwg = zeros(32,32);
for ii = 1:size(bw,1)
    for j = 1:size(bw,2)
        if bw(ii,j) == 1
            bwg(ii,j)=0;
        else
            bwg(ii,j)=100;
        end
    end
end
I(:,:,1) = I(:,:,1) - bwg;
I(:,:,2) = I(:,:,2) - bwg;
I(:,:,3) = I(:,:,3) - bwg;


figure,imshow(I);
Container{i}= I;


end

    Label=double([1 1 1 1 1;0 0 0 0 0]);

save('grainsMat.mat', 'Container','Label');
disp('process end');



