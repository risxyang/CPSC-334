int h, w, o, g, nRows, nCols;
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
  
  pg.beginDraw();
  pg.clear();
  for(int i = 0; i < nRows; i++)
  {
    for (int j = 0; j < nCols; j++)
    {
      pg.beginShape();
      pg.noStroke();
      //pg.blendMode(ADD);
      color c = color(220, 150, 10);
      pg.fill(c, 100);
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
