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

//Arcball arcball, arcball2;  

void settings() {
  size(sizeX , sizeY);
  smooth();
}

void setup() {
  surface.setTitle("Main sketch");
  surface.setLocation(spawnX, spawnY);
  spawnX += sizeX;
  
  //arcball = new Arcball(this);
  child1 = new ChildApplet();
  child2 = new ChildApplet();
  child3 = new ChildApplet();
  child4 = new ChildApplet();
  child5 = new ChildApplet();
}

void draw() {
   //arcball.run();

}


class ChildApplet extends PApplet {
  //JFrame frame;

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
    //arcball2 = new Arcball(this);
  }

  public void draw() {
    //arcball2.run();
    background(0);

  }


}
