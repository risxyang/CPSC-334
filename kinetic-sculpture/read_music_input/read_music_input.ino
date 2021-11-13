
#include <ESP32Servo.h>

//SERVO 

Servo shoulder;  // create servo object to control a servo
Servo elbow; 
Servo wrist; 
// 16 servo objects can be created on the ESP32
 
int wristPos = 0;    // variable to store the servo position
int elbowPos = 0; 
int shoulderPos = 0; 

bool decShoulder = false;
bool decElbow = false;
bool decWrist = false;


// Recommended PWM GPIO pins on the ESP32 include 2,4,12-19,21-23,25-27,32-33 
int wristPin = 19;
int elbowPin = 17;
int shoulderPin = 16;

//input read
String x;

void setup() {
 Serial.begin(115200);
 Serial.setTimeout(2);

  // Allow allocation of all timers
  ESP32PWM::allocateTimer(0);
  ESP32PWM::allocateTimer(1);
  ESP32PWM::allocateTimer(2);
  ESP32PWM::allocateTimer(3);
  
  shoulder.setPeriodHertz(50);    // standard 50 hz servo
  shoulder.attach(shoulderPin, 500, 2400); // attaches the servo on pin to the servo object
  
  elbow.setPeriodHertz(50);    // standard 50 hz servo
  elbow.attach(elbowPin, 500, 2400); // attaches the servo on pin to the servo object
  
  wrist.setPeriodHertz(50);    // standard 50 hz servo
  wrist.attach(wristPin, 500, 2400); // attaches the servo on pin to the servo object

  
}
void loop() {
 while (!Serial.available());
 x = Serial.readStringUntil('\n');
// Serial.print(x + 1);
  Serial.println(x);
  if(String(x[0]).toInt() == 0)
  {
    //note
    Serial.println("note");
  }
  else if(String(x[0]).toInt() == 1)
  {
    //chord
    Serial.println("chord");
  
  }
  else if(String(x[0]).toInt() == 2)
  {
    //rest
    Serial.println("rest");
  }
}
