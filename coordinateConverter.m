d = 5; %distance between cameras
%centroid coordinates
cenrx = 100;
cenry = 5;
cenlx = 60;
cenly = 8;
%camera angles
alphaz = 10 * pi/180;
alphax = 45 * pi/180;
beta = .1276 * pi/180;
%other angles
alphal = alphax - cenlx * beta;
alphar = alphax + cenrx * beta;

%equations
m = d*sin(alphar)/sin(pi - alphal - alphar);
n = sqrt(m^2 + d^2 / 4 - m*d*cos(alphal));
theta = asin(m*sin(alphal)/n) - pi/2;

%final equations
y = n*sin(theta);
x = n*cos(theta);
zl = x*tan(alphaz + cenly * beta);
zr = x*tan(alphaz + cenry * beta);
z = (zl + zr)/2;