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
function requestStr = jogMessage(action, setValues)  
    
    switch(action)
        case 1
            actStr = 'S01';
            procStr = 'X';
            jointStr = num2str(setValues,'%0+7.2f');
        case 2
            actStr = 'S02';
            procStr = 'X';
            jointStr = num2str(setValues,'%0+7.2f');
        case 3
            actStr = 'S03';
            procStr = 'X';
            jointStr = num2str(setValues,'%0+7.2f');
        case 4
            actStr = 'S04';
            procStr = 'X';
            jointStr = num2str(setValues,'%0+7.2f');
        case 5
            actStr = 'S05';
            procStr = 'X';
            jointStr = num2str(setValues,'%0+7.2f');
        case 6
            actStr = 'S06';
            procStr = 'X';
            jointStr = num2str(setValues,'%0+7.2f');
        case 7
            actStr = 'S07';
            procStr = num2str(setValues,'%1u');
            jointStr = 'XXXXXXX';
        case 8
            actStr = 'S08';
            procStr = num2str(setValues,'%1u');
            jointStr = 'XXXXXXX';
        case 9
            actStr = 'S09';
            procStr = num2str(setValues,'%1u');
            jointStr = 'XXXXXXX';
        case 10
            actStr = 'S10';
            procStr = num2str(setValues,'%1u');
            jointStr = 'XXXXXXX';
        case 11
            actStr = 'S11';
            procStr = num2str(setValues,'%1u');
            jointStr = 'XXXXXXX';
        case 12
            actStr = 'S12';
        case 13
            actStr = 'S13';
        case 14
            actStr = 'S14';
        case 15
            actStr = 'S15';
        case 16
            actStr = 'S16';            
    end
    
    xi = 'XXXXXXX';
    yi = 'XXXXXXX';
    zi = 'XXXXXXX';
    ti = 'XXXXXXX';
    xf = 'XXXXXXX';
    yf = 'XXXXXXX';
    zf = 'XXXXXXX';
    tf = 'XXXXXXX';   

    requestStr = strjoin({actStr, procStr, jointStr, xi, yi, zi, ti, xf, yf, zf, tf},'#');
    
    return;
    
end
