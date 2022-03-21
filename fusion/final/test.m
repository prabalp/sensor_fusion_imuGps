%creating a arduino object 
a = arduino('COM13', 'Mega2560', 'Libraries', {'I2C', 'Serial'});
imuFs = 100;
gpsFs = 1;
%setting up sensors
imu = mpu9250(a,'SampleRate',imuFs,'OutputFormat','matrix');
gpsObj = gpsdev(a,'SerialPort', 1);

localOrigin = [0 0 0];   % us can take the first reading of the sensor

imuSamplesPerGPS = (imuFs/gpsFs);

%creating the sensor fusion filter
gndFusion = insfilterNonholonomic('ReferenceFrame', 'ENU', ...
    'IMUSampleRate', imuFs, ...
    'ReferenceLocation', localOrigin, ...
    'DecimationFactor', 2);       %what is decimationFactor?


%set the intial parameters from GPS sensors
initialVel = [0 0 0];
%initialPos = [0 0 0];
initialPos = localOrigin;
%initialAtt = 0; 

% Initialize the states of the filter
eul = [0 pi/2 0];
gndFusion.State(1:4) = eul2quat(eul);
gndFusion.State(5:7) = [0 0 0] ;                      %imu.Gyroscope.ConstantBias;
gndFusion.State(8:10) = initialPos.';
gndFusion.State(11:13) = initialVel.';
%gndFusion.State(14:16) = 2e-4;    %from data sheet
gndFusion.State(14:16) = [0 0 0];

% Measurement noises
%Rvel = gps.VelocityAccuracy.^2;
%Rpos = gps.HorizontalPositionAccuracy.^2;

% Measurement noises from GPS
Rvel = 0;
Rpos = 0;

% The dynamic model of the ground vehicle for this filter assumes there is
% no side slip or skid during movement. This means that the velocity is
% constrained to only the forward body axis. The other two velocity axis
% readings are corrected with a zero measurement weighted by the
% |ZeroVelocityConstraintNoise| parameter.
gndFusion.ZeroVelocityConstraintNoise = 1e-2;

% Process noises
gndFusion.GyroscopeNoise = 4e-6;
gndFusion.GyroscopeBiasNoise = 4e-14;
gndFusion.AccelerometerNoise = 4.8e-2;
gndFusion.AccelerometerBiasNoise = 4e-14;

% Initial error covariance
gndFusion.StateCovariance = 1e-9*ones(16);

%running the test
totalSimTime = 30; % seconds

%numsamples = floor(min(t(end), totalSimTime) * gpsFs);

numsamples = 100;

%truePosition = zeros(numsamples,3);
%trueOrientation = quaternion.zeros(numsamples,1);
estPosition = zeros(1,3);
estOrientation = quaternion.zeros(1,1);

%tp = theaterPlot('XLimit',[-2 2],'YLimit',[-2 2],'ZLimit',[-2 2]);
%op = orientationPlotter(tp,'DisplayName','Fused Data',...
 %   'LocalAxesLength',2);


idx = 0;
for sampleIdx = 1:numsamples
    % Predict loop at IMU update frequency.
    for i = 1:imuSamplesPerGPS
        %if ~isDone(groundTruth)
        if 1
            idx = idx + 1;
               
            %read imu data and find accelData and gyroData
            accelData = imu.readAcceleration;
            gyroData = imu.readAngularVelocity;
            % Use the predict method to estimate the filter state based
            % on the accelData and gyroData arrays.
            predict(gndFusion, accelData, gyroData);
            
            % Log the estimated orientation and position.
           
            [estPosition(1,:), estOrientation(1,:)] = pose(gndFusion);

            % Update the pose viewer.  find a way to represent the data
            eul = quat2eul(estOrientation(1));
            disp('euler angles')
            disp(eul);
            disp('position')
            disp(estPosition(1,:));
            %plotOrientation(op, eul(1), eul(2), eul(3));
            %drawnow
        end
    end
    
    [tt, overruns] = read(gpsObj) ;
    if ~isnat(tt.Time(1))
        % This next step happens at the GPS sample rate.
        % read the GPS output based on the current pose.
        %[tt, overruns] = read(gpsObj) ;

        % Update the filter states based on the GPS data.
        fusegps(gndFusion, tt.LLA, Rpos, tt.GroundSpeed , Rvel);
    end
end

