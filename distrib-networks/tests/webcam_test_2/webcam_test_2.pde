import processing.sound.*;

// Run this program only in the Java mode inside the IDE,
// not on Processing.js (web mode)!!

import processing.video.*;

AudioIn input;
Amplitude analyzer;

Capture cam;

void setup() {
  //size(600, 300);
  fullScreen();
  //cam = new Capture(this, displayWidth, displayHeight, 30);
  String[] dims = loadStrings("../dims");
  String[] splitDims = dims[0].split(",");
  cam = new Capture(this, parseInt(splitDims[1]), parseInt(splitDims[0]), 30);
  cam.start();
  
   // Start listening to the microphone
  // Create an Audio input and grab the 1st channel
  input = new AudioIn(this, 0);

  // start the Audio Input
  input.start();

  // create a new Amplitude analyzer
  analyzer = new Amplitude(this);

  // Patch the input to an volume analyzer
  analyzer.input(input);
}

void draw() {
  //PImage curr = get();
  //curr.resize(displayWidth * 2, displayHeight * 2);
  //image(curr, -displayWidth,-displayHeight);
  background(0);
  if(cam.available()) {
    cam.read();
  }
  float vol = analyzer.analyze();
  //background(0);
  int offsetX = (displayWidth - cam.width) / 2;
  int offsetY = (displayHeight - cam.height) / 2;
  cam.filter(GRAY);
  image(cam, offsetX, offsetY);
  //cam.resize(displayWidth, displayHeight);
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
    //fill(color(0,0,0));
    //rect(0,0,displayWidth, displayHeight); 
    //pixellation
    cam.loadPixels();
    int x = 0;
    int y = 0;
    int sq_width = 10;
    float r_sum, g_sum, b_sum;
    float r_avg, g_avg, b_avg;
    while (y < cam.height - (sq_width + 1)){
      while(x < cam.width - (sq_width + 1)){
        //randomize squares 10+vol*200, 10+vol*200
        
        //VERSION 1
        //sq_width = (int)random(5, 30);
        
        //VERSION 2
        sq_width = (int)random(10+vol*300, 10+vol*300);
        r_sum = g_sum = b_sum = 0.0;
        r_avg = g_avg = b_avg = 0.0;
        for (int a = x; a < x + sq_width; a += 1)
        {
          for (int c = y; c < y + sq_width; c+=1)
          {
             int loc = (a + c * cam.width) % (cam.height * cam.width);

  
               float r = red(cam.pixels[loc]);
               float g = green(cam.pixels[loc]);
               float b = blue(cam.pixels[loc]);
             
             r_sum += r;
             g_sum += g;
             b_sum += b;
          }
        }
        
        r_avg = r_sum / (sq_width * sq_width);
        g_avg = g_sum / (sq_width * sq_width);
        b_avg = b_sum / (sq_width * sq_width);
        
        noStroke();

        if(random(0,1000) <= (int)random(0, (10+vol*300) * (vol * 300)))
        {
          //int r = (int)random(0,256);
          fill(color(0, 255, 255));
        }
        else
        {
          fill(r_avg, (g_avg + x + millis() * 0.3) % 255, (b_avg + y + millis() * 0.3) % 255);
        }
        rect(x + offsetX, y + offsetY, sq_width, sq_width);
        
        x += sq_width;
      }
        
     y += sq_width;
     x = 0;
    }

    for(int j = 1; j < (4 * nFaces) + 1; j+= 4)
    {
        //noFill();
        color(255);
        noStroke();
        //strokeWeight(12);
        //stroke(255,0,0);
        //10+vol*200, 10+vol*200
        blendMode(ADD);
        rect(offsetX + faces[j], offsetY + faces[j+1], faces[j+2], faces[j+3]);
        blendMode(NORMAL);
    }
    
    }
    
  //image(cam, random(width), random(height));
}
