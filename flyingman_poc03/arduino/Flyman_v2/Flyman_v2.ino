
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
#define TCAADDR 0x70
#define SEALEVELPRESSURE_HPA (1013.25)


char ground_level_flag = 0;
String outputDataString = ""; // Write to file and bluetooth

  
//Sensors
Adafruit_BME280 bme1; // use I2C interface
Adafruit_BME280 bme2; // use I2C interface
Adafruit_BME280 bme3; // use I2C interface
Adafruit_BME280 bme4; // use I2C interface

float ground_level1 = 0;
float ground_level2 = 0;
float ground_level3 = 0;
float ground_level4 = 0;

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

float feet_alt3 = 0;
float temp3 = 0; // Temperature in Celsius
float pressure3 = 0; // Pessure in hPA
float alt_m3 = 0; // Altitude in meters
float alt_feet3 = 0; // Altitude in feets
float humidity3 = 0; // Humidity in percents

float feet_alt4 = 0;
float temp4 = 0; // Temperature in Celsius
float pressure4 = 0; // Pessure in hPA
float alt_m4 = 0; // Altitude in meters
float alt_feet4 = 0; // Altitude in feets
float humidity4 = 0; // Humidity in percents

//int counting = 0;



// Check chanel number and enable transmission's data
void tcaselect(uint8_t i) {
  if (i > 7) return;
 
  Wire.beginTransmission(TCAADDR);
  Wire.write(1 << i);
  Wire.endTransmission();  
}


void setup() {
    while (!Serial);
    delay(1000);
    Wire.begin();
    Serial.begin(9600);
 
    for (uint8_t t=0; t<4; t++) {
      tcaselect(t);
      Serial.print("TCA Port #"); Serial.println(t);
 
      for (uint8_t addr = 0; addr<=127; addr++) {
        if (addr == TCAADDR) continue;
      
        uint8_t data;
        if (! twi_writeTo(addr, &data, 0, 1, 1)) {
           Serial.print("Found I2C 0x");  Serial.println(addr,HEX); 
        }
      }
    }
 
  tcaselect(0);
  if (!bme1.begin()) {
    Serial.println(F("Could not find a valid BMP280 sensor 1, check wiring or "
                      "try a different address!"));
    while (1) delay(10);
  }

  tcaselect(1);
  if (!bme2.begin()) {
    Serial.println(F("Could not find a valid BMP280 sensor 2, check wiring or "
                      "try a different address!"));
    while (1) delay(10);
  }

  tcaselect(2);
  if (!bme3.begin()) {
    Serial.println(F("Could not find a valid BMP280 sensor 3, check wiring or "
                      "try a different address!"));
    while (1) delay(10);
  }
  tcaselect(3);
  if (!bme4.begin()) {
    Serial.println(F("Could not find a valid BMP280 sensor 4, check wiring or "
                      "try a different address!"));
    while (1) delay(10);
  }
  
   pinMode(5, INPUT_PULLUP); // Reset button

}

void loop() {
   
// Only needed in forced mode! In normal mode, you can remove the next four lines.
    bme1.takeForcedMeasurement(); // has no effect in normal mode
    bme2.takeForcedMeasurement(); // has no effect in normal mode
    bme3.takeForcedMeasurement(); // has no effect in normal mode
    bme4.takeForcedMeasurement(); // has no effect in normal mode


//Set "ground level flag". Now we have to push button on board foe set flag but later we can do same action thru serial
  if(!digitalRead(5)){
// Button on board id pushed 
 // Serial.println("Btn - OK");
    ground_level_flag = '1';
  } 

    if (ground_level_flag == '1') {
      ground_level1 = bme1.readAltitude(SEALEVELPRESSURE_HPA);
      ground_level2 = bme2.readAltitude(SEALEVELPRESSURE_HPA);
      ground_level3 = bme3.readAltitude(SEALEVELPRESSURE_HPA);
      ground_level4 = bme4.readAltitude(SEALEVELPRESSURE_HPA);
    //   Serial.println(ground_level1);
    //   Serial.println(ground_level2);
    //   Serial.println(ground_level3);
    //   Serial.println(ground_level4);
      ground_level_flag = '0'; // Reset button flag
      }

  printToAndroid(); // Send string to Android App   
      



  delay(1000);
}

