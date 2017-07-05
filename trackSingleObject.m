function trackSingleObject()

param.motionModel = 'ConstantAcceleration';
%param.initialLocation = 'Same as first detection';
param.initialEstimateError = 1E5 * ones(1, 3);
param.motionNoise = [25, 10, 1];
param.measurementNoise = 25;
param.segmentationThreshold = 0.05;

isTrackInitialized = false;
t = 1;
locations = zeros(10, 2);
while true
    
    % Detect the ball.
    [detectedLocation, isObjectDetected] = getNextCenter(t); %Vision function
    t = t + 1;
    if(t > 10) 
        break
    end
    if(~isObjectDetected)
        if(isTrackInitialized)
            break;
        else
            continue;
        end
    end
    
    
    
    if ~isTrackInitialized
        if isObjectDetected
            % Initialize a track by creating a Kalman filter when the ball is
            % detected for the first time.
            kalmanFilter = configureKalmanFilter('ConstantAcceleration', detectedLocation, param.initialEstimateError, param.motionNoise, param.measurementNoise);
            
            isTrackInitialized = true;
            trackedLocation = correct(kalmanFilter, detectedLocation);
            label = 'Initial';
        else
            trackedLocation = [];
            label = '';
        end
        
    else
        % Use the Kalman filter to track the ball.
        if isObjectDetected % The ball was detected.
            % Reduce the measurement noise by calling predict followed by
            % correct.
            predict(kalmanFilter);
            trackedLocation = correct(kalmanFilter, detectedLocation);
            label = 'Corrected';
        else % The ball was missing.
            % Predict the ball's location.
            trackedLocation = predict(kalmanFilter);
            label = 'Predicted';
        end
    end
    locations(t, :) = trackedLocation;
end % while
plot (locations(1,:), locations(2,:));
hold on
plot (0 : 10, sqrt(x)); 
end