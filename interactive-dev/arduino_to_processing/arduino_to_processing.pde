import processing.serial.*;
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
import java.util.Arrays;

ArrayList<Integer> circleCentersX;
ArrayList<Integer> circleCentersY;
ArrayList<Integer> circleRadii;
ArrayList<Integer> circleHues;

int radius = 0;
int hue = 0;
int interval, startX, n;
float centerX, centerY;
int currIndex = 0;
int jButtonPrev = 0;
  
  
void setup()
{
  String portName = "/dev/tty.SLAB_USBtoUART";
  myPort = new Serial(this, portName, 115200);
  
  n = 5;
  interval = displayWidth / (n + 1);
  startX = 0;
  
  //get center of display
  centerX = displayWidth / 2;
  centerY = displayHeight / 2;
  
  circleCentersX = new ArrayList<Integer>();
  circleCentersY = new ArrayList<Integer>();
  circleRadii = new ArrayList<Integer>();
  circleHues = new ArrayList<Integer>();
  for (int j = 1; j < (n+1); j++)
  {
    circleCentersX.add(startX + j*interval);
    circleCentersY.add((int)centerY);
    circleRadii.add(0);
    circleHues.add(0);
  }
}

void settings()
{
  fullScreen();
}

void draw()
{

  color c;
 
  if ( myPort.available() > 0) 
  {  // If data is available,
    val = myPort.readStringUntil('\n').trim();         // read it and store it in val
    int[] input = Arrays.stream(val.split(",")).mapToInt(Integer::parseInt).toArray();
    
    //implement jbutton control
    if (input[2] == 1 &&  jButtonPrev != 1)
    {
      currIndex = (currIndex + 1) % n;
      jButtonPrev = 1;
    }
    else if(input[2] == 0 && jButtonPrev != 0)
    {
      jButtonPrev = 0;
    }
  
    radius = circleRadii.get(currIndex);
    hue = circleHues.get(currIndex);
    radius += modifyByThresholds(radius, input[1]);
    hue = (hue + modifyByThresholds(hue, input[0])) % 255;
    
    circleRadii.set(currIndex, radius);
    circleHues.set(currIndex, hue);
    
    noStroke();
    colorMode(HSB, 255);
    
    for(int i = 0; i < n; i++)
    {
      //for each circle in array, render its current properties.
      if(i != currIndex)
      {
        c = color(circleHues.get(i), 200, 200);
        fill(c);
        circle(circleCentersX.get(i), circleCentersY.get(i), circleRadii.get(i));
      }
    }
    //but draw the current circle on top
    c = color(circleHues.get(currIndex), 200, 200);
    fill(c);
    circle(circleCentersX.get(currIndex), circleCentersY.get(currIndex), circleRadii.get(currIndex));
    
    
  } 
  
  //generate 5 evenly spaced points across canvas
  int rectdim = 20;
  for (int j = 1; j < (n+1); j++)
  {
    colorMode(RGB, 255);
    if (currIndex+1 == j)
    {
      fill(0, 100, 255);
    }
    else
    {
      noStroke();
      fill(50, 50, 50);
    }
    rect(startX + j*interval - (rectdim / 2), centerY - (rectdim / 2), rectdim, rectdim);
  }
  
}

int modifyByThresholds(float r, int x)
{
  int base = 2;
  if (x > 2000)
  {
    return base ^ 4;
  }
  else if(x > 1500)
  {
    return base ^ 3;
  }
  else if(x > 1000)
  {
    return base ^ 2;
  }
  else if(x > 500)
  {
    return base ^ 1;
  }
  else if( x > -1000 && x < -500)
  {
    return - 1 * base ^ 1;
  }
  else if(x > -1500 && x < -1000)
  {
    return -1 & base ^ 2;
  }
  else if(x > -2400 && x < -1500)
  {
    return -1 * base ^ 3;
  }
  else if (x < -2400)
  {
    return -1 * base ^ 4;
  }
  else
  {
    return 0;
  }
  
 
}
