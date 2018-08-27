%MTRN4230 PSE3 Singularity - William Weida Huang z5062658 - 20/08/2018  
clear all; close all;
startup_rvc
%Defining DH parameter for each link.
L(1) = Link([0 0.290 0.000 pi/2]);
L(2) = Link([0 0.000 0.270 0]);
L(3) = Link([0 0.000 0.070 -pi/2]);
L(4) = Link([0 0.302 0.000 pi/2]);
L(5) = Link([0 0.000 0.000 pi/2]);
L(6) = Link([0 0.137 0.0 0]); 
L;
%Put together, call it IRB120.
IRB120 = SerialLink(L, 'name', 'IRB120','offset', [pi pi/2 0 0 pi 0]); 

% Above is just the DH defined robot from PSE2. CCW is positive direction.

T0 = [0, 0, 0, 0, 0, 0]*(pi/180);
T1 = [0, 6.5, 68.8, 0, 14.7, 0]*(pi/180);
T2 = [-71.4, 70.3, -39.0, 0, 58.7,-71.4]*(pi/180);

axis([-1 1 -1 1 -1 1]);
%To achieve relatively slow end-effector motion, very high-speed motion of the shoulder and elbow may be needed.
% Maniplty calculates the susceptibility to this through calculating the volume of an ellipsoid from which we can visualize the
% translational component (an ellipse). The axes refer to the possible velocities in each direction, thus, it can be seen that T1, 
% with the smaller range of values in both the vertical (Z) and x directions, can achieve less velocity in those directions compared to T0 and T2. 
IRB120.plot(T0)
J = IRB120.jacob0(T0);
jsingu(J);    %Determines whether any joints are in singularity
IRB120.maniplty(T0,'all')   
%figure; IRB120.vellipse(T0, 'trans'); %Plots the ellipsoid for the translational component.
pause
IRB120.plot(T1)
J = IRB120.jacob0(T1);
jsingu(J);
IRB120.maniplty(T1,'all')
figure;  IRB120.vellipse(T1, 'trans');
pause
IRB120.plot(T2)
J = IRB120.jacob0(T2);
jsingu(J);
IRB120.maniplty(T2,'all')
%figure;  IRB120.vellipse(T2, 'trans');

%This is a really good explanation: (Jesse)
%Wrist Singularities - These happen when two of the robot's wrist axes (joints 4 and 6) line up with each other. 
% This can cause these joints to try and spin 180 degrees instantaneously.
%Shoulder Singularities - These happen when the center of the robot's wrist aligns with the axis of joint 1. It
% causes joints 1 and 4 to try and spin 180 degrees instantaneously. A subset of this is an Alignment Singularity, where the first and last joints of the robot (joints 1 and 6) line up with each other.
%Elbow Singularities - These happen when the center of the robot's wrist lies on the same plane as joints 2 and 3.
% Elbow singularities look like the robot has "reached too far", causing the elbow to lock in position. This video shows a good example of an elbow singularity which causes the robot to get stuck.
