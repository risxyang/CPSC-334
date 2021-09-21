
ChildApplet child1;
ChildApplet child2;
ChildApplet child3;
ChildApplet child4;
ChildApplet child5;

int sizeX = 768;
int sizeY = 1360;
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

  windex += 1;
  child1 = new ChildApplet();
  child2 = new ChildApplet();
  child3 = new ChildApplet();
  child4 = new ChildApplet();
  child5 = new ChildApplet();
  
  PImage currImg = imgs.get(0);
  image(currImg,0,0);
  image(currImg,0,0, currImg.width / 4, currImg.height / 4);
  
  PImage sorted = createImage(currImg.width, currImg.height, RGB);
  sorted = currImg.get();
  sorted.resize(currImg.width / 4, currImg.height / 4);
  sorted_imgs.add(sorted);
}

void draw() {
  
  //println(frameRate);
  loadPixels();
  //pixellize by 10pixel squares
  PImage si = sorted_imgs.get(0);
  si.loadPixels();
  float r_sum, g_sum, b_sum;
  float r_avg, g_avg, b_avg;
  if (y < si.height - 16){
    while(x < si.width - 16){
      //println(x,si.width);
      r_sum = g_sum = b_sum = 0.0;
      r_avg = g_avg = b_avg = 0.0;
      for (int a = x; a < x+16; a += 1)
      {
        for (int c = y; c < y+16; c+=1)
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
      
      r_avg = r_sum / 256;
      g_avg = g_sum / 256;
      b_avg = b_sum / 256;
      
      noStroke();
      fill(r_avg, g_avg, b_avg);
      rect(x, y, 16, 16);

      x += 16;
    }
      
   y += 16;
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
  
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(sizeX, sizeY);
    smooth();
  }
  public void setup() { 
    surface.setTitle("Child sketch");
    surface.setLocation(spawnX, spawnY);
    spawnX += sizeX;

    PImage currImg = imgs.get(windex);
    image(currImg,0,0);
    image(currImg,0,0, currImg.width / 4, currImg.height / 4);
    windex += 1;
    
  }

  public void draw() {
    

  }


}
