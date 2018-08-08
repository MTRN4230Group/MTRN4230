% Author: Niels Alston
% Date modified: 28.5.2016
% This function is called to flip a chocolate from a certain position using
% our predefined flipping mechanism

function flipChocolate( handles, xi, yi, zi, thetai )

setValue = [xi yi zi thetai];
chocolateMessage(15, setValue, handles.socket); %do the flipping action, check number is correct
chocolateMessage(16, time, handles.socket); %turn conveyor on for a second
snap = getsnapshot(handles.conveyorvid);
ChocolateData = z337302_MTRN4230_ASST2(snap, 2);

end

