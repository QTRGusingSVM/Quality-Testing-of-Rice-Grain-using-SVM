function RiceComVisionSF(vid,sizeKernel,Color,DiskSize)
%riceComvision mix two toolbox image toolbox with computer vision toolbox
%to read a  ral time image of a rice grain  to measure distance and average
%color to do quality control of the grain these algorith dont implement a
%signal output but can be implemented in subrutine
vid1 = vision.VideoFileReader(vid);
vido=vision.VideoFileReader(vid);
warning('off','vision:transition:usesOldCoordinates');
hp = vision.DeployableVideoPlayer;
%war=clone(hp);
finfo = info(vid1);
XVid=finfo.VideoSize;
%hvfw = vision.VideoFileWriter('vipmen1.avi','AudioInputPort',false,'FrameRate', finfo.VideoFrameRate);
  for i=1:10
          [videoFrame , Original]=SubRutineIMSF(vid1,XVid,sizeKernel,Color,DiskSize);
          step(hp, videoFrame);
          %step(war,Original);
          %step(hvfw, videoFrame);
      %f=vido.isDone==0
      pause(1);
  end
  release(hp);
  %release(war);
 %release(vid0);
 %release(hvfw);