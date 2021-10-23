PImage photo, maskImage;
ArrayList<PImage> photos;
int iter = 0;

void setup() {
  //size(400, 400);
  photos = new ArrayList<PImage>();
  
  size(600, 600, P3D);
  
   for(int i = 1; i <= 6; i++)
   {
    PImage pi = loadImage(str(i)+".jpeg");
    photos.add(pi);
  }
   
  //photo = loadImage("1.jpeg");
  maskImage = loadImage("mask.jpeg");
  //photo.mask(maskImage);
  //  image(photo, 0, 0);
}


void draw() {
  //background(0);
  int sz = 300;
  rotateY(mouseY);
  translate(200, 200, 0); 
  memBox(iter, sz);
  iter += 1;
  if (iter >= 6)
  {
    iter = 0;
  }
  PImage photo = photos.get(0);
  photo.mask(maskImage);
  image(photo, 0, 0);
  //image(photo, mouseX, mouseY);
  //image(photo, mouseY, mouseX);
}

void memBox(int i, int sz) //draw one side of a box
{
  //PImage photo = loadImage(str(i)+".jpeg");
  PImage photo = photos.get(0); //change
  //photo.mask(maskImage);
  texture(photo);
  noStroke();
  beginShape();
  texture(photo);
  
  if (i == 0) //consider this the front
  {
    vertex(0, 0, 0, 0, 0);
    vertex(sz * 1, 0, 0, 100, 0);
    vertex(sz * 1, sz * 1, 0, 100, 100);
    vertex(0, sz * 1, 0, 0, 100);
  }
  else if (i == 1)  //left
  {
    vertex(sz * 1, 0, 0, 0, 0);
    vertex(sz * 1, 0, sz * 1, 100, 0);
    vertex(sz * 1, sz * 1, sz * 1, 100, 100);
    vertex(sz * 1, sz * 1, 0, 0, 100);
  }
  else if (i == 2) //then this is the back
  {
    vertex(sz * 1, 0, sz * 1, 0, 0);
    vertex(sz * 1, sz * 1, sz * 1, 100, 0);
    vertex(0, sz * 1, sz * 1, 100, 100);
    vertex(0, 0, sz * 1, 0, 100);
  }
  else if (i == 3) //right
  {
    vertex(0, 0, 0, 0, 0);
    vertex(0, sz * 1, 0, 100, 0);
    vertex(0, sz * 1, sz * 1, 100, 100);
    vertex(0, 0, sz * 1, 0, 100);
  }
  else if (i == 4) //top
  {
    vertex(0, sz * 1, 0, 0, 0);
    vertex(sz * 1, sz * 1, 0, 100, 0);
    vertex(sz * 1, sz * 1, sz * 1, 100, 100);
    vertex(0, sz * 1, sz * 1, 0, 100);
  }
  else if (i == 5) //bottom
  {
    vertex(0, 0, 0, 0, 0);
    vertex(sz * 1, 0, 0, 100, 0);
    vertex(sz * 1, 0, sz * 1, 100, 100);
    vertex(0, 0, sz * 1, 0, 100);
  }
  endShape();

}
