int l1 = 15; 

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);`

}

void loop() {
  // put your main code here, to run repeatedly:
  int lval1 = analogRead(l1); 
  Serial.println(lval1, DEC);

}
