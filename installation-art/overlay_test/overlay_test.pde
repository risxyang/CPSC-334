int h, w, o, g, nRows, nCols;

void setup() {
    size(600, 600, P3D);
    h = 50;
    w = 35;
    o = 15; // offset; can change
    g = 5; // gap
    nRows = 6;
    nCols = 4;
}

void draw()
{
  for(int i = 0; i < nRows; i++)
  {
    for (int j = 0; j < nCols; j++)
    {
      beginShape();
      noStroke();
      color c = color(220, 150, 10);
      fill(c);
      int xOffset = j * (o+w+g);
      int yOffset = i * (h + g);
      int rowIndent = i * (o+w+g);
      vertex(0 + xOffset + rowIndent, 0 + yOffset);
      vertex(w + xOffset + rowIndent, 0 + yOffset);
      vertex(w+o + xOffset + rowIndent, h + yOffset);
      vertex(o + xOffset + rowIndent, h + yOffset);
      endShape();
    }
  }
  
}
