% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.

function handles = find_nearest_rectangle(handles, mouse_location)

rectangles = handles.userdata.rectangles;

if isempty(rectangles)
    return;
end

% Check the centres.
dists = sum((rectangles(:, 1:2) - repmat(mouse_location, size(rectangles, 1), 1)).^2, 2);

min_overall_dist = min(dists);
min_dist_idx = find(dists == min(dists), 1);
move_mode = 'translate';
corner_idx = -1;

% Check the corners.
for rect_idx = 1:size(rectangles, 1)
    
    corners = get_rectangle_corners(rectangles(rect_idx, :), false);
    
    dists = sum((corners - repmat(mouse_location, size(corners, 1), 1)).^2, 2);
    
    min_dist = min(dists);
    
    if min_dist < min_overall_dist
        min_dist_idx = rect_idx;
        move_mode = 'rotate';
        corner_idx = find(dists == min_dist, 1);
        min_overall_dist = min_dist;
    end
    
end

if min_overall_dist < handles.userdata.minimum_association_distance
    handles.userdata.rectangle_idx = min_dist_idx;
    handles.userdata.move_mode = move_mode;
    handles.userdata.corner_idx = corner_idx;
else
    handles.userdata.rectangle_idx = -1;
end

