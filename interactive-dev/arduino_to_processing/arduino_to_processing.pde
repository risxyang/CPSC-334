import processing.serial.*;
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
import java.util.Arrays;

void setup()
{
  String portName = "/dev/tty.SLAB_USBtoUART";
  myPort = new Serial(this, portName, 115200);
}

void draw()
{
  if ( myPort.available() > 0) 
  {  // If data is available,
  val = myPort.readStringUntil('\n').trim();         // read it and store it in val
  int[] input = Arrays.stream(val.split(",")).mapToInt(Integer::parseInt).toArray();
  for (int i = 0; i < 5; i++)
  {
    println(input[i]); //print it out in the console
  }
  } 
  
}
