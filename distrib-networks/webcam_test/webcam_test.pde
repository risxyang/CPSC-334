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
    
    int i = 1;
    for(int j = 1; j < (4 * nFaces) + 1; j+= 4)
    {
        noFill();
        strokeWeight(16);
        rect(faces[j], faces[j+1], faces[j+2], faces[j+3]);
    }
    
  }
  
  //image(cam, random(width), random(height));
}
