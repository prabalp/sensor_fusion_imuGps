%a = arduino('COM13', 'Mega2560', 'Libraries', {'I2C', 'Serial'});

%gpsObj = gpsdev(a,'SerialPort',2);

imufs = 100; % Sample Rate in Hz   
%imu = mpu9250(a,'SampleRate',imufs,'SamplesPerRead',1,'OutputFormat','matrix');

dataPoints = 10;

%imu data;
for i = 1:dataPoints
    eval(['IMU_' num2str(i) '= i'])
    IMU_{i} = rand(3);
    %IMU_{i}(1,:) = imu.readAcceleration;
    %IMU_{i}(1,:) = imu.readAngularVelocity;
    %IMU_{i}(1,:) = imu.readMagneticField;
    
    save imu_gps_data.mat IMU_{i} 
    if mod(i,5) == 0
        eval(['GPS_' num2str(i) '= i'])
        %gpsData
        GPS_{i} = rand(1,4);
        %[tt, overruns] = read(gpsObj) ;
        GPS_{i}(1:3) = tt.LLA;
        GPS_{i}(4) = tt.GroundSpeed; 
        save imu_gps_data.mat GPS_{i}
    end
    
end

    