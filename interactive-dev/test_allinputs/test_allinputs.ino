int JoyStick_X = A6; // Analog Pin  X

int JoyStick_Y = A7; // // Analog Pin  Y

int JoyStick_button = 32; // IO Pin

int Momentary_button = 21; // green momentary button

int Switch = 16;

void setup()

{

    pinMode(JoyStick_X, INPUT);

    pinMode(JoyStick_Y, INPUT);

    pinMode(JoyStick_button, INPUT_PULLUP);

    pinMode(Momentary_button, INPUT);

    pinMode(Switch, INPUT);

    

    Serial.begin(115200);

}

void loop()

{

    int x, y, button, joybutton, switchinput;

    x = analogRead(JoyStick_X); //  X

    y = analogRead(JoyStick_Y); //  Y

    joybutton = digitalRead(JoyStick_button); // 
    if (joybutton == 1)
    {
      joybutton = 0;
    }
    else
    {
      joybutton = 1;
    }

    button = digitalRead(Momentary_button);

    switchinput = digitalRead(Switch);

    

    x = map(x, 0, 4096, -2048, 2048);

    y = map(y, 0, 4096, 2048, -2048);

    

    //In order: Joystick X, Joystick Y, Joystick button, momentary button, switch

    Serial.print(x, DEC);

    Serial.print(",");

    Serial.print(y, DEC);

    Serial.print(",");

    Serial.print(joybutton, DEC);

    Serial.print(",");

    Serial.print(button, DEC);

    Serial.print(",");
    
    Serial.print(switchinput, DEC);

    Serial.println(" ");

    delay(100);

}
