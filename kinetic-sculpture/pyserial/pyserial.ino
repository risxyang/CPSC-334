String x;
void setup() {
 Serial.begin(115200);
 Serial.setTimeout(1);
}
void loop() {
// while (!Serial.available());
// x = Serial.readStringUntil('\n');
//// Serial.print(x + 1);
//  Serial.println(x);

  String inData = "";
  while (Serial.available() > 0)
    {
        char recieved = Serial.readString();
        inData += recieved; 

        // Process message when new line character is recieved
        if (recieved == '\n')
        {
            Serial.print("Arduino Received: ");
            Serial.print(inData);

            inData = ""; // Clear recieved buffer
        }
    }
}
