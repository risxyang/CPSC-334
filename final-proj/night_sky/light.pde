class light
{
  float lx;
  float ly;
  float w;
  color c;
  int r;
  int g;
  int b;
  dapple[] dapples = new dapple[30];
  
  PImage dappleImg = loadImage("bokeh.png");
  
  light()
  {
    w = (displayHeight / 3);
    lx = -w/2;
    ly = -w/2;
    r = 20;
    g = 50;
    b = 70;
    
    for (int i = 0; i < dapples.length; i++) {
      dapples[i] = new dapple(w, dappleImg);
    }
  }
  
  void update()
  {
    //int cOffset = (int)((s/59.0) * 255);
    //r += changeX;
    //g += changeX;
    //b += changeY + changeX;
    c = color(r,g,b);
    
  }
  
  void show()
  {
    fill(c);
    rect(lx, ly, w, w);
    for (int i = 0; i < dapples.length; i++) {
    dapples[i].show();
  }
  
  blendMode(NORMAL);
  
  //draw border
  int xOffset = (int)((displayWidth - w) / 2);
  int yOffset = (int)((displayHeight - w) / 2);
  fill(0,0,0);
  rect(-displayWidth/2, -displayHeight/2, xOffset, displayHeight);
  rect(displayWidth - xOffset - displayWidth/2, -displayHeight/2, displayWidth, displayHeight);
  rect(-displayWidth/2, -displayHeight/2, displayWidth, yOffset);
  rect(-displayWidth/2, displayHeight/2 - yOffset, displayWidth, displayHeight); 
  
  }
 
  
}
