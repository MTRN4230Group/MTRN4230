%Author:Vivek Desai
%Date: 03/06/2016
%Description : Check Reachability of chocolate centroids

function[reachable]=ReachableityCheck(x,y)

radius = 804-23;
center_x= 800;
center_y= 289;

reachable = ((x - center_x)^2 + (y - center_y)^2 < radius^2);
end
 