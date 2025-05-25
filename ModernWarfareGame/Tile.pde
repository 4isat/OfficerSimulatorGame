class Tile {
  int gridX, gridY;
  String terrain;
  Unit unit;
  boolean isHighlighted;

  Tile(int x, int y, String terrain) {
    this.gridX = x;
    this.gridY = y;
    this.terrain = terrain;
    this.unit = null;
    this.isHighlighted = false;
  }

  void display() {
    int size = 40;
    int px = gridX * size;
    int py = gridY * size;

    if (terrain.equals("P")) {
      fill(150, 200, 150); 
    } else {
      fill(100);
    }
    rect(px, py, size, size);

    if (isHighlighted) {
      noFill();
      stroke(255, 255, 0);
      strokeWeight(3);
      rect(px, py, size, size);
      strokeWeight(1);
    }

    if (unit != null) {
      if (unit.owner == null) {
        fill(128);
      } else if (unit.owner.name.equals("Player 1")) {
        fill(0, 0, 255);  // Blue for player
      } else {
        fill(255, 0, 0);  // Red for enemy
      }

      ellipse(px + size / 2, py + size / 2, size * 0.6, size * 0.6);
      int actionsLeft = 0;
      if (!unit.moved && !unit.attacked) {
        actionsLeft = 2;
      } else if (unit.moved && !unit.attacked) {
        actionsLeft = 1;
      } else {
        actionsLeft = 0;
      }

      fill(255);
      textAlign(CENTER, CENTER);
      textSize(14);
      text(actionsLeft, px + size / 2, py + size / 2);
    }
  }

  boolean contains(float mx, float my) {
    int size = 40;
    int px = gridX * size;
    int py = gridY * size;
    return mx >= px && mx < px + size && my >= py && my < py + size;
  }
}
