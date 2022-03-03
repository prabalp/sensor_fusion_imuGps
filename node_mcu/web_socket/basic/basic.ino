#ifdef ESP8266
#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <SoftwareSerial.h>
#include <ArduinoJson.h>
 
#elif defined(ESP32)
#include <WiFi.h>
#include <ESPmDNS.h>
#else
#error "Board not found"
#endif
#include <WebSocketsServer.h>

#define LED1 13
#define LED2 12

char webpage[] PROGMEM = R"=====(
<!DOCTYPE html>
<html>
<script>
var connection = new WebSocket('ws://'+location.hostname+':81/');

connection.onmessage = function(event){
  var full_data = event.data;
  console.log(full_data);
  var data = JSON.parse(full_data);
  IMU_data = data.IMU;
  console.log(IMU_data);
  document.getElementById("IMU_value").innerHTML = IMU_data;
}

function button_linear_f()
{
  console.log("LED 1 is ON");
  connection.send("LED 1 is ON");
}
function button_linear_b()
{
console.log("LED 1 is OFF");
connection.send("LED 1 is OFF");
}
function button_ang_l()
{
  console.log("LED 2 is ON");
  connection.send("LED 2 is ON");
}
function button_ang_r()
{
console.log("LED 2 is OFF");
connection.send("LED 2 is OFF");
}
</script>
<body>
<center>
<h1>Sensor Fusion</h1>
<h3> Linear </h3>
<button onclick= "button_linear_f()" >Front</button><button onclick="button_linear_b()" >Back</button>
<h3> Angular </h3>
<button onclick= "button_ang_l()" >Left</button><button onclick="button_ang_r()" >Right</button>
<h3>IMU Sensor</h3><h3 id="IMU_value" style="display: inline-block;"> 2 </h3>
</center>
</body>
</html>
)=====";

#include <ESPAsyncWebServer.h>



AsyncWebServer server(80); // server port 80
WebSocketsServer websockets(81);



void notFound(AsyncWebServerRequest *request)
{
  request->send(404, "text/plain", "Page Not found");
}


void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {

  switch (type) 
  {
    case WStype_DISCONNECTED:
      Serial.printf("[%u] Disconnected!\n", num);
      break;
    case WStype_CONNECTED: {
        IPAddress ip = websockets.remoteIP(num);
        Serial.printf("[%u] Connected from %d.%d.%d.%d url: %s\n", num, ip[0], ip[1], ip[2], ip[3], payload);

        // send message to client
        websockets.sendTXT(num, "Connected from server");
      }
      break;
    case WStype_TEXT:
      Serial.printf("[%u] get Text: %s\n", num, payload);
      String message = String((char*)( payload));
      Serial.println(message);

      if(message == "LED 1 is OFF"){
        digitalWrite(LED1,LOW);
      }

      if(message == "LED 1 is ON"){
        digitalWrite(LED1,HIGH);
      }
      if(message == "LED 2 is OFF"){
        digitalWrite(LED2,LOW);
      }

      if(message == "LED 2 is ON"){
        digitalWrite(LED2,HIGH);
      }


  }
}

void setup(void)
{
  
//  Serial.begin(115200);    ---- also worked in it

  Serial.begin(9600);
  mySerial.begin(9600);

  pinMode(LED1,OUTPUT);
  pinMode(LED2,OUTPUT);
  
  WiFi.softAP("panda", "");
  Serial.println("softap");
  Serial.println("");
  Serial.println(WiFi.softAPIP());


  if (MDNS.begin("ESP")) { //esp.local/
    Serial.println("MDNS responder started");
  }


//base code 

//  server.on("/", [](AsyncWebServerRequest * request)
//  { 
//   String message = "hello world"; 
//  request->send(200, "text/plain", message);
//  });

   server.on("/", HTTP_GET, [](AsyncWebServerRequest * request)
  { 
    digitalWrite(LED1,HIGH);
  request->send_P(200, "text/html", webpage);
  });

  server.onNotFound(notFound);

  server.begin();  // it will start webserver
    websockets.begin();
  websockets.onEvent(webSocketEvent);
}


void loop(void)
{

  //for json
  
//  StaticJsonBuffer<1000> jsonBuffer;
//  JsonObject& data = jsonBuffer.parseObject(mySerial);
//
//  if (data == JsonObject::invalid()) {
//    //Serial.println("Invalid Json Object");
//    jsonBuffer.clear();
//    return;
//  }
//
//  Serial.println("JSON Object Recieved");
//  String msg = data["IDs"];
//  Serial.println(msg);

//test
  DynamicJsonDocument doc(1024);
//  Serial.println(String(mySerial.read()));
  String input = mySerial.readStringUntil('\r');
  Serial.println(input);
  websockets.broadcastTXT(input);
  deserializeJson(doc, input);
  JsonObject obj = doc.as<JsonObject>();
  String msg = obj[String{"IMU"}];
  Serial.println(msg);
  
//  String msg2 = mySerial.readStringUntil('\r');
//  Serial.println(msg2);

 websockets.loop();


}
