// I create a "Star" Class.
class Star {
  // I create variables to specify the x and y of each star.
  float x;
  float y;

  Star() {
    x = random(-displayWidth / 2, displayWidth / 2);
    y = random(-displayHeight / 2, displayHeight / 2);
  }

  void update() {
    //respawn if out of bounds
    if (x < -displayWidth/2 || x > displayWidth/2 || y < -displayHeight/2 || y > displayHeight /2) {
       x = random(-displayWidth / 2, displayWidth / 2);
        y = random(-displayHeight / 2, displayHeight / 2);
    }
  }
  
  //int getDirection() // (N=0, NE = 1, E = 2, SE = 3, S = 4, SW = 5, W = 6, NW = 7) 
  //{
  //  if
  //}

  void show() {
    fill(255);
    noStroke();

    // get the new star positions

    float sx = x - changeX;
    float sy = y - changeY;
    rect(sx, sy, random(1,3), random(1,3));
    x = sx;
    y = sy;

  }
  
  //void keyPressed() {
  //if (value == 0) {
  //  value = 255;
  //} else {
  //  value = 0;
  //}
  //}
}
