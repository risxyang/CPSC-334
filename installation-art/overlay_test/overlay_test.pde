int h, w, o, g, nRows, nCols; //for controlling geometry
int s; //for measuring time
color light, dark;
PImage photo, maskImage;
PGraphics pg;

void setup() {
    size(600, 600, P3D);
    h = 140;
    w = 100;
    o = 30; // offset; can change
    g = 15; // gap
    nRows = 4;
    nCols = 4;
    
    light = color(255, 255, 150);
    dark = color(250, 150, 10);
    
    photo = loadImage("1.jpeg");
    maskImage = loadImage("mask.jpeg");
    
    
    pg = createGraphics(600, 600);
    
    //noLoop(); // for testing
}

void draw()
{
  //filter(NORMAL);
  blendMode(NORMAL);
  photo.mask(maskImage);
  image(photo, 0, 0);
  
  //get the current time (seconds, values 0 to 59)
  s = second();
   
  pg.beginDraw();
  pg.clear();
  for(int i = 0; i < nRows; i++)
  {
    for (int j = 0; j < nCols; j++)
    {
      pg.beginShape();
      pg.noStroke();
      //pg.blendMode(ADD);
      //color c = color(220, 150, 10);
      color c = lerpColor(light, dark, (s / 59.0));  
      pg.fill(c, getOpacity(s));
      int xOffset = j * (o+w+g) + mouseX;
      int yOffset = i * (h + g) + mouseY;
      int rowIndent = i * o;
      pg.vertex(0 + xOffset + rowIndent, 0 + yOffset);
      pg.vertex(w + xOffset + rowIndent, 0 + yOffset);
      pg.vertex(w+o + xOffset + rowIndent, h + yOffset);
      pg.vertex(o + xOffset + rowIndent, h + yOffset);
      pg.endShape();

      //filter(BLUR, 4);
      
    }
  }
  
  pg.filter(BLUR, 4);
  pg.endDraw();
  blendMode(ADD);
  image(pg, 0, 0); 
 
}

////parabola eq which smoothes out the minute transition
////fades out opacity of the light shape near the end of the minute (50s), and fades it in at 10 s
//int getOpacity(int s) // take in current second value
//{
//  println(-1 * int((s-10) * (s-50) / 3));
//  return -1 * int((s-10) * (s-50) / 3); //division makes this cap out at 100
//}

float getOpacity(int s)
{
  if(s < 30) //slowly fade in from s=0 to s=30
  {
    return (s / 30.0) * 100;
  }
  else if (s >= 55) //start fading out at s=55
  {
    return (-20.0 * s + 1200);
  }
  else //return 100 for s between 30 and 55
  {
    return 100;
  }
}
