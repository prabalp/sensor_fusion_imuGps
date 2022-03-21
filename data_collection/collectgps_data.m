a = arduino('COM13', 'Mega2560', 'Libraries', {'I2C', 'Serial'});
gpsObj = gpsdev(a,'SerialPort', 1);
[tt, overruns] = read(gpsObj);
lat = tt.LLA(1);
long = tt.LLA(2);
initLat =  lat;
initLong = long;
gps_file = ["gps-data" '.mat'];
mfw = dsp.MatFileWriter(gps_file,'VariableName','data');
while true
   [tt, overruns] = read(gpsObj);
   lat  = tt.LLA(1);
   long = tt.LLA(2);
   data = lat + " " + long;
   mfw(data);
   figure(1);
   plot(lat - initLat,long - initLong,'.');
   hold on; 
end
release(mfw);
%imu= 