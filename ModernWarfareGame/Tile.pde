class Tile {
  int i, j;
  float x, y, size = 50;
  String type;
  Unit unit;
  boolean isHighlighted = false;

  Tile(int i, int j, String type) {
    this.i = i;
    this.j = j;
    this.type = type;
    this.x = i * size;
    this.y = j * size;
    this.unit = null;
  }

  void display() {
    stroke(0);
    if (type.equals("P")) fill(230);
    else if (type.equals("T")) fill(144, 238, 144);
    else if (type.equals("B")) fill(150);
    else if (type.equals("S")) fill(173, 216, 230);
    else fill(255);

    rect(x, y, size, size);

    if (isHighlighted) {
      noFill();
      stroke(255, 255, 0);
      strokeWeight(3);
      rect(x + 2, y + 2, size-4, size-4);
      strokeWeight(1);
    }

    if (unit != null) {
      unit.display(x+size/2, y+size/2);
    }
  }

  boolean contains(float mx, float my) {
    return (mx > x && mx < x + size && my> y && my < y + size);
  }
}
