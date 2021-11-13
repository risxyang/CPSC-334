String x;

void setup() {
 Serial.begin(115200);
 Serial.setTimeout(2);
}
void loop() {
 while (!Serial.available());
 x = Serial.readStringUntil('\n');
// Serial.print(x + 1);
  Serial.println(x);
  if(x[0].toInt() == 0)
  {
    //note
  }
  else if(x[0].toInt() == 1)
  {
    //chord
  
  }
  else if(x[0].toInt() == 2)
  {
    //rest
  }
}
