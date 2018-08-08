% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.

function handles = rotate_rectangle(handles, mouse_location)

rectangle = handles.userdata.rectangles(handles.userdata.rectangle_idx, :);

mouse_theta = atan2(mouse_location(2) - rectangle(2), ...
                    mouse_location(1) - rectangle(1));
                    
corners = get_rectangle_corners(rectangle, false);

selected_corner = corners(handles.userdata.corner_idx, :);

corner_theta = atan2(selected_corner(2) - rectangle(2), ...
                     selected_corner(1) - rectangle(1));

delta_theta = mouse_theta - corner_theta;
                
% prev_mouse_location = handles.userdata.previous_mouse_location;
% 
% prev_mouse_theta = atan2(prev_mouse_location(2) - rectangle(2), ...
%                          prev_mouse_location(1) - rectangle(1));
% 
% delta_theta = mouse_theta - prev_mouse_theta;

rectangle(3) = rectangle(3) + delta_theta;
while rectangle(3) >= pi
    rectangle(3) = rectangle(3) - 2*pi;
end
while rectangle(3) < -pi
    rectangle(3) = rectangle(3) + 2*pi;
end

handles.userdata.rectangles(handles.userdata.rectangle_idx, :) = rectangle;
