
#include <ESP32Servo.h>
#include <Stepper.h>

//SERVO 

Servo myservo;  // create servo object to control a servo
// 16 servo objects can be created on the ESP32
 
int pos = 0;    // variable to store the servo position
// Recommended PWM GPIO pins on the ESP32 include 2,4,12-19,21-23,25-27,32-33 
int servoPin = 16;


//STEPPER 
const int stepsPerRevolution = 64;  // change this to fit the number of steps per revolution
// for your motor
//int in3Pin = 32;
//int in4Pin = 35;

int in1Pin = 15;
int in2Pin = 2;
int in3Pin = 0;
int in4Pin = 4;

// initialize the stepper library on pins 8 through 11:
Stepper myStepper(stepsPerRevolution, in1Pin, in2Pin, in3Pin, in4Pin);  
 
void setup() {
  //SERVO
  // Allow allocation of all timers
  ESP32PWM::allocateTimer(0);
  ESP32PWM::allocateTimer(1);
  ESP32PWM::allocateTimer(2);
  ESP32PWM::allocateTimer(3);
  myservo.setPeriodHertz(50);    // standard 50 hz servo
  myservo.attach(servoPin, 500, 2400); // attaches the servo on pin to the servo object
  // using default min/max of 1000us and 2000us
  // different servos may require different min/max settings
  // for an accurate 0 to 180 sweep

  //STEPPER
  pinMode(in1Pin, OUTPUT);
  pinMode(in2Pin, OUTPUT);
  pinMode(in3Pin, OUTPUT);
  pinMode(in4Pin, OUTPUT);
  // set the speed at 60 rpm:
  myStepper.setSpeed(400);
  // initialize the serial port:
  Serial.begin(9600);
}
 
void loop() {

  //STEPPER: rotate 360
  // step one revolution  in one direction:
  Serial.println("clockwise");
  myStepper.step(2048);
  delay(15);

  //SERVO: rotate 10 degrees
  if (pos < 180)
  {
    pos += 10;
    myservo.write(pos);

  } //unless you've rotated 180 degrees already, then go back to position 0 degrees
  else
  {
     //go back to 0
     for (pos = 180; pos >= 0; pos -= 1) 
     { // goes from 180 degrees to 0 degrees
       myservo.write(pos);    // tell servo to go to position in variable 'pos'
       delay(15);
     }
  } 


   delay(15);
}
