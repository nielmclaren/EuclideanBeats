
int[] beats = {1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0};
int framesPerBar;
int innerBeatsPerBar;
int outerBeatsPerBar;

color backgroundColor = #0000ce;
color outerColor = #f94a45;
color outerHighlightColor = #fd9242;
color innerColor = #e84ed0;
color innerHighlightColor = #eab7e2;

void setup() {
  size(800, 800, P2D);

  framesPerBar = 128;
  innerBeatsPerBar = 16;
  outerBeatsPerBar = 5;
}

void draw() {
  int outerBeat = floor((frameCount % framesPerBar) / (framesPerBar / outerBeatsPerBar));
  int innerBeat = floor((frameCount % framesPerBar) / (framesPerBar / innerBeatsPerBar));

  background(backgroundColor);

  g.noStroke();
  g.fill(outerColor);
  drawBeats(g, outerBeatsPerBar, 350);

  g.fill(outerHighlightColor);
  drawBeat(g, outerBeat, outerBeatsPerBar, 330);

  g.fill(backgroundColor);
  drawCircle(g, 230);

  g.fill(innerColor);
  drawBeats(g, innerBeatsPerBar, 210);

  g.fill(innerHighlightColor);
  drawBeat(g, innerBeat, innerBeatsPerBar, 200);
}

void drawCircle(PGraphics g, float radius) {
  g.ellipse(width/2, height/2, radius, radius);
}

void drawBeats(PGraphics g, int numBeats, float radius) {
  for (int i = 0; i < numBeats; i++) {
    drawBeat(g, i, numBeats, radius);
  }
}

void drawBeat(PGraphics g, int beat, int numBeats, float radius) {
  g.pushMatrix();
  g.translate(width/2, height/2);

  float start = (float)beat / numBeats * 2 * PI - PI / 2;
  float end = start + 1. / numBeats * 2 * PI;

  float mid = start + 0.5 / numBeats * 2 * PI;
  float offset = 5;
  PVector centerOffset = new PVector(cos(mid), sin(mid));
  centerOffset.mult(offset);

  g.arc(centerOffset.x, centerOffset.y, radius - offset, radius - offset, start, end);

  g.popMatrix();
}