%Author:Vivek Desai
%Date: 03/06/2016
%Description : Image Detection Code
%This Function creates a template against which surf points will be
%compared for image detection.
function [TemplateData] =  CreateTemplateData()
clc ;
clear ;
close all ;

%the following lines load and convert sample images to a grayscale image
TemplateData.BWImages.MilkTop = struct('MilkTop1',rgb2gray(imread('MilkTop1.jpg')),'MilkTop2',rgb2gray(imread('MilkTop2.jpg')),'MilkTop3',rgb2gray(imread('MilkTop3.jpg')),'MilkTop4',rgb2gray(imread('MilkTop4.jpg')),'MilkTop5',rgb2gray(imread('MilkTop5.jpg')));
TemplateData.BWImages.MilkBack = struct('MilkBack1',rgb2gray(imread('MilkBack1.jpg')),'MilkBack2',rgb2gray(imread('MilkBack2.jpg')),'MilkBack3',rgb2gray(imread('MilkBack3.jpg')),'MilkBack4',rgb2gray(imread('MilkBack4.jpg')),'MilkBack5',rgb2gray(imread('MilkBack5.jpg')));
TemplateData.BWImages.DarkTop = struct('DarkTop1',rgb2gray(imread('DarkTop1.jpg')),'DarkTop2',rgb2gray(imread('DarkTop2.jpg')),'DarkTop3',rgb2gray(imread('DarkTop3.jpg')),'DarkTop4',rgb2gray(imread('DarkTop4.jpg')),'DarkTop5',rgb2gray(imread('DarkTop5.jpg')));
TemplateData.BWImages.MintTop = struct('MintTop1',rgb2gray(imread('MintTop1.jpg')),'MintTop2',rgb2gray(imread('MintTop2.jpg')),'MintTop3',rgb2gray(imread('MintTop3.jpg')),'MintTop4',rgb2gray(imread('MintTop4.jpg')),'MintTop5',rgb2gray(imread('MintTop5.jpg')));
TemplateData.BWImages.OrangeTop = struct('OrangeTop1',rgb2gray(imread('OrangeTop1.jpg')),'OrangeTop2',rgb2gray(imread('OrangeTop2.jpg')),'OrangeTop3',rgb2gray(imread('OrangeTop3.jpg')),'OrangeTop4',rgb2gray(imread('OrangeTop4.jpg')),'OrangeTop5',rgb2gray(imread('OrangeTop5.jpg')));
TemplateData.BWImages.NonMilkBack = struct('NonMilkBack1',rgb2gray(imread('NonMilkBack1.jpg')),'NonMilkBack2',rgb2gray(imread('NonMilkBack2.jpg')),'NonMilkBack3',rgb2gray(imread('NonMilkBack3.jpg')),'NonMilkBack4',rgb2gray(imread('NonMilkBack4.jpg')),'NonMilkBack5',rgb2gray(imread('NonMilkBack5.jpg')));
TemplateData.BWImages.Box = struct('Box1',rgb2gray((imread('Box1.jpg'))),'Box2',rgb2gray((imread('Box2.jpg'))));

