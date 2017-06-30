clear;
clc;
tic;

time = 0:.01:9.99;

%angles in radians
thetaX=44.9152 * pi / 180;
thetaY=36.7488 * pi /180;

%angle of camera tilted up and to sides.. RADIANS
%NOTE: variables to change
cameraAngleUp = 15*pi/180;
cameraAngleToSide = 0; 

%2 indicates camera 2
cameraAngleUp2 = 15*pi/180;
cameraAngleToSide2 = 0; 

%NOTE: test different numbers (to change), in meters
disFromT = 20;
disBetween= 15;
disOffGround=5;
cam1Pos=0;

%dimensions of camera
height=2;
width=2.44;


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

toc;

%plot the target and interceptor
plot3(YInterceptor(:,3), zeros(4,1000), YInterceptor(:,4)); grid on

hold on

plot3(YThreat(:,3), zeros(4,1000), YThreat(:,4)); grid on

%camera 1 location, NOTE: a variable to change
plot3([cam1Pos,cam1Pos,width+cam1Pos,width+cam1Pos,cam1Pos], [disFromT,disFromT,disFromT,disFromT,disFromT], [disOffGround,disOffGround+height,disOffGround+height,disOffGround,disOffGround]);

%camera 2 location, NOTE: a variable to change
plot3([disBetween+cam1Pos,disBetween+cam1Pos,disBetween+width+cam1Pos,disBetween+width+cam1Pos,disBetween+cam1Pos], [disFromT,disFromT,disFromT,disFromT,disFromT], [disOffGround,disOffGround+height,disOffGround+height,disOffGround,disOffGround]);

%camera 1 bore's sight line
boreVecX = zeros (disFromT,1);
boreVecY = zeros (disFromT,1);
boreVecZ = zeros (disFromT,1);

%camera 2
boreVecX2 = zeros (disFromT,1);
boreVecY2 = zeros (disFromT,1);
boreVecZ2 = zeros (disFromT,1);

count = disFromT;
pos2 = disFromT;
pos = 1;

while count>0
    
    boreVecX(pos2) = count * tan(cameraAngleToSide)+width/2+cam1Pos;
    boreVecY(pos) = count;
    boreVecZ(pos2) = count * tan(cameraAngleUp)+disOffGround+height/2;
    
    %camera 2
    boreVecX2(pos2) = count * tan(cameraAngleToSide2)+width/2+disBetween+cam1Pos;
    boreVecY2(pos) = count;
    boreVecZ2(pos2) = count * tan(cameraAngleUp2)+disOffGround+height/2;
    
    pos= pos+1;
    pos2=pos2-1;
    
    count= count-1;
    
end

%bores sight line for camera 1 and 2
plot3(boreVecX, boreVecY, boreVecZ);

plot3(boreVecX2, boreVecY2, boreVecZ2);

%outer lines for cameras, NOTE: use boreVecY for y
upperLeftX = zeros(disFromT, 1);
upperLeftZ = zeros(disFromT, 1);
upperRightX = zeros(disFromT, 1);
upperRightZ = zeros(disFromT, 1);
lowerLeftX = zeros(disFromT, 1);
lowerLeftZ = zeros(disFromT, 1);
lowerRightX = zeros(disFromT, 1);
lowerRightZ = zeros(disFromT, 1);

%camera 2
upperLeftX2 = zeros(disFromT, 1);
upperLeftZ2 = zeros(disFromT, 1);
upperRightX2 = zeros(disFromT, 1);
upperRightZ2 = zeros(disFromT, 1);
lowerLeftX2 = zeros(disFromT, 1);
lowerLeftZ2 = zeros(disFromT, 1);
lowerRightX2 = zeros(disFromT, 1);
lowerRightZ2 = zeros(disFromT, 1);

count=disFromT;
pos2=disFromT;


while count>0
    
    lowerLeftX(pos2) = boreVecX(pos2)- count * tan (thetaX/2) - width/2 ;
    lowerLeftZ(pos2) = boreVecZ(pos2) - count * tan(thetaY/2) - height/2;
    
    upperLeftX(pos2) = boreVecX(pos2)- count * tan (thetaX/2) - width/2 ;
    upperLeftZ(pos2) = boreVecZ(pos2) + count * tan(thetaY/2) + height/2;
    
    upperRightX(pos2) = boreVecX(pos2)+ count * tan (thetaX/2) +width/2 ;
    upperRightZ(pos2) = boreVecZ(pos2) + count * tan(thetaY/2) + height/2;
    
    lowerRightX(pos2) = boreVecX(pos2)+ count * tan (thetaX/2) + width/2 ;
    lowerRightZ(pos2) = boreVecZ(pos2) - count * tan(thetaY/2) - height/2;
    
    %camera 2
    lowerLeftX2(pos2) = boreVecX(pos2)- count * tan (thetaX/2) - width/2+disBetween ;
    lowerLeftZ2(pos2) = boreVecZ(pos2) - count * tan(thetaY/2) - height/2;
    
    upperLeftX2(pos2) = boreVecX(pos2)- count * tan (thetaX/2) - width/2+disBetween ;
    upperLeftZ2(pos2) = boreVecZ(pos2) + count * tan(thetaY/2) + height/2;
    
    upperRightX2(pos2) = boreVecX(pos2)+ count * tan (thetaX/2) +width/2+disBetween ;
    upperRightZ2(pos2) = boreVecZ(pos2) + count * tan(thetaY/2) + height/2;
    
    lowerRightX2(pos2) = boreVecX(pos2)+ count * tan (thetaX/2) + width/2 +disBetween;
    lowerRightZ2(pos2) = boreVecZ(pos2) - count * tan(thetaY/2) - height/2;   
    
    pos2=pos2-1;
    
    count= count-1;
    
