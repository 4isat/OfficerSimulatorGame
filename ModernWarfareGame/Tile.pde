class Tile {
  int gridX, gridY;
  String terrain;
  Unit unit;
  boolean isHighlighted;
  float size;

  Tile(int x, int y, String terrain, float size) {
    this.gridX = x;
    this.gridY = y;
    this.terrain = terrain;
    this.unit = null;
    this.isHighlighted = false;
    this.size = size;
  }

  void display() {
    float px = gridX * size;
    float py = gridY * size;

    if (terrain.equals("S")) {
      fill(0,100,0); 
    } 
    if (terrain.equals("P")){
      fill(210,180,140);
    }
    if (terrain.equals("T")){
      fill(110);
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
      unit.display(px + size / 2, py + size / 2, size);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(size * 0.3);
      int actionsLeft = (!unit.moved && !unit.attacked) ? 2 :
                        (unit.moved && !unit.attacked) ? 1 : 0;
      text(actionsLeft, px + size / 2, py + size / 2);
    }
  }

  boolean contains(float mx, float my) {
    float px = gridX * size;
    float py = gridY * size;
    return mx >= px && mx < px + size && my >= py && my < py + size;
  }
}