void printToAndroid() {
    
    // Set output variable
    temp1 = bme1.readTemperature();
    pressure1 = bme1.readPressure() / 100.0F;
    alt_m1 = (bme1.readAltitude(SEALEVELPRESSURE_HPA)) - (ground_level1);
    alt_feet1 = (((bme1.readAltitude(SEALEVELPRESSURE_HPA))- (ground_level1))*3.28084);
    humidity1 = (bme1.readHumidity());

    temp2 = (bme2.readTemperature());
    pressure2 = (bme2.readPressure() / 100.0F);
    alt_m2 = (bme2.readAltitude(SEALEVELPRESSURE_HPA)) - (ground_level2);
    alt_feet2 = (((bme2.readAltitude(SEALEVELPRESSURE_HPA))- (ground_level2))*3.28084);
    humidity2 = (bme2.readHumidity());    

    temp3 = (bme3.readTemperature());
    pressure3 = (bme3.readPressure() / 100.0F);
    alt_m3 = (bme3.readAltitude(SEALEVELPRESSURE_HPA)) - (ground_level3);
    alt_feet3 = (((bme3.readAltitude(SEALEVELPRESSURE_HPA))- (ground_level3))*3.28084);
    humidity3 = (bme3.readHumidity());   

    temp4 = (bme4.readTemperature());
    pressure4 = (bme4.readPressure() / 100.0F);
    alt_m4 = (bme4.readAltitude(SEALEVELPRESSURE_HPA)) - (ground_level4);
    alt_feet4 = (((bme4.readAltitude(SEALEVELPRESSURE_HPA))- (ground_level4))*3.28084);
    humidity4 = (bme4.readHumidity());   
    

    // Make output string



outputDataString="{\"Name\":\"BME01\",";
outputDataString.concat("\"T\":"+String(temp1)+",");
outputDataString.concat("\"P\":"+String(pressure1)+",");
outputDataString.concat("\"AltitudeM\":"+String(alt_m1)+",");
outputDataString.concat("\"AltitudeF\":"+String(alt_feet1)+",");
outputDataString.concat("\"Hm\":"+String(humidity1));
outputDataString.concat("}");
Serial.println(outputDataString);
outputDataString="";
outputDataString.concat("{\"Name\":\"BME02\",");
outputDataString.concat("\"T\":"+String(temp2)+",");
outputDataString.concat("\"P\":"+String(pressure2)+",");
outputDataString.concat("\"AltitudeM\":"+String(alt_m2)+",");
outputDataString.concat("\"AltitudeF\":"+String(alt_feet2)+",");
outputDataString.concat("\"Hm\":"+String(humidity2));
outputDataString.concat("}");
Serial.println(outputDataString);
outputDataString="";
outputDataString.concat("{\"Name\":\"BME03\",");
outputDataString.concat("\"T\":"+String(temp3)+",");
outputDataString.concat("\"P\":"+String(pressure3)+",");
outputDataString.concat("\"AltitudeM\":"+String(alt_m3)+",");
outputDataString.concat("\"AltitudeF\":"+String(alt_feet3)+",");
outputDataString.concat("\"Hm\":"+String(humidity3));
outputDataString.concat("}");
Serial.println(outputDataString);
outputDataString="";
outputDataString.concat("{\"Name\":\"BME04\",");
outputDataString.concat("\"T\":"+String(temp4)+",");
outputDataString.concat("\"P\":"+String(pressure4)+",");
outputDataString.concat("\"AltitudeM\":"+String(alt_m4)+",");
outputDataString.concat("\"AltitudeF\":"+String(alt_feet4)+",");
outputDataString.concat("\"Hm\":");
outputDataString.concat(String(humidity4));
outputDataString.concat("}");
Serial.println(outputDataString);
outputDataString="";
    
//    Serial.print("{\"data\":["+"{\"Name\":\"BME01\",");
//    Serial.print("\"T\":"+String(temp1)+",");
//    Serial.print("\"P\":"+String(pressure1)+",");
//    Serial.print("\"AltitudeM\":"+String(alt_m1)+",");
//    Serial.print("\"AltitudeF\":"+String(alt_feet1)+",");
//    Serial.print("\"Hm\":"+String(humidity1));
//    Serial.print("},");
//    Serial.print("{\"Name\":\"BME02\",");
//    Serial.print("\"T\":"+String(temp2)+",");
//    Serial.print("\"P\":"+String(pressure2)+",");
//    Serial.print("\"AltitudeM\":"+String(alt_m2)+",");
//    Serial.print("\"AltitudeF\":"+String(alt_feet2)+",");
//    Serial.print("\"Hm\":"+String(humidity2));
//    Serial.print("},");
//    Serial.print("{\"Name\":\"BME03\",");
//    Serial.print("\"T\":"+String(temp3)+",");
//    Serial.print("\"P\":"+String(pressure3)+",");
//    Serial.print("\"AltitudeM\":"+String(alt_m3)+",");
//    Serial.print("\"AltitudeF\":"+String(alt_feet3)+",");
//    Serial.print("\"Hm\":"+String(humidity3));
//    Serial.print("},");
//    Serial.print("{\"Name\":\"BME04\",");
//    Serial.print("\"T\":"+String(temp4)+",");
//    Serial.print("\"P\":"+String(pressure4)+",");
//    Serial.print("\"AltitudeM\":"+String(alt_m4)+",");
//    Serial.print("\"AltitudeF\":"+String(alt_feet4)+",");
//    Serial.print("\"Hm\":"+String(humidity4)+"}]}");
//    Serial.println();
    

    delay(0);
}
