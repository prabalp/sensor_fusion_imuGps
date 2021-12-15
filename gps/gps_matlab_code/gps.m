a = arduino('COM8', 'Mega2560', 'Libraries', 'Serial');
%First creating a arduino object. 
%Create a gps object
gpsObj = gpsdev(a,'SerialPort',1)
%gpsObj = gpsdev(a, "OutputFormat","matrix",'SamplesPerRead',2);

%Reading data from gps
%[tt, overruns] = read(gpsObj); or
[lla,speed,course,dops,gpsReceiverTime,timestamp,overruns] = read(gpsObj);







