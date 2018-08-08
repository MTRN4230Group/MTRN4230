% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.
% Julie Tang 2017.

function handles = draw_rectangles(handles)

% image = handles.userdata.image;
rectangles = handles.userdata.rectangles;

% imshow(image);
axis xy;

h = zoom(handles.imageaxes);
set(h, 'Enable', handles.userdata.zoom);

all_corners = [];
current_corners = [];

for rect_idx = 1:size(rectangles, 1)
    
    rect = rectangles(rect_idx, :);
    
    corners = get_rectangle_corners(rect, true);
    
    directed_corners = zeros(6, 2);
    directed_corners(1:4,:) = corners(1:4,:);
    delta_corners = corners(4,:) - corners(3,:);
    directed_corners(5,:) = mean(corners(4:5,:),1) + delta_corners/5;
    directed_corners(6,:) = corners(5,:);
    corners = directed_corners;
    
    if rect_idx == handles.userdata.rectangle_idx
        current_corners = corners;
    else
        all_corners = [all_corners; corners; [nan, nan]];
    end
    
end
  
if isempty(handles.userdata.rectangles_handle) && ~isempty(all_corners)
    hold on;
    handles.userdata.rectangles_handle = plot(all_corners(:,1), all_corners(:,2), 'r');
    hold off;
elseif ~isempty(all_corners)
    set(handles.userdata.rectangles_handle, 'XData', all_corners(:,1), 'YData', all_corners(:,2));
else
    set(handles.userdata.rectangles_handle, 'XData', nan, 'YData', nan);
end

if isempty(handles.userdata.current_rectangle_handle) && ~isempty(current_corners)
    hold on;
    handles.userdata.current_rectangle_handle = plot(current_corners(:,1), current_corners(:,2), 'g');
    hold off;
elseif ~isempty(current_corners)
    set(handles.userdata.current_rectangle_handle, 'XData', current_corners(:,1), 'YData', current_corners(:,2));
else
    set(handles.userdata.current_rectangle_handle, 'XData', nan, 'YData', nan);
end

reachable_points_x = linspace(-856, 856, 1000);
reachable_points_y = sqrt(856^2 - reachable_points_x.^2);
reachable_points_y = 1200 - reachable_points_y;
reachable_points_x = reachable_points_x + size(handles.userdata.image, 2)/2;

hold on;
plot(reachable_points_x, reachable_points_y, '-b');
hold off;
