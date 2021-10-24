//to store jpeg images from the project data folder
ArrayList<PImage> photos;

//values [0,5], corresponding to the current face of the cube being drawn
int iter = 0;

//u,v values for applying texture to cube faces. can be randomized every # of calls to draw
int u, v;

//vars which shape the moving light geomtry, number of panes, etc
//h = height of single pane
//w = width of single pane
//o = offset that makes this pane a parallelogram (the larger, the more slanted the pane)
//nRows, nCols = number of rows and columns of panes
int h, w, o, g, nRows, nCols; //for controlling geometry

//hshift and vshift keep track of light shift over successive calls to draw. change with time and are updated in each call to draw()
int hshift, vshift; 

//keep track of current translation for cube side and light panes
int xtrans, ytrans; 

//global vars for storing most recently measured time in seconds (s) and milliseconds (ms)
int s; //for measuring time
int ms;

//start and end values for interpolating the color at any given time
color light, dark;

//an off-screen graphics buffer. allows blurring of certain effects separate from others
PGraphics pg;

//global var for keeping track of current rotation (for light, and cube side)
float rot;

//current blur amount, randomized for each moving light generated
int b;

//for testing purposes, a base photo image 
//maskImage = image used for masking onto photo, or images from photos array
PImage photo, maskImage;

void setup() {

    size(600, 600, P3D);
    
    photos = new ArrayList<PImage>();
    
    //initialize first set of moving panes
    h = 140;
    w = 100;
    o = 30; // offset; can change
    g = 15; // gap
    nRows = 4;
    nCols = 4;
    
    hshift = 0;
    vshift = 0;
    
    xtrans = 200;
    ytrans = 200;
    
    b = 4; //blur
    
    light = color(255, 255, 150);
    dark = color(250, 120, 10);
    
  //store all jpegs in data folder
   for(int i = 1; i <= 6; i++)
   {
      PImage pi = loadImage(str(i)+".jpeg");
      photos.add(pi);
    }
   
  //load in mask
  maskImage = loadImage("mask.jpeg");
  
  //for testing
  photo = loadImage("1.jpeg");
  
  //photo.mask(maskImage);
  
  //display base photo
  image(photo, 0, 0);
  
  
  pg = createGraphics(600, 600);
  ms = millis(); //store start time in MS
}


void draw() {
  //background(0);

  //get the current time (seconds, values 0 to 59)
  s = second();
  
  int sz = 300; //box side size
  int tsz = 50; //texture size (length and width)

  //translate(200, 200, 0);
  //translate((int)random(150, 300), (int)random(150,300));
  translate(xtrans, ytrans, 0);

  //if (keyPressed) {
  //  if (key == 'b' || key == 'B') {
  //    image(photo, 0, 0);
  //    u = (int)random(1, photos.get(0).width - sz);
  //    v = (int)random(1, photos.get(0).height - sz);
  //    u = 0;
  //    v = 0;
  //  }
  //}

  if (millis() > ms + 5000)
  {
    //println("yeet");
        ms = millis();
    
       hshift = 0;
       vshift = 0;
       xtrans =(int)random(50, 300);
       ytrans =(int)random(50, 300);
       
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


  
  blendMode(NORMAL);
  photo.mask(maskImage);
  image(photo, 0, 0);
  }
  
  blendMode(NORMAL);
  rotateY(rot);
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
  //rotateY(rot); //?
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

float getOpacity(int s)
{
  if(s < 30) //slowly fade in from s=0 to s=30
  {
    return (s / 30.0) * 100 * 0.6;
  }
  else if (s >= 55) //start fading out at s=55
  {
    return (-20.0 * s + 1200) * 0.6;
  }
  else //return 100 for s between 30 and 55
  {
    return 60;
  }
}
