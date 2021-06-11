function RiceComVisionRT(vid,sizeKernel,Color,DiskSize)
%riceComvision mix two toolbox image toolbox with computer vision toolbox
%to read a  ral time image of a rice grain  to measure distance and average
%color to do quality control of the grain these algorith dont implement a
%signal output but can be implemented in subrutine
vid1 = vision.VideoFileReader(vid);
vido=vision.VideoFileReader(vid);
hp = vision.DeployableVideoPlayer;
war=vision.DeployableVideoPlayer;
finfo = info(vid1);
XVid=finfo.VideoSize;
%hvfw = vision.VideoFileWriter('vipmen1.avi','AudioInputPort',false,'FrameRate', finfo.VideoFrameRate);
  while vid1.isDone==0
          Original = step(vido);
          step(war,Original);
          [videoFrame , Original]=SubRutineIMRT(vid1,XVid,sizeKernel...
              ,Color,DiskSize);
          step(hp, videoFrame);
          %step(hvfw, videoFrame);
      vido.isDone==0;
  end
  release(hp);
  release(war);
 %release(vid0);
 %release(hvfw);