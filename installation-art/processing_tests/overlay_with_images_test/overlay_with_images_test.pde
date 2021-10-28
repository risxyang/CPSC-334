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

//box side size
int sz;

void setup() {

    size(600, 600, P3D);
    
    photos = new ArrayList<PImage>();
    
    //starting box side size
    sz = 300;
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
    ytrans = 0;
    
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
  
  int tsz = 50; //texture size (length and width)
  
  translate(xtrans, ytrans, 0);


  if (millis() > ms + 5000) //every 5 seconds, reset cube drawing, light size
  {
    //restart timer
    ms = millis();
    
    hshift = 0;
    vshift = 0;
    xtrans =(int)random(100, 350);
    //ytrans =(int)random(0, 100);
    //ytrans = 0;
       
    h = (int)random(50, 250);
    w = (int)random(50, 250);
    o = (int)random(10, 50); // offset; can change
    g = (int)random(10, 50); // gap
    nRows = (int)random(1, 6);
    nCols = (int)random(1, 6);
    
    b = (int)random(2,8);
    rot = random(0, 360);
    rotateY(rot);
    
    u = (int)random(1, photos.get(0).width - sz);
    v = (int)random(1, photos.get(0).height - sz);
    
    sz = (int)random(400, 700); //box side size
      
    blendMode(MULTIPLY);
    //photo = photos.get(iter);
    photo.mask(maskImage);
    image(photo, 0, 0); //!
    
    
    iter = (iter + 1) % 6;
  } //end condition
  
      blendMode(NORMAL);
      rotateY(rot);
      
      float shiftFactor = 20.0;
      int yShift = (int)(sin(PI * 2.0 * ((s % 60.0) / 60.0)) * shiftFactor);
       
      image(photo, 0, yShift); //!
      memBox(iter, sz, tsz, u, v, false);
      memBox(iter, sz, tsz, u, v, true);
  
   if (keyPressed == true) {
    
      pg.beginDraw();
      pg.clear(); //remove whatever was previously in the buffer
      
      for(int i = 0; i < nRows; i++)
      {
        for (int j = 0; j < nCols; j++)
        {
          
          //a single pane
          pg.beginShape();
          pg.noStroke();
          color c = lerpColor(light, dark, (s / 59.0));  
          pg.fill(c, getOpacity(s));
          float xOffset = j * (o+w+g) + hshift;
          float yOffset = i * (h + g) + vshift;
          float rowIndent = i * o;
          pg.vertex(0 + xOffset + rowIndent, 0 + yOffset);
          pg.vertex(w + xOffset + rowIndent, 0 + yOffset);
          pg.vertex(w+o + xOffset + rowIndent, h + yOffset);
          pg.vertex(o + xOffset + rowIndent, h + yOffset);
          pg.endShape();
          
        }
      }
      
      pg.filter(BLUR, b);
      pg.endDraw();
      
      blendMode(ADD); //for drawing the moving light, use add blend mode
      rotateZ(radians(PI * 2.0 * (s/60.0)));
      image(pg, 0, 0); 
      
      //shift position of light for next draw()
      vshift +=2;
      hshift +=3;
      
      //reset h/v shifts at new minute mark
      if (second() < s)
      {
        hshift = 0;
        vshift = 0;
      }
      
      //set blendmode back to normal
      blendMode(NORMAL);  
   }
}

void memBox(int i, int sz, int tsz, int u, int v, boolean mask) //draw one side of a box
{
  //PImage photo = loadImage(str(i)+".jpeg");
  PImage photo = photos.get(0); //change
  
  if(mask == true)
  {
    photo.mask(maskImage);
    blendMode(NORMAL);
  }
  else
  {
    blendMode(MULTIPLY);
  }
  
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
  
  //if(mask == false)
  //{
  //    memBox(i, sz, tsz, u, v, true);
  //}

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
