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
  lastAction = "";
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (grid[i][j].contains(mx, my)) {
        int dist = abs(unit.getGridX() - i) + abs(unit.getGridY() - j);
        if (unit.getType().equals("Artillery")) {
          if (mode.equals("move") && unit.hasAttacked()) {
            lastAction = "Artillery cannot move after attacking!";
            return false;
          }
          if (mode.equals("attack") && unit.hasMoved()) {
            lastAction = "Artillery cannot attack after moving!";
            return false;
          }
        }
        if (mode.equals("move") && dist <= unit.getRange() && grid[i][j].getUnit() == null && !unit.hasMoved() && unit.getFuel()>0) {
          if (grid[i][j].getTerrain().equals("building")){
            if (unit.getType().equals("Artillery") || unit.getType().equals("Cavalry")){
              lastAction = "Cannot move vehicle units to buildings";
            }
            else{
              grid[unit.getGridX()][unit.getGridY()].setUnit(null);
              unit.move(i, j);
              grid[i][j].setUnit(unit);
              lastAction = "Moved " + unit.getType() + " to " + i + "," + j;
              clearHighlights();
              highlightRange(unit, "move");
              return true;
            }
          }
          else{
            grid[unit.getGridX()][unit.getGridY()].setUnit(null);
            unit.move(i, j);
            grid[i][j].setUnit(unit);
            lastAction = "Moved " + unit.getType() + " to " + i + "," + j;
            clearHighlights();
            highlightRange(unit, "move");
            return true;
          }
        } else if (mode.equals("attack") && dist <= unit.getAttackRange() &&
                   grid[i][j].getUnit() != null && !unit.hasAttacked() && unit.getAmmo() > 0) {
            if (unit.getType().equals("Artillery")){
              int k = 0;
              while (k < 4){
                int L = i;
                int m = j;
                if (k == 0){
                  L = i - 1;
                }
                if (k == 1){
                  L = i + 1;
                }
                if (k == 2){
                  m = j - 1;
                }
                if (k == 3){
                  m = j + 1;
                }
                if (L >= 0 && L < cols){
                  if (m >= 0 && m < cols){
                    if(grid[L][m].getUnit() != null){
                      Unit target = grid[L][m].getUnit();
                      Tile targetTile = grid[L][m];
                      int splashDamage = 15;
                      if (!targetTile.getTerrain().equals("building") && !targetTile.getTerrain().equals("forest")){
                        target.setHealth(target.getHealth() - splashDamage);
                        lastAction += "Splashed " + target.getType() + " at " + target.getGridX() + "," + target.getGridY() + " \n";
                      }
                    }
                  }
                }
                k++;
              }
              // Right now, I just need this to loop to directly adjacent tiles
              //essentially make a loop that targets the adjacent tiles (1 attack radius). All enemy units should receive damage in these tiles, with the splash being 15 damage.
              //Use a similar method as the tile method to set the health of the enemy units in the splash radius lower by 15. If they are in the building or forest, they should
              //receive 0 damage as these tiles shield them from shrapnel. 
            }
          Unit target = grid[i][j].getUnit();
          Tile targetTile = grid[i][j];
          unit.consumeAmmo();
          if (targetTile.getTerrain().equals("building") || targetTile.getTerrain().equals("forest")) {
            int damageToTile;
            if (unit.getType().equals("Artillery")) {
              damageToTile = 100; 
            } else {
              damageToTile = unit.getEffectiveDamage();
            }
            targetTile.setHealth(targetTile.getHealth() - damageToTile);
            lastAction = unit.getType() + " damaged " + targetTile.getTerrain() + " tile at " + i + "," + j + "\n" +
                         " for " + damageToTile + " damage (remaining tile HP: " + targetTile.getHealth() + ") \n";
            if (targetTile.getHealth() <= 0) {
              targetTile.setTerrain("P"); 
              targetTile.setHealth(0);
              lastAction += " — tile destroyed!";
            }
          } else {
            unit.attack(target);
            if (!unit.getType().equals("Supply")) {
              lastAction += "Your " + unit.getType() + " at " + unit.getGridX() + "," + unit.getGridY() + 
                           " deals " + unit.getEffectiveDamage() + " damage to\n" + target.getOwner().getName() + " " + target.getType() + 
                           " at " + target.getGridX() + "," + target.getGridY() + " \n";
            }
            boolean killed = target.getHealth() <= 0;
            if (killed) {
              lastAction += "Enemy " + target.getType() + " at " + target.getGridX() + "," + target.getGridY() + 
                           " destroyed by " + unit.getType();
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
