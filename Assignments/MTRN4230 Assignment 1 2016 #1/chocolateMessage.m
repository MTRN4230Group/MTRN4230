% Author: Linda Mei
%
% Last modified: 29/3/2016
% 
% Purpose: Converts the message to be sent to the robot into a string
% 
% Inputs: The action, which is a code according to the protocol, the
% optional setValue which specifies position, the actionType: either get or
% set
% 
% Outputs: a string
function requestStr = chocolateMessage(action, setPositions)

    xi = num2str(setPositions(1),'%0+7.2f');
    yi = num2str(setPositions(2),'%0+7.2f');
    zi = num2str(setPositions(3),'%0+7.2f');
    ti = num2str(setPositions(4),'%0+7.2f');    
    
    switch(action)
%         case 1
%             actStr = 'S01';
%         case 2
%             actStr = 'S02';
%         case 3
%             actStr = 'S03';
%         case 4
%             actStr = 'S04';
%         case 5
%             actStr = 'S05';
%         case 6
%             actStr = 'S06';
%         case 7
%             actStr = 'S07';
%         case 8
%             actStr = 'S08';
%         case 9
%             actStr = 'S09';
%         case 10
%             actStr = 'S10';
%         case 11
%             actStr = 'S11';
        case 12
            actStr = 'S12';
            xf = num2str(setPositions(5),'%0+7.2f');
            yf = num2str(setPositions(6),'%0+7.2f');
            zf = num2str(setPositions(7),'%0+7.2f');
            tf = num2str(setPositions(8),'%0+7.2f');
        case 13
            actStr = 'S13';
            xf = 'XXXXXXX';
            yf = 'XXXXXXX';
            zf = 'XXXXXXX';
            tf = 'XXXXXXX';
        case 14
            actStr = 'S14';
            xf = num2str(setPositions(5),'%0+7.2f');
            yf = num2str(setPositions(6),'%0+7.2f');
            zf = num2str(setPositions(7),'%0+7.2f');
            tf = num2str(setPositions(8),'%0+7.2f');
        case 15
            actStr = 'S15';
            xf = num2str(setPositions(5),'%0+7.2f');
            yf = num2str(setPositions(6),'%0+7.2f');
            zf = num2str(setPositions(7),'%0+7.2f');
            tf = num2str(setPositions(8),'%0+7.2f');
        case 16
            actStr = 'S16';
            xf = num2str(setPositions(5),'%0+7.2f');
            yf = num2str(setPositions(6),'%0+7.2f');
            zf = num2str(setPositions(7),'%0+7.2f');
            tf = num2str(setPositions(8),'%0+7.2f');
            
        case 17
            actStr = 'S17';
            xi = 'XXXXXXX';
            yi = 'XXXXXXX';
            zi = 'XXXXXXX';
            ti = 'XXXXXXX';
            xf = 'XXXXXXX';
            yf = 'XXXXXXX';
            zf = 'XXXXXXX';
            tf = 'XXXXXXX';
            
        otherwise
            disp('wrong function for action or wrong action number');
    end
    
    procStr = 'X';
    jointStr = 'XXXXXXX';

    requestStr = strjoin({actStr, procStr, jointStr, xi, yi, zi, ti, xf, yf, zf, tf},'#')
    
    return;
    
end
