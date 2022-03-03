a = arduino('COM13', 'Mega2560', 'Libraries', {'I2C', 'Serial'});

gpsObj = gpsdev(a,'SerialPort',2);

imufs = 100; % Sample Rate in Hz   
imu = mpu9250(a,'SampleRate',imufs,'SamplesPerRead',1,'OutputFormat','matrix');
