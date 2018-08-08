% Author: Vivek Desai
% Last modified: 23/5/2016
% Purpose: Adds a chocolate to a virtual stack
% Inputs: A stack and a chocolate type
% Outputs: The newly modified stack
function[Stack]=AddToChocStack(Stack,choctype)
   [~,i] = size(Stack.xpos);
   
   Stack.xpos = [Stack.xpos ,Stack.StackXpos ];
   Stack.ypos = [Stack.ypos ,Stack.StackYpos ];
   Stack.theta = [Stack.theta ,Stack.StackTheta ];
   
   Stack.type = [Stack.type,choctype];
   Stack.TypeAtTop=choctype;
   if i ==0
       Stack.position = [Stack.position,1];

   end
   if i>0
       Stack.position = [Stack.position,(Stack.position(i)+1)];

   end
   [~,Stack.height]=(size(Stack.xpos));
   
end
