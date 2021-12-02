// Run this program only in the Java mode inside the IDE,
// not on Processing.js (web mode)!!

import processing.video.*;

Capture cam;

void setup() {
  //size(600, 300);
  fullScreen();
  //cam = new Capture(this, displayWidth, displayHeight, 30);
  String[] dims = loadStrings("../dims");
  String[] splitDims = dims[0].split(",");
  cam = new Capture(this, parseInt(splitDims[1]), parseInt(splitDims[0]), 30);
  cam.start();
}

void draw() {
  if(cam.available()) {
    cam.read();
  }
  image(cam, 0, 0);
  cam.filter(GRAY);
  //saveFrame("currFrame.png");
  
   String[] faceCoords = loadStrings("../faceread");
  //println(faceCoords[0]);
  if(faceCoords.length >= 1 && faceCoords[0] != "")
  {
    //split string into groups of 4
    String[] splitFaceCoords = faceCoords[0].split(",");
    int[] faces = new int[splitFaceCoords.length];
    for(int i = 0; i < splitFaceCoords.length; i++)
    {
       faces[i] = parseInt(splitFaceCoords[i]);
       //println(intFaceCoords[i]);
    }
    
    int nFaces = faces[0];
    boolean isPerson = false;
    if (nFaces > 0)
    {
      isPerson = true;
    }
 
    //pixellation
    cam.loadPixels();
    int x = 0;
    int y = 0;
    int sq_width = 10;
    float r_sum, g_sum, b_sum;
    float r_avg, g_avg, b_avg;
    while (y < cam.height - (sq_width + 1)){
      while(x < cam.width - (sq_width + 1)){
        r_sum = g_sum = b_sum = 0.0;
        r_avg = g_avg = b_avg = 0.0;
        for (int a = x; a < x + sq_width; a += 1)
        {
          for (int c = y; c < y + sq_width; c+=1)
          {
             int loc = (a + c * cam.width) % (cam.height * cam.width);
             //outofbounds
             float r = 0.0;
             float g = 0.0;
             float b = 0.0;
             if(!isPerson)
             {
                r = red(cam.pixels[loc]);
               g = green(cam.pixels[loc]);
               b = blue(cam.pixels[loc]);
             }
             else
             {
                r = red(cam.pixels[loc]);
             }
             
             r_sum += r;
             g_sum += g;
             b_sum += b;
          }
        }
        
        r_avg = r_sum / (sq_width * sq_width);
        g_avg = g_sum / (sq_width * sq_width);
        b_avg = b_sum / (sq_width * sq_width);
        
        noStroke();
        
        if(random(0,1000) <= 1)
        {
          int r = (int)random(0,256);
          fill(color(r, r, r));
        }
        else
        {
          fill(r_avg, g_avg, b_avg);
        }
        rect(x, y, sq_width, sq_width);
        
        x += sq_width;
      }
        
     y += sq_width;
     x = 0;
    }
    
   //now do it again with the face area
    
    for(int j = 1; j < (4 * nFaces) + 1; j+= 4)
    {
    }

 
    for(int j = 1; j < (4 * nFaces) + 1; j+= 4)
    {
        noFill();
        strokeWeight(12);
        stroke(255,0,0);
        rect(faces[j], faces[j+1], faces[j+2], faces[j+3]);
    }
    
    }
    
  //image(cam, random(width), random(height));
}
