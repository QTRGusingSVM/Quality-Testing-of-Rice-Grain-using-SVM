function [f,Original]=SubRutineIMRT(vid,XVid,sizeKernel,Color,DiskSize)
%% subrutineIm calculate the boundarys of a figure content in a variable 
% vid (video) and  Xvid (information of the image) and return a variable f
%(image with boundary ,size and color evaluation)
%
%all the supressed imshow are for internal testing if something wrong
%happend you can check ativating each one
%% acquire image frae from video
videoFrame = step(vid);
%Original=videoFrame;
Im=videoFrame;
Original=videoFrame;
%imshow(Im);
%% Thresholding the image on each color plane
Im= im2double(Im);
%imshow(Im);
[r c p]=size(Im);
imR=squeeze(Im(:,:,1));
%imshow(imR);
imG=squeeze(Im(:,:,2));
%imshow(imG);
imB=squeeze(Im(:,:,3));
%imshow(imB);


imBinaryR=im2bw(imR,graythresh(imR));
%imshow(imBinaryR);
imBinaryG=im2bw(imG,graythresh(imG));
%imshow(imBinaryG);
imBinaryB=im2bw(imB,graythresh(imB));
%imshow(imBinaryB);
imBinary=imcomplement(imBinaryR&imBinaryG&imBinaryB);
imBinary=imcomplement(imBinary);
%imshow(imBinary);
%% Morphologial opening 
%strel put a disck of value 2 inside common region inf the disk didt fix
%the zone is eliminate to adjust zones it just to ajust the number
se=strel('disk',DiskSize);
imClean=imopen(imBinary,se);
%imshow(imClean);
%% Fill Holes and clear border
%clean border and holes
imClean=imfill(imClean,'holes');
imClean=imclearborder(imClean);
%imshow(imClean);
%% segmented gray label image
[labels, numLabels]=bwlabel(imClean);
%disp(['Number of objects detected:' num2str(numLabels)]);
%% initializate matrices
rLabel=zeros(r,c);
gLabel=zeros(r,c);
bLabel=zeros(r,c);
AC=zeros(1,numLabels);
%% establish the parameters of average colour

for i=1:numLabels
    imR(labels==i)=median(imR(labels==i));
    A1=median(imR(labels==i));
    imG(labels==i)=median(imG(labels==i));
    A2=median(imG(labels==i));
    imB(labels==i)=median(imB(labels==i));
    A3=median(imB(labels==i));
    AC(1,i)=(A1+A2+A3)/3;
end

% image that content zones with average color 
%Concatenate arrays along specified dimension
%videoFrame=cat(3,imR,imG,imB);
for it=1:20
        for jt=1:20
        videoFrame(it,jt,1)=Color(1,1);
        videoFrame(it,jt,2)=Color(1,2);
        videoFrame(it,jt,3)=Color(1,3);
        end
end
for al=1:numLabels
    for it=(20*al+1):(20*al+20)
        for jt=1:20
            videoFrame(it,jt,1)=AC(1,al);
            videoFrame(it,jt,2)=AC(1,al);
            videoFrame(it,jt,3)=AC(1,al);
        end
    end
end
    
%imshow(videoFrame);
%impixelinfo(gcf);
%% Boundaries
% algorith to print boundary of image and create a matrix to stablish the
% lenght
 %imshow(Aux);
[B,L,N] = bwboundaries(imClean);
%imshow(videoFrame); hold on;
dis=zeros(1,length(B));
for d=1:length(B);
    boundary = B{d};
    [xmax,ymax]=size(boundary);
    Auxiliar=zeros(XVid(1,2),XVid(1,1));
    for x=1:xmax;
       %videoFrame(boundary(x,1),boundary(x,2),1)=0.9;
       Auxiliar(boundary(x,1),boundary(x,2))=1;
       %videoFrame(boundary(x,1),boundary(x,2),2)=0;
       %videoFrame(boundary(x,1),boundary(x,2),3)=0;
       %videoFrame((boundary(x,1)+1),(boundary(x,2)+1),1)=0.9;
       %videoFrame((boundary(x,1)-1),(boundary(x,2)-1),1)=0.9;
        
    end
    for it=1:XVid(1,2)
        for jt=1:XVid(1,1)
            if Auxiliar(it,jt)==1;
                MAXPoint=[jt it];
                it=XVid(1,2);jt=XVid(1,1);
                
            end
        end
    end
    
   for it=XVid(1,2):-1:1
        for jt=XVid(1,1):-1:1
            if Auxiliar(it,jt)==1;
                MinPoint=[jt it];
                it=XVid(1,2);jt=XVid(1,1);
                
            end
        end
    end
%% insert lines in the image    
    hshapeins = vision.ShapeInserter( ...
                'Shape', 'Lines', ...
                'BorderColor', 'Custom', ...
                'CustomBorderColor', [0 200 0], ...
                'Antialiasing', true);
dis(1,d)=sqrt((MAXPoint(1,1)-MinPoint(1,1))^2+(MAXPoint(1,2)-MinPoint(1,2))^2);
Pts = [MAXPoint(1,1) MAXPoint(1,2) MinPoint(1,1) MinPoint(1,2)];
videoFrame = step(hshapeins,videoFrame, Pts);

%insert the text Good.... if the image is good
      %H = vision.TextInserter('Good!');
 %H.Color = [0 0 1];
 %H.FontSize = 24;
 %H.Location = [20 20];
 %T = vision.TextInserter('Bad!');
 %T.Color = [0 1 0];
 %T.FontSize = 24;
 %T.Location = [20 20];
 %videoFrame=step(H,videoFrame);
     %imshow(videoFrame);
     %imshow(Auxiliar);
end
text=0;
%% measure if one of the distance detected if ok if is not ok flag is on
for d=1:length(B);
    if dis(1,d)<=sizeKernel
    text=text+1;
    end
end
%if text>0   
    %H = vision.TextInserter('Bad!');
    %H.Color = [0 1 0];
    %H.FontSize = 24;
    %H.Location = [20 20];
    %videoFrame=step(H,videoFrame);
%end
    
%imshow(videoFrame);


%% assembling movie

f=videoFrame;











