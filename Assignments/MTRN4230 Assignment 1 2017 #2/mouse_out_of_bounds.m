% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.

function out_of_bounds = mouse_out_of_bounds(handles, mouse_location)

out_of_bounds = mouse_location(1) < 1 || ...
                mouse_location(1) > size(handles.userdata.image, 2) || ...
                mouse_location(2) < 1 || ...
                mouse_location(2) > size(handles.userdata.image, 1);
            