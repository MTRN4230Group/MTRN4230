% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.
% Julie Tang 2017.

function handles = init_userdata(handles)

handles.userdata.mouse_down = false;

handles.userdata.image = [];
handles.userdata.image_handle = [];
handles.userdata.image_file_name = [];
handles.userdata.image_file_path = [];

handles.userdata.rectangles = [];
handles.userdata.current_rectangle_handle = [];
handles.userdata.rectangles_handle = [];
handles.userdata.rectangle_idx = -1;
handles.userdata.rectangle_x_idx = 1;
handles.userdata.rectangle_y_idx = 2;
handles.userdata.rectangle_theta_idx = 3;
handles.userdata.rectangle_shape = 0;
handles.userdata.rectangle_shape_idx = 5;
handles.userdata.rectangle_colour = 0;
handles.userdata.rectangle_colour_idx = 4;
handles.userdata.rectangle_uppersurface = 0;
handles.userdata.rectangle_uppersurface_idx = 6;
handles.userdata.rectangle_reachable = 1;
handles.userdata.rectangle_reachable_idx = 7;

handles.userdata.minimum_association_distance = 500;

handles.userdata.move_mode = 'translate';
handles.userdata.corner_idx = -1;

handles.userdata.show_text = 'all';

handles.userdata.shift = false;
handles.userdata.control = false;

handles.userdata.previous_mouse_location = [];

handles.userdata.zoom = 'off';
