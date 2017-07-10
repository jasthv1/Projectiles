%Initial guesses for position, velocity, and acceleration (meters based)
startX = 0;
startVX = 20 * cos(pi / 4);
startAX = 0;
startZ = 0;
startVZ = 20 * cos(pi / 4);
startAZ = -9.8;
%Create a matrix to represent all initial values
thetaLast = [startX; startVX; startAX; startZ; startVZ; startAZ];

%Initial variance matrix
pLast = zeros(6, 6);
pLast = 10^2*diag(ones(6,1));

%Process error matrix
Q = zeros(6, 6); %For now
%Simulated camera error for measurements
sigmaX = .5;
sigmaZ = .5;
R = zeros(2, 2);
R(1, 1) = sigmaX^2;
R(2, 2) = sigmaZ^2;

%Measurement matrix
H = [1, 0, 0, 0, 0, 0; 0, 0, 0, 1, 0, 0];

%Change in time (represents ideal frames/second and update rate)
dt = 1/30;
%Total time
t = 0:dt:3;

%Empty matrices for filtered values
x_filtered = zeros(size(t));
z_filtered = zeros(size(t));
x_measured = zeros(size(t));
z_measured = zeros(size(t));

%find the ideal paths of the target and interceptor (only target is used 
path = getPaths(t, 20);

%Filter and update measurements to represent estimated values using Kalman
%filter
for i = 1:length(t)

    %Get the measured values, will be changed to take camera input later
    measurement = getMeasurement(i, sigmaX, sigmaZ, path.threat); 
    
    %Kalman filter
    %Get the state transformation matrix
    F = getFMatrix(dt);
    %Predict new state values
    thetaPrediction = F * thetaLast; 
    %Predict new variance values
    pPrediction = F * pLast * F' + Q;
    %Predicted measurement
    zPrediction = H * thetaPrediction;
    %Find measurement residual
    residual = measurement - zPrediction;
    %Finds kalman adjustments
    S = R + H * pPrediction * H';
    K = pPrediction * H' / S;
    %Find new predicted values of theta
    thetaLast = thetaPrediction + K * residual;
    %Find new predicted covariance values
    pLast = (eye(6) - K*H)*pPrediction;
   
    % Store filtered data:
    x_measured(i) = measurement(1);
    x_filtered(i) = thetaLast(1);
    z_measured(i) = measurement(2);
    z_filtered(i) = thetaLast(4);
    
end

%Find the true trajectory of the target
m_truth = getMeasurement(1:length(t), 0, 0, path.threat);
x_truth = m_truth(1, :);
z_truth = m_truth(2, :);

%Plot everything
figure
plot(x_measured,z_measured,'bo')
hold on
plot(x_truth,z_truth,'-g','linewidth',1)
plot(x_filtered,z_filtered,'-*r','linewidth',2)
legend('Measured','Truth','Filtered')

%This method retrieves the state transformation matrix for given time
%difference
function F = getFMatrix(dt)

F = [1, dt, .5 * dt^2, 0, 0, 0; 0, 1, dt, 0, 0, 0; 0, 0, 1, 0, 0, 0;
    0, 0, 0, 1, dt, .5 * dt^2; 0, 0, 0, 0, 1, dt; 0, 0, 0, 0, 0, 1];

end

%This function finds measurments with normal error from a given index and function f 
function m = getMeasurement(i, sigmaX, sigmaZ, f)

x = f(i,3)' + randn(size(i)) * sigmaX;
z = f(i,4)' + randn(size(i)) * sigmaZ;
m = [x; z];

end
