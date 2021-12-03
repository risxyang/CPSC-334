let capture;
var detector;
var classifier = objectdetect.frontalface;
var img;
var faces;

function setup() {
  createCanvas(displayWidth, displayHeight);
  capture = createCapture(VIDEO);
  capture.size(displayWidth, displayHeight);
  capture.hide();

  var scaleFactor = 1.0;
  detector = new objectdetect.detector(displayWidth, displayHeight, scaleFactor, classifier);
  img = loadImage(capture, function (img) {
    faces = detector.detect(img.canvas);
})
}

function draw() {
  background(255);
  image(capture, 0, 0, displayWidth, displayHeight);
  // filter(INVERT);
  
  stroke(255);
    noFill();
    if (faces) {
        faces.forEach(function (face) {
            var count = face[4];
            if (count > 4) { // try different thresholds
                rect(face[0], face[1], face[2], face[3]);
            }
        })
    }
  
}

function mousePressed() {
  if (mouseX > 0 && mouseX < displayWidth && mouseY > 0 && mouseY < displayHeight) {
    let fs = fullscreen();
    fullscreen(!fs);
  }
}