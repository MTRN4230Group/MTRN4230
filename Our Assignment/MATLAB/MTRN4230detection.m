%MTRN4230 ASSIGNMENT 2 - Detect Letter and Tile Properties.
%William W Huang z5062658
%OCR Function V1.0, need pipelining, can do some efficiency increases, fix orientation directions and letter accuracy.
%How to use:
%[totalanswer] = detect_blocks(im,showImageInfo)
%totalanswer is a array storing all the necessary info in the format [x y theta shape color letter inrange]
%im is image to analyze
%showImageInfo prints the figure, with orientation or lettering displayed. (1 is enable).

im = imread('D:\MTRN4230\Assignment 2\IMG_026.jpg');
[analyzedInfo] = detect_blocks(im,1); 



function [totalanswer] = detect_blocks(im,showImageInfo)
close all;

% nameS = 'D:\MTRN4230\Assignment 1\MyNeuralNet\Labels Set A V2-20180903\Labels Set A V2\IMG_003.jpg';
 jmg = im;
% jmg = imread('D:\MTRN4230\Assignment 1\MyNeuralNet\Labels Set A V2-20180903\Labels Set A V2\IMG_020.jpg');
%jmg = imread('D:\MTRN4230\Assignment 1\MyNeuralNet\Labels Set A V2-20180903\Labels Set A V2\IMG_020.jpg');
%jmg2= imrotate(jmg, 30);
%figure; imshow(jmg);
originalHSV = rgb2hsv(jmg);
%figure; imshow(jmg2);
%---------------------------------
%Saving backup of image for later.
% jmg3 = rgb2hsv(jmg);
% 
% mask= find(jmg3(:,:,1)>(70/360)&jmg3(:,:,1)<(170/360)&jmg3(:,:,3)>0.31);
% 
% %jmg3(mask)=255;
% mask = mask+1920000;
% jmg3(mask)=0.25*jmg3(mask);
% mask = mask+1920000;
% jmg3(mask)=1.7*jmg3(mask);
% jmg3 = hsv2rgb(jmg3);

% % [blueandpurplemask,jmg4]= hsvblueandpurple(jmg);
% % jmg(find(blueandpurplemask==1))= 155;
% % jmg(find(blueandpurplemask==1)+(1200*1600))=155;
% % 
% % [rno,jmg4]= hsvredandorange(jmg);
% % jmg(find(rno==1))= 200;
% % jmg(find(rno==1)+(1200*1600))=200;
% % [orange1,jmg4]= hsvorangemask(jmg);
% % jmg(find(orange1==1))= 200;
% % jmg(find(orange1==1)+(1200*1600))=200;
% % [green1,jmg4]= hsvgreen(jmg);
% % jmg(find(green1==1))= 170;
% % jmg(find(green1==1)+(1200*1600))=170;

%jmg(3*find(redandorangemask==1))=240

%figure; imshow(jmg);


tests=originalHSV(:,:,2);
%Structure parameters --------------
se = strel('line',4,0);
se2 = strel('arbitrary',eye(5));
%se2 = strel('arbitrary',[-1 0 0 0;0 -1 0 0 ;0 0 -1 0;0 0 0 -1])
se4 = strel('line',4,90);
SE1 = strel('square',1);
SE2 = strel('diamond',1);
%Structure parameters --------------
%Gray here.
BW = rgb2gray(jmg);
Saved1 = imbinarize(BW);
Saved1 = imcomplement(Saved1);
%Remove Grid
BW2 = imdilate(BW,se);
BW3 = imerode(BW2,se);
BW3 = imdilate(BW3,se4);
BW3 = imerode(BW3,se4);
jmg2 = imbinarize(BW3);
BW3 = imdilate(BW3,se);
BW3 = imerode(BW3,se);
BW3 = imdilate(BW3,se4);
BW3 = imerode(BW3,se4);
BW3 = imopen(BW3,SE2);

