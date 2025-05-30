abstract class Level {
  private Tile[][] grid;
  private int cols, rows;
  private float tileSize;
  private String lastAction;
  
  String getLastAction(){
    return lastAction;
  }

  Level(int cols, int rows, int availableWidth, int availableHeight) {
    this.cols = cols;
    this.rows = rows;
    tileSize = min((float) availableWidth / cols, (float) availableHeight / rows);
    grid = new Tile[cols][rows];
    initEmptyGrid();
  }

  Tile[][] getGrid() { return grid; }
  int getCols() { return cols; }
  int getRows() { return rows; }
  float getTileSize() { return tileSize; }

  void setGrid(Tile[][] grid) { this.grid = grid; }
  void setCols(int cols) { this.cols = cols; }
  void setRows(int rows) { this.rows = rows; }
  void setTileSize(float tileSize) { this.tileSize = tileSize; }

  void initEmptyGrid() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j] = new Tile(i, j, "P", tileSize);
      }
    }
  }

  void display(int availableWidth, int availableHeight) {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j].display();
      }
    }
  }

  int getPixelWidth() {
    return int(cols * tileSize);
  }

  Unit selectUnit(float mx, float my, Player player) {
    clearHighlights();
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        Unit unit = grid[i][j].getUnit();
        if (grid[i][j].contains(mx, my) && unit != null &&
            unit.getOwner() == player &&
            (!unit.hasMoved() || !unit.hasAttacked())) {
          highlightRange(unit, "move");
          return unit;
        }
      }
    }
    return null;
  }

  void clearHighlights() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j].setHighlighted(false);
      }
    }
  }

  void highlightRange(Unit unit, String mode) {
    clearHighlights();
    int range;
    color highlightColor;
    if (mode.equals("move")) {
      range = unit.getRange();
      highlightColor = color(255, 255, 0);
    } else {
      range = unit.getAttackRange();
      highlightColor = color(255, 0, 0);
    }
    for (int i = max(0, unit.getGridX() - range); i <= min(cols - 1, unit.getGridX() + range); i++) {
      for (int j = max(0, unit.getGridY() - range); j <= min(rows - 1, unit.getGridY() + range); j++) {
        if (abs(unit.getGridX() - i) + abs(unit.getGridY() - j) <= range) {
          grid[i][j].setHighlighted(true);
          grid[i][j].setHighlightColor(highlightColor);
        }
      }
    }
  }

  boolean handleTileAction(float mx, float my, Unit unit, String mode) {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (grid[i][j].contains(mx, my)) {
          int dist = abs(unit.getGridX() - i) + abs(unit.getGridY() - j);
          if (mode.equals("move") && dist <= unit.getRange() && grid[i][j].getUnit() == null && !unit.hasMoved()) {
            grid[unit.getGridX()][unit.getGridY()].setUnit(null);
            unit.move(i, j);
            grid[i][j].setUnit(unit);
            lastAction = "Moved " + unit.getType() + " to " + i + "," + j;
            clearHighlights();
            highlightRange(unit, "move");
            return true;
          } else if (mode.equals("attack") && dist <= unit.getAttackRange() &&
                     grid[i][j].getUnit() != null && !unit.hasAttacked()) {
            Unit target = grid[i][j].getUnit();
            unit.attack(target);
            if (!unit.getType().equals("Supply")){
              lastAction = "Your " + unit.getType() + " at " + unit.gridX + "," + unit.gridY + " deals " + unit.getEffectiveDamage() + " damage to enemy " + target.getType() + " " + target.gridX + "," + target.gridY;
            }
            boolean killed = target.getHealth() <= 0;
            if (killed) {
              lastAction = "Enemy " + target.getType() + " at " + target.gridX + "," + target.gridY + " destroyed by " + unit.getType();
              for (int x = 0; x < cols; x++) {
                for (int y = 0; y < rows; y++) {
                  Unit other = grid[x][y].getUnit();
                  if (other != null && other.getOwner() == target.getOwner() &&
                      abs(other.getGridX() - target.getGridX()) + abs(other.getGridY() - target.getGridY()) <= 3) {
                    other.setMorale(other.getMorale() - 30);
                    if (other.getMorale() < 0) other.setMorale(0);
                  }
                  if (other != null && other.getOwner() != target.getOwner() &&
                      abs(other.getGridX() - target.getGridX()) + abs(other.getGridY() - target.getGridY()) <= other.getRange() &&
                      other != unit) {
                    other.setMorale(other.getMorale() + 25);
                  }
                }
              }
              grid[i][j].setUnit(null);
            }
            clearHighlights();
            return true;
          }
        }
      }
    }
    return false;
  }

  void resetUnitActions(Player player) {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        Unit u = grid[i][j].getUnit();
        if (u != null && u.getOwner() == player) {
          u.setMoved(false);
          u.setAttacked(false);
          u.setMorale(u.getMorale() - 5);
          if (u.getMorale() < 0) u.setMorale(0);
          u.updateEffectiveHealth();
        }
      }
    }
  }

  abstract String getObjective();
  abstract void placeInitialUnits(Player player, Player enemy);
  abstract ArrayList<Unit> getEnemyList();
}
