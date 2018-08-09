% Author: Vivek Desai
% Last modified: 23/5/2016
% Purpose: Initialise a stack in a position
% Inputs: X position, Y position, Angle of the stack, base chocolate type
% Outputs: The newly created stack
function[Stack] = InitialiseChocStack(StackXpos , StackYpos , StackTheta , baseChocType)
   Stack.StackXpos = StackXpos;
   Stack.StackYpos = StackYpos;
   Stack.StackTheta =StackTheta;
if baseChocType == 0
   Stack.xpos = [];
   Stack.ypos = [];
   Stack.theta = [];
   Stack.position = [];
   Stack.type = [];
   Stack.height=0;
   Stack.TypeAtTop=[];
end
if baseChocType ~= 0
   Stack.xpos = [StackXpos];
   Stack.ypos = [StackYpos];
   Stack.theta = [StackTheta];
   Stack.position = [1];
   Stack.type = [baseChocType];
   Stack.height=[1];
   Stack.TypeAtTop=[baseChocType];
end
end

