#ifdef ESP8266
#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <SoftwareSerial.h>
#include <ArduinoJson.h>
SoftwareSerial mySerial (D1, D2); //Rx, Tx pins
#elif defined(ESP32)
#include <WiFi.h>
#include <ESPmDNS.h>
#else
#error "Board not found"
#endif



#include <ESPAsyncWebServer.h>

AsyncWebServer server(80); // server port 80

void notFound(AsyncWebServerRequest *request)
{
  request->send(404, "text/plain", "Page Not found");
}

void setup(void)
{
  
//  Serial.begin(115200);    ---- also worked in it

  Serial.begin(9600);
  mySerial.begin(9600);
  
  WiFi.softAP("panda", "");
  Serial.println("softap");
  Serial.println("");
  Serial.println(WiFi.softAPIP());


  if (MDNS.begin("ESP")) { //esp.local/
    Serial.println("MDNS responder started");
  }



  server.on("/", [](AsyncWebServerRequest * request)
  { 
   String message = "hello world"; 
  request->send(200, "text/plain", message);
  });

   server.on("/page1", HTTP_GET, [](AsyncWebServerRequest * request)
  { 
   String message = "Welcome to page1"; 
  request->send(200, "text/plain", message);
  });

  server.onNotFound(notFound);

  server.begin();  // it will start webserver
}


void loop(void)
{
  StaticJsonBuffer<1000> jsonBuffer;
  JsonObject& data = jsonBuffer.parseObject(mySerial);

  if (data == JsonObject::invalid()) {
    //Serial.println("Invalid Json Object");
    jsonBuffer.clear();
    return;
  }

  Serial.println("JSON Object Recieved");
  String msg = data["haha"];
  Serial.println(msg);

  
//  String msg = mySerial.readStringUntil('\r');
//  Serial.println(msg);
}
