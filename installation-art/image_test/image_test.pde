PImage photo, maskImage;

void setup() {
  size(400, 400);
  photo = loadImage("1.jpeg");
  maskImage = loadImage("2.jpeg");
  photo.mask(maskImage);
}

void draw() {
  image(photo, 0, 0);
  image(photo, mouseX, mouseY);
  image(photo, mouseY, mouseX);
}
