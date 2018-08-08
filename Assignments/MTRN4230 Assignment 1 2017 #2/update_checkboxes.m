% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.
% Julie Tang 2017

function handles = update_checkboxes(handles)

if handles.userdata.rectangle_idx < 1
    return;
end

set(handles.shapelistbox, 'Value', handles.userdata.rectangles( ...
    handles.userdata.rectangle_idx, ...
    handles.userdata.rectangle_shape_idx)+1);

set(handles.colourlistbox, 'Value', handles.userdata.rectangles( ...
    handles.userdata.rectangle_idx, ...
    handles.userdata.rectangle_colour_idx)+1);

set(handles.reachablecheckbox, 'Value', handles.userdata.rectangles( ...
    handles.userdata.rectangle_idx, ...
    handles.userdata.rectangle_reachable_idx));
