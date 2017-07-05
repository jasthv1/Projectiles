function [detection, isObjectDetected] = getNextCenter(t)
isObjectDetected = true;
detection = [t, sqrt(t) + (rand - 0.5) * 2];