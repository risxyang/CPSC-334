PImage earth; 
PShape globe;

void setup() { 
  size(600, 600, P3D); 
  background(0); 
  //String http = "http://";
  earth = loadImage("akw1.jpg");
  globe = createShape(SPHERE, 1000); 
  globe.setTexture(earth);
  noStroke();
}

void draw() { 
  translate(width/2, height/2); 
  rotateX(second()/30);
  rotateY(second()/30);
  noStroke();
  shape(globe);
}