%extraction of surf points from greyscale images 
T=50;
TemplateData.SurfPoints.MilkTop = struct('MilkTop1',{detectSURFFeatures(TemplateData.BWImages.MilkTop.MilkTop1,'MetricThreshold', T)},'MilkTop2',{detectSURFFeatures(TemplateData.BWImages.MilkTop.MilkTop2,'MetricThreshold', T)},'MilkTop3',{detectSURFFeatures(TemplateData.BWImages.MilkTop.MilkTop3,'MetricThreshold', T)},'MilkTop4',{detectSURFFeatures(TemplateData.BWImages.MilkTop.MilkTop4,'MetricThreshold', T)},'MilkTop5',{detectSURFFeatures(TemplateData.BWImages.MilkTop.MilkTop5,'MetricThreshold', T)});
TemplateData.SurfPoints.MilkBack = struct('MilkBack1',{detectSURFFeatures(TemplateData.BWImages.MilkBack.MilkBack1,'MetricThreshold', T)},'MilkBack2',{detectSURFFeatures(TemplateData.BWImages.MilkBack.MilkBack2,'MetricThreshold', T)},'MilkBack3',{detectSURFFeatures(TemplateData.BWImages.MilkBack.MilkBack3,'MetricThreshold', T)},'MilkBack4',{detectSURFFeatures(TemplateData.BWImages.MilkBack.MilkBack4,'MetricThreshold', T)},'MilkBack5',{detectSURFFeatures(TemplateData.BWImages.MilkBack.MilkBack5,'MetricThreshold', T)});
TemplateData.SurfPoints.DarkTop = struct('DarkTop1',{detectSURFFeatures(TemplateData.BWImages.DarkTop.DarkTop1,'MetricThreshold', T)},'DarkTop2',{detectSURFFeatures(TemplateData.BWImages.DarkTop.DarkTop2,'MetricThreshold', T)},'DarkTop3',{detectSURFFeatures(TemplateData.BWImages.DarkTop.DarkTop3,'MetricThreshold', T)},'DarkTop4',{detectSURFFeatures(TemplateData.BWImages.DarkTop.DarkTop4,'MetricThreshold', T)},'DarkTop5',{detectSURFFeatures(TemplateData.BWImages.DarkTop.DarkTop5,'MetricThreshold', T)});
TemplateData.SurfPoints.MintTop = struct('MintTop1',{detectSURFFeatures(TemplateData.BWImages.MintTop.MintTop1,'MetricThreshold', T)},'MintTop2',{detectSURFFeatures(TemplateData.BWImages.MintTop.MintTop2,'MetricThreshold', T)},'MintTop3',{detectSURFFeatures(TemplateData.BWImages.MintTop.MintTop3,'MetricThreshold', T)},'MintTop4',{detectSURFFeatures(TemplateData.BWImages.MintTop.MintTop4,'MetricThreshold', T)},'MintTop5',{detectSURFFeatures(TemplateData.BWImages.MintTop.MintTop5,'MetricThreshold', T)});
TemplateData.SurfPoints.OrangeTop = struct('OrangeTop1',{detectSURFFeatures(TemplateData.BWImages.OrangeTop.OrangeTop1,'MetricThreshold', T)},'OrangeTop2',{detectSURFFeatures(TemplateData.BWImages.OrangeTop.OrangeTop2,'MetricThreshold', T)},'OrangeTop3',{detectSURFFeatures(TemplateData.BWImages.OrangeTop.OrangeTop3,'MetricThreshold', T)},'OrangeTop4',{detectSURFFeatures(TemplateData.BWImages.OrangeTop.OrangeTop4,'MetricThreshold', T)},'OrangeTop5',{detectSURFFeatures(TemplateData.BWImages.OrangeTop.OrangeTop5,'MetricThreshold', T)});
B = 10;

TemplateData.SurfPoints.NonMilkBack = struct('NonMilkBack1',{detectSURFFeatures(TemplateData.BWImages.NonMilkBack.NonMilkBack1,'MetricThreshold', B)},'NonMilkBack2',{detectSURFFeatures(TemplateData.BWImages.NonMilkBack.NonMilkBack2,'MetricThreshold', B)},'NonMilkBack3',{detectSURFFeatures(TemplateData.BWImages.NonMilkBack.NonMilkBack3,'MetricThreshold', B)},'NonMilkBack4',{detectSURFFeatures(TemplateData.BWImages.NonMilkBack.NonMilkBack4,'MetricThreshold', B)},'NonMilkBack5',{detectSURFFeatures(TemplateData.BWImages.NonMilkBack.NonMilkBack5,'MetricThreshold', B)});

TemplateData.SurfPoints.Box = struct('Box1',{detectSURFFeatures(TemplateData.BWImages.Box.Box1,'MetricThreshold',T)},'Box2',{detectSURFFeatures(TemplateData.BWImages.Box.Box2,'MetricThreshold',T)});

%extraction of surf features from surf points for milk chocolate images 

