%%
clear;
clc;
time = 0:.01:9.99;
tic;

threatParams.mass = 1.134;
threatParams.area = 0.05067;
threatParams.drag = 0.47;
threatIC = [35 / sqrt(2),35 / sqrt(2),0,0];


interceptorParams.mass = 0.0427;
interceptorParams.area = 0.0025652;
interceptorParams.drag = 0.47;
interceptorIC = [-45 / sqrt(2),45 / sqrt(2),50,0];


[tInterceptor,YInterceptor] = ode45(@(t,Y) trajectory(t,Y,interceptorParams), time, interceptorIC);
[tThreat,YThreat] = ode45(@(t,Y) trajectory(t,Y,threatParams), time, threatIC);


plot(YInterceptor(:,3), YInterceptor(:,4));
hold on;
plot(YThreat(:,3), YThreat(:,4));

xlim([-30, 70]);
ylim([.1, 100]);