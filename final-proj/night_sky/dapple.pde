// I create a "Star" Class.
class dapple {
  // I create variables to specify the x and y of each star.
  float x;
  float y;
  float dw;

  dapple(float lw) {
    dw = lw;
    x = random(-dw/2, dw/2);
    y = random(-dw/2, dw/2);
  }

  void show() {
    
    blendMode(ADD);
    fill(100,100,0);
    noStroke();

    ellipse(x, y, random(60,68), random(60,68));
    
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
