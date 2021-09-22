
//declaring the child windows -- 5 for this display
ChildApplet child1;
ChildApplet child2;
ChildApplet child3;
ChildApplet child4;
ChildApplet child5;

//window index for instantiating child applets w/ a child id
int windex = 1;

//sizeX = horizontal width of image-to-be-projected ond desktop
//sizeX = vertical height of image-to-be-projected ond desktop
int sizeX = 1360; 
int sizeY = 768;
int spawnX = 0;
int spawnY = 0;

//x and y vars for iterating thru 
int x = 0;
int y = 0;
int pid = 0;

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
  size(sizeX , sizeY);
  smooth();
  
  imgs = new ArrayList<PImage>();
  mod_imgs = new ArrayList<PImage>();
}

void setup() {
  surface.setTitle("Main sketch");
  surface.setLocation(spawnX, spawnY);
  spawnX += sizeX;
  
  //load all 6 images from the number of images available in the data folder; i am choosing from /hands/
  
  int nImages = 15;
  int starti = (int)random(0, nImages + 1);
  for(int i = starti; i < (starti + 6) % nImages + 1; i++)
  {
    PImage pi = loadImage("hand/"+str(i)+".jpeg");
    
     //filter images before adding them to imgs array list
     //pi.filter(POSTERIZE,10);
     pi.filter(GRAY);
     // pi.filter(THRESHOLD,0.5);
    imgs.add(pi);
    
    
  }
  
  //get first image 
  PImage currImg = imgs.get(pid);
  println(pid);
  image(currImg,0,0);
  image(currImg,0,0, currImg.width / 4, currImg.height / 4);
  
  PImage mod = createImage(currImg.width, currImg.height, RGB);
  mod = currImg.get();
  mod.resize(currImg.width, currImg.height);
  mod_imgs.add(mod);
  //println(windex);
  
  //instantiate child applets
  child1 = new ChildApplet();
  child2 = new ChildApplet();
  child3 = new ChildApplet();
  child4 = new ChildApplet();
  child5 = new ChildApplet();
}

void draw() {

  //create randomly sized rectangular gradients drawing values from underlying pixels
  PImage si = mod_imgs.get(pid);
  si.loadPixels();
  noStroke();
  
  //xr, yr = top left x and y coords
  //xr2, yr2 = bottom right x and y coords
  int xr = (int)random(1, sizeX);
  int yr = (int)random(1, sizeY);
  int w = (int)random(1, sizeX/8);
  int h = (int)random(1, sizeY/8);
  int xr2 = (xr + w) % sizeX;
  int yr2 = (yr + h) % sizeY;
  
  //take values
  color c1 = si.get(xr, yr);
  color c2 = si.get(xr2, yr2);
  
  setGradient(xr, yr, w, h, c1, c2, Y_AXIS);
  setGradient(xr, yr, w, h, c1, c2, X_AXIS);

  //PIXELLATION effect drawing values as averages of underlying pixels
  if (y >= si.height - (sq_width + 1))
  {
    y = 0;
  }
  //accumulate sums and divide by square areas
  float r_sum, g_sum, b_sum;
  float r_avg, g_avg, b_avg;
  
  //iterate thru all pixels in this y col and pixellate an 8x8 square
  if (y < si.height - (sq_width + 1)){
    while(x < si.width - (sq_width + 1)){
      r_sum = g_sum = b_sum = 0.0;
      r_avg = g_avg = b_avg = 0.0;
      for (int a = x; a < x + sq_width; a += 1)
      {
        for (int c = y; c < y + sq_width; c+=1)
        {
           int loc = (a + c*si.width) % (si.height * si.width);
           float r = red(si.pixels[loc]);
           float g = green(si.pixels[loc]);
           float b = blue(si.pixels[loc]);
           
           r_sum += r;
           g_sum += g;
           b_sum += b;
        }
      }
      
      //avg rgb values for this 8x8 square
      r_avg = r_sum / (sq_width * sq_width);
      g_avg = g_sum / (sq_width * sq_width);
      b_avg = b_sum / (sq_width * sq_width);
      
      noStroke();
      fill(r_avg, g_avg, b_avg);
      rect(x, y, 8, 8);
      
      //for saving these vales back into the original image -- wip
      //for (int a = x; a < x+8; a += 1)
      //{
      //  for (int c = y; c < y+8; c+=1)
      //  {
      //     int loc = a + c*si.width;
           
      //     si.pixels[loc] = color(r_avg, g_avg, b_avg);
      //     //si.loadPixels();
      //  }
      //}

      //move onto next square horizontally
      x += 8;
    }
      
   //move onto next row
   y += 8;
   x = 0;
  }
  
  //a small chance of displaying a baby copy of the original image, somewhere on the screen
  float chance = random(0, 100);
  if (chance < 5){
    image(si, random(0, sizeX), random(0,sizeY), random(10, si.width / 10), random(10, si.height / 10));
  }
  
}

//linear gradient function referenced from processing examples: https://processing.org/examples/lineargradient.html
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


class ChildApplet extends PApplet {

  PImage img;
  int cid;
  
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    
    //for retrieving images in the mod_images arraylist, handy to have a child id assoc with this child applet instance
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
    
    //spawn this window at the designated location, with the same interval of distance between each window
    surface.setLocation(spawnX, spawnY);
    spawnX += sizeX;

    //load this img from imgs arraylist
    PImage currImg = imgs.get(cid);
    image(currImg,0,0);
    image(currImg,0,0, currImg.width / 4, currImg.height / 4);
    
    //save resized version of image in mod_imgs arraylist
    PImage mod = createImage(currImg.width, currImg.height, RGB);
    mod = currImg.get();
    mod.resize(currImg.width / 4, currImg.height / 4);
    mod_imgs.add(mod);

    
  }

  public void draw() {
    
  //println(cid);
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
  color c1 = si.get(xr, yr);
  color c2 = si.get(xr2, yr2);
  
  //noStroke();
  setGradient(xr, yr, w, h, c1, c2, Y_AXIS);
  setGradient(xr, yr, w, h, c1, c2, X_AXIS);
  
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
      fill(r_avg, g_avg, b_avg);
      rect(x, y, 8, 8);
      
      x += 8;
    }
      
   y += 8;
   x = 0;
  }
  
  float chance = random(0, 100);
  if (chance < 5){
    image(si, random(0, sizeX), random(0,sizeY), random(10, si.width / 10), random(10, si.height / 10));
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
