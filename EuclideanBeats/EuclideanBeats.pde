import controlP5.*;
import processing.sound.*;

boolean isPaused;
boolean showCurrentBeat;
boolean isLowSound;
boolean isHighSound;
boolean isKickSound;

ControlP5 cp5;

int currFrame;
int prevOuterBeat;
int prevInnerBeat;
int prevKickBeat;

public int framesPerBar;
public int outerBeatsPerBar;
public int innerBeatsPerBar;
public int kickBeatsPerBar;

ArrayList<Integer> notes;

color backgroundColor = #0000ce;
color outerColor = #f94a45;
color outerHighlightColor = #fd9242;
color innerColor = #e84ed0;
color innerActiveColor = #e18bc8;
color innerHighlightColor = #eab7e2;
color kickColor = #0264c5;
color kickHighlightColor = #019fba;

SoundFile lowSound;
SoundFile highSound;
SoundFile kickSound;

FileNamer fileNamer;

void setup() {
  size(800, 800, P2D);

  lowSound = new SoundFile(this, "90016__marleneayni__clavelow.wav");
  highSound = new SoundFile(this, "90017__marleneayni__clavehi.wav");
  kickSound = new SoundFile(this, "244194__cima__kick.wav");
  kickSound.amp(0.5);

  isPaused = false;
  showCurrentBeat = true;
  isLowSound = false;
  isHighSound = false;
  isKickSound = false;

  framesPerBar = 128;
  outerBeatsPerBar = 5;
  innerBeatsPerBar = 16;
  kickBeatsPerBar = 4;

  notes = new ArrayList<Integer>();

  setupControlP5();

  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void reset() {
  notes = generateNotes();
  currFrame = 0;
  prevOuterBeat = -1;
  prevInnerBeat = -1;
  prevKickBeat = -1;
}

ArrayList<Integer> generateNotes() {
  if (innerBeatsPerBar < outerBeatsPerBar) {
    int temp = innerBeatsPerBar;
    innerBeatsPerBar = outerBeatsPerBar;
    outerBeatsPerBar = temp;
  }

  float noteLength = (float)innerBeatsPerBar / outerBeatsPerBar;
  int beatIndex = 0;
  ArrayList<Integer> resultNotes = new ArrayList<Integer>();
  while (beatIndex < outerBeatsPerBar) {
    float idealNotePosition = (float)beatIndex * noteLength;
    int optionA = floor(idealNotePosition);
    int optionB = ceil(idealNotePosition);
    int notePosition = chooseNotePosition(idealNotePosition, optionA, optionB);
    resultNotes.add(notePosition);
    beatIndex++;
  }

  return resultNotes;
}

int chooseNotePosition(float ideal, int optionA, int optionB) {
  if (abs(optionA - ideal) < abs(optionB - ideal)) {
    return optionA;
  }
  return optionB;
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

  cp5.addSlider("outerBeatsPerBar")
    .setBroadcast(false)
    .setRange(1, 20)
    .setPosition(20, currY)
    .setSize(100, 10)
    .setBroadcast(true)
    .setValue(5);
  currY += 20;

  cp5.addSlider("innerBeatsPerBar")
    .setBroadcast(false)
    .setRange(1, 20)
    .setPosition(20, currY)
    .setSize(100, 10)
    .setBroadcast(true)
    .setValue(16);
  currY += 20;

  cp5.addSlider("kickBeatsPerBar")
    .setBroadcast(false)
    .setRange(1, 20)
    .setPosition(20, currY)
    .setSize(100, 10)
    .setBroadcast(true)
    .setValue(4);
  currY += 20;

  cp5.addToggle("isLowSound")
    .setPosition(20, currY)
    .setSize(15, 15)
    .setState(false);
  currY += 30;

  cp5.addToggle("isHighSound")
    .setPosition(20, currY)
    .setSize(15, 15)
    .setState(false);
  currY += 30;

  cp5.addToggle("isKickSound")
    .setPosition(20, currY)
    .setSize(15, 15)
    .setState(false);
  currY += 30;
}

void draw() {
  int outerBeat = floor(currFrame / ((float)framesPerBar / outerBeatsPerBar));
  int innerBeat = floor(currFrame / ((float)framesPerBar / innerBeatsPerBar));
  int kickBeat = floor(currFrame / ((float)framesPerBar / kickBeatsPerBar));

  if (!isPaused) {
    if (isLowSound && outerBeat != prevOuterBeat) {
      lowSound.play();
    }
    if (isHighSound && innerBeat != prevInnerBeat && isNote(innerBeat)) {
      highSound.play();
    }
    if (isKickSound && kickBeat != prevKickBeat) {
      kickSound.play();
    }
  }

  g.background(backgroundColor);
  g.noStroke();

  g.fill(kickColor);
  drawBeats(g, kickBeatsPerBar, 900);

  if (showCurrentBeat) {
    g.fill(kickHighlightColor);
    drawBeat(g, kickBeat, kickBeatsPerBar, 800);
  }

  g.fill(backgroundColor);
  drawCircle(g, 520);

  g.fill(outerColor);
  drawBeats(g, outerBeatsPerBar, 500);

  if (showCurrentBeat) {
    g.fill(outerHighlightColor);
    drawBeat(g, outerBeat, outerBeatsPerBar, 480);
  }

  g.fill(backgroundColor);
  drawCircle(g, 380);

  g.fill(innerColor);
  drawBeats(g, innerBeatsPerBar, 360);

  g.fill(innerActiveColor);
  drawNotes(g, innerBeatsPerBar, 350);

  if (showCurrentBeat) {
    g.fill(innerHighlightColor);
    drawBeat(g, innerBeat, innerBeatsPerBar, 350);
  }

  if (!isPaused) {
    currFrame++;
    if (currFrame >= framesPerBar) {
      currFrame = 0;
    }
  }

  prevOuterBeat = outerBeat;
  prevInnerBeat = innerBeat;
  prevKickBeat = kickBeat;
}

void drawCircle(PGraphics g, float radius) {
  g.ellipse(width/2, height/2, radius, radius);
}

void drawBeats(PGraphics g, int numBeats, float radius) {
  for (int i = 0; i < numBeats; i++) {
    drawBeat(g, i, numBeats, radius);
  }
}

boolean isNote(int beat) {
  for (Integer note : notes) {
    if (beat == note) {
      return true;
    }
  }
  return false;
}

void drawNotes(PGraphics g, int numBeats, float radius) {
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

void stop() {
  isPaused = true;
  reset();
}

public void innerBeatsPerBar(int value) {
  stop();
}

public void outerBeatsPerBar(int value) {
  stop();
}

public void kickBeatsPerBar(int value) {
  stop();
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
    case 'r':
      save(savePath(fileNamer.next()));
      break;
    case 's':
      stop();
      break;
  }
}
