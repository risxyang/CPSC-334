 //LED 1
 
 #define LEDR 5
 #define LEDG 18
 #define LEDB 19
 #define R_channel 0
 #define G_channel 1
 #define B_channel 2

//LED 2
 #define LEDR_2 15
 #define LEDG_2 2
 #define LEDB_2 0
 #define R_channel_2 3
 #define G_channel_2 4
 #define B_channel_2 5

//LED 3
 #define LEDR_3 33
 #define LEDG_3 25
 #define LEDB_3 26
 #define R_channel_3 6
 #define G_channel_3 7
 #define B_channel_3 8

 
 #define pwm_Frequency 5000 // pwm frequency  
 #define pwm_resolution 8 // 8 bit resolution  

 
 void setup() {  

  //LED 1
  ledcAttachPin(LEDR, R_channel);  
  ledcAttachPin(LEDG, G_channel);  
  ledcAttachPin(LEDB, B_channel);   
  ledcSetup(R_channel, pwm_Frequency, pwm_resolution);  
  ledcSetup(G_channel, pwm_Frequency, pwm_resolution);  
  ledcSetup(B_channel, pwm_Frequency, pwm_resolution);  

  //LED 2
  ledcAttachPin(LEDR_2, R_channel_2);  
  ledcAttachPin(LEDG_2, G_channel_2);  
  ledcAttachPin(LEDB_2, B_channel_2);   
  ledcSetup(R_channel_2, pwm_Frequency, pwm_resolution);  
  ledcSetup(G_channel_2, pwm_Frequency, pwm_resolution);  
  ledcSetup(B_channel_2, pwm_Frequency, pwm_resolution);

  //LED 3
  ledcAttachPin(LEDR_3, R_channel_3);  
  ledcAttachPin(LEDG_3, G_channel_3);  
  ledcAttachPin(LEDB_3, B_channel_3);   
  ledcSetup(R_channel_3, pwm_Frequency, pwm_resolution);  
  ledcSetup(G_channel_3, pwm_Frequency, pwm_resolution);  
  ledcSetup(B_channel_3, pwm_Frequency, pwm_resolution);
 }  
 void loop() {  
 
  for(int i = 0; i < 255; i++)
  {
    RGB_Color(i, i, 0);
    RGB_Color_2(255-i, 0, i);
    RGB_Color_3(i, 0, i);
    delay(50);
  }
  for(int i = 255; i > 0; i--)
  {
    RGB_Color(i,i, 0);
    RGB_Color_2(255-i, 0, i);
    RGB_Color_3(i, 0, i);
    delay(50);
  }
 }  
 void RGB_Color(int i, int j, int k)  
 {  
  ledcWrite(R_channel, i);   
  ledcWrite(G_channel, j);  
  ledcWrite(B_channel, k);   
 }  

  void RGB_Color_2(int i, int j, int k)  
 {  
  ledcWrite(R_channel_2, i);   
  ledcWrite(G_channel_2, j);  
  ledcWrite(B_channel_2, k);   
 } 

  void RGB_Color_3(int i, int j, int k)  
 {  
  ledcWrite(R_channel_3, i);   
  ledcWrite(B_channel_3, j);  
  ledcWrite(G_channel_3, k);   
 } 
