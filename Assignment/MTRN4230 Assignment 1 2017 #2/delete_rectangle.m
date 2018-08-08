% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.

function handles = delete_rectangle(handles)

if handles.userdata.rectangle_idx < 1
    return;
end

rectangles = handles.userdata.rectangles;

valid_indices = 1:size(rectangles, 1) ~= handles.userdata.rectangle_idx;

handles.userdata.rectangles = rectangles(valid_indices, :);

handles.userdata.rectangle_idx = -1;
