% Author: Linda Mei
%
% Last modified: 29/3/2016
% 
% Purpose: Sends a disconnection request to the robot
% 
% Inputs: The socket

function Server_Disconnect(socket)
    % Request close connection with Robot studio
    
    fwrite(socket,'S01 1');
    % Close the socket.
    fclose(socket);
    
    %Dummy position for the message to be displayed in the message log
    disp('Connection to Robot Server has been cut');

end

