clear
a = arduino('COM13', 'Mega2560', 'Libraries', {'I2C', 'Serial'});
imuFs = 100;
gpsFs = 1;
%setting up sensors
%imu = mpu9250(a,'SampleRate',imuFs,'OutputFormat','matrix');
imu = mpu9250(a,'SampleRate',imuFs,'SamplesPerRead',1,'OutputFormat','matrix');
gpsObj = gpsdev(a,'SerialPort', 1);

%orientationPlotter
tp = theaterPlot('XLimit',[-2 2],'YLimit',[-2 2],'ZLimit',[-2 2]);
op = orientationPlotter(tp,'DisplayName','Fused Data',...
    'LocalAxesLength',2);

%variables
gps_lat = 0;
gps_long = 0;
gps_speed = 0;
v_n = 0;
v_e = 0;
d_n = 0;
d_e = 0;

while 1
    %gps loop
    [tt, overruns] = read(gpsObj);
    gps_lat = tt.LLA(1);
    gps_long = tt.LLA(2);
    gps_speed = tt.GroundSpeed;
    lat = gps_lat;
    long = gps_long;
    for i = 1:100
        %imu loop 
        GyroscopeNoiseMPU9250 = 3.0462e-06;
        AccelerometerNoiseMPU9250 = 0.0061;
        FUSE = ahrsfilter('SampleRate',imu.SampleRate, 'GyroscopeNoise',GyroscopeNoiseMPU9250,'AccelerometerNoise',AccelerometerNoiseMPU9250);
        [accel,gyro,mag] = read(imu);
        quat = FUSE(accel,gyro,mag);
        rotm = quat2rotm( quat );
        a_NED= mtimes(accel, inv(rotm));
        dv_n = a_NED(1)*0.01;
        dv_e = a_NED(2)*0.01;
        v_n = v_n + dv_n;
        v_e = v_e + dv_e;
        d_n = v_n*0.01;
        d_e = v_e*0.01;
        dlat = 0.00015696123*d_n*57.2958;
        dlong = 0.00015696123*d_e*57.2958;
        lat = lat + dlat;
        long = long + dlong;
        figure(1);
        geoplot([lat lat-dlat],[long long-dlong],'-*'); hold on;
        %eul = 57.293*quat2eul(quat);
        %plotOrientation(op, eul(1), eul(2), eul(3))
        pause(0.001);
    end
end
