
#include <MPU9250.h>


#include <Adafruit_GPS.h>
#define GPSSerial Serial1
Adafruit_GPS GPS(&GPSSerial);
#define GPSECHO false

MPU9250 IMU(Wire,0x68);
int status;
int rowCount = 1000;
int rowNumber = 0;
uint32_t timer = millis();


void setup()
{
  Serial.begin(115200);
//  Serial.println("Adafruit GPS library basic parsing test!");  //this line

 status = IMU.begin();



  GPS.begin(9600);
  GPS.sendCommand(PMTK_SET_NMEA_OUTPUT_RMCGGA);
  GPS.sendCommand(PMTK_SET_NMEA_UPDATE_1HZ); // 1 Hz update rate
  GPS.sendCommand(PGCMD_ANTENNA);
  delay(1000);
  GPSSerial.println(PMTK_Q_RELEASE);
}

void loop() // run over and over again
{
  char c = GPS.read();
  if (GPSECHO)
    if (c) Serial.print(c);
  if (GPS.newNMEAreceived()) {
    GPS.lastNMEA();
//    Serial.print(GPS.lastNMEA());
    if (!GPS.parse(GPS.lastNMEA())) // this also sets the newNMEAreceived() flag to false
      return; // we can fail to parse a sentence in which case we should just wait for another
  }

  // approximately every 2 seconds or so, print out the current stats
  if (millis() - timer > 100) {
    timer = millis(); // reset the timer
//    Serial.print("\nTime: ");
    if (GPS.hour < 10) { 
//      Serial.print('0'); 
      }
//    Serial.print(GPS.hour, DEC); Serial.print(':');
    if (GPS.minute < 10) { 
//      Serial.print('0'); 
      }
//    Serial.print(GPS.minute, DEC); Serial.print(':');
    if (GPS.seconds < 10) {
//      Serial.print('0'); 
      }
//    Serial.print(GPS.seconds, DEC); Serial.print('.');
    if (GPS.milliseconds < 10) {
//      Serial.print("00");
    } else if (GPS.milliseconds > 9 && GPS.milliseconds < 100) {
//      Serial.print("0");
    }
//    Serial.println(GPS.milliseconds);
//    Serial.print("Date: ");
//    Serial.print(GPS.day, DEC); Serial.print('/');
//    Serial.print(GPS.month, DEC); Serial.print("/20");
//    Serial.println(GPS.year, DEC);
//    Serial.println("Fix: "); 
//Serial.println((int)GPS.fix);
//    Serial.print(" quality: "); Serial.println((int)GPS.fixquality);
    if (GPS.fix) {

Serial.print((int)GPS.fix);
    Serial.print("\t");
    Serial.print(GPS.latitude, 4);
    Serial.print("\t");
    Serial.print(GPS.longitude, 4);
    Serial.print("\t");
    Serial.print(GPS.speed, 6);
    Serial.print("\t");
    Serial.print(GPS.altitude, 6);
    Serial.print("\t");
    Serial.print(GPS.angle, 6);
    Serial.print("\t");
    Serial.print((int)GPS.satellites, 6);

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
//    Serial.print("\t");
      
//      Serial.print("Location: ");
//      Serial.print(GPS.latitude, 4); Serial.print(GPS.lat);
//      Serial.print(", ");
//      Serial.print(GPS.longitude, 4); Serial.println(GPS.lon);
//      Serial.print("Speed (knots): "); Serial.println(GPS.speed);
//      Serial.print("Angle: "); Serial.println(GPS.angle);
//      Serial.print("Altitude: "); Serial.println(GPS.altitude);
//      Serial.print("Satellites: "); Serial.println((int)GPS.satellites);
    }
  }
}
