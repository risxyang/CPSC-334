#include "WiFi.h"
const uint16_t port = 8090;
const char * host = "172.27.128.205";
WiFiClient client;

//can only use ADC1 pins with wifi
int l1 = 34; 
int l2 = 35; 
int l3 = 32;
int l4 = 33;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);

  //handle wifi connectivity
  WiFi.mode(WIFI_MODE_STA);
  delay(10);
  WiFi.begin("yale wireless");
  Serial.println("Connecting.");
  while(WiFi.status() != WL_CONNECTED) {
    Serial.println(".");
    delay(500);
  }
  Serial.println("WiFi connected - IP address: ");
  Serial.println(WiFi.localIP());


}

void loop() {

  //handle connectivity errors
  if (!client.connect(host, port)) {
        Serial.println("Connection to host failed");
        delay(10);
        return;
    }
    
  // read sensor vals
  int lval1 = analogRead(l1); 
  int lval2 = analogRead(l2); 
  int lval3 = analogRead(l3); 
  int lval4 = analogRead(l4); 
  
  Serial.print(lval1, DEC);
  Serial.print(",");
  Serial.print(lval2, DEC);
  Serial.print(",");
  Serial.print(lval3, DEC);
  Serial.print(",");
  Serial.println(lval4, DEC);

  client.println(String(lval1) + "," + String(lval2) + "," + String(lval3) + "," + String(lval4));
  delay(50);

}
