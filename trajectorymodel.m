%%
clear;
clc;
%Time interval
time = 0:.001:9.99;
%Begin timing
tic;

%Define parameters for threat structure
threatParams.mass = 1.134;
threatParams.area = 0.05067;
threatParams.drag = 0.47;
threatIC = [35 / sqrt(2),35 / sqrt(2),0,0];

%Define parameters for interceptor structure
interceptorParams.mass = 0.0427;
interceptorParams.area = 0.0025652;
interceptorParams.drag = 0.47;
interceptorIC = [-45 / sqrt(2),45 / sqrt(2),50,0];

%Differential equations solver calculates the X velocities, Z velocities,
%X position, and Z position. Stored in an array 'Y'
[tInterceptor,YInterceptor] = ode45(@(t,Y) trajectory(t,Y,interceptorParams), time, interceptorIC);
[tThreat,YThreat] = ode45(@(t,Y) trajectory(t,Y,threatParams), time, threatIC);

%Create an array for the interceptor and threat X positions and Y positions
interceptorPath = [YInterceptor(:,3), YInterceptor(:,4)];
threatPath = [YThreat(:,3), YThreat(:,4)];

%Stop timing
toc;

%Plot everything
plot(YInterceptor(:,3), YInterceptor(:,4));
hold on;
plot(YThreat(:,3), YThreat(:,4));

InterX(interceptorPath, threatPath)

%Set plot limits
xlim([-30, 70]);
ylim([.1, 100]);