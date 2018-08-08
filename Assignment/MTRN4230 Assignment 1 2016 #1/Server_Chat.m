% Author: Linda Mei
%
% Last modified: 29/3/2016
% 
% Purpose: Sends and receives a message to the robot
% 
% Inputs: The request strin and the socket
% 
% Outputs: a string
function responseStr = Server_Chat( requestStr,socket )

    % Send input string to robotstudio
    fwrite(socket,requestStr); %Getting connection status for confirmation
    
    % read in data from robotstudio and output (currently to command window
    % and this is just a return of the input string)
    
    responseStr = fgetl(socket);%data should be a str = '100 0' <=NEEDS TO BE EDITED IN PROTOCOL
    
    %Dummy msg to be printed in the message log
    fprintf(char(responseStr));


end

