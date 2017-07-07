startX = 0;
startVX = 20 * cos(pi / 4);
startAX = 0;
startZ = 0;
startVZ = 20 * cos(pi / 4);
startAZ = -9.8;
thetaLast = [startX; startVX; startAX; startZ; startVZ; startAZ];
pLast = zeros(6, 6);%TODO change this
pLast = 10^2*diag(ones(6,1));
Q = zeros(6, 6); %For now
sigmaX = 0.5;
sigmaZ = 0.5;
R = zeros(2, 2);
R(1, 1) = sigmaX^2;
R(2, 2) = sigmaZ^2;
H = [1, 0, 0, 0, 0, 0; 0, 0, 0, 1, 0, 0];

dt = 1/30;
t = 0:dt:3;
x_filtered = zeros(size(t));
z_filtered = zeros(size(t));
x_measured = zeros(size(t));
z_measured = zeros(size(t));
for i = 1:length(t)
    pLast
    measurement = getMeasurement(t(i), sigmaX, sigmaZ); %change this
    thetaPrediction = getFMatrix(dt) * thetaLast; 
    pPrediction = getFMatrix(dt) * pLast * getFMatrix(dt)' + Q;
    zPrediction = H * thetaPrediction;
    residual = measurement - zPrediction;

    S = R + H * pPrediction * H';
    K = pPrediction * H' / S;
    thetaLast = thetaPrediction + K * residual;
    %TODO:  figure out whats going on with theta
    %pLast = pPrediction - K * S * K';
    pLast = (eye(6) - K*H)*pPrediction;
    % Store filtered data:
    x_measured(i) = measurement(1);
    x_filtered(i) = thetaLast(1,1);
    z_measured(i) = measurement(2);
    z_filtered(i) = thetaLast(1,2);
end

%getFMatrix(dt)
%K

figure
plot(x_measured,z_measured,'bo')
hold on
plot(x_filtered,z_filtered,'-*r','linewidth',2)


function F = getFMatrix(dt)

F = [1, dt, .5 * dt^2, 0, 0, 0; 0, 1, dt, 0, 0, 0; 0, 0, 1, 0, 0, 0;
    0, 0, 0, 1, dt, .5 * dt^2; 0, 0, 0, 0, 1, dt; 0, 0, 0, 0, 0, 1];

end

function m = getMeasurement(t, sigmaX, sigmaZ)

x = 20 * cos(pi / 4) * t + randn(size(t)) * sigmaX;
z = 20 * cos(pi / 4) * t - 9.8 * t^2 / 2 + randn(size(t)) * sigmaZ;

m = [x, z];
end
