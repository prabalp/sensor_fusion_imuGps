a = arduino('COM13', 'Mega2560', 'Libraries', {'I2C', 'Serial'});
gpsObj = gpsdev(a,'SerialPort', 1);


[tt, overruns] = read(gpsObj);

latCurr = 17.543;
lonCurr = 78.57;
latPast = 17.543;
lonPast = 78.57;

figure(1);
geoplot([latCurr latPast],[lonCurr lonPast],'-*'); hold on;

error = [0,1,2,3,4,5,6,7,8,9];

i =1;
while 1
    [tt, overruns] = read(gpsObj);
    latPast = latCurr;
    lonPast = lonCurr;
    latCurr = tt.LLA(1);
    lonCurr = tt.LLA(2);
    disp('start');
    disp(latPast);
    disp(lonPast);
    disp(latCurr);
    disp(lonCurr);
    disp('end');
    figure(1);
    la = latCurr+error(i)*0.00001;
    ln = lonCurr + error(i)*0.00001;
    geoplot([la latPast],[ln lonPast],'-*'); hold on;
    %geobasemap streets
    if i >9
        i = 0;
    end
    i = i+1;
end


%geolimits([45 62],[-149 -123])
%geobasemap streets

