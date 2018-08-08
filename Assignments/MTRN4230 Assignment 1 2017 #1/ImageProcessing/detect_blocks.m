function c = detect_blocks(image)
    disp("hello");
    
    image = imread(image);
    %image = imresize(image, 0.5);
    c = 250; %number of pixels at top of each image to discard
    image(1:c, :, :) = 0;
    [angles, centroids_angles] = useBlocks(image);
    [colours, shapes, centroids] = useColours(image);
    
    %more angles than colours
    
    
    %%Associate angles with the colour centroids
    adjustedAngles = zeros(size(colours));
    
    
    
    unclassifiedCount = 1;
    
    for i=1:size(angles)
        %associate an angle with colours
        classified = false;
        for j=1:size(colours)
            dist = sqrt((centroids_angles(i,1)-centroids(j,1))^2 + (centroids_angles(i,2)-centroids(j,2))^2);
            if(dist<10)
                adjustedAngles(j) = angles(i)
                classified = true;
                break;
            end
        end
        if(classified == false)
            unclassifiedAngles(unclassifiedCount, 1) = angles(i);
            unclassifiedCentroids(unclassifiedCount, 1) = centroids_angles(i, 1);
            unclassifiedCentroids(unclassifiedCount, 2) = centroids_angles(i, 2);
            unclassifiedCount = unclassifiedCount+1;
        end
    end

    adjustedAngles =[adjustedAngles; unclassifiedAngles];
    adjustedCentroids =[centroids; unclassifiedCentroids];
    adjustedColours = [colours; zeros(size(unclassifiedAngles))];
    adjustedShapes = [shapes; zeros(size(unclassifiedAngles))];
    
    
    
    imshow(image)
    format short g;

    for i=1:size(adjustedCentroids)

        %%% CONSTRUCT FINAL ARRAY

        block = [adjustedCentroids(i,1), adjustedCentroids(i,2),... 
            deg2rad(adjustedAngles(i)), adjustedColours(i), adjustedShapes(i), (adjustedShapes(i) > 0),...
            isReachable(adjustedCentroids(i,1), adjustedCentroids(i,2))];
    
        txt = ['shape: ', num2str(adjustedShapes(i)), ' angle: ', num2str(adjustedAngles(i))];
        
        text(adjustedCentroids(i,1)+40, adjustedCentroids(i,2), txt, 'Color', 'Blue', 'FontSize',10); 
        if(i == 1)
            c = block;
        else
            c = [c; block];
        end
    end
    
    
    

    
    

end

%%
function reachable = isReachable(x, y)
    robotZero = [800, 285];
    robotRadius = robotZero(1)-15; 
    
    %(x-x0)^2+(y-y0)^2 < radius^2
    if(x-robotZero(1))^2+(y-robotZero(2))^2<robotRadius^2
        reachable = true;
    else
        reachable = false;
    end
end

%%
% uses blocks and no tiles to identify 
function [angles, centroids] = useBlocks(image)
    image = imsharpen(image);
    imHSV = rgb2hsv(image);
    
    imMask = imHSV(:,:,2)<0.3 & imHSV(:,:,3)>0.55;
    imMask = bwareaopen(imMask, 10000);
    imMask = ~bwareaopen(~imMask, 500);
    imMask(1:250, :, :) = 1;
    %imshow(imMask);
    [centroids, area, perim, solid, conv, orientation, majorAxis, minorAxis] = shapeStats(~imMask);
    
    angles = zeros(size(area));
    
    for i = 1:length(area)
       
       %label = processShape(area(i), perim(i), solid(i), conv(i), i);

       angles(i) = processAngle(orientation(i), majorAxis(i), minorAxis(i), centroids(i), i);
       
       %info = ['area/perim: ', num2str(conv(i)/perim(i)), '  solidity: ', num2str(solid(i)),...
       %    ' convarea: ', num2str(conv(i)), ' perim: ', num2str(perim(i)) ]
       %text(centroids(i,1)+40, centroids(i,2), num2str(angles(i)), 'Color', 'Blue', 'FontSize',10); 
       
    end
    
end

