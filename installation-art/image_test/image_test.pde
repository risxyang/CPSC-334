PImage photo, maskImage;
ArrayList<PImage> photos;
int iter = 0;
int value; //test mouseDragged 
int u, v;

void setup() {
  //size(400, 400);
  photos = new ArrayList<PImage>();
  
  size(600, 600, P3D);
  
   for(int i = 1; i <= 6; i++)
   {
    PImage pi = loadImage(str(i)+".jpeg");
    photos.add(pi);
  }
   
  photo = loadImage("1.jpeg");
  maskImage = loadImage("mask.jpeg");
  //photo.mask(maskImage);
    image(photo, 0, 0);
}


void draw() {
  //background(0);
  int sz = 300;
  int tsz = 50;
  rotateY(mouseY);
  //rotateX(mouseX);
  translate(200, 200, 0);

  if (keyPressed) {
    if (key == 'b' || key == 'B') {
      image(photo, 0, 0);
      u = (int)random(1, photos.get(0).width - sz);
      v = (int)random(1, photos.get(0).height - sz);
    }
  }
  //for (int j = 0; j < 6; j++)
  //{
  //  memBox(j, sz, tsz, u, v);
  //}
  
  //sep sides
  memBox(iter, sz, tsz, u, v);
  iter += 1;
  if (iter >= 6)
  {
    iter = 0;
  }
  
  
  //PImage photo = photos.get(0);
  //photo.mask(maskImage);
  //image(photo, 0, 0);
  //image(photo, mouseX, mouseY);
  //image(photo, mouseY, mouseX);
}

void memBox(int i, int sz, int tsz, int u, int v) //draw one side of a box
{
  //PImage photo = loadImage(str(i)+".jpeg");
  PImage photo = photos.get(0); //change
  photo.mask(maskImage);
  textureMode(IMAGE);
  noStroke();
  beginShape();
  texture(maskImage);
  
  if (i == 0) //consider this the front
  {
    vertex(0, 0, 0, u, v);
    vertex(sz * 1, 0, 0, u + tsz, v);
    vertex(sz * 1, sz * 1, 0, u + tsz, v + tsz);
    vertex(0, sz * 1, 0, u, v + tsz);
  }
  else if (i == 1)  //left
  {
    vertex(sz * 1, 0, 0, u, v);
    vertex(sz * 1, 0, sz * 1, u + tsz, v);
    vertex(sz * 1, sz * 1, sz * 1, u + tsz, v + tsz);
    vertex(sz * 1, sz * 1, 0, u, v + tsz);
  }
  else if (i == 2) //then this is the back
  {
    vertex(sz * 1, 0, sz * 1, u, v);
    vertex(sz * 1, sz * 1, sz * 1, u + tsz, v);
    vertex(0, sz * 1, sz * 1, u + tsz, v + tsz);
    vertex(0, 0, sz * 1, u, v + tsz);
  }
  else if (i == 3) //right
  {
    vertex(0, 0, 0, u, v);
    vertex(0, sz * 1, 0, u + tsz, v);
    vertex(0, sz * 1, sz * 1, u + tsz, v + tsz);
    vertex(0, 0, sz * 1, u, v + tsz);
  }
  else if (i == 4) //top
  {
    vertex(0, sz * 1, 0, u, v);
    vertex(sz * 1, sz * 1, 0, u + tsz, v);
    vertex(sz * 1, sz * 1, sz * 1, u + tsz, v + tsz);
    vertex(0, sz * 1, sz * 1, u, v + tsz);
  }
  else if (i == 5) //bottom
  {
    vertex(0, 0, 0, u, v);
    vertex(sz * 1, 0, 0, u + tsz, v);
    vertex(sz * 1, 0, sz * 1, u + tsz, v + tsz);
    vertex(0, 0, sz * 1, u, v + tsz);
  }
  endShape();

}

void mouseDragged() 
{
  value = value + 1;
  if (value > 360) {
    value = 0;
  }
}
