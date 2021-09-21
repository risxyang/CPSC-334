
ChildApplet child1;
ChildApplet child2;
ChildApplet child3;
ChildApplet child4;
ChildApplet child5;

int sizeX = 1360;
int sizeY = 768;
int spawnX = 0;
int spawnY = 0;
int x = 0;
int y = 0;

ArrayList<PImage> imgs;
ArrayList<PImage> sorted_imgs;

int windex = 0;
int index = 0;

void settings() {
  size(sizeX , sizeY);
  smooth();
  
  imgs = new ArrayList<PImage>();
  sorted_imgs = new ArrayList<PImage>();
}

void setup() {
  surface.setTitle("Main sketch");
  surface.setLocation(spawnX, spawnY);
  spawnX += sizeX;
  
  for(int i = 1; i <= 6; i++)
  {
    PImage pi = loadImage("hand/"+str(i)+".jpeg");
    
     //pi.filter(POSTERIZE,10);
     pi.filter(GRAY);
     // pi.filter(THRESHOLD,0.5);
    imgs.add(pi);
    
    
  }

  child1 = new ChildApplet();
  child2 = new ChildApplet();
  child3 = new ChildApplet();
  child4 = new ChildApplet();
  child5 = new ChildApplet();
  
  PImage currImg = imgs.get(windex);
  image(currImg,0,0);
  image(currImg,0,0, currImg.width / 4, currImg.height / 4);
  
  PImage sorted = createImage(currImg.width, currImg.height, RGB);
  sorted = currImg.get();
  sorted.resize(currImg.width / 4, currImg.height / 4);
  sorted_imgs.add(sorted);
  windex += 1;
  //println(windex);
}

void draw() {

  //RANDOM RECTANGLE FILL
  //pick random pixel center random width
  PImage si = sorted_imgs.get(0);
  si.loadPixels();
  noStroke();
  int xr = (int)random(1, sizeX);
  int yr = (int)random(1, sizeY);
  int w = (int)random(1, sizeX/4);
  int h = (int)random(1, sizeY/4);
  color col = si.get(xr, yr);
  fill(col);
  rect(xr, yr, w, h);
  
  //PIXELLATION
  if (y >= si.height - 8)
  {
    y = 0;
  }
  //println(frameRate);
  loadPixels();
  //pixellize by 8pixel squares
  //PImage si = sorted_imgs.get(0);
  si.loadPixels();
  float r_sum, g_sum, b_sum;
  float r_avg, g_avg, b_avg;
  if (y < si.height - 8){
    while(x < si.width - 8){
      //println(x,si.width);
      r_sum = g_sum = b_sum = 0.0;
      r_avg = g_avg = b_avg = 0.0;
      for (int a = x; a < x+8; a += 1)
      {
        for (int c = y; c < y+8; c+=1)
        {
           int loc = a + c*si.width;
           float r = red(si.pixels[loc]);
           float g = green(si.pixels[loc]);
           float b = blue(si.pixels[loc]);
           
           r_sum += r;
           g_sum += g;
           b_sum += b;
        }
      }
      
      r_avg = r_sum / 64;
      g_avg = g_sum / 64;
      b_avg = b_sum / 64;
      
      //color c = sky.get(240, 360);
      noStroke();
      fill(r_avg, g_avg, b_avg);
      rect(x, y, 8, 8);
      
      for (int a = x; a < x+8; a += 1)
      {
        for (int c = y; c < y+8; c+=1)
        {
           int loc = a + c*si.width;
           
           si.pixels[loc] = color(r_avg, g_avg, b_avg);
           //si.loadPixels();
        }
      }
      //si.updatePixels();
      //imgs.set(0,si);
      ////image(si, 0,0, si.width / 4, si.height / 4);
      //updatePixels();

      x += 8;
    }
      
   y += 8;
   x = 0;
  }
  
  //PImage si = sorted_imgs.get(0);
  //si.loadPixels();

  //si.updatePixels();
  //sorted_imgs.set(0,si);
  //image(si, 0,0, si.width / 4, si.height / 4);
  //updatePixels();
  
}


class ChildApplet extends PApplet {

  PImage img;
  int cid;
  
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    
    cid = windex;
    println(cid, windex);
    windex += 1;
  }

  public void settings() {
    size(sizeX, sizeY);
    smooth();
  }
  public void setup() { 
    surface.setTitle("Child sketch");
    surface.setLocation(spawnX, spawnY);
    spawnX += sizeX;

    PImage currImg = imgs.get(cid);
    image(currImg,0,0);
    image(currImg,0,0, currImg.width / 4, currImg.height / 4);
    PImage sorted = createImage(currImg.width, currImg.height, RGB);
    sorted = currImg.get();
    sorted.resize(currImg.width / 4, currImg.height / 4);
    sorted_imgs.add(sorted);
    //println(sorted_imgs.size(), cid);

    
  }

  public void draw() {
    //PImage si = sorted_imgs.get(cid);
    //image(si,0,0, si.width / 4, si.height / 4);
    //si.loadPixels();
    //loadPixels();
    //// Loop through every pixel
    //for (int i = 0; i < si.pixels.length; i++) {
    //  // Pick a random number, 0 to 255
    //  float rand = random(255);
    //  // Create a grayscale color based on random number
    //  color c = color(rand);
    //  // Set pixel at that location to random color
    //  si.pixels[i] = c;
    //}
    //// When we are finished dealing with pixels
    //si.updatePixels();
    //sorted_imgs.set(cid,si);
    
    //RANDOM RECTANGLE FILL
  //pick random pixel center random width
  PImage si = sorted_imgs.get(cid);
  //println(cid);
  si.loadPixels();
  noStroke();
  int xr = (int)random(1, sizeX);
  int yr = (int)random(1, sizeY);
  int w = (int)random(1, sizeX/4);
  int h = (int)random(1, sizeY/4);
  color col = si.get(xr, yr);
  fill(col);
  rect(xr, yr, w, h);
  
  //PIXELLATION
  if (y >= si.height - 8)
  {
    y = 0;
  }
  //println(frameRate);
  loadPixels();
  //pixellize by 8pixel squares
  //PImage si = sorted_imgs.get(0);
  si.loadPixels();
  float r_sum, g_sum, b_sum;
  float r_avg, g_avg, b_avg;
  if (y < si.height - 8){
    while(x < si.width - 8){
      //println(x,si.width);
      r_sum = g_sum = b_sum = 0.0;
      r_avg = g_avg = b_avg = 0.0;
      for (int a = x; a < x+8; a += 1)
      {
        for (int c = y; c < y+8; c+=1)
        {
           int loc = a + c*si.width;
           float r = red(si.pixels[loc]);
           float g = green(si.pixels[loc]);
           float b = blue(si.pixels[loc]);
           
           r_sum += r;
           g_sum += g;
           b_sum += b;
        }
      }
      
      r_avg = r_sum / 64;
      g_avg = g_sum / 64;
      b_avg = b_sum / 64;
      
      //color c = sky.get(240, 360);
      noStroke();
      fill(r_avg, g_avg, b_avg);
      rect(x, y, 8, 8);
      
      for (int a = x; a < x+8; a += 1)
      {
        for (int c = y; c < y+8; c+=1)
        {
           int loc = a + c*si.width;
           
           si.pixels[loc] = color(r_avg, g_avg, b_avg);
           //si.loadPixels();
        }
      }
      //si.updatePixels();
      //imgs.set(0,si);
      ////image(si, 0,0, si.width / 4, si.height / 4);
      //updatePixels();

      x += 8;
    }
      
   y += 8;
   x = 0;
  }
  

  }


}
