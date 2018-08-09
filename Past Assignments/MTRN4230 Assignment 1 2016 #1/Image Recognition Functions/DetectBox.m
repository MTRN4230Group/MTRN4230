%Author:Vivek Desai
%Date: 03/06/2016
%Description : Detection sequence for detecting loading box
function[BoxStackData] =DetectBox(boximage , imagefeed)

close all 
clc
num = 0;
scannum = 0;
table = imread('emptyconveyor.jpg');
image = imread(boximage);
boximage = imsubtract(image,table);
imshow(boximage)

% load('Template.mat')

% if imagefeed == 1 
%     background_image = imread('emptytable.jpg');
% end
% if imagefeed == 2
%     background_image = imread('emptyconveyor.jpg');
% end

% boximage = imcomplement(imsubtract(background_image,boximage ));
BWWorkspaceImage = rgb2gray(boximage);

while (num==0 )
    if (scannum > 5)
        break
    end
WorkspaceSurfPoints = detectSURFFeatures(BWWorkspaceImage,'MetricThreshold',1000);
[WorkspaceFeatures,WorkspaceValidPoints] = extractFeatures(BWWorkspaceImage,WorkspaceSurfPoints);
TemplateData = CreateTemplateData();
a = 'dont show';
% Box
Thresh = 100;
Ratio = 1;

[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.Box1,WorkspaceValidPoints,TemplateData.ValidPoints.Box1,Thresh,Ratio);
[DetectedData_Box1]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,boximage,10 , a,0);

%Thresh = 100;
%Ratio = 1;

%[matchedTemplatePoints,matchedWorkspacePoints] = Feature_Matching(WorkspaceFeatures ,TemplateData.Features.Box2,WorkspaceValidPoints,TemplateData.ValidPoints.Box2,Thresh,Ratio);
%[DetectedData_Box2]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,boximage,10 , a,0)

DetectedData_Box= DetectedData_Box1;
%DetectedData_Box= [DetectedData_Box1;DetectedData_Box2];

[num,~]=size(DetectedData_Box);
if (num>1)
    c = num;
    while c~=1 
        [num2,~]=size(DetectedData_Box);
        for d = num2:-1:1
            dist = pdist([DetectedData_Box(c,1),DetectedData_Box(c,2);DetectedData_Box(d,1),DetectedData_Box(d,2)],'euclidean');
            if dist == 0
               dist = 1000;
            end;
            if dist < 13 && (DetectedData_Box(c,4)==DetectedData_Box(d,4))
               DetectedData_Box(d,:) = []; 
               break
            end
        end
        c = c-1;
    end
end

[num,~]=size(DetectedData_Box);
if num >0
    
   
%         BoxData.xpos =DetectedData_Box(:,1);
%         BoxData.ypos =DetectedData_Box(:,2);

    
    if imagefeed ==1 
        BoxData.xpos =DetectedData_Box(:,2)/1.51 +15;
        BoxData.ypos =DetectedData_Box(:,1)/1.51 +530;
    end
    
    if imagefeed == 2 
        BoxData.xpos =DetectedData_Box(:,2)/1.315 -393;
        BoxData.ypos =DetectedData_Box(:,1)/1.315 -326;
    end
    
    BoxData.theta =DetectedData_Box(:,3)*(180/pi);
    BoxData.type =DetectedData_Box(:,4);
end

    
%write_output_file(DetectedData_Box, image_file_name, output_file_path);
scannum = scannum+1;
end
    if num == 0

        BoxData.xpos = [];
        BoxData.ypos = [];
        BoxData.theta = [];
        BoxData.type= [];

    end
    BoxStackData = StackLocations(BoxData);
    scannum
end


function[BoxStackData] = StackLocations(BoxData)
%creation of stack locations within the box given box centroid and angle
%and dimensions 
    [num,~] = size(BoxData);
    theta = BoxData.theta-90;
    dx = 40*cos(theta);
    dy = 40*sin(theta);
    
        BoxStackData.Stack1.StackXpos = BoxData.xpos - 3*dx;
        BoxStackData.Stack2.StackXpos = BoxData.xpos - dx;
        BoxStackData.Stack3.StackXpos=BoxData.xpos + dx;
        BoxStackData.Stack4.StackXpos= BoxData.xpos + 3* dx;
        BoxStackData.Stack1.StackYpos = BoxData.ypos - 3*dy;
        BoxStackData.Stack2.StackYpos= BoxData.ypos - dy;
        BoxStackData.Stack3.StackYpos =BoxData.ypos +dy;
        BoxStackData.Stack4.StackYpos= BoxData.ypos + 3*dy;
        BoxStackData.Stack1.StackTheta = theta;
        BoxStackData.Stack2.StackTheta= theta;
        BoxStackData.Stack3.StackTheta=theta;
        BoxStackData.Stack4.StackTheta =theta;
        
    
end