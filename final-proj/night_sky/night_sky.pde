Star[] stars = new Star[800];

// I create a variable "speed", it'll be useful to control the speed of stars.
float speed;
int changeX;
int changeY;

void setup() {
  //size(600, 600);
  fullScreen();
  // I fill the array with a for loop;
  // running 800 times, it creates a new star using the Star() class.
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star();
  }
}

void draw() {
  // i link the value of the speed variable to the mouse position.
  speed = map(mouseX, 0, width, 0, 50);

  background(0);
  // I shift the entire composition,
  // moving its center from the top left corner to the center of the canvas.
  translate(width/2, height/2);
  changeX = (int)((mouseX - (displayWidth / 2)) * 0.02);
  changeY = (int)((mouseY - (displayHeight / 2)) * 0.02);
  // I draw each star, running the "update" method to update its position and
  // the "show" method to show it on the canvas.
  for (int i = 0; i < stars.length; i++) {
    stars[i].update();
    stars[i].show();
  }
  delay(50);
 
 //add borders to make this a square
 int xOffset = (displayWidth - displayHeight) / 2;
 
 fill(0,0,0);
 
  rect(-displayWidth/2, -displayHeight/2, xOffset, displayHeight);
  rect(displayWidth - xOffset - displayWidth/2, -displayHeight/2, displayWidth, displayHeight);
 
 translate(changeX, changeY);
 //rect(0, 0, xOffset, displayHeight);
 //rect(displayWidth - xOffset, 0, displayWidth, displayHeight);
 

 
}
