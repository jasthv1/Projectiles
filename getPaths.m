function paths = getPaths(time, seperation)

%Defining variables
voThreat = 20;
angleThreat =  pi / 4 ;
voInterceptor = 45;
angleInterceptor = pi / 4;
%seperation = 25;


%Define parameters for threat structure
threatParams.mass = 1.134;
threatParams.area = 0.05067;
threatParams.drag = 0.47;
threatIC = [voThreat * cos(angleThreat),voThreat * sin(angleThreat),-seperation, 0];

%Define parameters for interceptor structure
interceptorParams.mass = 0.0427;
interceptorParams.area = 0.0025652;
interceptorParams.drag = 0.47;
interceptorIC = [-voInterceptor * cos(angleInterceptor),voInterceptor * sin(angleInterceptor),0,0];

%Differential equations solver calculates the X velocities, Z velocities,
%X position, and Z position. Stored in an array 'Y'
[tInterceptor,YInterceptor] = ode45(@(t,Y) trajectory(t,Y,interceptorParams), time, interceptorIC);
[tThreat,YThreat] = ode45(@(t,Y) trajectory(t,Y,threatParams), time, threatIC);


paths.interceptor = YInterceptor;
paths.threat = YThreat;