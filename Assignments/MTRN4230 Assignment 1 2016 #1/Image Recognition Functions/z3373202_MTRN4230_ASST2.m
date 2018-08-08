%Author:Vivek Desai
%Date: 03/06/2016
%Description : Assignment 2 : Image Detection Code

%sample input code
%z3373202_MTRN4230_ASST2('C:\Users\vivek\OneDrive\Documents\Sem1 2016\MTRN4230\Assignments\Assignment 2\Final\Calibration images\tablemilkmintcalib.jpg',
%'calibrationimage','outputfile1.txt')
function ChocolateData = z3373202_MTRN4230_ASST2(image,imagefeed)
tic;
warning off ;
%im = imread('C:\Users\vivek\OneDrive\Documents\Sem1 2016\MTRN4230\Assignments\Assignment 2\Training labels\IMG_001);

%the imagefeed value determines the source of the workspace image in order
%to appropriately image subtract.
%imagefeed 1 = table 
%imagefeed 2 = conveyor
%im = image
im = imread(image);
imshow(im)
chocolates = DetectChocolates(im,imagefeed);
[num,~]=size(chocolates);

%transform for pixel to distance depending on workspace image source
if num >0
    if imagefeed ==1 
        ChocolateData.xpos =chocolates(:,2)/1.51 +15;
        ChocolateData.ypos =chocolates(:,1)/1.51 +530;
    end
    if imagefeed == 2 
        ChocolateData.xpos =chocolates(:,2)/1.315 -393;
        ChocolateData.ypos =chocolates(:,1)/1.315 -326;
    end
ChocolateData.theta =chocolates(:,3)*(180/pi);
ChocolateData.type =chocolates(:,4);
end

if num == 0
    
    
%initialisation of ChocolateData structure in the event of no chocolates 
ChocolateData.xpos = [];
ChocolateData.ypos = [];
ChocolateData.theta = [];
ChocolateData.type= [];

end
%write_output_file(chocolates, image_file_name, output_file_path);

toc
end

%function used for debugging logs
function write_output_file(chocolates, image_file_name, output_file_path)

fid = fopen(output_file_path, 'w');

fprintf(fid, 'image_file_name:\n');
fprintf(fid, '%s\n', image_file_name);
fprintf(fid, 'rectangles:\n');
fprintf(fid, ...
        [repmat('%f ', 1, size(chocolates, 2)), '\n'], chocolates');
    
% Please ensure that you close any files that you open. If you fail to do
% so, there may be a noticeable decrease in the speed of your processing.
%fclose(fid);
end