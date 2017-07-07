startX = 0;
startVX = 20 * cos(pi / 4);
startAX = 0;
startZ = 0;
startVZ = 20 * cos(pi / 4);
startAZ = -9.8;
thetaLast = [startX; startVX; startAX; startZ; startVZ; startAZ];
pLast = zeros(6, 6); %TODO
q = zeros(6, 6); %TODO
r = zeros(2, 6); %TODO
h = [1, 0, 0, 0, 0, 0; 0, 0, 0, 1, 0, 0];

for i = 1:10
    measurement = getMeasurment(); %TODO
    thetaPrediction = getFMatrix(1) * thetaLast; 
    pPrediction = getFMatrix(1) * pLast * getFMatrix(1)' + q;
    %Replace 1 with t
    zPrediction = h * thetaPrediction;
    y = measurement - zPrediction;
    s = r + h * pPrediction * h';
    k = pPrediction * h' / s;
    thetaLast = thetaPrediction + k * y;
    pLast = pPrediction - k * s * k';
end

function f = getFMatrix(t)

f = [1, t, .5 * t^2, 0, 0, 0; 0, 1, t, 0, 0, 0; 0, 0, 1, 0, 0, 0;
    0, 0, 0, 1, t, .5 * t^2; 0, 0, 0, 0, 1, t; 0, 0, 0, 0, 0, 1];

end
