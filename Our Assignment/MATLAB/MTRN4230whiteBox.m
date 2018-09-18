%MTRN4230 ASSIGNMENT 2 - Detect white box.
%William W Huang z5062658
im = imread('D:\MTRN4230\Assignment 2\Conveyor1.jpg');
[whiteBoxAnswer] = detect_whiteBox(im)

%%%How this function works is by detecting the box boudnary, then using this boundary property,
%%%determines whether it is obscured by the table or camera view.
%%%The function takes in an image and returns a struct holding 7 variables.
%%%exists detects whether there is a box, if so, it returns 1
%%%boundaryX and boundaryY gives the plot of the box outline.
%%%centreX and centreY give the centre of the box (or close to the centre if obscured).
%%%conveyoredge detects whether it is obscured, returns 1 if it is.
%%%theta returns the angle in degrees.
%%%example access of struct: plot(whiteBoxAnswer.boundaryX,whiteBoxAnswer.boundaryY);
% figure; imshow(im);hold on;
% plot(whiteBoxAnswer.boundaryX,whiteBoxAnswer.boundaryY,'r-','LineWidth',2);  %%Example outcome.
% hold off;

function [whiteBoxAnswer] = detect_whiteBox(im)
close all;
whiteBoxAnswer=[];
whiteBoxAnswer.exists = 0;
nearedge=0;
BW = rgb2gray(im);
BWmasked = BW;
BWmasked(709:end,:) =0;

% figure; imshow(BWmasked);
boxMask = find(BWmasked<=75);
BWmasked(boxMask) =0;
% figure; imshow(BWmasked);

[BW1,maskedRGBImage] = createwhiteMask(im);
BW1 = uint8(BW1);    % c is an int8
BWmasked = BW1.*BWmasked;


% figure; imshow(BWmasked);
BWmasked = bwareaopen(BWmasked, 1500);
SE = strel('square',10);
BWmasked = imdilate(BWmasked,SE);
BWmasked = imerode(BWmasked,SE);
BWmasked(1,:) =255;
BWmasked(709,:) =255;
[B,L,N,A] = bwboundaries(BWmasked); 


% figure; imshow(BWmasked); hold on;
boxOutline.X = [];
boxOutline.Y = [];
%Loop through object boundaries  
for k = 1:N 
    % Boundary k is the parent of a hole if the k-th column 
    % of the adjacency matrix A contains a non-zero element 
    if (nnz(A(:,k)) > 0) 
        boundary = B{k}; 
%         plot(boundary(:,2),... 
%             boundary(:,1),'r','LineWidth',2); 
        if (length(boundary(:,2)) >=500)
           boxOutline.X = boundary(:,2);
           boxOutline.Y = boundary(:,1);
           boxOutline.centroidX = mean(boxOutline.X);
           boxOutline.centroidY = mean(boxOutline.Y);
        end
        % Loop through the children of boundary k 
        for l = find(A(:,k))' 
            boundary = B{l}; 
%             plot(boundary(:,2),... 
%                 boundary(:,1),'g','LineWidth',2);
            if (length(boundary(:,2)) >=800)
                boxInnerOutline.X =boundary(:,2);
                boxInnerOutline.Y =boundary(:,1);
            end
        end 
    end 
end

if (isempty(boxOutline.X)==false)
%%% In the case of the box at the top edge or bottom edge of the screen, we will have a unique outer
%%% boundary length. In these 2 cases we will use an alternate equation for calculation.
%%% Approx 3000+ at edge. 1500 at not edge.
if (length(boxOutline.X) <=2000)
   %Work out what orientation.
   %TODO    
    maxX =max(boxOutline.X);
    maxY =max(boxOutline.Y);
    minX =min(boxOutline.X);  
    minY =min(boxOutline.Y); 
    maxYx=median(boxOutline.X(find(boxOutline.Y==maxY)));
    maxXy=median(boxOutline.Y(find(boxOutline.X==maxX)));
    minYx=median(boxOutline.X(find(boxOutline.Y==minY)));
    minXy=median(boxOutline.Y(find(boxOutline.X==minX)));
%     hold on
%     plot(minYx,minY,'b+');
%     plot(minX,minXy,'b+');
    if (abs(maxYx(1) - maxX) >=5)
       gradient1 = (median(maxXy) - maxY)/(median(maxYx) - maxX); 
       gradient2 = (median(minXy) - minY)/(median(minYx) - minX); 
       gradientAVG = (gradient1+gradient2)/2;
    else
       gradientAVG = 100;    %%Vertical
    end
    rotateTile = atan(gradientAVG)*(180/pi);
else
    nearedge=1;
    newholeDist= 99999;
    midpointY = (max(boxOutline.Y)+min(boxOutline.Y))/2;
    for counterj = 1: numel(boxOutline.X)
       minDistX = (boxOutline.X(counterj,1)-(boxOutline.centroidX)).^2;
       minDistY = (boxOutline.Y(counterj,1)-(midpointY)).^2;
       
       holeDist = min(sqrt(minDistX+minDistY));
       holeIndex = find(sqrt(minDistX+minDistY)==holeDist);
       if (holeDist < newholeDist)
           newholeDist = holeDist;
           preservedIndex = [counterj holeIndex];

       end  
    end
    
    if ((boxOutline.X(preservedIndex(1,1),1) - boxOutline.centroidX)~=0)
       gradient = (boxOutline.Y(preservedIndex(1,1),1) - midpointY)/(boxOutline.X(preservedIndex(1,1),1) - boxOutline.centroidX); 
    else
       gradient = 100;   %almost vertical 
    end
    rotateTile = atan(gradient)*(180/pi); 
    
end

whiteBoxAnswer.boundaryX = boxOutline.X;
whiteBoxAnswer.boundaryY = boxOutline.Y;
removeLine = find(whiteBoxAnswer.boundaryY ==1 |whiteBoxAnswer.boundaryY ==709);
whiteBoxAnswer.boundaryX(removeLine)=[];
whiteBoxAnswer.boundaryY(removeLine)=[];
whiteBoxAnswer.centreX = boxOutline.centroidX;
whiteBoxAnswer.centreY = boxOutline.centroidY;
whiteBoxAnswer.conveyorEdge = nearedge;
whiteBoxAnswer.theta = rotateTile;
whiteBoxAnswer.exists = 1;
% jmg2 = imrotate(BWmasked, -rotateTile);
% 
% figure; imshow(jmg2);
end

end