% figure; imshow(BW3);
%BW3 = imerode(BW3,se2);
BW3(1:225,:) = 255;
BW3(find(BW3(:,:)>150))=255;
BW3(find(BW3(:,:)<=150))=0;
%Binarize
BW3 = imbinarize(BW3);
BW3 = imcomplement(BW3);
%Perfect edge detection
BW4 = edge(BW3,'Canny',[0.001,0.9]);
% figure; imshow(BW3); hold on;
% corners = detectHarrisFeatures(BW3,'MinQuality',0.5);
% plot(corners.selectStrongest(50)); hold off;
% figure; imshow(jmg2);
% figure; imshow(BW3);
%BW boundaries for parent and child boundaries.
[B,L,N,A] = bwboundaries(BW3); 
% figure; imshow(BW3); hold on; 
% Loop through object boundaries  
% for k = 1:N 
%     % Boundary k is the parent of a hole if the k-th column 
%     % of the adjacency matrix A contains a non-zero element 
%     if (nnz(A(:,k)) > 0) 
%         boundary = B{k}; 
%         plot(boundary(:,2),... 
%             boundary(:,1),'r','LineWidth',2); 
%         % Loop through the children of boundary k 
%         for l = find(A(:,k))' 
%             boundary = B{l}; 
%             plot(boundary(:,2),... 
%                 boundary(:,1),'g','LineWidth',2); 
%         end 
%     end 
% end
 

%Plotting all scenario, not just parent with child.
% imshow(BW3); hold on;
childY={};
childX={};
parentY={};
parentX={};

for k=1:length(B),
   boundary = B{k};
   if(k > N)
     %plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
    
     childX{k,2} = boundary(:,2); 
     childY{k,1} = boundary(:,1);
   else
     %plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
     parentX{k,2} = boundary(:,2);
     parentY{k,1} = boundary(:,1);
    
   end
  
end
measurements = regionprops(BW3, 'Area');
allAreas = [measurements.Area];
%-----------------------------------------------------------------------
%Saving each important piece of information as a vertical cell array.
%childX is the child X and Y boundary coordinates.
childX = childX(~cellfun('isempty',childX));  
childY = childY(~cellfun('isempty',childY)); 
%Number of child elements. (Rows)
[childrowOld,junk] = size(childX);
%This calculates the perimeter of the boundary for child.
boundaryPchild = cellfun('size',childX,1);

%parentX is the parent X and Y boundary coordinates.
parentX = parentX(~cellfun('isempty',parentX));  
parentY = parentY(~cellfun('isempty',parentY)); 
%Number of parent elements. (Rows)
[parentrowOld,junk] = size(parentX);
%This calculates the perimeter of the boundary for parent.
boundaryPparent = cellfun('size',parentX,1);
%-----------------------------------------------------------------------
%Find parent holes inside child holes, and also delete noise.
usefulholes = find(boundaryPparent<80 & boundaryPparent>15);
savedFeatureholesX = parentX(usefulholes); 
savedFeatureholesY = parentY(usefulholes);
%The above X and Y are saved features for use later,after masking, such as detecting the hole in B or P

%These are definitely noise, delete these.
noiseholes = find(boundaryPparent<=15);

%Large parent boundaries to deal with later. Defined as perimeters greater than 220.
largeBoundaries = find(boundaryPparent>220);
largeBoundariesX = parentX(largeBoundaries); 
largeBoundariesY = parentY(largeBoundaries);
%-----------------------------------------------------------------------
%Deletion of duplicate or noise elements for parent.
removalMask = [noiseholes;largeBoundaries;usefulholes];
parentX(removalMask) = [];
parentY(removalMask) = [];
boundaryPparent(removalMask)= [];

%-----------------------------------------------------------------------
%Repeat similar process for child.
%The holes we dont need are the ones that have very low or very high perimeter. However be careful with high perimeter, we need also check Hue.
%This is because some shapes like stars have really high perimeter. Maybe use CNN. Will also consider area for some cases.
largeperimChild = find(boundaryPchild>300 );    %Finetune this number. This are the extra checks needed elements.
largeperimChildX = childX(largeperimChild); 
largeperimChildY = childY(largeperimChild);

%These are definitely noise, delete these.
noisechildholes = find(boundaryPchild<=70);   %Finetune this number.
%-----------------------------------------------------------------------
%Deletion of duplicate or noise elements for parent.
childremovalMask = [noisechildholes;largeperimChild];
childX(childremovalMask) = [];
childY(childremovalMask) = [];
boundaryPchild(childremovalMask)= [];

%Up to here, we have classified and saved all the boundaries and holes.
%Summary of key values: largeperimChild (big perims), savedFeatureholes (small perim parents, ie holes in B and P).
%Parent and child x and ys. Boundary... (perimeter values)

