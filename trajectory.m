function f = trajectory_new(t, Y, parameters)

mass = parameters.mass;
crossSectionalArea = parameters.area;
coefficentOfDrag = parameters.drag;

density = 1.225; %of the air in kg/m^3
c = crossSectionalArea * coefficentOfDrag * density / 2;
g = 9.8;

f = zeros(4,1);
%Derivative of vx
f(1,1)= -c * sqrt(Y(1).^2 + Y(2).^2) * Y(1) / mass;
%Derivative of vy
f(2,1)= -c * sqrt(Y(1).^2 + Y(2).^2) * Y(2) / mass - g;
%Derivative of x
f(3,1)= Y(1);
%Derivative of z
f(4,1)= Y(2);
