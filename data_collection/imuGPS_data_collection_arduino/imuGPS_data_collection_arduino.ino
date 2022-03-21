#include <MPU9250.h>
#include <Adafruit_GPS.h>
#define GPSSerial Serial1
Adafruit_GPS GPS(&GPSSerial);

uint32_t timer = millis();
 
#define GPSECHO false

MPU9250 IMU(Wire,0x68);
int status;
int rowCount = 1000;
int rowNumber = 0;

void setup() {
  Serial.begin(9600);
 

  // start communication with IMU 
  status = IMU.begin();
//  if (status < 0) {
//    Serial.println("IMU initialization unsuccessful");
//    Serial.println("Check IMU wiring or try cycling power");
//    Serial.print("Status: ");
//    Serial.println(status);
//    while(1) {}
//  }


GPS.begin(9600);
GPS.sendCommand(PMTK_SET_NMEA_OUTPUT_RMCGGA);
GPS.sendCommand(PMTK_SET_NMEA_UPDATE_1HZ); 
GPS.sendCommand(PGCMD_ANTENNA);
delay(1000);
GPSSerial.println(PMTK_Q_RELEASE);
}

void loop() {

 char c = GPS.read();
//  if (GPSECHO)
//    if (c) Serial.print(c);
//    Serial.print('\t');
  if (GPS.newNMEAreceived()) {
    GPS.lastNMEA();
//    Serial.print(GPS.lastNMEA());
    if (!GPS.parse(GPS.lastNMEA())) // this also sets the newNMEAreceived() flag to false
      return; // we can fail to parse a sentence in which case we should just wait for another
  }
  
  
    Serial.print(++rowNumber);
    Serial.print('\t');

//    Serial.print(GPS.day, DEC); 
//    Serial.print("\t");
//    Serial.print(GPS.month, DEC);
//    Serial.print("\t");
//    Serial.print(GPS.year, DEC);
//    Serial.print("\t");
    Serial.print((int)GPS.fix);
    Serial.print("\t");
    Serial.print(GPS.lat, 6);
    Serial.print("\t");
    Serial.print(GPS.lon, 6);
    Serial.print("\t");
    Serial.print(GPS.speed, 6);
    Serial.print("\t");
    Serial.print(GPS.altitude, 6);
    Serial.print("\t");
    Serial.print(GPS.angle, 6);
    Serial.print("\t");
    Serial.print((int)GPS.satellites, 6);
    Serial.print("\t");

    //printing imu data
    IMU.readSensor();
    Serial.print(IMU.getAccelX_mss(),6);
  Serial.print("\t");
  Serial.print(IMU.getAccelY_mss(),6);
  Serial.print("\t");
  Serial.print(IMU.getAccelZ_mss(),6);
  Serial.print("\t");
  Serial.print(IMU.getGyroX_rads(),6);
  Serial.print("\t");
  Serial.print(IMU.getGyroY_rads(),6);
  Serial.print("\t");
  Serial.print(IMU.getGyroZ_rads(),6);
  Serial.print("\t");
  Serial.print(IMU.getMagX_uT(),6);
  Serial.print("\t");
  Serial.print(IMU.getMagY_uT(),6);
  Serial.print("\t");
  Serial.print(IMU.getMagZ_uT(),6);
  Serial.print("\t");
  Serial.println(IMU.getTemperature_C(),6);
    
//    if (rowNumber % 2 == 0) {
//      Serial.print("even\t"); 
//    } else {
//      Serial.print("odd\t");
//    }
//    Serial.println(random(16000), HEX);
//  }
}
