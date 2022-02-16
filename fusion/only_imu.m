a = arduino('COM13', 'Mega2560', 'Libraries', {'I2C', 'Serial'});
serial1 = device(a,'SerialPort',1, 'BaudRate',9600);
fs = 100; % Sample Rate in Hz   
imu = mpu9250(a,'SampleRate',fs,'SamplesPerRead',1,'OutputFormat','matrix');

GyroscopeNoiseMPU9250 = 3.0462e-06; % GyroscopeNoise (variance value) in units of rad/s
AccelerometerNoiseMPU9250 = 0.0061; % AccelerometerNoise(variance value)in units of m/s^2
%viewer = HelperOrientationViewer('Title',{'AHRS Filter'});
FUSE = ahrsfilter('SampleRate',imu.SampleRate, 'GyroscopeNoise',GyroscopeNoiseMPU9250,'AccelerometerNoise',AccelerometerNoiseMPU9250);
stopTimer = 100;

n =100;
while n>1
    [accel,gyro,mag] = read(imu);
    rotators = FUSE(accel,gyro,mag);
    eul = round(quat2eul(rotators)*100)/100;
    data = '{"IMU":"%s"}';
    msg = sprintf(data, mat2str(eul));
    %msg = sprintf(data, 'Prabal Panda');
    disp(msg)
    serial1.write(msg);
    pause(1);

n = n-1;
end
release(imu);
delete(imu);
clear;