%Update new sizes to check.
[childrow1,junk] = size(childX);
[parentrow1,junk] = size(parentX);

%Now start with the easy, not clumped blocks. Creating a mask, then finding key properties such as area, centroid, etc.
% %
% for k=1:length(B),
%    boundary = B{k};
%    if(k > N)
%      plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
%     
%      childX{k,2} = boundary(:,2); 
%      childY{k,1} = boundary(:,1);
%    else
%      plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
%      parentX{k,2} = boundary(:,2);
%      parentY{k,1} = boundary(:,1);
%     
%    end
%   
% end
childFlag1={};
% parentX{1,1}(1)...bwmask(Y,X)
%This loop pairs parents with their child, through testing whether child point lies within the mask 
%Created by the polygon. Note this is for separated blocks so that poly2mask works as intended.
for k=1:parentrow1
xmask=parentX{k,1}';
ymask=parentY{k,1}';
bwmask = poly2mask(xmask,ymask,1200,1600);
counter=0;
   for k1=1:childrow1
       if (bwmask(childY{k1,1}(1),childX{k1,1}(1))==1)
           counter= counter+1;
           childFlag1{k}=counter;  %In this flag rows are the parents, and column activations is the corresponding child, if any.
           break
       else
           counter= counter+1;
           childFlag1{k}=[];
       end
   end
% figure; imshow(bwmask.*BW3);
end
if (isempty(childFlag1)==false)
   childFlag1 =  childFlag1';
end
%Now group again for childless parents.
length(childFlag1);
parentwChild={};
morespace=1;
for k3=1:length(childFlag1)
    if (isempty(childFlag1{k3})==false)
       parentwChild{morespace} = {parentY{k3,1}, parentX{k3,1},childY{childFlag1{k3},1},childX{childFlag1{k3},1},boundaryPparent(k3),boundaryPchild(childFlag1{k3})} ;  %This tile is solvable.
       morespace = morespace+1;
       parentY{k3,1} =[];
       parentX{k3,1} =[];
       childY{childFlag1{k3},1} = [];
       childX{childFlag1{k3},1}=[];
       boundaryPparent(k3)= nan;
       boundaryPchild(childFlag1{k3})= nan;
    end
end
%remove boundary rows that belong to solved elements.
boundaryPparent = boundaryPparent(all(~isnan(boundaryPparent),2),:); % for nan - rows
boundaryPchild = boundaryPchild(all(~isnan(boundaryPchild),2),:); % for nan - rows
if (isempty(parentwChild)==false)
parentwChild = parentwChild';
end


%Now remove these solved elements from the array.
%-----------------------------------------------------------------------
childX = childX(~cellfun('isempty',childX));  
childY = childY(~cellfun('isempty',childY)); 
parentX = parentX(~cellfun('isempty',parentX));  
parentY = parentY(~cellfun('isempty',parentY)); 
%Update new sizes to check.
[childrow2,junk] = size(childX);
[parentrow2,junk] = size(parentX);


%For children, we can only use area and perimeter.
morespace=1;
orphanChilds={};
for k4=1:length(boundaryPchild) 
    orphanChilds{morespace} = {childY{k4,1},childX{k4,1},boundaryPchild(k4)};
    morespace = morespace+1;
end
if (isempty(orphanChilds)==false)
orphanChilds = orphanChilds';
end
morespace=1;
orphanParents={};
for k5=1:length(boundaryPparent) 
    orphanParents{morespace} = {parentY{k5,1},parentX{k5,1},boundaryPparent(k5)};
    morespace = morespace+1;
end
if (isempty(orphanChilds)==false)
orphanParents = orphanParents';
end
if (showImageInfo == 1)
   figure; imshow(BW3);
end
[arrayAnswer] = solveforcompleteTile(parentwChild,jmg2,BW3,originalHSV,showImageInfo);  %arrayAnswer is in the format [x, y ,theta, color, shape, letter, reachable];

[clumpAnswer] = solveforClump(orphanChilds,BW3, originalHSV,orphanParents,largeBoundariesX,largeBoundariesY,showImageInfo);
totalanswer = [arrayAnswer;clumpAnswer];
%write_output_file(totalanswer, nameS3, nameS2);

end

