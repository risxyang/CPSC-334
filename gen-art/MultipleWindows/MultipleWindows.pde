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

int pointillize = 90;

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
    imgs.add(loadImage("hand/"+str(i)+".jpeg"));
  }

  windows[windex] = new Window(this);
  windex += 1;
  child1 = new ChildApplet();
  child2 = new ChildApplet();
  child3 = new ChildApplet();
  child4 = new ChildApplet();
  child5 = new ChildApplet();
  
  image(imgs.get(0),0,0, sizeX, sizeY);
}

void draw() {
  
  
  
   //arcball.run();
  
   
  //// Before we deal with pixels
  //loadPixels();
  // int x = int(random(img.width));
  //int y = int(random(img.height));
  //int loc = x + y*img.width;

  //// Look up the RGB color in the source image
  //loadPixels();
  //float r = red(img.pixels[loc]);
  //float g = green(img.pixels[loc]);
  //float b = blue(img.pixels[loc]);
  //noStroke();

  //// Draw an ellipse at that location with that color
  //fill(r,g,b,100);
  //ellipse(x,y,pointillize,pointillize);
  
   

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
    image(imgs.get(windex),0,0);
    windows[windex] = new Window(this);
    windex += 1;
    
  }

  public void draw() {
    
    
    
//    //arcball2.run();
//    //background(0);
//    for(int i = 10; i < width; i += 10) {
//  // If 'i' divides by 20 with no remainder draw 
//  // the first line, else draw the second line
//  if((i % 20) == 0) {
//    stroke(255);
//    line(i, 80, i, height/2);
//  } else {
//    stroke(153);
//    line(i, 20, i, 180); 
//  }
//}
    

  }


}
