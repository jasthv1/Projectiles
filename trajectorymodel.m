%%
clear;
clc;

timeStep = 0.01; 
%Time interval
time = 0:timeStep:(5 - timeStep);
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

%Calculate intersections
[intersectionX, intersectionY] = intersections(YInterceptor(:, 3), YInterceptor(:, 4), YThreat(:, 3), YThreat(:, 4));

%Iterator through the threat path
%Arbitraly look at x values of threat
%Finds the index of the first x greater than the intersection point
iThreat = 1;
while YThreat(iThreat,3) < intersectionX
    iThreat = iThreat + 1;
end
xBefore = YThreat(iThreat - 1, 3);
xAfter = YThreat(iThreat, 3);
xDif = xAfter - xBefore;
xDifToIntersection = intersectionX - xBefore;
ratio = xDifToIntersection / xDif;
timeIntersection = tThreat(iThreat) + ratio * timeStep

iIntercept = 1;
while YInterceptor(iIntercept,3) > intersectionX
    iIntercept = iIntercept + 1;
end

%Stop timing
toc;

%Plot everything
plot(YInterceptor(1:iIntercept,3), YInterceptor(1:iIntercept,4), 'b');
hold on;
plot(YInterceptor(iIntercept: length(YInterceptor),3), YInterceptor(iIntercept: length(YInterceptor),4), ':b');

plot(YThreat(1:iThreat,3), YThreat(1:iThreat,4), 'r');
plot(YThreat(iThreat:length(YThreat),3), YThreat(iThreat:length(YThreat),4), ':r');

plot(intersectionX, intersectionY, '-*k');
%Set plot limits
xlim([-30, 70]);
ylim([.1, 100]);