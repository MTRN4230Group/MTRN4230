% Author: Linda Mei
%
% Last modified: 29/3/2016
% 
% Purpose: Converts the response message from the robot into a display
% message
% 
% Inputs: The response string
% 
% Outputs: None
function msgReceived(responseStr)

    [code,value] = strtok(responseStr);
    
    %disp('\n');
    disp(code);
    disp(value);

    switch(code)
        case '100'
            disp('Completed');
        case '101'
            disp('Accepted');
        case '200'
            disp('Bad Request');
        case '201'
            disp('Not Acknowledged');
        case '202'
            disp('Forbidden');
        case '203'
            disp('Request Timeout');
        case '204'
            disp('Action Not Allowed');
        case '205'
            disp('Conflict');
        case '300'
            disp('Internal Server Error');
        case '301'
            disp('Not Implemented');
        case '302'
            disp('Service Unavailable');
        case '303'
            disp('Connection Timeout');
        otherwise
            disp('Unidentifiable error');
    end
        
end

