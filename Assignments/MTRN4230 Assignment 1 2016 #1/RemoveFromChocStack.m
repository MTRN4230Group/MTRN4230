% Author: Vivek Desai
% Last modified: 23/5/2016
% Purpose: Remove the top chocolate from the stack
% Inputs: A stack
% Outputs: The newly modified stack and the type of chocolate removed
function[Stack,TypeRemoved] = RemoveFromChocStack(Stack)
    [~,i] = size(Stack.xpos);
    TypeRemoved = Stack.type(i);
    Stack.xpos(i) = [];
    Stack.ypos(i) = [];
    Stack.theta(i) = [];
    Stack.position(i) = [];
    Stack.type(i) = [];
    [~,i] = size(Stack.xpos);
    if i==0
        Stack.height = 0;
        Stack.TypeAtTop = 0;
    end
    if i>0
    Stack.height=(Stack.position(i));
    Stack.TypeAtTop=Stack.type(i);
    end
end