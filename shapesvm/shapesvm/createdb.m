function [Container,Label]=createdb(nsamples,bTest)

disp('creating data base')
if nargin==0 %default value
    nsamples=8;
    bTest = 0;
elseif nargin < 2
    bTest = 0;
end
img=imread('C:\Users\HP\Desktop\PROJECT_RICE\RICE GRAIN\CODE\TRAINING IMAGES\1.jpg');
[imgRow,imgCol]=size(img);



if bTest == 0 
        strPath='C:\Users\HP\Desktop\PROJECT_RICE\RICE GRAIN\CODE\TRAINING IMAGES\';
else
        strPath='C:\Users\HP\Desktop\PROJECT_RICE\RICE GRAIN\CODE\TRAINING IMAGES\';
end
disp('Process Started');
for i = 1:nsamples
    strpath=strcat(strPath,num2str(i),'.jpg');
    I=imread(strpath);
I = imresize(I,[16,16]);
mask = zeros(size(I));

for xi = 1:size(I,1)
    for yi = 1:size(I,2)
        if (I(xi,yi)>130)
            mask(xi,yi) =1;
        else
            mask(xi,yi) =0;
        end
    end
end
se = strel('disk',1);
I2 = imclose(mask,se);


BW_filled = imfill(I2,'holes');
Container{i}= BW_filled(:,:,1);

end

    Label=double([1 1 1 1 1 0 0 0;0 0 0 0 0 1 1 1]);

save('grainsMat.mat', 'Container','Label');
disp('process end');



