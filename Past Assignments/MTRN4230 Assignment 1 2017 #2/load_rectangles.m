% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.

function handles = load_rectangles(handles, file_path, file_name)

fid = fopen([file_path, file_name]);

line = fgetl(fid);
while ischar(line)
    
    if ~isempty(strfind(line, 'image_file_name'))
        line = fgetl(fid);
        handles.userdata.image_file_name = strrep(line, '\n', '');
        image_file_path = [file_path, handles.userdata.image_file_name];
        handles.userdata.image_file_path = image_file_path;
        handles.userdata.image = imread(image_file_path);
    elseif ~isempty(strfind(line, 'rectangles'))
        line = fgetl(fid);
        rectangles = [];
        while ischar(line)
            rectangles = [rectangles; sscanf(line, '%f')'];
            line = fgetl(fid);
        end
        handles.userdata.rectangles = rectangles;
    end
    
    line = fgetl(fid);
    
end
