%Author: William Huang , Z5062658
%Program: MTRN4230 PSE1

clc; clear all; close all; dbstop if error; 

img1 = imread('D:\MTRN4230\board.tif');
%Convert to double and normalize.
jmg1 = DoubleandNormalize(img1);

img2 = imread('D:\MTRN4230\hands2.jpg');
%Convert to double and normalize.
jmg2 = DoubleandNormalize(img2);

img3 = imread('D:\MTRN4230\pillsetc.png');
%Convert to double and normalize.
jmg3 = DoubleandNormalize(img3);

img4 = imread('D:\MTRN4230\coloredChips.png');
%Convert to double and normalize.
jmg4 = DoubleandNormalize(img4);

%PSE1 Tasks.
%a
figure; subplot(1,2,1); imshow(img1);
title('Default Picture: Board.tif');
showGreen(jmg1);
%b
figure; subplot(1,2,1); imshow(img2);
title('Default Picture: hands2.jpg');
showEdge(jmg2);
%c
figure; subplot(1,2,1); imshow(img3);
title('Default Picture: pillsetc.png');
showSURF(jmg3);
%d
figure; subplot(1,2,1); imshow(img4);
title('Default Picture: coloredChips.png');
showBlue(jmg4);

function [jmg]=DoubleandNormalize(img)  
    jmg = double(img);
    jmg = jmg/256;
end

function [jmg]= showGreen(jmg) 
    %Useful sites: 
    %https://stackoverflow.com/questions/37684903/matlab-how-to-detect-green-color-on-image
    %http://infohost.nmt.edu/tcc/help/pubs/colortheory/web/hsv.html
    %https://gyazo.com/96377aa7c641509cdf1833a8cd95b1f2
    GREEN_RANGE = [65,170]/360;
    WHITE_BOUND = 0.2;
    HSV = rgb2hsv(jmg);
    %Finding all pixels which lies outside hue range for green, or is visually white.
    greenmask = find(HSV(:,:,1)<GREEN_RANGE(1)| HSV(:,:,1) > GREEN_RANGE(2)| HSV(:,:,2)<WHITE_BOUND);
    %Moving to the saturation (HSV(:,:,2)) indexes. (1*648*306)
    greenmask = greenmask +198288;
    %Setting all other colors to gray through desaturating
    HSV(greenmask)=0;
    %Moving to the value (HSV(:,:,3)) indexes.
    greenmask = greenmask +198288;
    %Halving intensity of non-green pixels as required.
    HSV(greenmask)=(1/2)*HSV(greenmask);
    greenArea = hsv2rgb(HSV);
      
    subplot(1,2,2) ; imshow(greenArea);
    title('a. Green Segmentation');
    drawnow;
end

function [jmg]=showEdge(jmg)  
    %Useful sites: 
    %https://au.mathworks.com/help/images/ref/edge.html?s_tid=doc_ta 
    grey = rgb2gray(jmg);
    %Canny, log and zerocross detect a lot more detailed edges by default, which mean we need to change threshold
    %as we only want the general hand outline. It is noticed from testing that [0.8 0.9] higher values result in 
    %only the most distinct lines detected (not enough detection) whilst [0.1 0.2] result in very detailed detection
    %(too much detection).
    jmgedge=edge(grey,'canny',[0.01,0.55]);
    %Moving to the value (HSV(:,:,3)) indexes. (2*240*320)
    outlinemask = find(jmgedge>0)+76800+76800;
    HSV = rgb2hsv(jmg);
    %Setting outline pixels to black.
    HSV(outlinemask)= 0;
    blackoutlinehand = hsv2rgb(HSV);
    
    subplot(1,2,2) ; imshow(blackoutlinehand);
    title('b. Hand Outline');
    drawnow;
end

function [jmg]=showSURF(jmg) 
    %Convert to grey image.
    grey = rgb2gray(jmg);
    points = detectSURFFeatures(grey);
    
    subplot(1,2,2) ; imshow(jmg);
    hold on;
    %Plotting the 10 strongest features overlaid on original image.
    plot(points.selectStrongest(10));
    title('c. Surf Descriptors Overlaid');
    drawnow;
end

function [jmg]=showBlue(jmg)  
    %Useful sites: 
    %https://au.mathworks.com/help/images/ref/regionprops.html?searchHighlight=regionprops&s_tid=doc_srchtitle#buoixjn-1-properties
    BLUE_RANGE = [190,260]/360;
    WHITE_BOUND = 0.2;
    DARK_BOUND = 0.5;
    HSV = rgb2hsv(jmg);
    %Finding all pixels which lies outside hue range for blue, or is visually white.
    bluemask = find(HSV(:,:,1)<BLUE_RANGE(1)| HSV(:,:,1) > BLUE_RANGE(2)| HSV(:,:,2)<WHITE_BOUND|HSV(:,:,3)<DARK_BOUND);
    %Moving to the value (HSV(:,:,3)) indexes. (391*518*2)
    bluemask = bluemask +202538+202538;
    %Setting non-blue elements to black.
    HSV(bluemask)=0;
    %Setting all non-black elements to white.
    bluetowhite = find(HSV(:,:,3)>DARK_BOUND);
    %Moving to the saturation (HSV(:,:,2)) indexes.
    bluetowhite = bluetowhite +202538;
    HSV(bluetowhite) = 0;
    %Moving to the value (HSV(:,:,3)) indexes.
    bluetowhite = bluetowhite +202538;
    HSV(bluetowhite) = 1;
    blueArea = hsv2rgb(HSV);
    grey = rgb2gray(blueArea);
    %Converting greyscale to binary image.
    BW = imbinarize(grey);
    %Using regionprops to identify centroids and edge to identify perimeter from binary image.
    s = regionprops(BW,'centroid');
    centroids = cat(1, s.Centroid);
    perimeter = edge(BW,'Canny');
    
    %Go back to original picture and add required information.
    HSVfinal = rgb2hsv(jmg);
    %Setting perimeter to bright red as required.
    outlinemask = find(perimeter>0);
    HSVfinal(outlinemask)= 0;
    outlinemask =outlinemask+202538;
    HSVfinal(outlinemask)= 1;
    outlinemask =outlinemask+202538;
    HSVfinal(outlinemask)= 1;
    %Image with added red perimeter.
    jmgfinal = hsv2rgb(HSVfinal);
    
    subplot(1,2,2) ; imshow(jmgfinal);
    %Plotting centroids and perimeter overlaid.
    hold on
    %imshow(perimeter);
    %Plotting saved centroids onto image as black +.
    plot(centroids(:,1),centroids(:,2), 'k+')
    hold off
    title('d. Blue Chip Perimeter and Centroid');
    drawnow;
end





















