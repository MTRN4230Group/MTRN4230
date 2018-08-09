% Author: Adam Mills
% Last modified: 28/5/2016
% Purpose: Returns a list of chocolates that are blocking the placing
% positions and a list of those not
% Inputs: A list of all of the chocolates with their positions
% Outputs: List of blocking chocolates and non blocking chocolates
function [blockingChocs,nonBlockingChocs] = StackingPosClear(ChocolateData)

blockingChocs1 = ChocolateData;
Choccolx = find(blockingChocs1.xpos<100 | blockingChocs1.xpos>300);
        blockingChocs1.xpos(Choccolx) = [];
        blockingChocs1.ypos(Choccolx) = [];
        blockingChocs1.theta(Choccolx) = [];
        blockingChocs1.type(Choccolx) = [];

blockingChocs = blockingChocs1;
Choccoly = find(blockingChocs.ypos<0 | blockingChocs.ypos>500);
        blockingChocs.xpos(Choccoly) = [];
        blockingChocs.ypos(Choccoly) = [];
        blockingChocs.theta(Choccoly) = [];
        blockingChocs.type(Choccoly) = [];
        


nonBlockingChocs = ChocolateData;
nChoccol = find(nonBlockingChocs.xpos>100 & nonBlockingChocs.xpos<300 & nonBlockingChocs.ypos>0 & nonBlockingChocs.ypos<500);
        nonBlockingChocs.xpos(nChoccol) = [];
        nonBlockingChocs.ypos(nChoccol) = [];
        nonBlockingChocs.theta(nChoccol) = [];
        nonBlockingChocs.type(nChoccol) = [];
        
end