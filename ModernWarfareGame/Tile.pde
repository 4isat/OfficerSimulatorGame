class Tile {
  private int gridX, gridY;
  private String terrain;
  private Unit unit;
  private boolean isHighlighted;
  private color highlightColor;
  private float size;

  Tile(int x, int y, String terrain, float size) {
    this.gridX = x;
    this.gridY = y;
    this.terrain = terrain;
    this.unit = null;
    this.isHighlighted = false;
    this.highlightColor = color(255, 255, 0);
    this.size = size;
  }
  int getGridX() { return gridX; }
  int getGridY() { return gridY; }
  String getTerrain() { return terrain; }
  Unit getUnit() { return unit; }
  boolean isHighlighted() { return isHighlighted; }
  color getHighlightColor() { return highlightColor; }
  float getSize() { return size; }
  void setGridX(int gridX) { this.gridX = gridX; }
  void setGridY(int gridY) { this.gridY = gridY; }
  void setTerrain(String terrain) { this.terrain = terrain; }
  void setUnit(Unit unit) { this.unit = unit; }
  void setHighlighted(boolean highlighted) { this.isHighlighted = highlighted; }
  void setHighlightColor(color highlightColor) { this.highlightColor = highlightColor; }
  void setSize(float size) { this.size = size; }

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

      if (!unit.getType().equals("Artillery")) {
        if (!unit.hasMoved() && !unit.hasAttacked()) {
          actionsLeft = 2;
        } else if (unit.hasMoved() && !unit.hasAttacked()) {
          actionsLeft = 1;
        } else {
          actionsLeft = 0;
        }
      } else {
        if (!unit.hasMoved() && !unit.hasAttacked()) {
          actionsLeft = 1;
        } else {
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
