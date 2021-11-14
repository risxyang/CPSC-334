
#include <ESP32Servo.h>

//physical input
int Switch = 13;
int reading;           // the current reading from the input pin
int previous = LOW;    // the previous reading from the input pin
int state = 0;      // the current state of the output

// the follow variables are long's because the time, measured in miliseconds,
// will quickly become a bigger number than can be stored in an int.
long t = 0;         // the last time the output pin was toggled
long debounce = 300;   // the debounce time, increase if the output flickers



//SERVO 

Servo shoulder;  // create servo object to control a servo
Servo elbow; 
Servo wrist; 
// 16 servo objects can be created on the ESP32
 
int wristPos = 0;    // variable to store the servo position
int elbowPos = 0; 
int shoulderPos = 0; 
int newWristPos;
int newElbowPos;
int newShoulderPos;

bool decShoulder = false;
bool decElbow = false;
bool decWrist = false;


// Recommended PWM GPIO pins on the ESP32 include 2,4,12-19,21-23,25-27,32-33 
int wristPin = 19;
int elbowPin = 17;
int shoulderPin = 16;

//input read
String x;
int ind1; 
int ind2;
int ind3;
int ind4;


void setup() {
 Serial.begin(115200);

 pinMode(Switch, INPUT);
 
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

  shoulder.writeMicroseconds(0);
  elbow.writeMicroseconds(0);
  wrist.writeMicroseconds(0);
  
}
void loop() {

 int reading = digitalRead(Switch);
// Serial.println(reading, DEC);
 if (reading == 1 && previous == LOW && millis() - t > debounce) 
    {
      state = 1;
      previous = HIGH;
    }
    else if(reading == 0 && previous == HIGH && millis() - t > debounce)
    {
      state = 0;
      previous = LOW;
    }

    
    Serial.println(state, DEC);
    t = millis();
 

  
 while (!Serial.available())
 {
   int reading = digitalRead(Switch);
// Serial.println(reading, DEC);
 if (reading == 1 && previous == LOW && millis() - t > debounce) 
    {
      state = 1;
      previous = HIGH;
    }
    else if(reading == 0 && previous == HIGH && millis() - t > debounce)
    {
      state = 0;
      previous = LOW;
    }

    
    Serial.println(state, DEC);
    t = millis();
 }
 x = Serial.readStringUntil('\n');
// Serial.println(x);

// read duration
ind1 = x.indexOf(',');  //finds location of first ,
double dur = x.substring(0, ind1).toDouble();   //captures first data String
int durMS = (int)(dur * 1000.0);

ind2 = x.indexOf(',', ind1+1 );
shoulderPos = x.substring(ind1+1, ind2+1).toInt();

ind3 = x.indexOf(',', ind2+1 );
elbowPos = x.substring(ind2+1, ind3+1).toInt();
wristPos =  x.substring(ind3+1).toInt(); 

shoulder.writeMicroseconds(shoulderPos);
elbow.writeMicroseconds(elbowPos);
wrist.writeMicroseconds(wristPos);

//n = 10; //delay segmentation
//double d = durMS / n;
//if (newShoulderPos < shoulderPos)
//{
//  for (int sp = shoulderPos; sp
//}

}
