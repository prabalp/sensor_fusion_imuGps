//mega code
#include <ArduinoJson.h>

void setup() {
  // put your setup code here, to run once:
  Serial1.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:

  StaticJsonBuffer<1000> jsonBuffer;
  JsonObject& data = jsonBuffer.createObject();

  data["haha"] = "Hello from Mega";

  data.printTo(Serial1);
  jsonBuffer.clear();
  
//  Serial1.println("Hello from arduino mega");
  delay(1000);

}
