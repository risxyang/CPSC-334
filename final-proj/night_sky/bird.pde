class bird {
  float x;
  float y;
  PImage birdImage;
  PImage[] glideFrames;
  PImage[] flapFrames;
  int w;
  boolean isFlapping;
  int flapCount;
  
  int frameIndex;
  
  bird()
  {
     w = 500;
     
     glideFrames = new PImage[6];
     flapFrames = new PImage[10];
     
     for(int i = 0; i < 6; i++)
     {
       glideFrames[i] = loadImage("glide/"+(i+1)+".png");
       glideFrames[i].resize(w,w);
     }
     
     for(int i = 0; i < 10; i++)
     {
       flapFrames[i] = loadImage("flap/"+(i+1)+".png");
       flapFrames[i].resize(w,w);
     }
     
     frameIndex = 0;
     isFlapping = false;
     flapCount = 0;
     
  }
  
  void update(String dir)
  {
    
    int angle = 0;
    int base = -45;
    switch(dir)
    {
      case "N":
        angle = 0 + base;
        break;
      case "NE":
        angle = 45 + base;
        break;
      case "E":
        angle = 90 + base;
        break;
      case "SE":
        angle = 135 + base;
        break;
      case "S":
        angle = 180 + base;
        break;
      case "SW":
        angle = 225 + base;
        break;
      case "W":
        angle = 270 + base;
        break;
      case "NW":
        angle = 315 + base;
        break;
    }
    
    rotate(angle);
      
    
  }
  
  void show()
  {
    //rotate(mouseX);
     if (!isFlapping)
     {
       int chanceFlap = (int)random(0,100); //see if you want to start
       if (chanceFlap > 95)
       {
           isFlapping = true; 
           frameIndex = 0;
       }
       else
       {
         image(glideFrames[frameIndex], -displayWidth/5 ,-displayHeight/5);
         frameIndex = (frameIndex + 1) % 6;
       }
    }
    else //is currently flapping
    {
        image(flapFrames[frameIndex], -displayWidth/5 ,-displayHeight/5);
        if(frameIndex == 8 && (flapCount > (int)random(2,5)))
        {
          isFlapping = false;
          frameIndex = 0;
          flapCount = 0;
        }
        else
        {
          if(frameIndex == 8)
          {
            flapCount += 1;
          }
          frameIndex = (frameIndex + 1) % 10;
        }
    }
  }
 
  
}
