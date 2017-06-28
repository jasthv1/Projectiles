function f = trajectory(t, Y)
g = 9.8;
mass = .0427; %kilograms
crossSectionalArea = (2.25 / 12 * .3048 / 2)^2 * pi; %meters
coefficentOfDrag = .47; %will later be determined by testing
density = 1.225; %of the air in kg/m^3
c = crossSectionalArea * coefficentOfDrag * density / 2;

%Derivative of vx
f(1,1)= -c * sqrt(Y(1)^2 + Y(2)^2) * Y(1) / mass;
%Derivative of vy
f(1,2)= -c * sqrt(Y(1)^2 + Y(2)^2) * Y(2) / mass - g;
%Derivative of x
f(1,3)= Y(1);
%Derivative of z
f(1,4)= Y(2);

