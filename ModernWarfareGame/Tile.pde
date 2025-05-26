class Tile {
  int gridX, gridY;
  String terrain;
  Unit unit;
  boolean isHighlighted;
  color highlightColor;
  float size;

  Tile(int x, int y, String terrain, float size) {
    this.gridX = x;
    this.gridY = y;
    this.terrain = terrain;
    this.unit = null;
    this.isHighlighted = false;
    this.highlightColor = color(255, 255, 0);
    this.size = size;
  }

  void display() {
    float px = gridX * size;
    float py = gridY * size;
    if (terrain.equals("S")) {
      fill(0, 100, 0);
    }
    if (terrain.equals("P")) {
      fill(210, 180, 140);
    }
    if (terrain.equals("T")) {
      fill(110);
    }
    rect(px, py, size, size);
    if (isHighlighted) {
      noFill();
      stroke(highlightColor);
      strokeWeight(5);
      rect(px, py, size, size);
      strokeWeight(1);
    }
    if (unit != null) {
      unit.display(px + size / 2, py + size / 2, size);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(size * 0.18);
      int actionsLeft;
      if (!unit.getType().equals("Artillery")){
        if (!unit.moved && !unit.attacked) {
          actionsLeft = 2;
        } else if (unit.moved && !unit.attacked) {
          actionsLeft = 1;
        } else {
          actionsLeft = 0;
        }
      }
      else{
        if (!unit.moved && !unit.attacked) {
          actionsLeft = 1;
        } else{
          actionsLeft = 0;
        }
      }
      text(actionsLeft, px + size / 2, py + size / 3);
      text(unit.getType(), px + size / 2, py + size / 2);
    }
  }

  boolean contains(float mx, float my) {
    float px = gridX * size;
    float py = gridY * size;
    return mx >= px && mx < px + size && my >= py && my < py + size;
  }
}