function [blocks]=solveforcompleteTile(info,imagejmg2,image, hsvimage,showImageInfo)
counterblock =1;
blocks = [ 0 0 0 0 0 0 0];
%%figure; imshow(image);

for k=1:length(info)
   rotateTile =0;
   %Creating the mask for parent.
   ymask=info{k, 1}{1, 1};
   xmask=info{k, 1}{1, 2};
   
   %Work out what letter or shape.
   bwmask = poly2mask(xmask,ymask,1200,1600); %This is parent mask (tile mask).
   roiimg=bwmask.*image; %Mask applied.
   smask = regionprops(bwmask,'centroid','Area','Orientation','EulerNumber','Extrema'); %blank mask stats.
   sroi = regionprops(roiimg,'centroid','Area','Orientation','EulerNumber','Extrema'); %Mask and lettering/shape stats.
   sroicentroids = cat(1, sroi.Centroid);
   smaskcentroids = cat(1, smask.Centroid);


   %Work out if in range.
   %From fit circle through 3 points, R = 831.9670
   %xcyc = (806.3378, 26.1245) (X,Y)
   %Therefore to detect if in range:
   distEffector = 0;
   if (isempty(smaskcentroids(:,1))==false)
      distEffector=sqrt((smaskcentroids(:,1)-806.3378).^2+(smaskcentroids(:,2)-26.1245).^2); %distance from centre of circle of range.
      colorCoordsX = cast(smaskcentroids(:,1),'int64');
      colorCoordsY = cast(smaskcentroids(:,2),'int64');
      diffSize=smask.Area-sroi.Area;
      centroidDistance = sqrt(((smaskcentroids(:,1)-sroicentroids(:,1)).^2)+((smaskcentroids(:,2)-sroicentroids(:,2)).^2));
      
   end
   
   %Caculating whether within range, inRange is passed into blocks, a key value.
   if (distEffector <= 831.9670)
       inRange = 1;
   else
       inRange = 0;
   end 
   
   %Work out what color.
   %if the saturation on the original HSV image greater than 0.21, it is a color and not white (or board).
   %Pick centre 9 pixels.
   counterk=1;
   for pixelkx = -10:1:10
       for pixelky = -10:1:10
       hsv2(counterk) = hsvimage(colorCoordsY+pixelky, colorCoordsX+pixelkx,1);
       counterk= counterk+1;
       end
   end 
   hsvmhue= median(hsv2);    %This is mean hue.
   
   counterk=1;
   for pixelkx = -10:1:10
       for pixelky = -10:1:10
       hsv1(counterk) = hsvimage(colorCoordsY+pixelky, colorCoordsX+pixelkx,2);
       counterk= counterk+1;
       end
   end 
   hsvmsat= median(hsv1);   %This is mean saturation.

   
   
   if (hsvmsat <0.21)      %Type detector based on saturation.
      colorFinal = 0;      %Must be a letter. 
   else                    %Color detector based on hue.
      if (hsvmhue<0.013 ||hsvmhue>=0.947)
         colorFinal = 1;   %is red.
      elseif (hsvmhue>=0.013 &&hsvmhue<0.112)
         colorFinal = 2;   %is orange.
      elseif (hsvmhue>=0.112 &&hsvmhue<0.192)
         colorFinal = 3;   %is yellow.
      elseif (hsvmhue>=0.192 &&hsvmhue<0.438)
         colorFinal = 4;   %is green.
      elseif (hsvmhue>=0.438 &&hsvmhue<0.642)
         colorFinal = 5;   %is blue.
      elseif (hsvmhue>=0.642 &&hsvmhue<0.947)
         colorFinal = 6;   %is purple.
      else
         colorFinal = 4;   %in case didnt cover.
      end
   end
   finalGuess = 0;
   votingmatrix = zeros([1,32]); %letters A and Z and one error slot.
   %Work out letter. Detecting the easiest ones without OCR.
   if (colorFinal == 0)
       if (sroi.EulerNumber==2)
           votingmatrix(2)=votingmatrix(2)+500;
       
       elseif (sroi.EulerNumber==1)
           votingmatrix(1)=votingmatrix(1)+25;
           votingmatrix(4)=votingmatrix(4)+25;
           votingmatrix(15)=votingmatrix(15)+25;
           votingmatrix(16)=votingmatrix(16)+25;
           votingmatrix(17)=votingmatrix(17)+25;
           votingmatrix(18)=votingmatrix(18)+25;
           votingmatrix(19)=votingmatrix(19)+25;
           
       else
           votingmatrix(2)=votingmatrix(2)-500;
           votingmatrix(1)=votingmatrix(1)-25;
           votingmatrix(4)=votingmatrix(4)-25;
           votingmatrix(15)=votingmatrix(15)-25;
           votingmatrix(16)=votingmatrix(16)-25;
           votingmatrix(17)=votingmatrix(17)-25;
           votingmatrix(18)=votingmatrix(18)-25;
           votingmatrix(19)=votingmatrix(19)-25;
       end
