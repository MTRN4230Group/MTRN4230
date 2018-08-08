%Author:Vivek Desai
%Date: 03/06/2016
%Description : creation of rectangle points for plotting and centroid/angle data 
function[rectangle,centroid]=Rectangle_Points(width,height,tform)
   
    corner1 = [0,0];
    corner2 = [width, 0];
    corner3= [width,height];
    corner4 = [0, height];

    rectangle = [corner1;corner2;corner3;corner4;corner1];
    centroid = [width/2,height/2];
    rectangle = transformPointsForward(tform, rectangle);
    centroid = transformPointsForward(tform, centroid); 
    
end