[TemplateData.Features.MilkTop1,TemplateData.ValidPoints.MilkTop1] = extractFeatures(TemplateData.BWImages.MilkTop.MilkTop1,TemplateData.SurfPoints.MilkTop.MilkTop1);
[TemplateData.Features.MilkTop2,TemplateData.ValidPoints.MilkTop2] = extractFeatures(TemplateData.BWImages.MilkTop.MilkTop2,TemplateData.SurfPoints.MilkTop.MilkTop2);
[TemplateData.Features.MilkTop3,TemplateData.ValidPoints.MilkTop3] = extractFeatures(TemplateData.BWImages.MilkTop.MilkTop3,TemplateData.SurfPoints.MilkTop.MilkTop3);
[TemplateData.Features.MilkTop4,TemplateData.ValidPoints.MilkTop4] = extractFeatures(TemplateData.BWImages.MilkTop.MilkTop4,TemplateData.SurfPoints.MilkTop.MilkTop4);
[TemplateData.Features.MilkTop5,TemplateData.ValidPoints.MilkTop5] = extractFeatures(TemplateData.BWImages.MilkTop.MilkTop5,TemplateData.SurfPoints.MilkTop.MilkTop5);
%extraction of surf features from surf points for milk chocolate backs images 
[TemplateData.Features.MilkBack1,TemplateData.ValidPoints.MilkBack1] = extractFeatures(TemplateData.BWImages.MilkBack.MilkBack1,TemplateData.SurfPoints.MilkBack.MilkBack1);
[TemplateData.Features.MilkBack2,TemplateData.ValidPoints.MilkBack2] = extractFeatures(TemplateData.BWImages.MilkBack.MilkBack2,TemplateData.SurfPoints.MilkBack.MilkBack2);
[TemplateData.Features.MilkBack3,TemplateData.ValidPoints.MilkBack3] = extractFeatures(TemplateData.BWImages.MilkBack.MilkBack3,TemplateData.SurfPoints.MilkBack.MilkBack3);
[TemplateData.Features.MilkBack4,TemplateData.ValidPoints.MilkBack4] = extractFeatures(TemplateData.BWImages.MilkBack.MilkBack4,TemplateData.SurfPoints.MilkBack.MilkBack4);
[TemplateData.Features.MilkBack5,TemplateData.ValidPoints.MilkBack5] = extractFeatures(TemplateData.BWImages.MilkBack.MilkBack5,TemplateData.SurfPoints.MilkBack.MilkBack5);

%extraction of surf features from surf points for dark chocolate images 
[TemplateData.Features.DarkTop1,TemplateData.ValidPoints.DarkTop1] = extractFeatures(TemplateData.BWImages.DarkTop.DarkTop1,TemplateData.SurfPoints.DarkTop.DarkTop1);
[TemplateData.Features.DarkTop2,TemplateData.ValidPoints.DarkTop2] = extractFeatures(TemplateData.BWImages.DarkTop.DarkTop2,TemplateData.SurfPoints.DarkTop.DarkTop2);
[TemplateData.Features.DarkTop3,TemplateData.ValidPoints.DarkTop3] = extractFeatures(TemplateData.BWImages.DarkTop.DarkTop3,TemplateData.SurfPoints.DarkTop.DarkTop3);
[TemplateData.Features.DarkTop4,TemplateData.ValidPoints.DarkTop4] = extractFeatures(TemplateData.BWImages.DarkTop.DarkTop4,TemplateData.SurfPoints.DarkTop.DarkTop4);
[TemplateData.Features.DarkTop5,TemplateData.ValidPoints.DarkTop5] = extractFeatures(TemplateData.BWImages.DarkTop.DarkTop5,TemplateData.SurfPoints.DarkTop.DarkTop5);

