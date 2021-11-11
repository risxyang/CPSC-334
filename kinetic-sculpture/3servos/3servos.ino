
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


void setup() {
  //SERVO
  // Allow allocation of all timers
  ESP32PWM::allocateTimer(0);
  ESP32PWM::allocateTimer(1);
  ESP32PWM::allocateTimer(2);
  ESP32PWM::allocateTimer(3);
  shoulder.setPeriodHertz(50);    // standard 50 hz servo
  shoulder.attach(shoulderPin, 500, 2400); // attaches the servo on pin to the servo object
  // using default min/max of 1000us and 2000us
  // different servos may require different min/max settings
  // for an accurate 0 to 180 sweep
//

//  ESP32PWM::allocateTimer(4);
//  ESP32PWM::allocateTimer(5);
//  ESP32PWM::allocateTimer(6);
//  ESP32PWM::allocateTimer(7);
  elbow.setPeriodHertz(50);    // standard 50 hz servo
  elbow.attach(elbowPin, 500, 2400); // attaches the servo on pin to the servo object
  
  wrist.setPeriodHertz(50);    // standard 50 hz servo
  wrist.attach(wristPin, 500, 2400); // attaches the servo on pin to the servo object

  Serial.begin(9600);
}
 
void loop() {


  //SERVO: rotate 10 degrees
  if (shoulderPos < 90 && decShoulder == false)
  {
    shoulderPos += 1;
    shoulder.write(shoulderPos);
    delay(10);

  } //unless you've rotated 180 degrees already, then go back to position 0 degrees
  else if(shoulderPos >= 90 && decShoulder == false)
  {
      decShoulder = true;
       
  } 
  else if(decShoulder == true)
  {
        shoulderPos -= 1; 
        shoulder.write(shoulderPos);    // tell servo to go to position in variable 'pos'

        if(shoulderPos <= 1)
        {
          decShoulder = false;
        }
        delay(10);
  }


  if (elbowPos < 120 && decElbow == false)
  {
    elbowPos += 1;
    elbow.write(elbowPos);
       delay(10);

  } //unless you've rotated 180 degrees already, then go back to position 0 degrees
  else if(elbowPos >= 120 && decElbow == false)
  {
      decElbow = true;
       
  } 
  else if(decElbow == true)
  {
        elbowPos -= 1; 
        elbow.write(elbowPos);    // tell servo to go to position in variable 'pos'

        if(elbowPos <= 1)
        {
          decElbow = false;
        }
        delay(10);
  }


  if (wristPos < 45 && decWrist == false)
  {
    wristPos += 1;
    wrist.write(elbowPos);
       delay(10);

  } //unless you've rotated 180 degrees already, then go back to position 0 degrees
  else if(wristPos >= 45 && decWrist == false)
  {
      decWrist = true;
       
  } 
  else if(decWrist == true)
  {
        wristPos -= 1; 
        wrist.write(wristPos);    // tell servo to go to position in variable 'pos'

        if(wristPos <= 1)
        {
          decWrist = false;
        }
        delay(10);
  }

}
