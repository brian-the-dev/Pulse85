#include <DigiCDC.h>

void setup() {
  SerialUSB.begin(); 
}

void loop() {
    int sensorOutput = analogRead(1);
    if (SerialUSB.available()){
        SerialUSB.println(sensorOutput);
    }
}
