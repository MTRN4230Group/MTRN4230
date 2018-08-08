% Author: Vivek Desai
%
% Last modified: 29/3/2016
% 
% Purpose: Script to connect with the IRB120 robot system
% 
% Outputs: a socket

function socket = Server_Connect()
   
    %this is in effect the protocol for sending data to Robot Studio
    % x,y and z are prefixes for the relative coordinates,
    % #signifies the end of input string.
    
    % The robot's IP address '192.168.2.1' for actual robot , '127.0.0.1'for simulation .
    
%     robot_IP_address = '192.168.125.1';
     robot_IP_address = '127.0.0.1';

    % The port that the robot will be listening on. This must be the same as in
    % your RAPID program.
    robot_port = 1064;

    % Open a TCP connection to the robot.
    socket = tcpip(robot_IP_address, robot_port);
    set(socket, 'ReadAsyncMode', 'continuous');
    fopen(socket);


    % Check if the connection is valid.
    if(~isequal(get(socket, 'Status'), 'open'))
        warning(['Could not open TCP connection to ', robot_IP_address, ' on port ', robot_port]);
        return;
    end

    % Send input string to robotstudio
    fwrite(socket, 'G01 1'); %Getting connection status for confirmation
    
    % read in data from robotstudio and output (currently to command window
    % and this is just a return of the input string)
    
    data = fgetl(socket);%data should be a str = '100 0' <=NEEDS TO BE EDITED IN PROTOCOL
    
    %Dummy msg to be printed in the message log
    fprintf(char(data));
end
