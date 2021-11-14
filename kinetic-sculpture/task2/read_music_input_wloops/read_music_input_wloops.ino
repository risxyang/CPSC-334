
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

int wristMax = 1500;
int elbowMax = 3000;
int shoulderMax = 1500;

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
int ind5;
int ind6;

int elbowMin = 600;

  int sval;
  int eval;
  int wval;
  int loopmode = false; //default
  int motordelay = 10; //default


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

    
//    Serial.println(state, DEC);
    t = millis();
 
  
 if (Serial.available())
 {
    x = Serial.readStringUntil('\n');
   Serial.println(x);
  
  // read duration
  ind1 = x.indexOf(',');  //finds location of first ,
  double dur = x.substring(0, ind1).toDouble();   //captures first data String
  int durMS = (int)(dur * 1000.0);
  
  ind2 = x.indexOf(',', ind1+1 );
  ind3 = x.indexOf(',', ind2+1 );
  ind4 = x.indexOf(',', ind3+1 );
  ind5 = x.indexOf(',', ind4+1 );
  ind6 = x.indexOf(',', ind5+1 );
  
  sval = x.substring(ind1+1, ind2+1).toInt();
  eval = x.substring(ind2+1, ind3+1).toInt();
  wval = x.substring(ind3+1, ind4+1).toInt();
  loopmode = x.substring(ind4+1, ind5+1).toInt();
  motordelay = x.substring(ind5+1, ind6+1).toInt();
  elbowMin =  x.substring(ind6+1).toInt(); 

 }

if(loopmode == 0)
{
  shoulder.writeMicroseconds(sval);
  elbow.writeMicroseconds(eval);
  wrist.writeMicroseconds(wval);
}
else
{
  shoulderMax = sval;
  elbowMax = eval;
  wristMax = wval;
  
  int inc = 10;
  if (shoulderPos < shoulderMax && decShoulder == false)
  {
    shoulderPos += inc;
    shoulder.writeMicroseconds(shoulderPos);
  delay(motordelay);

  } //unless you've rotated 180 degrees already, then go back to position 0 degrees
  else if(shoulderPos >= shoulderMax && decShoulder == false)
  {
      decShoulder = true;
       
  } 
  else if(decShoulder == true)
  {
        shoulderPos -= inc; 
        if(shoulderPos <= 600)
        {
          decShoulder = false;
        }
        else
        {
          shoulder.writeMicroseconds(shoulderPos);    // tell servo to go to position in variable 'pos'
          delay(motordelay);
        }

  }
//  Serial.println(shoulderPos);


  if (elbowPos < elbowMax && decElbow == false)
  {
    elbowPos += inc;
    elbow.writeMicroseconds(elbowPos);
     delay(motordelay);

  } //unless you've rotated 180 degrees already, then go back to position 0 degrees
  else if(elbowPos >= elbowMax && decElbow == false)
  {
      decElbow = true;
       
  } 
  else if(decElbow == true)
  {
        elbowPos -= inc; 
        elbow.writeMicroseconds(elbowPos);    // tell servo to go to position in variable 'pos'
        delay(motordelay);

        if(elbowPos <= elbowMin)
        {
          decElbow = false;
        }
  }


  if (wristPos < wristMax && decWrist == false)
  {
    wristPos += inc;
    wrist.writeMicroseconds(wristPos);
    delay(motordelay);

  } //unless you've rotated 180 degrees already, then go back to position 0 degrees
  else if(wristPos >= wristMax && decWrist == false)
  {
      decWrist = true;
       
  } 
  else if(decWrist == true)
  {
        wristPos -= inc; 
        wrist.writeMicroseconds(wristPos);    // tell servo to go to position in variable 'pos'
        delay(motordelay);

        if(wristPos <= 600)
        {
          decWrist = false;
        }
  }

}

}
