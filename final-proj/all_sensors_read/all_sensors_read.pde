void setup()
{
}

void draw()
{
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
    
    String dir = "";
    switch(minIndex)
    {
      case 0:
        dir = "S";
        break;
      case 1:
        dir = "E";
        break;
      case 2:
        dir = "W";
        break;
      case 3:
        dir = "N";
        break;
      case 4:
        dir = "C";
        break;
      case 5:
        dir = "SE";
        break;
      case 6: 
        dir = "NE";
        break;
      case 7:
        dir = "NW";
        break;
      case 8:
        dir = "SW";
        break;
    }
    
    println(dir);
  }
  
  
}
