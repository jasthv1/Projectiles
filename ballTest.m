%%
clear;
clc;

timeStep = 0.0001; 
%Time interval
time = 0:timeStep:(5 - timeStep);
height = 10;

%Define parameters for threat structure
threatParams.mass = 1.134;
threatParams.area = 0.05067;
threatParams.drag = 0.47;
threatIC = [0, 0, 0, height];

%Differential equations solver calculates the X velocities, Z velocities,
%X position, and Z position. Stored in an array 'Y'
[tThreat,YThreat] = ode45(@(t,Y) trajectory(t,Y,threatParams), time, threatIC);

%Find when the ball hits the ground
ground = find(YThreat(:, 4) < 0, 1, 'first');
timeGround = ground / 100

%Plot everything
plot(YThreat(:, 3), YThreat(:, 4));

%Set plot limits
xlim([-30, 70]);
ylim([.1, 40]);
title('Kickball ICBM VS. Raquetball SAM (New Model)');
xlabel('X Position in Meters');
ylabel('Y Position in Meters');

