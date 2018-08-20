%MTRN4230 PSE2 - William Weida Huang z5062658 - 20/08/2018  
clear all;
startup_rvc
%Defining DH parameter for each link.
L(1) = Link([0 0.290 0.000 pi/2]);
L(2) = Link([0 0.000 0.270 0]);
L(3) = Link([0 0.000 0.070 -pi/2]);
L(4) = Link([0 0.302 0.000 pi/2]);
L(5) = Link([0 0.000 0.0 -pi/2]);
L(6) = Link([0 0.065 0.0 pi/2]); 
L
%Put together, call it IRB120.
IRB120 = SerialLink(L, 'name', 'IRB120','offset', [0 pi/2 0 0 0 0]); %Apply an offset because of the parallel z axes.
%2.1 - Position plots for T1, T2 and T3.
T1 = [0, 6.5, 68.8, 0, 14.7, 0] ;
T2 = [-71.4, 70.3, -39.0, 0, 58.7,-71.4];
T3 = [71.4, 70.3, -39.0, 0, 58.7, 71.4];
axis([-1 1 -1 1 -1 1]);
IRB120.plot([0 0 0 0 0 0])
pause
IRB120.plot(T1)
pause
IRB120.plot(T2)
pause
IRB120.plot(T3)
pause

%2.2 - Forward Kinematic.
IRB120.fkine([pi/18 pi/18 pi/18 pi/18 pi/18 pi/18])
IRB120.plot([pi/18 pi/18 pi/18 pi/18 pi/18 pi/18]);
pause

%2.3 - Inverse Kinematic.
%quat = [0 0 1 0];
%tform = quat2tform(quat)
%Position for ikine [0.547, 0, 0.147]
%tform = [-1 0 0 0; 0 1 0 0; 0 0 -1 0; 0 0 0 1] is homogenous transformation matrix.
tform = [-1 0 0 0.547; 0 1 0 0; 0 0 -1 0.147; 0 0 0 1] %Concatenate Position
Q = IRB120.ikine(tform)
IRB120.plot(Q);