end

plot3(lowerLeftX,boreVecY , lowerLeftZ,'--');
plot3(upperLeftX,boreVecY , upperLeftZ,'--');
plot3(lowerRightX,boreVecY , lowerRightZ,'--');
plot3(upperRightX,boreVecY , upperRightZ,'--');

%create funnels
plane1X=[0,0, upperLeftX(disFromT),lowerLeftX(disFromT),0];
plane1Y=[disFromT,disFromT, 0,0,disFromT];
plane1Z=[disOffGround, disOffGround+height, upperLeftZ(disFromT),lowerLeftZ(disFromT),disOffGround];

colors=[.5,.5,.5,.5,.5];

fill3(plane1X,plane1Y,plane1Z,colors);
alpha(.5);

plane2X=[0,width,upperRightX(disFromT),upperLeftX(disFromT),0];
plane2Z=[disOffGround+height,disOffGround+height,upperRightZ(disFromT),upperLeftZ(disFromT) ,disOffGround+height];

fill3(plane2X,plane1Y,plane2Z,colors);
alpha(.5);

plane3X=[width,width,upperRightX(disFromT) ,lowerRightX(disFromT) ,width];
plane3Z=[disOffGround,disOffGround+height,upperRightZ(disFromT),lowerRightZ(disFromT),disOffGround];

fill3(plane3X,plane1Y,plane3Z, colors);
alpha(.5);

plane4X=[0,width,lowerRightX(disFromT),lowerLeftX(disFromT),0];
plane4Z=[disOffGround,disOffGround,lowerRightZ(disFromT),lowerLeftZ(disFromT),disOffGround];

fill3(plane4X,plane1Y,plane4Z,colors);
alpha(.5);

%camera2 funnels
plane1X=[disBetween,disBetween, upperLeftX(disFromT)+disBetween,lowerLeftX(disFromT)+disBetween,disBetween];
plane1Y=[disFromT,disFromT, 0,0,disFromT];
plane1Z=[disOffGround, disOffGround+height, upperLeftZ(disFromT),lowerLeftZ(disFromT),disOffGround];

fill3(plane1X,plane1Y,plane1Z,colors);
alpha(.5);

plane2X=[disBetween,width+disBetween,upperRightX(disFromT)+disBetween,upperLeftX(disFromT)+disBetween,disBetween];
plane2Z=[disOffGround+height,disOffGround+height,upperRightZ(disFromT),upperLeftZ(disFromT) ,disOffGround+height];

fill3(plane2X,plane1Y,plane2Z,colors);
alpha(.5);

plane3X=[width+disBetween,width+disBetween,upperRightX(disFromT)+disBetween ,lowerRightX(disFromT)+disBetween ,width+disBetween];
plane3Z=[disOffGround,disOffGround+height,upperRightZ(disFromT),lowerRightZ(disFromT),disOffGround];

fill3(plane3X,plane1Y,plane3Z, colors);
alpha(.5);

plane4X=[disBetween,width+disBetween,lowerRightX(disFromT)+disBetween,lowerLeftX(disFromT)+disBetween,disBetween];
plane4Z=[disOffGround,disOffGround,lowerRightZ(disFromT),lowerLeftZ(disFromT),disOffGround];

fill3(plane4X,plane1Y,plane4Z,colors);
alpha(.5);

plot3(lowerLeftX2,boreVecY , lowerLeftZ2,'--');
plot3(upperLeftX2,boreVecY , upperLeftZ2,'--');
plot3(lowerRightX2,boreVecY , lowerRightZ2,'--');
plot3(upperRightX2,boreVecY , upperRightZ2,'--');

%plot layout
xlim([-30, 70]);
ylim([-10, disFromT+10]);
zlim([.4, 30]); 
xlabel('Distance between target in interceptor in meters');
ylabel('Distance from target in meters');
zlabel('Height in meters');
title('Camera FOV Model');


