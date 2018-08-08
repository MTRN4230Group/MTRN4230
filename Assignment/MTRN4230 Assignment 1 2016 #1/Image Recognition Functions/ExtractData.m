%Author:Vivek Desai
%Date: 03/06/2016
%Description : Data extraction from matched points 

function[DetectedData]=ExtractData(matchedTemplatePoints,matchedWorkspacePoints,WorkspaceImage , ChocolateType,ShowImage,ChocOrBox)
%image output for debugging 
if (strcmp(ShowImage,'dont show'))
else
    figure(ChocolateType);  
    imshow(WorkspaceImage)
    hold on;
end
%initialise struct
DetectedData = [];

count=1;
while(1) %continue until all matched points are addressed 
     if ((matchedWorkspacePoints.Count== 0))
         break
     end
    [tform, ~, ~, status]= estimateGeometricTransform(matchedTemplatePoints, matchedWorkspacePoints,'similarity');
    %new coordinates for centroids and angle 
    Tinv  = tform.invert.T;

ss = Tinv(2,1);
sc = Tinv(1,1);
scaleRecovered = sqrt(ss*ss + sc*sc);
%limin scale change to reduce false detects
    if abs(scaleRecovered -1) >0.1
        break
    end
    %only proceed upto a max of 50 detections 
    if ((status ~= 0) || (matchedWorkspacePoints.Count<=3) || (count==50) )
         break
    end
    %determine dimensions depending on what is being detected 
    if ChocOrBox == 1 ;
    width = 177;
	height = 81;
    end
    if ChocOrBox == 0;
    width = 320;
	height = 180;
    end
    
    
    if (mod(width,2)==1)
        width = width+1;
    end

    if (mod(height,2)==1)
        height = height+1;
    end
     
	[rectangle,centroid]=Rectangle_Points(width,height,tform);
       
    [matchedWorkspacePoints,matchedTemplatePoints] = UpdateMatchedPoints(matchedWorkspacePoints,matchedTemplatePoints,rectangle);
    
	%centroid(1)=int16(centroid(1));
    %centroid(2)=int16(centroid(2));
    
if (strcmp(ShowImage,'dont show'))
else
    line(rectangle(:, 1), rectangle(:, 2), 'Color', 'b');
    plot(centroid(1),centroid(2),'-rx');
end

    
    Tinv  = tform.invert.T;

    ss = Tinv(2,1);
    sc = Tinv(1,1);
    theta = deg2rad(atan2(ss,sc)*180/pi);
     if (theta>pi)
         theta = pi-theta;
     end
%     
count = count+1;
 %  X    Y    Theta Length Width Flavour     1 = Reachable
reachable = ReachableityCheck(centroid(1),centroid(2));
%NewData = [(1600-centroid(1)) centroid(2) theta width height ChocolateType reachable ];
NewData = [(centroid(1)) centroid(2) theta ChocolateType ];
DetectedData = [DetectedData ; NewData];
end


end