%extraction of surf features from surf points for mint chocolate images 
[TemplateData.Features.MintTop1,TemplateData.ValidPoints.MintTop1] = extractFeatures(TemplateData.BWImages.MintTop.MintTop1,TemplateData.SurfPoints.MintTop.MintTop1);
[TemplateData.Features.MintTop2,TemplateData.ValidPoints.MintTop2] = extractFeatures(TemplateData.BWImages.MintTop.MintTop2,TemplateData.SurfPoints.MintTop.MintTop2);
[TemplateData.Features.MintTop3,TemplateData.ValidPoints.MintTop3] = extractFeatures(TemplateData.BWImages.MintTop.MintTop3,TemplateData.SurfPoints.MintTop.MintTop3);
[TemplateData.Features.MintTop4,TemplateData.ValidPoints.MintTop4] = extractFeatures(TemplateData.BWImages.MintTop.MintTop4,TemplateData.SurfPoints.MintTop.MintTop4);
[TemplateData.Features.MintTop5,TemplateData.ValidPoints.MintTop5] = extractFeatures(TemplateData.BWImages.MintTop.MintTop5,TemplateData.SurfPoints.MintTop.MintTop5);
%extraction of surf features from surf points for orage chocolate images 
[TemplateData.Features.OrangeTop1,TemplateData.ValidPoints.OrangeTop1] = extractFeatures(TemplateData.BWImages.OrangeTop.OrangeTop1,TemplateData.SurfPoints.OrangeTop.OrangeTop1);
[TemplateData.Features.OrangeTop2,TemplateData.ValidPoints.OrangeTop2] = extractFeatures(TemplateData.BWImages.OrangeTop.OrangeTop2,TemplateData.SurfPoints.OrangeTop.OrangeTop2);
[TemplateData.Features.OrangeTop3,TemplateData.ValidPoints.OrangeTop3] = extractFeatures(TemplateData.BWImages.OrangeTop.OrangeTop3,TemplateData.SurfPoints.OrangeTop.OrangeTop3);
[TemplateData.Features.OrangeTop4,TemplateData.ValidPoints.OrangeTop4] = extractFeatures(TemplateData.BWImages.OrangeTop.OrangeTop4,TemplateData.SurfPoints.OrangeTop.OrangeTop4);
[TemplateData.Features.OrangeTop5,TemplateData.ValidPoints.OrangeTop5] = extractFeatures(TemplateData.BWImages.OrangeTop.OrangeTop5,TemplateData.SurfPoints.OrangeTop.OrangeTop5);
%extraction of surf features from surf points for the back chocolate images 
[TemplateData.Features.NonMilkBack1,TemplateData.ValidPoints.NonMilkBack1] = extractFeatures(TemplateData.BWImages.NonMilkBack.NonMilkBack1,TemplateData.SurfPoints.NonMilkBack.NonMilkBack1);
[TemplateData.Features.NonMilkBack2,TemplateData.ValidPoints.NonMilkBack2] = extractFeatures(TemplateData.BWImages.NonMilkBack.NonMilkBack2,TemplateData.SurfPoints.NonMilkBack.NonMilkBack2);
[TemplateData.Features.NonMilkBack3,TemplateData.ValidPoints.NonMilkBack3] = extractFeatures(TemplateData.BWImages.NonMilkBack.NonMilkBack3,TemplateData.SurfPoints.NonMilkBack.NonMilkBack3);
[TemplateData.Features.NonMilkBack4,TemplateData.ValidPoints.NonMilkBack4] = extractFeatures(TemplateData.BWImages.NonMilkBack.NonMilkBack4,TemplateData.SurfPoints.NonMilkBack.NonMilkBack4);
[TemplateData.Features.NonMilkBack5,TemplateData.ValidPoints.NonMilkBack5] = extractFeatures(TemplateData.BWImages.NonMilkBack.NonMilkBack5,TemplateData.SurfPoints.NonMilkBack.NonMilkBack5);
%extraction of surf features from surf points for box images 
[TemplateData.Features.Box1,TemplateData.ValidPoints.Box1] = extractFeatures(TemplateData.BWImages.Box.Box1,TemplateData.SurfPoints.Box.Box1);
[TemplateData.Features.Box2,TemplateData.ValidPoints.Box2] = extractFeatures(TemplateData.BWImages.Box.Box2,TemplateData.SurfPoints.Box.Box2);
end

