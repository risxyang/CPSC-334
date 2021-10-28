#include "WiFi.h"
#include <CapacitiveSensor.h>

//int lightSensor = A6;
//int pressureSensor = A7; 

int ccount = 1; 
int cloopfor = 10;
int lsumsum = 0;
int lsumavg = 0; //over 10 loops, get average value of sum of all light sensors, to compare against this start state later on

int psum = 0;
int pavg = 0;

long capsum = 0;
long capavg = 0;

// capacitive sensing constant
CapacitiveSensor capSensor = CapacitiveSensor(18,19);  // 1M resistor between pins 4 & 2, pin 2 is sensor pin
int light1 = 34; 
int light2 = 35;
int light3 = 32;
int light4 = 33;
int vib = 4;

const uint16_t port = 8091;
const char * host = "172.29.30.152";
//const char * host = "172.29.33.126";
//const char * host = "172.29.20.24";

  
WiFiClient client;

void setup(){

  pinMode(light2, INPUT_PULLUP);
  pinMode(light3, INPUT_PULLUP);
   

Serial.begin(115200);

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

void loop(){

//Serial.println(WiFi.macAddress());

int l1 = analogRead(light1); 
int l2 = analogRead(light2); 
int l3 = analogRead(light3); 
int l4 = analogRead(light4); 
int p = analogRead(vib);
long cap =  capSensor.capacitiveSensor(30);

//Serial.println(measurement);
 
    if (!client.connect(host, port)) {
 
        Serial.println("Connection to host failed");
 
        delay(10);
        return;
    }

 Serial.println("Connected to server successful!");
 
int lsum = l1 + l2 + l3 + l4;
if(ccount <= cloopfor) 
{
    lsumsum += lsum;
    lsumavg = lsumsum / ccount;

    psum += p;
    pavg = psum / ccount;

    capsum += cap;
    capavg = capsum / ccount;
    
    Serial.print("lsumavg: ");
    Serial.println(lsumavg, DEC);

    Serial.print("pavg: ");
    Serial.println(pavg, DEC);

    Serial.print("capavg: ");
    Serial.println(capavg, DEC);
    ccount += 1;
}
else //send data
{
//  char buf[16];
//  ltoa(cap,buf,10);
//  Serial.println(buf);
    client.println(String(lsumavg) + "," + String(lsum) + "," + String(pavg) + "," + String(p) + "," + String(capavg) + "," + String(cap));
    Serial.print(lsumavg, DEC);
//    client.print(",");
    Serial.print(",");
    
//    client.print(lsum, DEC);
    Serial.print(lsum, DEC);    
//    client.print(",");
    Serial.print(",");
    
//    client.print(vib, DEC);
    Serial.print(p, DEC);
//    client.print(",");
    Serial.print(",");
    
//    client.print(cap, DEC);
    Serial.print(cap, DEC);
//    client.println(" ");
    Serial.println(" ");
}
 
//    delay(10);

}
