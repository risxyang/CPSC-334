
//declaring the child windows -- 6 for this display
ChildApplet child1;
ChildApplet child2;
ChildApplet child3;
ChildApplet child4;
ChildApplet child5;
ChildApplet child6;

//window index for instantiating child applets w/ a child id
int windex = 0;

//sizeX = horizontal width of image-to-be-projected ond desktop
//sizeX = vertical height of image-to-be-projected ond desktop
int sizeX = 1360; 
int sizeY = 768;

//vars to hold current spawn locations for windows as they are created
int spawnX = 0;
int spawnY = 0;

//start location of the first window (after first desktop monitor)
int startX = 1024;



 //x and y vars for iterating thru rows/cols
 int x = 0;
 int y = 0;



//array list for holding loaded images (length 6 after all images are loaded)
ArrayList<PImage> imgs;

//array list for holding modified images
ArrayList<PImage> mod_imgs;

//square width for each pixel segment in pixellation stage`
int sq_width = 8;


int index = 0;

//axis declarations for setting up gradient directions 
int Y_AXIS = 1;
int X_AXIS = 2;

void settings() {
  //size(sizeX , sizeY);
  smooth();
  
  imgs = new ArrayList<PImage>();
  mod_imgs = new ArrayList<PImage>();
}

void setup() {
  //load all 6 images from the number of images available in the data folder; i am choosing from /hands/
  
  int nImages = 14;
  int starti = (int)random(0, nImages + 1);
  for(int i = starti; i < (starti + 6) % nImages + 1; i++)
  {
    PImage pi = loadImage("hand/"+str(i)+".jpeg");
    
     //filter images before adding them to imgs array list
     //pi.filter(POSTERIZE,3);
     pi.filter(GRAY);
     // pi.filter(THRESHOLD,0.5);
    imgs.add(pi);
  }
  
  //instantiate child applets
  child1 = new ChildApplet();
  child2 = new ChildApplet();
  child3 = new ChildApplet();
  child4 = new ChildApplet();
  child5 = new ChildApplet();
  child6 = new ChildApplet();
}

void draw() {

  
}


class ChildApplet extends PApplet {

  //vars for holding this child applet's loaded image, child applet ID
  PImage img;
  int cid = 0;
  
  ////x and y vars for iterating thru rows/cols
  //int x = 0;
  //int y = 0;
  
  //int var to hold the y value at which the small background image begins
  int xStartSmall;
  
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    
    //for retrieving images in the mod_images arraylist, handy to have a child id assoc with this child applet instance
    cid = windex;
    windex += 1;
  }

  public void settings() {
    size(sizeX, sizeY);
    smooth();
  }
  public void setup() { 
    surface.setTitle("Child sketch");
    
    //spawn this window at the designated location, with the same interval of distance between each window
    surface.setLocation(spawnX + startX, spawnY);
    spawnX += sizeX;

    //load this img from imgs arraylist
    //println(cid);
    PImage currImg = imgs.get(cid);
    
    xStartSmall = (int)random(0, sizeX / 3);
    image(currImg,0,0);
    image(currImg,xStartSmall,0, currImg.width / 4, currImg.height / 4);
    
    //save resized version of image in mod_imgs arraylist
    PImage mod = createImage(currImg.width, currImg.height, RGB);
    mod = currImg.get();
    mod.resize(currImg.width / 4, currImg.height / 4);
    mod_imgs.add(mod);

    
  }

  public void draw() {
    
  println(cid);
  PImage si = mod_imgs.get(cid);

  si.loadPixels();
  noStroke();
  
  //same as parent -- set up random gradients
  int xr = (int)random(1, sizeX);
  int yr = (int)random(1, sizeY);
  int w = (int)random(1, sizeX/8);
  int h = (int)random(1, sizeY/8);
  int xr2 = (xr + w) % sizeX;
  int yr2 = (yr + h) % sizeY;
  color c1 = si.get(xr + xStartSmall, yr);
  color c2 = si.get(xr2 + xStartSmall, yr2);
  
  //noStroke();
  if(random(0,2) == 0) { 
  setGradient(xr + xStartSmall, yr, w, h, c1, c2, Y_AXIS); 
  }
  else
  {
  setGradient(xr + xStartSmall, yr, w, h, c1, c2, X_AXIS);
  }
  
  //PIXELLATION
  if (y >= si.height - 8)
  {
    y = 0;
  }
  //println(frameRate);
  loadPixels();
  si.loadPixels();
  float r_sum, g_sum, b_sum;
  float r_avg, g_avg, b_avg;
  if (y < si.height - (sq_width + 1)){
    while(x < si.width - (sq_width + 1)){
      r_sum = g_sum = b_sum = 0.0;
      r_avg = g_avg = b_avg = 0.0;
      for (int a = x; a < x + sq_width; a += 1)
      {
        for (int c = y; c < y + sq_width; c+=1)
        {
           int loc = (a + c * si.width) % (si.height * si.width);
           //outofbounds
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
      
      noStroke();
      
      if(random(0,1000) <= 1)
      {
        int r = (int)random(0,256);
        fill(color(r, r, r));
      }
      else
      {
        fill(r_avg, g_avg, b_avg);
      }
      rect(x + xStartSmall, y, 8, 8);
      
      x += 8;
    }
      
   y += 8;
   x = 0;
  }
  
  float chance = random(0, 100);
  if (chance < 5){
    image(si, random(0, sizeX), random(0,sizeY), random(10, si.width / 10), random(10, si.height / 10));
    rotate(0.2);  
  }
  

  }

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}

}