%        if (centroidDistance >0.9)    %c k l
%            votingmatrix(11)=votingmatrix(11)+10;
%            votingmatrix(12)=votingmatrix(12)+10;
%            votingmatrix(3)=votingmatrix(3)+10;   
%        end
%        if (centroidDistance <0.25)   %i v
%            votingmatrix(9)=votingmatrix(9)+10;
%            votingmatrix(22)=votingmatrix(22)+10;
%        end
       if(diffSize <200)
           votingmatrix(9)=votingmatrix(9)+100;
       end
       if(diffSize >500)
           votingmatrix(17)=votingmatrix(17)+10;
       end
   %Work out what orientation.
   %TODO    
    maxX =max(xmask);
    maxY =max(ymask);
    minX =min(xmask);  
    minY =min(ymask); 
    maxYx=xmask(find(ymask==maxY));
    maxXy=ymask(find(xmask==maxX));
    if (abs(maxYx(1) - maxX) >=5)
       gradient = (median(maxXy) - maxY)/(median(maxYx) - maxX); 
    else
       gradient = 100;    %%Vertical
    end
    rotateTile = atan(gradient)*(180/pi);
    if (colorFinal == 0)  %Using OCR.
       roiimg2 =imcomplement(bwmask)+roiimg;    
       roi =[sroicentroids(:,1)-40 sroicentroids(:,2)-40 80 80];
       cutletterImage = imcrop(roiimg2,roi);                        %%Just the tile, rotate and perform OCR.
       cutletterImage = imrotate(cutletterImage,-rotateTile,'crop');
       cutletterImage = imcrop(cutletterImage,[12,17,50,50]);
       cutletterImage90=imrotate(cutletterImage,90,'crop');
       cutletterImage180=imrotate(cutletterImage,180,'crop');
       cutletterImage270=imrotate(cutletterImage,270,'crop');
       
       %figure;  imshow(roiimg2); 
       %figure;  imshow(cutletterImage); 
       %figure;  imshow(cutletterImage90); 
       %txt = ocr(imcomplement(roiimg2),[sroicentroids(1,1)-40 sroicentroids(1,2)-40 80 80],'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ','Language','English');
       v90 = 0;
       v180=0;
       v270=0;
       %%Rotating each tile 90 degrees, doing OCR and repeating. If high confidence letter is detected, and only 1 letter, vote for letter.
              txt = ocr(cutletterImage,'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ','Language','English');
       if(isempty(txt.CharacterConfidences)==false)
         
      
           if ((txt.CharacterConfidences(1)>= 0.70) && (isempty(txt.CharacterConfidences)==false) && length(txt.CharacterConfidences)<=3)
               v0 = uint64(txt.Words{1,1})-64;
               votingmatrix(v0)=votingmatrix(v0)+50;
           end   
       end
       txt90 = ocr(cutletterImage90,'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ','Language','English');
        if(isempty(txt90.CharacterConfidences)==false)
       
           if ((txt90.CharacterConfidences(1)>= 0.70) && (isempty(txt90.CharacterConfidences)==false)&& length(txt90.CharacterConfidences)<=3)
               v90 = uint64(txt90.Words{1,1})-64;
               votingmatrix(v90)=votingmatrix(v90)+50;        
           end
        end
       txt180 = ocr(cutletterImage180,'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ','Language','English');
        if(isempty(txt180.CharacterConfidences)==false)
      
           if ((txt180.CharacterConfidences(1)>= 0.70) && (isempty(txt180.CharacterConfidences)==false)&& length(txt180.CharacterConfidences)<=3)
               v180 = uint64(txt180.Words{1,1})-64;
               votingmatrix(v180)=votingmatrix(v180)+50;
           end
        end
       txt270 = ocr(cutletterImage270,'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ','Language','English');
        if(isempty(txt270.CharacterConfidences)==false)
     
           if ((txt270.CharacterConfidences(1)>= 0.70) && (isempty(txt270.CharacterConfidences)==false)&& length(txt270.CharacterConfidences)<=3)
               v270 = uint64(txt270.Words{1,1})-64;
               votingmatrix(v270)=votingmatrix(v270)+50; 
           end
        end
    end    
       
       
