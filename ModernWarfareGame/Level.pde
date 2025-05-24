abstract class Level {
  Tile[][] grid;
  int cols, rows;

  Level(int cols, int rows) {
    this.cols = cols;
    this.rows = rows;
    grid = new Tile[cols][rows];
    initEmptyGrid();
  }

  void initEmptyGrid() {
    for (int i= 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j] = new Tile(i, j, "P");
      }
    }
  }

  void display() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j< rows; j++) {
        grid[i][j].display();
      }
    }
  }

  Unit selectUnit(float mx, float my, Player player) {
    clearHighlights();

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (grid[i][j].contains(mx, my) && grid[i][j].unit != null &&
            grid[i][j].unit.owner == player) {
          println("Selected unit at " + i + "," + j);
          highlightRange(grid[i][j].unit);
          return grid[i][j].unit;
        }
      }
    }
    return null;
  }

  void clearHighlights() {
    for (int i = 0; i<cols; i++) {
      for (int j=0; j < rows; j++) {
        grid[i][j].isHighlighted = false;
      }
    }
  }

  void highlightRange(Unit unit) {
    int range = unit.getRange();
    for (int i = max(0, unit.gridX-range); i <= min(cols-1, unit.gridX+range); i++) {
      for (int j = max(0, unit.gridY-range); j <= min(rows-1, unit.gridY+range); j++) {
        if (abs(unit.gridX-i) + abs(unit.gridY-j) <= range) {
          grid[i][j].isHighlighted = true;
        }
      }
    }
  }

  boolean handleTileAction(float mx, float my, Unit unit, String mode) {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (grid[i][j].contains(mx, my)) {
          int dist = abs(unit.gridX - i) + abs(unit.gridY - j);
          if (mode.equals("move") && dist <= unit.getRange() && grid[i][j].unit == null) {
            grid[unit.gridX][unit.gridY].unit = null;
            unit.move(i, j);
            grid[i][j].unit = unit;
            println("Moved unit to " + i + "," + j);
            clearHighlights();
            return true;
          } else if (mode.equals("attack") && dist <= unit.getRange() &&
                     grid[i][j].unit != null &&
                     grid[i][j].unit.owner != unit.owner) {
            unit.attack(grid[i][j].unit);
            if (grid[i][j].unit.health <= 0) {
              println("Enemy unit destroyed!");
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

  abstract String getObjective();
  abstract void placeInitialUnits(Player player, Player enemy);
}
