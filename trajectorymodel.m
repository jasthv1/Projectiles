function timeTillLaunch = trajectorymodel(startingXThreat, startingZThreat, vXThreat, vZThreat, makePlots)

%Begin timing
tic;

%Time interval
timeStep = 0.01;
time = 0:timeStep:(10 - timeStep);

%Get paths
paths = getPaths(time, startingXThreat, startingZThreat, vXThreat, vZThreat);
YInterceptor = paths.interceptor;
YThreat = paths.threat;



%Calculate intersections
[intersectionX, intersectionY] = intersections(YInterceptor(:, 3), YInterceptor(:, 4), YThreat(:, 3), YThreat(:, 4));


%Iterator through the paths
%Finds the index of the first x greater than the intersection point
%Finds the time at these points00
iThreat = find(YThreat(:, 3) > intersectionX, 1);
xBefore = YThreat(iThreat - 1, 3);
xAfter = YThreat(iThreat, 3);
xDif = xAfter - xBefore;
xDifToIntersection = intersectionX - xBefore;
ratio = xDifToIntersection / xDif;
timeIntersectionThreat = time(iThreat) + ratio * timeStep;

iInterceptor = find(YInterceptor(:, 3) < intersectionX, 1);
xBefore = YInterceptor(iInterceptor - 1, 3);
xAfter = YInterceptor(iInterceptor, 3);
xDif = xAfter - xBefore;
xDifToIntersection = intersectionX - xBefore;
ratio = xDifToIntersection / xDif;
timeIntersectionInterceptor = time(iInterceptor) + ratio * timeStep;

%Stop timing and read time
timeElapsed = toc;

%Find the time until the interceptor needs to be launched
timeTillLaunch = timeIntersectionThreat - timeIntersectionInterceptor - timeElapsed;

%Plot everything
if(makePlots)
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
end