%        figure;  imshow(roiimg); 
%        hold on;
       %plot(sroicentroids(:,1)-40,sroicentroids(:,2)+40, 'b*')
       %rectangle('Position',[sroicentroids(:,1)-40 sroicentroids(:,2)-40 80 80],'FaceColor','r');       
%        hold off 
%Counting the ballots.     
       [printer,finalGuess] = max(votingmatrix);
%Only one of these should activate.
       flagDup=0;
       if (finalGuess == v90 && flagDup ~= 1)
          rotateTile = rotateTile+90;
          flagDup =1;
       end

  
       if (finalGuess == v180&& flagDup ~= 1)
          rotateTile = rotateTile+180;
          flagDup =1;
       end

  
       if (finalGuess == v270&& flagDup ~= 1)
          rotateTile = rotateTile+270;
          flagDup =1;
       end

       
   end
   finalShape=0;
   if (colorFinal~=0)
       finalShape =1;
   end

%        figure;  imshow(roiimg); title(['color:', num2str(colorFinal), ' range:', num2str(diffSize), ' cdist:', num2str(centroidDistance),' guess:' num2str(finalGuess)])
   if (showImageInfo ==1)
        hold on;
        plot(sroicentroids(:,1),sroicentroids(:,2), 'b*')
        plot(smaskcentroids(:,1),smaskcentroids(:,2), 'b+')
        text1 =num2str(finalGuess);
        text(smaskcentroids(:,1),smaskcentroids(:,2),text1,'Color','red');
       % You may store your results in matrix as shown below.
        %           X Y  Theta Colour Shape Letter     1 = Reachable
        %                                              0 = Not reachable
        hold off;
   end
   blocks(counterblock,:) = [smaskcentroids(1,1), smaskcentroids(1,2), rotateTile, colorFinal,finalShape, finalGuess, inRange];
   
   counterblock =counterblock+1;
   
end



end


function [blocks2]=solveforClump(info,image, hsvimage,orphanParents,largeBoundariesX,largeBoundariesY,showImageInfo)
counterblock =1;
image = imcomplement(image);
% figure;  imshow(image); 
blocks2 = [ 0 0 0 0 0 0 0];
originlength = length(info);
if(isempty(info)==true & isempty(orphanParents)==false)
    orphanParents = orphanParents';
