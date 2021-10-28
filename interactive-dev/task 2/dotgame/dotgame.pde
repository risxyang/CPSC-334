import processing.serial.*;
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
import java.util.Arrays;
import java.io.InputStreamReader;

ArrayList<Integer> circleCentersX;
ArrayList<Integer> circleCentersY;
ArrayList<Integer> circleRadii;
ArrayList<Integer> circleHues;

int nNotes = 13;
ArrayList<String> noteNames;

int radius = 0;
int hue = 0;
int interval, startX, n;
float centerX, centerY;
int currIndex = 0;
int jButtonPrev = 0;
int mButtonPrev = 0;
int mButtonHeld = 0;
int switchPrev = 0;
int switchOn = 0;

String commandToRun;
File workingDir;   // where to run this command, as full path
String returnedValues;                        
  
PrintWriter output;
  
void setup()
{
  String portName = "/dev/tty.SLAB_USBtoUART"; //for testing on laptop
  //String portName = "/dev/ttyUSB0"; //for raspi
  myPort = new Serial(this, portName, 115200);
  
  workingDir = new File(sketchPath(""));
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
  
  noteNames = new ArrayList<String>();
  noteNames.add("c");
  noteNames.add("c#");
  noteNames.add("d");
  noteNames.add("d#");
  noteNames.add("e");
  noteNames.add("f");
  noteNames.add("f#");
  noteNames.add("g");
  noteNames.add("g#");
  noteNames.add("a");
  noteNames.add("a#");
  noteNames.add("b");
  noteNames.add("c#5");
  
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
    //int[] input = Arrays.stream(val.split(",")).mapToInt(Integer::parseInt).toArray(); //won'trun on version of processing for pi
    
    String[] arr = val.split(",");
    int[] input = {0, 0,d 0, 0, 0};
    for(int i = 0; i < 5; i++)
    {
        input[i] = parseInt(arr[i]);
    }

    
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
    
    //implement mButton control
    if (input[3] == 1 && mButtonPrev != 1)
    {
      mButtonPrev = 1;
      mButtonHeld = 1;
    }
    else if (input [3] == 0 && mButtonPrev !=0)
    {
      mButtonPrev = 0;
      mButtonHeld = 0;
    }
    
    //switch control
    if(input[4] == 1 && switchPrev != 1)
    {
      switchPrev = 1;
      playSound(0);
      
    }
    else if(input[4] == 0 && switchPrev != 0)
    {
      switchPrev = 0;
      //playSound(1); //get sounds to play backwards
    }
    
    radius = circleRadii.get(currIndex);
    hue = circleHues.get(currIndex);
    
    int rdiff = modifyByThresholds(radius, input[1]);
    int hdiff = modifyByThresholds(hue, input[0]);
    
    if (mButtonHeld == 1)
    {
      for (int i = 0; i < n; i++)
      {
        circleRadii.set(i, circleRadii.get(i) + rdiff);
        circleHues.set(i, ((circleHues.get(i) + hdiff) + 255) % 255);
      }
    }
    else
    {
      radius += rdiff;
      hue = ((hue + hdiff) +255) % 255;
      circleRadii.set(currIndex, radius);
      circleHues.set(currIndex, hue);
    }
    
    
    //uncomment next 2 lines for 5inch hdmi screen
    strokeWeight(4);
    stroke(255, 255, 255);
    //noStroke(); //comment this out if using 5inch hdmi screen
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
  
  noStroke();
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

void writeFile(int direction) //0 is forewards, 1 is backwards
{
  output = createWriter("result.py"); 
  output.println("import pysynth as ps");
  output.print("song = (");
  //convert hue and radius for each circle
  
  
  if(direction == 0)
  {
    for(int i = 0; i < n; i++)
    {
      int rratio = circleRadii.get(i) / (displayHeight / 2 ); //ratio of radius to half of screen height
      int h = circleHues.get(i);
      
      int noteIndex = h / 20;
      int duration;
      if (rratio < 0.2)
      {
        duration = 8;
      }
      else if(rratio < 0.4)
      {
         duration = 4; 
      }
      else
      {
        duration = 2;
      }
      
      output.print("('"+noteNames.get(noteIndex)+"', " + duration + "), ");
    }
  }
  else
  {
    for(int i = n-1; i >= 0; i--)
    {
      int rratio = circleRadii.get(i) / (displayHeight / 2);
      int h = circleHues.get(i);
      
      int noteIndex = h / 20;
      int duration;
      if (rratio < 0.2)
      {
        duration = 8;
      }
      else if(rratio < 0.4)
      {
         duration = 4; 
      }
      else
      {
        duration = 2;
      }
      
      output.print("('"+noteNames.get(noteIndex)+"', " + duration + "), ");
    }
  }
  
  output.println(")");
  output.println("ps.make_wav(song, fn = 'out.wav')");
  output.flush();
  output.close();
  
}

void playSound(int direction) //0 is forward, 1 is backwards
{ 
  writeFile(direction);
  runCommand("chmod +x result.py");
  runCommand("mv result.py PySynth");
  runCommand("python3 PySynth/result.py PySynth/out.wav");
  runCommand("./play.sh");
}

void runCommand(String command)
{
  // give us some info:
  //println("Running command: " + command);
  //println("Location:        " + workingDir);
  //println("---------------------------------------------\n");

  // run the command!
  try {
    Process p = Runtime.getRuntime().exec(command, null, workingDir);

    // variable to check if we've received confirmation of the command
    int i = p.waitFor();

    // if we have an output, print to screen
    if (i == 0) {

      // BufferedReader used to get values back from the command
      BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));

      // read the output from the command
      while ( (returnedValues = stdInput.readLine ()) != null) {
        //println(returnedValues);
      }
    }

    // if there are any error messages but we can still get an output, they print here
    else {
      BufferedReader stdErr = new BufferedReader(new InputStreamReader(p.getErrorStream()));

      // if something is returned (ie: not null) print the result
      while ( (returnedValues = stdErr.readLine ()) != null) {
        //println(returnedValues);
      }
    }
  }

  // if there is an error, let us know
  catch (Exception e) {
    //println("Error running command!");  
    //println(e);
    // e.printStackTrace();    // a more verbose debug, if needed
  }

  // when done running command, quit
  //println("\n---------------------------------------------");
  //println("DONE!");
}
