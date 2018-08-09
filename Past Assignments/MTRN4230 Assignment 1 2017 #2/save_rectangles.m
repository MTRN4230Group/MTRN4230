% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.
% Julie Tang 2017.

function save_rectangles(handles)

% [file_path, file_name] = save_file_path;
rect_data = handles.userdata.rectangles;
inverted_ids = (rect_data(:,handles.userdata.rectangle_shape_idx) == 0) | ...
(rect_data(:,handles.userdata.rectangle_colour_idx) == 0)   ;
rect_data(inverted_ids, handles.userdata.rectangle_uppersurface_idx) = 2;
rect_data(inverted_ids, handles.userdata.rectangle_colour_idx) = 0;
rect_data(inverted_ids, handles.userdata.rectangle_shape_idx) = 0;
rect_data(~inverted_ids, handles.userdata.rectangle_uppersurface_idx) = 1;
handles.userdata.rectangles = rect_data;


image_file_path = handles.userdata.image_file_path;
text_file_path = [image_file_path(1:(strfind(image_file_path, '.')-1)), ...
    '.txt'];

fid = fopen(text_file_path, 'w');

fprintf(fid, 'image_file_name:\n');
fprintf(fid, '%s\n', handles.userdata.image_file_name);
fprintf(fid, ' rectangles:\n');
fprintf(fid, ...
        [repmat('%f ', 1, size(handles.userdata.rectangles, 2)), '\n'], ...
        handles.userdata.rectangles');

fclose(fid);
