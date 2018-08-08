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
function requestStr = msgForSending(action,actionType,setValue)

    if actionType == 0
        requestStr = getMsg(action);
    elseif actionType == 1
        requestStr = setMsg(action,setValue);
    else
        disp('Unidentified Action')
    end
    
    disp(requestStr);
    
end

function requestStr = getMsg(action)

    switch(action)
        case 1
            requestStr = 'G01 X';
        case 2
            requestStr = 'G02 X';
        case 3
            requestStr = 'G03 X';
        case 4
            requestStr = 'G04 X';
        case 5
            requestStr = 'G05 X';
        case 6
            requestStr = 'G06 X';
        case 7
            requestStr = 'G07 X';
        case 8
            requestStr = 'G08 X';
        case 9
            requestStr = 'G09 X';
        case 10
            requestStr = 'G10 X';
        case 11
            requestStr = 'G11 X';
        case 12
            requestStr = 'G12 X';
        case 13
            requestStr = 'G13 X';
        case 14
            requestStr = 'G14 X';
        case 15
            requestStr = 'G15 X';
        case 16
            requestStr = 'G16 X';
        case 17
            requestStr = 'G17 X';
        case 18
            requestStr = 'G18 X';
        case 19
            requestStr = 'G19 X';
        case 20
            requestStr = 'G20 X';
        case 21
            requestStr = 'G21 X';
        case 22
            requestStr = 'G22 X';
        case 23
            requestStr = 'G23 X';
        case 24
            requestStr = 'G24 X';
        case 25
            requestStr = 'G25 X';
        case 26
            requestStr = 'G26 X';
        case 27
            requestStr = 'G27 X';
        case 28
            requestStr = 'G28 X';
        case 29
            requestStr = 'G29 X';
        case 30
            requestStr = 'G30 X';
        case 31
            requestStr = 'G31 X';
        case 32
            requestStr = 'G32 X';
        case 33
            requestStr = 'G33 X';
        case 34
            requestStr = 'G34 X';
        case 35
            requestStr = 'G35 X';
        case 36
            requestStr = 'G36 X';
        case 37
            requestStr = 'G37 X';
    end
    
end

function requestStr = setMsg(action,setValue)

    valueStr = num2str(setValue);

    switch(action)
        case 1
            requestStr = 'S01';
        case 2
            requestStr = 'S02';
        case 3
            requestStr = 'S03';
        case 4
            requestStr = 'S04';
        case 5
            requestStr = 'S05';
        case 6
            requestStr = 'S06';
        case 7
            requestStr = 'S07';
        case 8
            requestStr = 'S08';
        case 9
            requestStr = 'S09';
        case 10
            requestStr = 'S10';
        case 11
            requestStr = 'S11';
        case 12
            requestStr = 'S12';
        case 13
            requestStr = 'S13';
        case 14
            requestStr = 'S14';
        case 15
            requestStr = 'S15';
        case 16
            requestStr = 'S16';
        case 17
            requestStr = 'S17';
        case 18
            requestStr = 'S18';
        case 19
            requestStr = 'S19';
        case 20
            requestStr = 'S20';
        case 21
            requestStr = 'S21';
        case 22
            requestStr = 'S22';
        case 23
            requestStr = 'S23';
        case 24
            requestStr = 'S24';
        case 25
            requestStr = 'S25';
        case 26
            requestStr = 'S26';
        case 27
            requestStr = 'S27';
        case 28
            requestStr = 'S28';
        case 29
            requestStr = 'S29';
        case 30
            requestStr = 'S30';
        case 31
            requestStr = 'S31';
        case 32
            requestStr = 'S32';
        case 33
            requestStr = 'S33';
        case 34
            requestStr = 'S34';
        case 35
            requestStr = 'S35';
        case 36
            requestStr = 'S36';
        case 37
            requestStr = 'S37';
        case 38
            requestStr = 'S38';
        case 39
            requestStr = 'S39';
        case 40
            requestStr = 'S40';
        case 41
            requestStr = 'S41';
        case 42
            requestStr = 'S42';
        case 43
            requestStr = 'S43';
    end
    
        requestStr = strjoin({requestStr, valueStr});
    
end

