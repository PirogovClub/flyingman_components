
#include <Wire.h>
extern "C" { 
#include "utility/twi.h"  // from Wire library, so we can do bus scanning
}
#include <SD.h> // SD Card library
#include <SPI.h>
#include <SoftwareSerial.h>
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BME280.h>
#define SEALEVELPRESSURE_HPA (1013.25)


char ground_level_flag = 0;
String outputDataString = ""; // Write to file and bluetooth

  
//Sensors
Adafruit_BME280 bme1; // use I2C interface
Adafruit_BME280 bme2; // use I2C interface


float ground_level1 = 0;
float ground_level2 = 0;


float feet_alt1 = 0;   
float temp1 = 0; // Temperature in Celsius
float pressure1 = 0; // Pessure in hPA
float alt_m1 = 0; // Altitude in meters
float alt_feet1 = 0; // Altitude in feets
float humidity1 = 0; // Humidity in percents

float feet_alt2 = 0;
float temp2 = 0; // Temperature in Celsius
float pressure2 = 0; // Pessure in hPA
float alt_m2 = 0; // Altitude in meters
float alt_feet2 = 0; // Altitude in feets
float humidity2 = 0; // Humidity in percents


void setup() {
    while (!Serial);
    delay(1000);
    Wire.begin();
    Serial.begin(9600);

//  tcaselect(0);
  if (!bme1.begin()) {
    Serial.println(F("Could not find a valid BMP280 sensor 1, check wiring or "
                      "try a different address!"));
    while (1) delay(10);
  }

//  tcaselect(1);
  if (!bme2.begin(0x76)) {
    Serial.println(F("Could not find a valid BMP280 sensor 2, check wiring or "
                      "try a different address!"));
    while (1) delay(10);
  }

   pinMode(5, INPUT_PULLUP); // Reset button

}

void loop() {
   
// Only needed in forced mode! In normal mode, you can remove the next four lines.
    bme1.takeForcedMeasurement(); // has no effect in normal mode
    bme2.takeForcedMeasurement(); // has no effect in normal mode

//Set "ground level flag". Now we have to push button on board foe set flag but later we can do same action thru serial
  if(!digitalRead(5)){
    // Button on board id pushed 
    //Serial.println("Btn - OK");
    ground_level_flag = '1';
  } 

    if (ground_level_flag == '1') {
      ground_level1 = bme1.readAltitude(SEALEVELPRESSURE_HPA);
      ground_level2 = bme2.readAltitude(SEALEVELPRESSURE_HPA);
      ground_level_flag = '0'; // Reset button flag
      }

     printToAndroid(); // Send string to Android App   
      



  delay(1000);
}

void printToAndroid() {
    
    // Set output variable
    temp1 = bme1.readTemperature();
    pressure1 = bme1.readPressure() / 1.0F;
    alt_m1 = (bme1.readAltitude(SEALEVELPRESSURE_HPA)) - (ground_level1);
    alt_feet1 = (((bme1.readAltitude(SEALEVELPRESSURE_HPA))- (ground_level1))*3.28084);
    humidity1 = (bme1.readHumidity());

    temp2 = (bme2.readTemperature());
    pressure2 = (bme2.readPressure() / 1.0F);
    alt_m2 = (bme2.readAltitude(SEALEVELPRESSURE_HPA)) - (ground_level2);
    alt_feet2 = (((bme2.readAltitude(SEALEVELPRESSURE_HPA))- (ground_level2))*3.28084);
    humidity2 = (bme2.readHumidity());    

    // Make output string
    
    outputDataString="{\"Name\":\"BME01\",";
    outputDataString.concat("\"T\":"+String(temp1)+",");
    outputDataString.concat("\"P\":"+String(pressure1)+",");
    outputDataString.concat("\"AltitudeM\":"+String(alt_m1)+",");
    outputDataString.concat("\"AltitudeF\":"+String(alt_feet1)+",");
    outputDataString.concat("\"Hm\":"+String(humidity1));
    outputDataString.concat("}|");
    Serial.print(outputDataString);
    outputDataString="";
    
    outputDataString.concat("{\"Name\":\"BME02\",");
    outputDataString.concat("\"T\":"+String(temp2)+",");
    outputDataString.concat("\"P\":"+String(pressure2)+",");
    outputDataString.concat("\"AltitudeM\":"+String(alt_m2)+",");
    outputDataString.concat("\"AltitudeF\":"+String(alt_feet2)+",");
    outputDataString.concat("\"Hm\":"+String(humidity2));
    outputDataString.concat("}|");
    Serial.print(outputDataString);
    outputDataString="";

    delay(0);
}