end
info = [info;orphanParents]';
for k=1:length(info)
   
   %Creating the mask for Child.
   ymask=info{1, k}{1, 1};
   xmask=info{1, k}{1, 2};
   
   %Work out what letter or shape.
   bwmask = poly2mask(xmask,ymask,1200,1600); %This is child mask (tile mask).
    %bwmask = imcomplement(bwmask);
 
   roiimg =bwmask.*image;
   if (k>originlength)
       roiimg = bwmask;
   else
       roiimg =bwmask.*image;
   end
   sroi = regionprops(roiimg,'centroid','Area','EulerNumber'); %Mask and lettering/shape stats.
   sroicentroids = cat(1, sroi.Centroid);
   distEffector=0;
   distEffector=sqrt((sroicentroids(:,1)-806.3378).^2+(sroicentroids(:,2)-26.1245).^2); %distance from centre of circle of range.
   if (distEffector <= 831.9670)
       inRange = 1;
   else
       inRange = 0;
   end 
   
   colorCoordsX = cast(sroicentroids(:,1),'int64');
   colorCoordsY = cast(sroicentroids(:,2),'int64');
   %color as previous
   counterk=1;
   for pixelkx = -10:1:10
       for pixelky = -10:1:10
       hsv2(counterk) = hsvimage(colorCoordsY+pixelky, colorCoordsX+pixelkx,1);
       counterk= counterk+1;
       end
   end 
   hsvmhue= median(hsv2);    %This is mean hue.
   
   counterk=1;
   for pixelkx = -10:1:10
       for pixelky = -10:1:10
       hsv1(counterk) = hsvimage(colorCoordsY+pixelky, colorCoordsX+pixelkx,2);
       counterk= counterk+1;
       end
   end 
   hsvmsat= median(hsv1);   %This is mean saturation.

   
   
   if (hsvmsat <0.21)      %Type detector based on saturation.
      colorFinal = 0;      %Must be a letter. 
   else                    %Color detector based on hue.
      if (hsvmhue<0.013 ||hsvmhue>=0.947)
         colorFinal = 1;   %is red.
      elseif (hsvmhue>=0.013 &&hsvmhue<0.112)
         colorFinal = 2;   %is orange.
      elseif (hsvmhue>=0.112 &&hsvmhue<0.192)
         colorFinal = 3;   %is yellow.
      elseif (hsvmhue>=0.192 &&hsvmhue<0.438)
         colorFinal = 4;   %is green.
      elseif (hsvmhue>=0.438 &&hsvmhue<0.642)
         colorFinal = 5;   %is blue.
      elseif (hsvmhue>=0.642 &&hsvmhue<0.947)
         colorFinal = 6;   %is purple.
      else
         colorFinal = 4;   %in case didnt cover.
      end
   end
   
   finalShape=0;
   if (colorFinal~=0)
       finalShape =1;
   end
   
    finalGuess = 0;
   votingmatrix = zeros([1,32]); %letters A and Z and one error slot.
   %Work out letter. 
   if (colorFinal == 0)
       if (sroi.EulerNumber==-1)
           votingmatrix(2)=votingmatrix(2)+500;
       
       elseif (sroi.EulerNumber==0)
           votingmatrix(1)=votingmatrix(1)+25;
           votingmatrix(4)=votingmatrix(4)+25;
           votingmatrix(15)=votingmatrix(15)+25;
           votingmatrix(16)=votingmatrix(16)+25;
           votingmatrix(17)=votingmatrix(17)+25;
           votingmatrix(18)=votingmatrix(18)+25;
           votingmatrix(19)=votingmatrix(19)+25;
       else
           votingmatrix(1)=votingmatrix(1)-25;
           votingmatrix(4)=votingmatrix(4)-25;
           votingmatrix(15)=votingmatrix(15)-25;
           votingmatrix(16)=votingmatrix(16)-25;
           votingmatrix(17)=votingmatrix(17)-25;
           votingmatrix(18)=votingmatrix(18)-25;
           votingmatrix(19)=votingmatrix(19)-25;
           votingmatrix(2)=votingmatrix(2)-500;
       end

       
       [printer,finalGuess] = max(votingmatrix);
   end
   %%Beginning here we add the ocr for clumps.
   %%First we calculate orientation based on using the closest point to hole centroid.

   newholeDist= 99999;
    for counterj = 1: numel(largeBoundariesX)
       minDistX = (largeBoundariesX{counterj,1}(1:end)-(sroicentroids(1,1))).^2;
       minDistY = (largeBoundariesY{counterj,1}(1:end)-(sroicentroids(1,2))).^2;
       
       holeDist = min(sqrt(minDistX+minDistY));
       holeIndex = find(sqrt(minDistX+minDistY)==holeDist);
       if (holeDist < newholeDist)
           newholeDist = holeDist;
           preservedIndex = [counterj holeIndex];

       end  
    end
    if ((largeBoundariesX{preservedIndex(1,1),1}(preservedIndex(1,2)) - sroicentroids(1,1))~=0)
       gradient = (largeBoundariesY{preservedIndex(1,1),1}(preservedIndex(1,2)) - sroicentroids(1,2))/(largeBoundariesX{preservedIndex(1,1),1}(preservedIndex(1,2)) - sroicentroids(1,1)); 
    else
       gradient = 100;   %almost vertical 
    end
       rotateTile = atan(gradient)*(180/pi);
       
     if (colorFinal == 0)  %Using OCR.
       roiimg2 =imcomplement(bwmask.*roiimg);    
       
       roi =[sroicentroids(:,1)-40 sroicentroids(:,2)-40 80 80];
       cutletterImage = imcrop(roiimg2,roi);                        %%Just the tile, rotate and perform OCR.
       cutletterImage = imrotate(cutletterImage,rotateTile,'crop');
       cutletterImage = imcrop(cutletterImage,[12,17,50,50]);
       cutletterImage90=imrotate(cutletterImage,90,'crop');
       cutletterImage180=imrotate(cutletterImage,180,'crop');
       cutletterImage270=imrotate(cutletterImage,270,'crop');
       
       %figure;  imshow(roiimg2); 
       %figure;  imshow(cutletterImage); 
       %figure;  imshow(cutletterImage90); 
       %txt = ocr(imcomplement(roiimg2),[sroicentroids(1,1)-40 sroicentroids(1,2)-40 80 80],'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ','Language','English');
       v90 = 0;
       v180=0;
       v270=0;
       %%Rotating each tile 90 degrees, doing OCR and repeating. If high confidence letter is detected, and only 1 letter, vote for letter.
              txt = ocr(cutletterImage,'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ','Language','English');
       if(isempty(txt.CharacterConfidences)==false)
         
      
           if ((txt.CharacterConfidences(1)>= 0.70) && (isempty(txt.CharacterConfidences)==false) && length(txt.CharacterConfidences)<=3)
               v0 = uint64(txt.Words{1,1})-64;
               votingmatrix(v0)=votingmatrix(v0)+50;
           end   
       end
       txt90 = ocr(cutletterImage90,'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ','Language','English');
        if(isempty(txt90.CharacterConfidences)==false)
       
           if ((txt90.CharacterConfidences(1)>= 0.70) && (isempty(txt90.CharacterConfidences)==false)&& length(txt90.CharacterConfidences)<=3)
               v90 = uint64(txt90.Words{1,1})-64;
               votingmatrix(v90)=votingmatrix(v90)+50;        
           end
        end
       txt180 = ocr(cutletterImage180,'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ','Language','English');
        if(isempty(txt180.CharacterConfidences)==false)
      
           if ((txt180.CharacterConfidences(1)>= 0.70) && (isempty(txt180.CharacterConfidences)==false)&& length(txt180.CharacterConfidences)<=3)
               v180 = uint64(txt180.Words{1,1})-64;
               votingmatrix(v180)=votingmatrix(v180)+50;
           end
        end
       txt270 = ocr(cutletterImage270,'TextLayout', 'Word','CharacterSet','ABCDEFGHIJKLMNOPQRSTUVWXYZ','Language','English');
        if(isempty(txt270.CharacterConfidences)==false)
     
           if ((txt270.CharacterConfidences(1)>= 0.70) && (isempty(txt270.CharacterConfidences)==false)&& length(txt270.CharacterConfidences)<=3)
               v270 = uint64(txt270.Words{1,1})-64;
               votingmatrix(v270)=votingmatrix(v270)+50; 
           end
        end
     end   
    
    %Counting the ballots.     
       [printer,finalGuess] = max(votingmatrix);
