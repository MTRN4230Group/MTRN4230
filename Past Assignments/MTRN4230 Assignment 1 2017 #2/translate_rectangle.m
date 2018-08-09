% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.

function handles = translate_rectangle(handles, mouse_location)

handles.userdata.rectangles(handles.userdata.rectangle_idx, 1:2) = ...
    mouse_location;
