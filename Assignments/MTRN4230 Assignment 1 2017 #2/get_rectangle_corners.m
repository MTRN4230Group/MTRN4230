% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.
% Julie Tang 2017.

function corners = get_rectangle_corners(rect, loop)

x = rect(1);
y = rect(2);
theta = rect(3);
width = 50;
height = 50;

rot = [cos(theta), -sin(theta);
       sin(theta),  cos(theta)];

top_right    = [ width/2;  height/2];
top_left     = [-width/2;  height/2];
bottom_left  = [-width/2; -height/2];
bottom_right = [ width/2; -height/2];

centre = [x; y];

top_right    = rot*top_right    + centre;
top_left     = rot*top_left     + centre;
bottom_left  = rot*bottom_left  + centre;
bottom_right = rot*bottom_right + centre;

corners = [top_right'; top_left'; bottom_left'; bottom_right'];

if loop
    corners = [corners; top_right'];
end
