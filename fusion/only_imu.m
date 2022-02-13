a = arduino('COM13', 'Uno', 'Libraries', {'I2C', 'Serial'});
fs = 100; % Sample Rate in Hz   
imu = mpu9250(a,'SampleRate',fs,'OutputFormat','matrix');

tic;
stopTimer = 100;
magReadings=[];
while(toc<stopTimer)
    % Rotate the sensor around x axis from 0 to 360 degree.
    % Take 2-3 rotations to improve accuracy.
    % For other axes, rotate around that axis.
    [accel,gyro,mag] = read(imu);
    magReadings = [magReadings;mag];
end

% GyroscopeNoise and AccelerometerNoise is determined from datasheet.
GyroscopeNoiseMPU9250 = 3.0462e-06; % GyroscopeNoise (variance value) in units of rad/s
AccelerometerNoiseMPU9250 = 0.0061; % AccelerometerNoise(variance value)in units of m/s^2
viewer = HelperOrientationViewer('Title',{'AHRS Filter'});
FUSE = ahrsfilter('SampleRate',imu.SampleRate, 'GyroscopeNoise',GyroscopeNoiseMPU9250,'AccelerometerNoise',AccelerometerNoiseMPU9250);
stopTimer = 100;

% For y axis, use magReadings (:,2) and for z axis use magReadings(:,3)
magx_min = min(magReadings(:,1));
magx_max = max(magReadings(:,1));
magx_correction = (magx_max+magx_min)/2;


% Use ahrsfilter to estimate orientation and update the viewer as the
% sensor moves for time specified by stopTimer
displayMessage(['This section uses AHRS filter to determine orientation of the sensor by collecting live sensor data from the \slmpu9250 \rm' ...
    'system object. Move the sensor to visualize orientation of the sensor in the figure window. Keep the sensor stationery before you' ...
    'click OK'],...
    'Estimate Orientation using AHRS filter and MPU-9250')
tic;
while(toc < stopTimer)
    [accel,gyro,mag] = readSensorDataMPU9250(imu);
    rotators = FUSE(accel,gyro,mag);
    for j = numel(rotators)
        viewer(rotators(j));
    end
end


displayMessage(['This section uses  IMU filter to determine orientation of the sensor by collecting live sensor data from the \slmpu9250 \rm' ...
    'system object. Move the sensor to visualize orientation of the sensor in the figure window. Keep the sensor stationery before you'...
    'click OK'],...
    'Estimate Orientation using IMU filter and MPU-9250.')
% GyroscopeNoise and AccelerometerNoise is determined from datasheet.
GyroscopeNoiseMPU9250 = 3.0462e-06; % GyroscopeNoise (variance) in units of rad/s
AccelerometerNoiseMPU9250 = 0.0061; % AccelerometerNoise (variance) in units of m/s^2
viewer = HelperOrientationViewer('Title',{'IMU Filter'});
FUSE = imufilter('SampleRate',imu.SampleRate, 'GyroscopeNoise',GyroscopeNoiseMPU9250,'AccelerometerNoise', AccelerometerNoiseMPU9250);
stopTimer=100;


% Use imufilter to estimate orientation and update the viewer as the
% sensor moves for time specified by stopTimer
tic;
while(toc < stopTimer)
    [accel,gyro] = readSensorDataMPU9250(imu);
    rotators = FUSE(accel,gyro);
    for j = numel(rotators)
        viewer(rotators(j));
    end
end

displayMessage(['This section uses \slecompass \rmfunction to determine orientation of the sensor by collecting live sensor data from the \slmpu9250 ' ...
    '\rmsystem object. Move the sensor to visualize orientation of the sensor in the figure window. Keep the sensor stationery before you click OK'],...
    'Estimate Orientation using Ecompass algorithm.')
tic;
viewer = HelperOrientationViewer('Title',{'Ecompass Algorithm'});
stopTimer = 100;
tic;
% Use ecompass algorithm to estimate orientation and update the viewer as the
% sensor moves for time specified by stopTimer.
while(toc < stopTimer)
    [accel,gyro,mag] = readSensorDataMPU9250(imu);
    rotators = ecompass(accel,mag);
    for j = numel(rotators)
        viewer(rotators(j));
    end
end

release(imu);
delete(imu);
clear;


