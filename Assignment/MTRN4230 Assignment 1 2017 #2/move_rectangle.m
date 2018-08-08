% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.

function handles = move_rectangle(handles, mouse_location)

if handles.userdata.rectangle_idx < 1
    return;
end

% if handles.userdata.shift
%     handles.userdata.move_mode = 'rotate';
% else
%     handles.userdata.move_mode = 'translate';
% end

if strcmp(handles.userdata.move_mode, 'translate')
    handles = translate_rectangle(handles, mouse_location);
elseif strcmp(handles.userdata.move_mode, 'rotate')
    handles = rotate_rectangle(handles, mouse_location);
end
