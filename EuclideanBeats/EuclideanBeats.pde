import controlP5.*;

boolean isPaused;
boolean showCurrentBeat;

ControlP5 cp5;

int currFrame;
public int framesPerBar;
public int innerBeatsPerBar;
public int outerBeatsPerBar;

ArrayList<Integer> notes;

color backgroundColor = #0000ce;
color outerColor = #f94a45;
color outerHighlightColor = #fd9242;
color innerColor = #e84ed0;
color innerActiveColor = #e18bc8;
color innerHighlightColor = #eab7e2;

void setup() {
  size(800, 800, P2D);

  isPaused = false;

  framesPerBar = 128;
  innerBeatsPerBar = 16;
  outerBeatsPerBar = 5;

  notes = new ArrayList<Integer>();

  setupControlP5();

  /*
  println("Bjorklund");
  Bjorklund b = new Bjorklund(8, 5);
  ArrayList<Integer> pattern = b.get();
  println("pattern: ");
  for (Integer i : pattern) {
    print(i + " ");
  }
  println();
  */

  euclid(8, 5);

  reset();
}

int euclid(int m, int k) {
  println(m, k);
  if (k == 0) {
    return m;
  }
  int x = euclid(k, m % k);
  return x;
}

void reset() {
  notes = generateNotes();
  currFrame = 0;
}

int chooseNotePosition(int optionA, int optionB) {
  return random(1) < 0.5 ? optionA : optionB;
}

void setupControlP5() {
  int currY = 20;

  cp5 = new ControlP5(this);

  cp5.addSlider("framesPerBar")
    .setBroadcast(false)
    .setRange(0, 1000)
    .setPosition(20, currY)
    .setSize(200, 10)
    .setBroadcast(true)
    .setValue(128);
  currY += 20;

  cp5.addSlider("innerBeatsPerBar")
    .setBroadcast(false)
    .setRange(1, 20)
    .setPosition(20, currY)
    .setSize(100, 10)
    .setBroadcast(true)
    .setValue(16);
  currY += 20;

  cp5.addSlider("outerBeatsPerBar")
    .setBroadcast(false)
    .setRange(1, 20)
    .setPosition(20, currY)
    .setSize(100, 10)
    .setBroadcast(true)
    .setValue(5);
  currY += 20;
}

void draw() {
  int outerBeat = floor(currFrame / ((float)framesPerBar / outerBeatsPerBar));
  int innerBeat = floor(currFrame / ((float)framesPerBar / innerBeatsPerBar));

  background(backgroundColor);

  g.noStroke();
  g.fill(outerColor);
  drawBeats(g, outerBeatsPerBar, 350);

  if (showCurrentBeat) {
    g.fill(outerHighlightColor);
    drawBeat(g, outerBeat, outerBeatsPerBar, 330);
  }

  g.fill(backgroundColor);
  drawCircle(g, 230);

  g.fill(innerColor);
  drawBeats(g, innerBeatsPerBar, 210);

  g.fill(innerActiveColor);
  drawActiveBeats(g, innerBeatsPerBar, 200);

  if (showCurrentBeat) {
    g.fill(innerHighlightColor);
    drawBeat(g, innerBeat, innerBeatsPerBar, 200);
  }

  if (!isPaused) {
    currFrame++;
    if (currFrame >= framesPerBar) {
      currFrame = 0;
    }
  }
}

void drawCircle(PGraphics g, float radius) {
  g.ellipse(width/2, height/2, radius, radius);
}

void drawBeats(PGraphics g, int numBeats, float radius) {
  for (int i = 0; i < numBeats; i++) {
    drawBeat(g, i, numBeats, radius);
  }
}

void drawActiveBeats(PGraphics g, int numBeats, float radius) {
  for (Integer beat : notes) {
    drawBeat(g, beat, numBeats, radius);
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


ArrayList<Integer> generateNotes() {
  if (innerBeatsPerBar < outerBeatsPerBar) {
    int temp = innerBeatsPerBar;
    innerBeatsPerBar = outerBeatsPerBar;
    outerBeatsPerBar = temp;
  }

  float noteLength = (float)innerBeatsPerBar / outerBeatsPerBar;
  float error = 0;
  int beatIndex = 0;
  ArrayList<Integer> resultNotes = new ArrayList<Integer>();
  while (beatIndex < outerBeatsPerBar) {
    float idealNotePosition = (float)beatIndex * noteLength;
    int optionA = floor(idealNotePosition);
    int optionB = ceil(idealNotePosition);
    int notePosition = chooseNotePosition(optionA, optionB);
    resultNotes.add(notePosition);

    error += notePosition - idealNotePosition;

    beatIndex++;
  }

  return resultNotes;
}


void keyReleased() {
  switch (key) {
    case 't':
      showCurrentBeat = !showCurrentBeat;
      break;
    case 'e':
      reset();
      break;
    case ' ':
      isPaused = !isPaused;
      break;
  }
}
