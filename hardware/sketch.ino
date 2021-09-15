#include <DigiCDC.h>

void setup() {
  SerialUSB.begin(); 
}

void loop() {
    // Read analog value from pin P2
    int sensorOutput = analogRead(1);
    if (SerialUSB.available()){
        // Send the sensor analog value to the device
        SerialUSB.println(sensorOutput);
    }
}
