PImage photo, maskImage;
ArrayList<PImage> photos;
int iter = 0;
int value; //test mouseDragged 
int u, v;
int h, w, o, g, nRows, nCols; //for controlling geometry
int hshift, vshift; //light shift over successive calls to draw
int s; //for measuring time
color light, dark;
PGraphics pg;
float rot;
int time;
int b;

void setup() {
  //size(400, 400);
    h = 140;
    w = 100;
    o = 30; // offset; can change
    g = 15; // gap
    nRows = 4;
    nCols = 4;
    hshift = 0;
    vshift = 0;
    b = 4; //blur
    
    light = color(255, 255, 150);
    dark = color(250, 120, 10);
    
  photos = new ArrayList<PImage>();
  
  size(600, 600, P3D);
  
   for(int i = 1; i <= 6; i++)
   {
    PImage pi = loadImage(str(i)+".jpeg");
    photos.add(pi);
  }
   
  photo = loadImage("1.jpeg");
  maskImage = loadImage("mask.jpeg");
  //photo.mask(maskImage);
    image(photo, 0, 0);
    
    pg = createGraphics(600, 600);
    time = millis();
}


void draw() {
  //background(0);
  

  //get the current time (seconds, values 0 to 59)
  s = second();
  
  int sz = 300;
  int tsz = 50;
  //rotateY(mouseY);
  //rotateY(radians(PI * 2.0 * random(0,1)));
  //rotateX(mouseX);
  translate(200, 200, 0);

  //if (keyPressed) {
  //  if (key == 'b' || key == 'B') {
  //    image(photo, 0, 0);
  //    u = (int)random(1, photos.get(0).width - sz);
  //    v = (int)random(1, photos.get(0).height - sz);
  //    u = 0;
  //    v = 0;
  //  }
  //}

  if (millis() > time + 5000)
  {
    //println("yeet");
       time = millis();
    
       hshift = 0;
       vshift = 0;
       
      h = (int)random(50, 250);
      w = (int)random(50, 250);
      o = (int)random(10, 50); // offset; can change
      g = (int)random(10, 50); // gap
      nRows = (int)random(1, 6);
      nCols = (int)random(1, 6);
      b = (int)random(2,8);
    
    
      rot = random(0, 360);
      rotateY(rot);
      println(rot);
      //sep sides
    memBox(iter, sz, tsz, u, v);
    iter += 1;
    if (iter >= 6)
    {
      iter = 0;
    }
    
  //for (int j = 0; j < 6; j++)
  //{
  //  memBox(j, sz, tsz, u, v);
  //}


  
  //filter(NORMAL);
  blendMode(NORMAL);
  photo.mask(maskImage);
  image(photo, 0, 0);
  }
  
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
  
  pg.filter(BLUR, b);
  pg.endDraw();
  blendMode(ADD);
  //rotateY(81);
  rotateZ(radians(PI * 2.0 * (s/60.0)));
  //rotateZ(hshift);
  //println(PI * 2.0 * (s/60.0));
  //rotateY(radians(PI/3.0));
  rotateY(rot);
  image(pg, 0, 0); 
  vshift +=2;
  hshift +=3;
  if (second() < s)
  {
    hshift = 0;
    vshift = 0;
  }
  blendMode(NORMAL);  

  
  
  //PImage photo = photos.get(0);
  //photo.mask(maskImage);
  //image(photo, 0, 0);
  //image(photo, mouseX, mouseY);
  //image(photo, mouseY, mouseX);
}

void memBox(int i, int sz, int tsz, int u, int v) //draw one side of a box
{
  //PImage photo = loadImage(str(i)+".jpeg");
  PImage photo = photos.get(0); //change
  //photo.mask(maskImage);
  textureMode(IMAGE);
  noStroke();
  beginShape();
  texture(photo);
  
  if (i == 0) //consider this the front
  {
    vertex(0, 0, 0, u, v);
    vertex(sz * 1, 0, 0, u + tsz, v);
    vertex(sz * 1, sz * 1, 0, u + tsz, v + tsz);
    vertex(0, sz * 1, 0, u, v + tsz);
  }
  else if (i == 1)  //left
  {
    vertex(sz * 1, 0, 0, u, v);
    vertex(sz * 1, 0, sz * 1, u + tsz, v);
    vertex(sz * 1, sz * 1, sz * 1, u + tsz, v + tsz);
    vertex(sz * 1, sz * 1, 0, u, v + tsz);
  }
  else if (i == 2) //then this is the back
  {
    vertex(sz * 1, 0, sz * 1, u, v);
    vertex(sz * 1, sz * 1, sz * 1, u + tsz, v);
    vertex(0, sz * 1, sz * 1, u + tsz, v + tsz);
    vertex(0, 0, sz * 1, u, v + tsz);
  }
  else if (i == 3) //right
  {
    vertex(0, 0, 0, u, v);
    vertex(0, sz * 1, 0, u + tsz, v);
    vertex(0, sz * 1, sz * 1, u + tsz, v + tsz);
    vertex(0, 0, sz * 1, u, v + tsz);
  }
  else if (i == 4) //top
  {
    vertex(0, sz * 1, 0, u, v);
    vertex(sz * 1, sz * 1, 0, u + tsz, v);
    vertex(sz * 1, sz * 1, sz * 1, u + tsz, v + tsz);
    vertex(0, sz * 1, sz * 1, u, v + tsz);
  }
  else if (i == 5) //bottom
  {
    vertex(0, 0, 0, u, v);
    vertex(sz * 1, 0, 0, u + tsz, v);
    vertex(sz * 1, 0, sz * 1, u + tsz, v + tsz);
    vertex(0, 0, sz * 1, u, v + tsz);
  }
  endShape();

}

void mouseDragged() 
{
  value = value + 1;
  if (value > 360) {
    value = 0;
  }
}

float getOpacity(int s)
{
  if(s < 30) //slowly fade in from s=0 to s=30
  {
    return (s / 30.0) * 100 * 0.8;
  }
  else if (s >= 55) //start fading out at s=55
  {
    return (-20.0 * s + 1200) * 0.8;
  }
  else //return 100 for s between 30 and 55
  {
    return 80;
  }
}
