
class Bjorklund {
  private int pulses;
  private int steps;

  private ArrayList<Integer> pattern;
  private ArrayList<Float> counts;
  private ArrayList<Float> remainders;
  private float divisor;

  Bjorklund(int stepsArg, int pulsesArg) {
    steps = stepsArg;
    pulses = pulsesArg;

    if (pulses > steps) {
      throw new IllegalArgumentException();
    }

    reset();
  }

  private void reset() {
    pattern = new ArrayList<Integer>();
    counts = new ArrayList<Float>();
    remainders = new ArrayList<Float>();
    divisor = steps - pulses;
    remainders.add((float)pulses);
  }

  public ArrayList<Integer> get() {
    int level = bjorklund();
    build(level, 0);

    // TODO: Rotate the pattern so it starts at 0.

    ArrayList<Integer> result = pattern;

    reset();
    return result;
  }

  /**
  * https://github.com/brianhouse/bjorklund
  * Based on code by Brian House
  */
  private int bjorklund() {
    int level = 0;
    while (true) {
      counts.add(divisor / remainders.get(level));
      remainders.add(divisor % remainders.get(level));
      divisor = remainders.get(level);
      level++;

      if (remainders.get(level) <= 1) {
        break;
      }
    }

    counts.add(divisor);

    print("counts: ");
    for (Float count : counts) {
      print(count + " ");
    }
    println();

    print("remainders: ");
    for (Float remainder : remainders) {
      print(remainder + " ");
    }
    println();

    println("level: " + level);

    return level;
  }

  private void build(int level, int depth) {
    for (int i = 0; i < depth; i++) {
      print("  ");
    }
    println("build(" + level + ", " + depth + ")");
    switch (level) {
      case -1:
        pattern.add(0);
        break;

      case -2:
        pattern.add(1);
        break;

      default:
        for (int i = 0; i < counts.get(level); i++) {
          build(level - 1, depth + 1);
        }
        if (remainders.get(level) != 0) {
          build(level - 2, depth + 1);
        }
    }
  }
}