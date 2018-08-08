% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.

function listbox_value = get_listbox_value(handles)

listbox_contents = cellstr(get(handles.actionlistbox, 'String'));
listbox_value = listbox_contents(get(handles.actionlistbox, 'Value'));
