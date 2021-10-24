int h, w, o, g, nRows, nCols; //for controlling geometry
int hshift, vshift; //light shift over successive calls to draw
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
    hshift = 0;
    vshift = 0;
    
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
  if (s == 0)
  {
    hshift = 0;
    vshift = 0;
  }
  
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
      //int xOffset = j * (o+w+g) + mouseX;
      //int yOffset = i * (h + g) + mouseY;
      float xOffset = j * (o+w+g) + hshift;
      float yOffset = i * (h + g) + vshift;
      float rowIndent = i * o;
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
  vshift +=2;
  hshift +=3;
  

 
}


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
