// I create a "Star" Class.
class dapple {
  // I create variables to specify the x and y of each star.
  float x;
  float y;
  float dw;
  PImage img;

  dapple(float lw, PImage dappleImg) {
    dw = lw;
    dw = 140;
    x = random(-dw*1.5, dw/2);
    y = random(-dw*1.5, dw/2);
    img = dappleImg;
    img.resize((int)random(dw-10,dw), (int)random(dw-10,dw));
  }
 

  void show() {
    
    blendMode(ADD);
    fill(100,100,0);
    noStroke();

    //ellipse(x, y, random(60,68), random(60,68));
    x += random(-2, 2);
    y += random(-2,2);
    image(img, x, y);
    
    //filter(BLUR, 10);

  }
  
  //void keyPressed() {
  //if (value == 0) {
  //  value = 255;
  //} else {
  //  value = 0;
  //}
  //}
}
