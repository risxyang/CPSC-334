//float theta;
 int currX = width / 2;
 int currY = height / 2;
 
 //an off-screen graphics buffer
PGraphics pg;

 
void setup() {
  size(800, 600);
  pg = createGraphics(width, height);
}
 
void draw() {
  //background(255);
//Pick an angle according to the mouse location.
  //theta = map(mouseX,0,width,0,PI/2);
 
//The first branch starts at the bottom of the window.
  noFill();
  int randOffset = (int)random(10,20);
  currX += randOffset;
  currY += randOffset;
  translate(currX + randOffset, currY + randOffset);
  rotate(radians((int)random(0,30)));
  drawLeaf();
  stroke(0);
  
 
}



//https://openprocessing.org/sketch/7743/#
void drawLeaf(){ // draw a leaf as follows
  //background(255);
  //fill(50,200,180);
  //noStroke();
  float pointShift = random(-5,5); // here is a variable between -20 and 20 
  //circle(40 + pointShift/2, 45, 50);
  //filter(BLUR, 10);
  
  stroke(3);
 
  pg.beginDraw();
  pg.beginShape(); // start to draw a shape
   //pg.noFill();
  pg.fill(90,150,100);
  pg.vertex(20, 45); // begin at this point x, y
  // bezierVertex(30,30,60,40,70 + random(-20,20),50); // moving only the pointy point meant that sometimes the leaf shape would turn into a heart shape, because the control points were not also moving. So I created a variable called pointShift
    pg.bezierVertex(30,30, 60 + pointShift,40 + pointShift/2, 70 + pointShift,50); // make the pointy end of the leaf vary on the x axis (so the leaf gets longer or shorter) AND vary the y axis of the control points by the same amount. It should be possible to have 'normal' leaves, very short fat ones and very long thin ones.
    pg.bezierVertex(60 + pointShift,55, 30,65, 20,45); // draw the other half of the shape
  pg.endShape();
  pg.line(20, 45, 40 + pointShift/2, 45);
  pg.endDraw();
  
  image(pg, 0, 0); 

}
