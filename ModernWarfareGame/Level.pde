abstract class Level {
  Tile[][] grid;
  int cols, rows;
  float tileSize;

  Level(int cols, int rows, int availableWidth, int availableHeight) {
    this.cols = cols;
    this.rows = rows;
    tileSize = min((float) availableWidth / cols, (float) availableHeight / rows);
    grid = new Tile[cols][rows];
    initEmptyGrid();
  }
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
        if (grid[i][j].contains(mx, my) && grid[i][j].unit != null &&
            grid[i][j].unit.owner == player &&
            (!grid[i][j].unit.moved || !grid[i][j].unit.attacked)) {
          highlightRange(grid[i][j].unit, "move");
          return grid[i][j].unit;
        }
      }
    }
    return null;
  }
  void clearHighlights() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j].isHighlighted = false;
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
    for (int i = max(0, unit.gridX - range); i <= min(cols - 1, unit.gridX + range); i++) {
      for (int j = max(0, unit.gridY - range); j <= min(rows - 1, unit.gridY + range); j++) {
        if (abs(unit.gridX - i) + abs(unit.gridY - j) <= range) {
          grid[i][j].isHighlighted = true;
          grid[i][j].highlightColor = highlightColor;
        }
      }
    }
  }
  boolean handleTileAction(float mx, float my, Unit unit, String mode) {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (grid[i][j].contains(mx, my)) {
          int dist = abs(unit.gridX - i) + abs(unit.gridY - j);
          if (mode.equals("move") && dist <= unit.getRange() && grid[i][j].unit == null && !unit.moved) {
            grid[unit.gridX][unit.gridY].unit = null;
            unit.move(i, j);
            grid[i][j].unit = unit;
            clearHighlights();
            highlightRange(unit, "move");
            return true;
          } else if (mode.equals("attack") && dist <= unit.getAttackRange() &&
                     grid[i][j].unit != null && !unit.attacked) {
            Unit target = grid[i][j].unit;
            unit.attack(target);
            boolean killed = target.health <= 0;
            if (killed) {
              // lower morale of units around a killed teammate
              for (int x = 0; x < cols; x++) {
                for (int y = 0; y < rows; y++) {
                  Unit other = grid[x][y].unit;
                  if (other != null && other.owner == target.owner &&
                      abs(other.gridX - target.gridX) + abs(other.gridY - target.gridY) <= 3) {
                    other.morale -= 30;
                    if (other.morale < 0) other.morale = 0;
                  }
                  // raise morale of enemy units within range of the death
                  if (other != null && other.owner != target.owner &&
                      abs(other.gridX - target.gridX) + abs(other.gridY - target.gridY) <= other.getRange() &&
                      other != unit) {
                    other.morale += 25;
                  }
                }
              }
              grid[i][j].unit = null;
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
        Unit u = grid[i][j].unit;
        if (u != null && u.owner == player) {
          u.moved = false;
          u.attacked = false;
          u.morale -= 5;
          if (u.morale < 0) u.morale = 0;
          u.updateEffectiveHealth();
        }
      }
    }
  }
  abstract String getObjective();
  abstract void placeInitialUnits(Player player, Player enemy);
  abstract ArrayList<Unit> getEnemyList();
}
