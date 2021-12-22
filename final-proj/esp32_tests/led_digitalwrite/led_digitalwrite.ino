int red = 5;
int green = 18;
int blue = 19;

int red1 = 15;
int green1 = 2;
int blue1 = 0;
 
// the setup routine runs once when you press reset:
void setup()
{
// initialize the digital pin as an output.
pinMode(red, OUTPUT);
pinMode(green, OUTPUT);
pinMode(blue, OUTPUT);
digitalWrite(red, HIGH);
digitalWrite(green, HIGH);
digitalWrite(blue, HIGH);

pinMode(red1, OUTPUT);
pinMode(green1, OUTPUT);
pinMode(blue1, OUTPUT);
digitalWrite(red1, HIGH);
digitalWrite(green1, HIGH);
digitalWrite(blue1, HIGH);
}
 
// the loop routine runs over and over again forever:
void loop() {
digitalWrite(red, LOW); // turn the LED on 
digitalWrite(red1, LOW); // turn the LED on 
delay(1000); // wait for a second
digitalWrite(red, HIGH); // turn the LED off by making the voltage LOW
digitalWrite(red1, HIGH); // turn the LED off by making the voltage LOW
delay(1000); // wait for a second
digitalWrite(green, LOW); // turn the LED on 
digitalWrite(green1, LOW); // turn the LED on 
delay(1000); // wait for a second
digitalWrite(green, HIGH); // turn the LED off by making the voltage
digitalWrite(green1, HIGH); // turn the LED off by making the voltagLOW
delay(1000); // wait for a second
digitalWrite(blue, LOW); // turn the LED on
digitalWrite(blue1, LOW); // turn the LED on
delay(1000); // wait for a second
digitalWrite(blue, HIGH); // turn the LED off by making the voltage LOW
digitalWrite(blue1, HIGH); // turn the LED off by making the voltage LOW
delay(1000); // wait for a second
}