%%
function [colours, shapes, centroids] = useColours(image)
    imHSV = rgb2hsv(image);
    %imHSV(:,:,3) = imadjust(imHSV(:,:,3));
    r_imMask = imHSV(:,:,2)>0.2 & imHSV(:,:,3)>0.4 & imHSV(:,:,1)>0.85 & imHSV(:,:,1) < 1;
    r_imMask = bwareaopen(r_imMask, 350);
    [r_centroids, r_area, r_perim, r_solid, r_conv, r_orientation, r_majorAxis, r_minorAxis] = shapeStats(r_imMask);
    
    o_imMask = imHSV(:,:,2)>0.2 & imHSV(:,:,3)>0.4 & (imHSV(:,:,1) < 0.164 | imHSV(:,:,1)>0.996);
    o_imMask = bwareaopen(o_imMask, 350);
    [o_centroids, o_area, o_perim, o_solid, o_conv, o_orientation, o_majorAxis, o_minorAxis] = shapeStats(o_imMask);
    
    y_imMask = imHSV(:,:,2)>0.15 & imHSV(:,:,3)>0.6 & imHSV(:,:,1) > 0.11 & imHSV(:,:,1)<0.25;
    y_imMask = bwareaopen(y_imMask, 350);
    [y_centroids, y_area, y_perim, y_solid, y_conv, y_orientation, y_majorAxis, y_minorAxis] = shapeStats(y_imMask);
    
    g_imMask = imHSV(:,:,2)>0.3 & imHSV(:,:,3)>0.3 & imHSV(:,:,1) > 0.2 & imHSV(:,:,1)<0.45;
    g_imMask = bwareaopen(g_imMask, 350);
    [g_centroids, g_area, g_perim, g_solid, g_conv, g_orientation, g_majorAxis, g_minorAxis] = shapeStats(g_imMask);
    
    b_imMask = imHSV(:,:,2)>0.3 & imHSV(:,:,3)>0.3 & imHSV(:,:,1) > 0.55 & imHSV(:,:,1)<0.632;
    b_imMask = bwareaopen(b_imMask, 350);
    [b_centroids, b_area, b_perim, b_solid, b_conv, b_orientation, b_majorAxis, b_minorAxis] = shapeStats(b_imMask);
    
    v_imMask = imHSV(:,:,2)>0.3 & imHSV(:,:,3)>0.3 & imHSV(:,:,1) > 0.632 & imHSV(:,:,1)<0.8;
    v_imMask = bwareaopen(v_imMask, 350);
    [v_centroids, v_area, v_perim, v_solid, v_conv, v_orientation, v_majorAxis, v_minorAxis] = shapeStats(v_imMask);
    
    
    
    
    colours = [ones(size(r_area)); ...
               2*ones(size(o_area)); ...
               3*ones(size(y_area)); ...
               4*ones(size(g_area)); ...
               5*ones(size(b_area)); ...
               6*ones(size(v_area))];
    
    imshow(y_imMask);

    centroids = [r_centroids; o_centroids; y_centroids; g_centroids; b_centroids; v_centroids];
    area = [r_area; o_area; y_area; g_area; b_area; v_area];
    perim = [r_perim; o_perim; y_perim; g_perim; b_perim; v_perim];
    conv = [r_conv; o_conv; y_conv; g_conv; b_conv; v_conv];
    solid = [r_solid; o_solid; y_solid; g_solid; b_solid; v_solid];
    orientation = [r_orientation; o_orientation; y_orientation; g_orientation; b_orientation; v_orientation];
    majorAxis = [r_majorAxis; o_majorAxis; y_majorAxis; g_majorAxis; b_majorAxis; v_majorAxis];
    
    %imshow(image);
    %hold on
    
    shapes = zeros(size(area));
    
    for i = 1:length(area)
       
       shapes(i) = processShape(area(i), perim(i), solid(i), conv(i), i);

       %angle = processAngle(orientation(i), majorAxis(i), centroids(i), i);
       
       %info = ['area/perim: ', num2str(conv(i)/perim(i)), '  solidity: ', num2str(solid(i)),...
       %    ' convarea: ', num2str(conv(i)), ' perim: ', num2str(perim(i)) ]
       %text(centroids(i,1)+40, centroids(i,2), angle, 'Color', 'Blue', 'FontSize',10); 
       
    end
    
    hold on
end


function angle = processAngle(orientation, majorAxis, minorAxis, centroid, i)
    %angle = [];
    
    
    if(majorAxis-minorAxis < 1)
        if(orientation < 0)
            orientation = orientation+45;
        else
            orientation = orientation-45;
        end
    end
    
    if(abs(orientation)>45)
        if(orientation > 0)
            orientation = 90-orientation;
        else
            orientation = 90+orientation;
        end
    end
    %angle = strcat(num2str(i));
    %angle = strcat(angle, ' : ');
    %angle = strcat(angle, num2str(orientation));
    angle = orientation;
end

%takes in regionprops and determines the shape
function shape = processShape(area, perim, solidity, conv, i)
       label = [];
       
       label = strcat(num2str(i));
       %if(solid(i) >
       shape = 0;
       %% #1 Square
       if(area > 900 && area < 1020 ...
           && solidity > 0.9)
           label = strcat(label, 'Square ');
           shape = 1;
       
       %% #2 Diamond
       elseif(area/perim>6.5 && area/perim<8 ...
               && solidity > 0.9)
           label = strcat(label, 'Diamond ');
           shape = 2;
       %% #3 Circle
       
       elseif(solidity > 0.8 ...
           && area/perim > 8.5)
           label = strcat(label, 'Circle ');
           shape = 3;
       
       %% #4 Club
       elseif(conv > 1000 && conv < 1290 ...
           && solidity > 0.75 < solidity < 0.85)
           label = strcat(label, 'Club ');
           shape = 4;
       %% #5 Cross
       elseif(solidity > 0.45 && solidity < 0.62 ...
           && conv/perim > 6.5)
           label = strcat(label, 'Cross ');
           shape = 5;
       %% #6 Star
       elseif(solidity > 0.56 && solidity < 0.7 ...
           && conv/perim < 6.5)
           label = strcat(label, 'Star ');
           shape = 6;
       %% #0 Inverted
       end
       %shape = label
end

%takes in a black and white mask of shapes and gets the stats on each
function [centroids, area, perim, solid, conv, orientation, majorAxis, minorAxis] = shapeStats(imMask)
    stats = regionprops(imMask, 'Centroid', 'Area', 'Orientation', 'Perimeter', 'ConvexArea', 'Solidity', 'EquivDiameter', ...
        'Orientation', 'MajorAxisLength', 'MinorAxisLength');
    
    centroids = cat(1, stats.Centroid);
    area = cat(1, stats.Area);
    perim = cat(1, stats.Perimeter);
    solid = cat(1, stats.Solidity);
    conv = cat(1, stats.ConvexArea);
    orientation = cat(1, stats.Orientation);
    majorAxis = cat(1, stats.MajorAxisLength);
    minorAxis = cat(1, stats.MinorAxisLength);
end

%%



%% iterative corner piece and angle detection
% 1) convert mask into one that filters out all the coloured sections
% 2) run a corner detection algorithm to find the corners of the pieces
% 3) for each corner, find out if there's a centroid within x pixels of the
% corner
% 4) the angle of the line between the corner and the centroid can be
% converted to a piece angle
% 5) remove the piece from the mask
% 6) repeat