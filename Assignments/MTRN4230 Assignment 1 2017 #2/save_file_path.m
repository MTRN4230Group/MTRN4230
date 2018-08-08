% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.

function [file_path, file_name] = save_file_path

[file_name, file_path] = uiputfile('*');

if file_name == 0
    file_path = [];
    file_name = [];
    return;
end
