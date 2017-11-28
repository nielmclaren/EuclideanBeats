
int[] beats = {1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0};
int framesPerBeat;

void setup() {
  size(800, 800, P2D);

  framesPerBeat = 8;
}

void draw() {
  int currBeat = floor(frameCount / framesPerBeat) % beats.length;

  background(0);

  g.fill(64);
  drawBeats(g, 16);

  g.fill(255);
  drawBeat(g, currBeat, 16);
}

void drawBeats(PGraphics g, int numBeats) {
  for (int i = 0; i < numBeats; i++) {
    drawBeat(g, i, numBeats);
  }
}

void drawBeat(PGraphics g, int beat, int numBeats) {
  g.pushMatrix();
  g.translate(width/2, height/2);

  float radius = 200;

  float start = (float)beat / numBeats * 2 * PI;
  float end = start + 1. / numBeats * 2 * PI;

  float mid = start + 0.5 / numBeats * 2 * PI;
  float offset = 5;
  PVector centerOffset = new PVector(cos(mid), sin(mid));
  centerOffset.mult(offset);

  g.arc(centerOffset.x, centerOffset.y, radius, radius, start, end);

  g.popMatrix();
}