// Based on code by GeneKao (https://github.com/GeneKao)

ChildApplet child1;
ChildApplet child2;
ChildApplet child3;
ChildApplet child4;
ChildApplet child5;
//Arcball arcball, arcball2;  

void settings() {
  size(800 , 1200);
  smooth();
}

void setup() {
  surface.setTitle("Main sketch");
  surface.setResizable(true);
  surface.setLocation(0, 0);
  //arcball = new Arcball(this);
  child1 = new ChildApplet();
  child2 = new ChildApplet();
  child3 = new ChildApplet();
  child4 = new ChildApplet();
  child5 = new ChildApplet();
}

void draw() {
   arcball.run();

}


class ChildApplet extends PApplet {
  //JFrame frame;

  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(800, 1200);
    smooth();
  }
  public void setup() { 
    surface.setTitle("Child sketch");
    //arcball2 = new Arcball(this);
  }

  public void draw() {
    //arcball2.run();
    background(0);

  }


}
