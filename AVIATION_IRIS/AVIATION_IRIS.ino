/*
 Example using the SparkFun HX711 breakout board with a scale
 By: Nathan Seidle
 SparkFun Electronics
 Date: November 19th, 2014
 License: This code is public domain but you buy me a beer if you use this and we meet someday (Beerware license).
 
 This is the calibration sketch. Use it to determine the calibration_factor that the main example uses. It also
 outputs the zero_factor useful for projects that have a permanent mass on the scale in between power cycles.
 
 Setup your scale and start the sketch WITHOUT a weight on the scale
 Once readings are displayed place the weight on the scale
 Press +/- or a/z to adjust the calibration_factor until the output readings match the known weight
 Use this calibration_factor on the example sketch
 
 This example assumes pounds (lbs). If you prefer kilograms, change the Serial.print(" lbs"); line to kg. The
 calibration factor will be significantly different but it will be linearly related to lbs (1 lbs = 0.453592 kg).
 
 Your calibration factor may be very positive or very negative. It all depends on the setup of your scale system
 and the direction the sensors deflect from zero state

 This example code uses bogde's excellent library: https://github.com/bogde/HX711
 bogde's library is released under a GNU GENERAL PUBLIC LICENSE

 Arduino pin 2 -> HX711 CLK
 3 -> DOUT
 5V -> VCC
 GND -> GND
 
 Most any pin on the Arduino Uno will be compatible with DOUT/CLK.
 
 The HX711 board can be powered from 2.7V to 5V so the Arduino 5V power should be fine.
 
*/

#include "HX711.h" //This library can be obtained here http://librarymanager/All#Avia_HX711
#include <DynamixelSerial.h>
int temp=0;
#define LOADCELL1_DOUT_PIN  22
#define LOADCELL1_SCK_PIN  23
#define LOADCELL2_DOUT_PIN  24
#define LOADCELL2_SCK_PIN  25
#define LOADCELL3_DOUT_PIN  26
#define LOADCELL3_SCK_PIN  27
#define LOADCELL4_DOUT_PIN  28
#define LOADCELL4_SCK_PIN  29
#define LOADCELL5_DOUT_PIN  30
#define LOADCELL5_SCK_PIN  31
#define LOADCELL6_DOUT_PIN  32
#define LOADCELL6_SCK_PIN  33
#define LOADCELL7_DOUT_PIN  34
#define LOADCELL7_SCK_PIN  35
HX711 scale1;
HX711 scale2;
HX711 scale3;
HX711 scale4;
HX711 scale5;
HX711 scale6;
HX711 scale7;

float calibration_factor = -450; //-7050 worked for my 440lb max scale setup and -430 suppposedly worked for grsms set-up with the metal blocks

void setup() {
  Serial.begin(9600);
  //Serial.println("HX711 calibration sketch");
  //Serial.println("Remove all weight from scale");
  //Serial.println("After readings begin, place known weight on scale");
  //Serial.println("Press + or a to increase calibration factor");
  //Serial.println("Press - or z to decrease calibration factor");

  scale1.begin(LOADCELL1_DOUT_PIN, LOADCELL1_SCK_PIN);
  scale1.set_scale();
  scale1.tare();  //Reset the scale to 0
  scale2.begin(LOADCELL2_DOUT_PIN, LOADCELL2_SCK_PIN);
  scale2.set_scale();
  scale2.tare();  //Reset the scale to 0
  scale3.begin(LOADCELL3_DOUT_PIN, LOADCELL3_SCK_PIN);
  scale3.set_scale();
  scale3.tare();  //Reset the scale to 0
  scale4.begin(LOADCELL4_DOUT_PIN, LOADCELL4_SCK_PIN);
  scale4.set_scale();
  scale4.tare();  //Reset the scale to 0
  scale5.begin(LOADCELL5_DOUT_PIN, LOADCELL5_SCK_PIN);
  scale5.set_scale();
  scale5.tare();  //Reset the scale to 0
  scale6.begin(LOADCELL6_DOUT_PIN, LOADCELL6_SCK_PIN);
  scale6.set_scale();
  scale6.tare();  //Reset the scale to 0
  scale7.begin(LOADCELL7_DOUT_PIN, LOADCELL7_SCK_PIN);
  scale7.set_scale();
  scale7.tare();  //Reset the scale to 0
  
  long zero_factor1 = scale1.read_average(); //Get a baseline reading
  long zero_factor2 = scale2.read_average();
  long zero_factor3 = scale3.read_average(); //Get a baseline reading
  long zero_factor4 = scale4.read_average();
  long zero_factor5 = scale5.read_average(); //Get a baseline reading
  long zero_factor6 = scale6.read_average();
  long zero_factor7 = scale7.read_average(); //Get a baseline reading
//  Serial.print("Zero factor 1: "); //This can be used to remove the need to tare the scale. Useful in permanent scale projects.
//  Serial.println(zero_factor1);
//  Serial.print("Zero factor 2: ");
//  Serial.println(zero_factor2);
//  Serial.print("Zero factor 3: ");
//  Serial.println(zero_factor3);
//  Serial.print("Zero factor 4: ");
//  Serial.println(zero_factor4);
//  Serial.print("Zero factor 5: ");
//  Serial.println(zero_factor5);
//  Serial.print("Zero factor 6: ");
//  Serial.println(zero_factor6);
//  Serial.print("Zero factor 7: ");
//  Serial.println(zero_factor7);
  Dynamixel.setSerial(&Serial1); // &Serial - Arduino UNO/NANO/MICRO, &Serial1, &Serial2, &Serial3 - Arduino Mega
  Dynamixel.begin(1000000,2);  // Inicialize the servo at 1 Mbps and Pin Control 2
  delay(250);
  Dynamixel.move(1,50);
  delay(250);
  Dynamixel.move(1,1);
}

void loop() {

  scale1.set_scale(calibration_factor); //Adjust to this calibration factor
  scale2.set_scale(calibration_factor);
  scale3.set_scale(calibration_factor);
  scale4.set_scale(calibration_factor);
  scale5.set_scale(calibration_factor);
  scale6.set_scale(calibration_factor);
  scale7.set_scale(calibration_factor);
  //Serial.print("Reading: ");
  Serial.print(scale1.get_units(), 1);
  Serial.print(" ");
  Serial.print(scale2.get_units(), 1);
  Serial.print(" ");
  Serial.print(scale3.get_units(), 1);
  Serial.print(" ");
  Serial.print(scale4.get_units(), 1);
  Serial.print(" ");
  Serial.print(scale5.get_units(), 1);
  Serial.print(" ");
  Serial.print(scale6.get_units(), 1);
  Serial.print(" ");
  Serial.println(scale7.get_units(), 1);

  //Serial.print(" grams"); //Change this to kg and re-adjust the calibration factor if you follow SI units like a sane person
  //Serial.print(" calibration_factor: ");
  //Serial.print(calibration_factor);
  //Serial.println();

  if (Serial.available() > 0) {    // is a character available?
    temp = Serial.parseInt();
  }
  if(temp>0&&temp<1023){
    Dynamixel.move(1,temp);
  }

//  if(Serial.available())
//  {
//    char temp = Serial.read();
//    if(temp == '+' || temp == 'a')
//      calibration_factor += 10;
//    else if(temp == '-' || temp == 'z')
//      calibration_factor -= 10;
//  }
}