%Only one of these should activate.
       flagDup=0;
       if (finalGuess == v90 && flagDup ~= 1)
          rotateTile = rotateTile+90;
          flagDup =1;
       end

  
       if (finalGuess == v180&& flagDup ~= 1)
          rotateTile = rotateTile+180;
          flagDup =1;
       end

  
       if (finalGuess == v270&& flagDup ~= 1)
          rotateTile = rotateTile+270;
          flagDup =1;
       end

       
       
%     roi =[sroicentroids(:,1)-40 sroicentroids(:,2)+40 80 80];
%     txt = ocr(imcomplement(roiimg),[sroicentroids(:,1)-40 sroicentroids(:,2)-40 80 80],'TextLayout', 'Word');
    if (showImageInfo ==1)
        hold on
        plot(sroicentroids(:,1),sroicentroids(:,2), 'b*')

        %text1 =num2str(rotateTile);
        text1 =num2str(finalGuess);
        text(sroicentroids(:,1),sroicentroids(:,2),text1,'Color','red');
        hold off
    end
    
%    figure;  imshow(roiimg); 
%     hold on;
%    plot(sroicentroids(:,1)-40,sroicentroids(:,2)+40, 'b*')
%   %rectangle('Position',[sroicentroids(:,1)-40 sroicentroids(:,2)-40 80 80],'FaceColor','r');
%    hold off 
   blocks2(counterblock,:) = [sroicentroids(1,1), sroicentroids(1,2), rotateTile, colorFinal,finalShape, finalGuess, inRange];
   
   
   counterblock =counterblock+1;
   
   
end

end

