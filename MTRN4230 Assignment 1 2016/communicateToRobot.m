% Author: Niels Alston
%
% Last modified: 29/3/2016
% 
% Purpose: Converts the message to be sent to the robot into a readable
% string, sends it to the robot and receives a reply with the success or
% failure of the action
% 
% Inputs: The action, which is a code according to the protocol, the
% optional setValue which specifies position, the actionType: either get or
% set and the socket.
function communicateToRobot(action, setValue, actionType, socket)
    requestStr = msgForSending(action, actionType, setValue);
    responseStr = Server_Chat(requestStr,socket);
    msgReceived(responseStr);
return    