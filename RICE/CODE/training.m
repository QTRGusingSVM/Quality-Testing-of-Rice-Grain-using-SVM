clc
clear all
close all

nsamples=5;
bTest=0;


createdb(nsamples,bTest)
load('grainsMat.mat')

% Load the training data into memory
xTrainImages = Container;
tTrain = Label;

%% Display some of the training images
% clf
% for i = 1:20
%     subplot(4,5,i);
%     imshow(xTrainImages{i});
% end

rng('default')
hiddenSize1 = 100;

autoenc1 = trainAutoencoder(xTrainImages,hiddenSize1, ...
    'MaxEpochs',200, ...
    'L2WeightRegularization',0.004, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.15, ...
    'ScaleData', false);



feat1 = encode(autoenc1,xTrainImages);

hiddenSize2 = 50;
autoenc2 = trainAutoencoder(feat1,hiddenSize2, ...
    'MaxEpochs',100, ...
    'L2WeightRegularization',0.002, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.1, ...
    'ScaleData', false);


feat2 = encode(autoenc2,feat1);

softnet = trainSoftmaxLayer(feat2,tTrain,'MaxEpochs',400);


%% displaying training phases
view(autoenc1)
view(autoenc2)
view(softnet)

deepnet = stack(autoenc1,autoenc2,softnet);
view(deepnet)