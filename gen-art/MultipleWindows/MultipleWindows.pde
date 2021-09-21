// Based on code by GeneKao (https://github.com/GeneKao)

ChildApplet child1;
ChildApplet child2;
ChildApplet child3;
ChildApplet child4;
ChildApplet child5;

int sizeX = 768;
int sizeY = 1360;
int spawnX = 0;
int spawnY = 0;

ArrayList<PImage> imgs;


Window[] windows = new Window[6];
int windex = 0;

void settings() {
  size(sizeX , sizeY);
  smooth();
  
  imgs = new ArrayList<PImage>();
}

void setup() {
  surface.setTitle("Main sketch");
  surface.setLocation(spawnX, spawnY);
  spawnX += sizeX;
  
  for(int i = 1; i <= 6; i++)
  {
    PImage pi = loadImage("hand/"+str(i)+".jpeg");
    pi.filter(GRAY);
    imgs.add(pi);
    
  }

  windows[windex] = new Window(this);
  windex += 1;
  child1 = new ChildApplet();
  child2 = new ChildApplet();
  child3 = new ChildApplet();
  child4 = new ChildApplet();
  child5 = new ChildApplet();
  
  PImage currImg = imgs.get(0);
  image(currImg,0,0);
  image(currImg,0,0, currImg.width / 4, currImg.height / 4);
}

void draw() {
  

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
    windows[windex] = new Window(this);
    windex += 1;
    
  }

  public void draw() {
    

  }


}
