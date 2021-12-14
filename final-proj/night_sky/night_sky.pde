Star[] stars = new Star[800];

// I create a variable "speed", it'll be useful to control the speed of stars.
float speed;
int changeX;
int changeY;
int dirX = 0;
int dirY = 0;

int s = second(); //0-59

light lightfield;

void setup() {
  //size(600, 600);
  fullScreen();
  // I fill the array with a for loop;
  // running 800 times, it creates a new star using the Star() class.
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star();
  }
  
  lightfield = new light();
}

void draw() {
  
  String[] sensorVals1 = loadStrings("../wifiread");
  String[] sensorVals2 = loadStrings("../wifiread2");
  
  if (sensorVals1.length > 0 && sensorVals2.length > 0)
  {
    String[] arr1 = sensorVals1[0].split(",");
    String[] arr2 = sensorVals2[0].split(",");
    int[] input = {0, 0, 0, 0, 0, 0, 0, 0, 0}; //9 total photoresistors
    for(int i = 0; i < 5; i++)
    {
       input[i] = parseInt(arr1[i]);
    }
    for(int i = 0; i < 4; i++)
    {
       input[i+5] = parseInt(arr2[i]);
    }
  
  
    //remove any max 4095 values (sensor is having connectivity problems)
    for(int i = 0; i < 9; i++)
    {
      if(input[i] == 4095 || input[i] == 0)
      {
        input[i] = 2200; //just set it to some average ish value
      }
    }
    
    //get min value
    
    int minVal = 4095;
    int minIndex = 0;
    for(int i = 0; i < 9; i++)
    {
      if (input[i] < minVal)
      {
        minVal = input[i];
        minIndex = i;
      }
    }
    
    //if minVal > 1500 (probably no one is on sensor), do nothing
    
    if (minVal < 1500)
    {
      String dir = "";
      dirX = 0;
      dirY = 0;
      switch(minIndex)
      {
        case 0:
          dir = "S";
          dirY = -1;
          break;
        case 1:
          dir = "E";
          dirX = 1;
          break;
        case 2:
          dir = "W";
          dirX = -1;
          break;
        case 3:
          dir = "N";
          dirY = 1;
          break;
        case 4:
          dir = "C";
          break;
        case 5:
          dir = "SE";
          dirX = 1;
          dirY = -1;
          break;
        case 6: 
          dir = "NE";
          dirX = 1;
          dirY = 1;
          break;
        case 7:
          dir = "NW";
          dirX = -1;
          dirY = 1;
          break;
        case 8:
          dir = "SW";
          dirX = -1;
          dirY = -1;
          break;
      }
      
      println(dir);
    }
  }
  
  // i link the value of the speed variable to the mouse position.
  //speed = map(mouseX, 0, width, 0, 50);

  background(0);
  // I shift the entire composition,
  // moving its center from the top left corner to the center of the canvas.
  translate(width/2, height/2);
  //changeX = (int)((mouseX - (displayWidth / 2)) * 0.02);
  //changeY = (int)((mouseY - (displayHeight / 2)) * 0.02);
  changeX = dirX * 4;
  changeY = dirY * -4;
  // I draw each star, running the "update" method to update its position and
  // the "show" method to show it on the canvas.
  for (int i = 0; i < stars.length; i++) {
    stars[i].update();
    stars[i].show();
  }
  delay(50);
 
 //add borders to make this a square
 int xOffset = (displayWidth - displayHeight) / 2;
 
  fill(0,0,0);
  rect(-displayWidth/2, -displayHeight/2, xOffset, displayHeight);
  rect(displayWidth - xOffset - displayWidth/2, -displayHeight/2, displayWidth, displayHeight);
  
  
  //lightfield.update();
  //lightfield.show();
 
 translate(changeX, changeY);
 //rect(0, 0, xOffset, displayHeight);
 //rect(displayWidth - xOffset, 0, displayWidth, displayHeight);
 

 
}
