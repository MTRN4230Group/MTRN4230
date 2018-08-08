%Author:Vivek Desai
%Date: 03/06/2016
%Description : Implementation of all other functions 

function[DetectedData] =DetectChocolates(WorkspaceImage,imagefeed)
close all 
clc

load('TemplateData.mat')
%load('Template.mat')

if imagefeed == 1 
    background_image = imread('emptytable.jpg');
end
if imagefeed == 2
    background_image = imread('emptyconveyor.jpg');
end
%imshow(WorkspaceImage)
WorkspaceImage = imcomplement(imsubtract(background_image,WorkspaceImage )); 
BWWorkspaceImage = rgb2gray(WorkspaceImage);

WorkspaceSurfPoints = detectSURFFeatures(BWWorkspaceImage,'MetricThreshold',100);
% WorkspaceSurfPoints = detectSURFFeatures(BWWorkspaceImage,'MetricThreshold',100, 'ROI', [1 260 1600 905]);
[WorkspaceFeatures,WorkspaceValidPoints] = extractFeatures(BWWorkspaceImage,WorkspaceSurfPoints);
a = 'dont show';
%b = 'show';

% %Milk
Thresh = 1.35;
Ratio = .4;
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.MilkTop2,WorkspaceValidPoints,TemplateData.ValidPoints.MilkTop2,Thresh,Ratio);
[DetectedData_MilkTop2]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,1 , a,1);
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.MilkTop3,WorkspaceValidPoints,TemplateData.ValidPoints.MilkTop3,Thresh,Ratio);
[DetectedData_MilkTop3]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,1 , a,1);
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.MilkTop5,WorkspaceValidPoints,TemplateData.ValidPoints.MilkTop5,Thresh,Ratio);
[DetectedData_MilkTop5]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,1 , a,1);

DetectedData_MilkTop= [DetectedData_MilkTop2;DetectedData_MilkTop3;DetectedData_MilkTop5];

% %Dark
Thresh = 10;
Ratio = .3;
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.DarkTop2,WorkspaceValidPoints,TemplateData.ValidPoints.DarkTop2,Thresh,Ratio);
[DetectedData_DarkTop2]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,2 , a,1);
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.DarkTop3,WorkspaceValidPoints,TemplateData.ValidPoints.DarkTop3,Thresh,Ratio);
[DetectedData_DarkTop3]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,2 , a,1);
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.DarkTop5,WorkspaceValidPoints,TemplateData.ValidPoints.DarkTop5,Thresh,Ratio);
[DetectedData_DarkTop5]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,2, a,1);

DetectedData_DarkTop= [DetectedData_DarkTop2;DetectedData_DarkTop3;DetectedData_DarkTop5];

% %Orange
Thresh = 2.5;
Ratio = .3;
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.OrangeTop2,WorkspaceValidPoints,TemplateData.ValidPoints.OrangeTop2,Thresh,Ratio);
[DetectedData_OrangeTop2]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,3 , a,1);
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.OrangeTop3,WorkspaceValidPoints,TemplateData.ValidPoints.OrangeTop3,Thresh,Ratio);
[DetectedData_OrangeTop3]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,3 , a,1);
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.OrangeTop4,WorkspaceValidPoints,TemplateData.ValidPoints.OrangeTop4,Thresh,Ratio);
[DetectedData_OrangeTop4]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,3 , a,1);

DetectedData_OrangeTop= [DetectedData_OrangeTop2;DetectedData_OrangeTop3;DetectedData_OrangeTop4;];
  
% % %Mint
Thresh = 10;
Ratio = .3;

[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.MintTop2,WorkspaceValidPoints,TemplateData.ValidPoints.MintTop2,Thresh,Ratio);
[DetectedData_MintTop2]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,4 , a,1);
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.MintTop3,WorkspaceValidPoints,TemplateData.ValidPoints.MintTop3,Thresh,Ratio);
[DetectedData_MintTop3]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,4 , a,1);
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.MintTop4,WorkspaceValidPoints,TemplateData.ValidPoints.MintTop4,Thresh,Ratio);
[DetectedData_MintTop4]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,4 , a,1);

DetectedData_MintTop= [DetectedData_MintTop2;DetectedData_MintTop3;DetectedData_MintTop4];
 
%MilkBack
Thresh = 3;
Ratio = .5;

[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.MilkBack2,WorkspaceValidPoints,TemplateData.ValidPoints.MilkBack2,Thresh,Ratio);
[DetectedData_MilkBack2]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,5 , a,1);
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.MilkBack3,WorkspaceValidPoints,TemplateData.ValidPoints.MilkBack3,Thresh,Ratio);
[DetectedData_MilkBack3]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,5 , a,1);
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.MilkBack4,WorkspaceValidPoints,TemplateData.ValidPoints.MilkBack4,Thresh,Ratio);
[DetectedData_MilkBack4]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,5 , a,1);

DetectedData_MilkBack= [DetectedData_MilkBack2;DetectedData_MilkBack3;DetectedData_MilkBack4];

% %NonMilkBack
Thresh = 30;
Ratio = .95;

[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.NonMilkBack1,WorkspaceValidPoints,TemplateData.ValidPoints.NonMilkBack1,Thresh,Ratio);
[DetectedData_NonMilkBack1]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,5 , a,1);

Thresh = 15;
Ratio = 1;

[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.NonMilkBack2,WorkspaceValidPoints,TemplateData.ValidPoints.NonMilkBack2,Thresh,Ratio);
[DetectedData_NonMilkBack2]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,5 , a,1);
[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.NonMilkBack5,WorkspaceValidPoints,TemplateData.ValidPoints.NonMilkBack5,Thresh,Ratio);
[DetectedData_NonMilkBack5]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage,5 , a,1);

DetectedData_NonMilkBack= [DetectedData_NonMilkBack1;DetectedData_NonMilkBack2;DetectedData_NonMilkBack5];

DetectedData = [DetectedData_MilkTop;DetectedData_DarkTop;DetectedData_OrangeTop;DetectedData_MintTop;DetectedData_MilkBack;DetectedData_NonMilkBack];

%remove double detects 
[num,~]=size(DetectedData)
if (num>1)
    c = num;
    while c~=1 
        [num2,~]=size(DetectedData)
        for d = num2:-1:1
            dist = pdist([DetectedData(c,1),DetectedData(c,2);DetectedData(d,1),DetectedData(d,2)],'euclidean');
            if dist == 0
               dist = 1000;
            end;
            if dist < 13 && (DetectedData(c,4)==DetectedData(d,4))
               DetectedData(d,:) = []; 
               break
            end
        end
        c = c-1;
    end
end



end


