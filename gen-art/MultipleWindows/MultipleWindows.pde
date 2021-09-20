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

Window[] windows = new Window[6];
int windex = 0;
PImage img0; 

void settings() {
  size(sizeX , sizeY);
  smooth();
}

void setup() {
  surface.setTitle("Main sketch");
  surface.setLocation(spawnX, spawnY);
  spawnX += sizeX;
  img0 = loadImage("hand/"+str(1)+".jpeg");
  image(img0,0,0);
  
  windows[windex] = new Window(this);
  windex += 1;
  child1 = new ChildApplet();
  child2 = new ChildApplet();
  child3 = new ChildApplet();
  child4 = new ChildApplet();
  child5 = new ChildApplet();
}

void draw() {
   //arcball.run();
   image(img0, 0, height/5, img0.width/5, img0.height/5);
   

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
    //img = loadImage("hand/"+str(2)+".jpeg");
    //image(img,0,0);
    windows[windex] = new Window(this);
    windex += 1;
    
  }

  public void draw() {
    //arcball2.run();
    //background(0);
    for(int i = 10; i < width; i += 10) {
  // If 'i' divides by 20 with no remainder draw 
  // the first line, else draw the second line
  if((i % 20) == 0) {
    stroke(255);
    line(i, 80, i, height/2);
  } else {
    stroke(153);
    line(i, 20, i, 180); 
  }
}
    

  }


}
