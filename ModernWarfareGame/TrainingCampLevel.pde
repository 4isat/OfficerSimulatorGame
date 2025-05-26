class TrainingCampLevel extends Level {
  
  ArrayList<Unit> enemyList = new ArrayList<Unit>();

  String[][] mapData = {
    {"P", "P", "T", "T", "B", "B", "T", "T", "P", "P"},
    {"P", "P", "T", "S", "S", "S", "T", "T", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    {"P", "P", "T", "T", "P", "P", "T", "T", "P", "P"},
    {"P", "P", "T", "B", "B", "B", "T", "T", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"}
  };

  TrainingCampLevel(int availableWidth, int availableHeight) {
    super(10, 8, availableWidth, availableHeight);
    setupMap();
  }

  void setupMap() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        String type = mapData[j][i];
        grid[i][j] = new Tile(i, j, type, tileSize);
      }
    }
  }

  void placeInitialUnits(Player player, Player enemy) {
    grid[1][1].unit = new InfantryUnit(player, 1, 1);
    grid[1][3].unit = new CavalryUnit(player, 1, 3);
    grid[2][2].unit = new ArtilleryUnit(player, 2, 2);
    Unit enemy1 = new InfantryUnit(enemy, 8, 1);
    grid[8][1].unit = enemy1;
    enemyList.add(enemy1);
    Unit enemy2 = new InfantryUnit(enemy, 8, 3);
    grid[8][3].unit = enemy2;
    enemyList.add(enemy2);
    Unit enemy3 = new InfantryUnit(enemy, 7, 2);
    grid[7][2].unit = enemy3;
    enemyList.add(enemy3);
  }

  String getObjective() {
    return """
    Learn the basics: move infantry units and destroy the enemies.
    Click on a unit to move them, toggle mode and click on an enemy to attack.
    """;
  }
  
  ArrayList<Unit> getEnemyList(){
    return enemyList; 
  }
}
