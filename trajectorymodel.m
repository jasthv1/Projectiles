function timeTillLaunch = trajectorymodel(seperation)

%Begin timing
tic;

%Defining variables
voThreat = 20;
angleThreat =  pi / 4 ;
voInterceptor = 45;
angleInterceptor = pi / 4;
%seperation = 25;

%Time interval
timeStep = 0.01;
time = 0:timeStep:(10 - timeStep);

%Define parameters for threat structure
threatParams.mass = 1.134;
threatParams.area = 0.05067;
threatParams.drag = 0.47;
threatIC = [voThreat * cos(angleThreat),voThreat * sin(angleThreat),0,0];

%Define parameters for interceptor structure
interceptorParams.mass = 0.0427;
interceptorParams.area = 0.0025652;
interceptorParams.drag = 0.47;
interceptorIC = [-voInterceptor * cos(angleInterceptor),voInterceptor * sin(angleInterceptor),seperation,0];

%Differential equations solver calculates the X velocities, Z velocities,
%X position, and Z position. Stored in an array 'Y'
[tInterceptor,YInterceptor] = ode45(@(t,Y) trajectory(t,Y,interceptorParams), time, interceptorIC);
[tThreat,YThreat] = ode45(@(t,Y) trajectory(t,Y,threatParams), time, threatIC);
%Calculate intersections
[intersectionX, intersectionY] = intersections(YInterceptor(:, 3), YInterceptor(:, 4), YThreat(:, 3), YThreat(:, 4));


%Iterator through the paths
%Finds the index of the first x greater than the intersection point
%Finds the time at these points
iThreat = find(YThreat(:, 3) > intersectionX, 1);
xBefore = YThreat(iThreat - 1, 3);
xAfter = YThreat(iThreat, 3);
xDif = xAfter - xBefore;
xDifToIntersection = intersectionX - xBefore;
ratio = xDifToIntersection / xDif;
timeIntersectionThreat = tThreat(iThreat) + ratio * timeStep;

iInterceptor = find(YInterceptor(:, 3) < intersectionX, 1);
xBefore = YInterceptor(iInterceptor - 1, 3);
xAfter = YInterceptor(iInterceptor, 3);
xDif = xAfter - xBefore;
xDifToIntersection = intersectionX - xBefore;
ratio = xDifToIntersection / xDif;
timeIntersectionInterceptor = tInterceptor(iInterceptor) + ratio * timeStep;

%Stop timing and read time
timeElapsed = toc;
%Find the time until the interceptor needs to be launched
timeTillLaunch = timeIntersectionThreat - timeIntersectionInterceptor - timeElapsed

%Plot everything
%Comment out eventually
plot(YInterceptor(1:iInterceptor,3), YInterceptor(1:iInterceptor,4), 'b');
hold on;
plot(YThreat(1:iThreat,3), YThreat(1:iThreat,4), 'r');
plot(YInterceptor(iInterceptor: length(YInterceptor),3), YInterceptor(iInterceptor: length(YInterceptor),4), ':b');
plot(YInterceptor(iInterceptor: length(YInterceptor),3), YInterceptor(iInterceptor: length(YInterceptor),4), ':b');
plot(YThreat(iThreat:length(YThreat),3), YThreat(iThreat:length(YThreat),4), ':r');
plot(intersectionX, intersectionY, '-*k');

%Set plot limits
xlim([-30, 70]);
ylim([.1, 40]);
title('Kickball ICBM VS. Raquetball SAM');
xlabel('X Position in Meters');
ylabel('Y Position in Meters');
legend('Interceptor', 'Target');

