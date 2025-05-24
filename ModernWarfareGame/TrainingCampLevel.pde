class TrainingCampLevel extends Level {
  
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

  TrainingCampLevel() {
    super(10, 8);
    setupMap();
  }

  void setupMap() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j< rows; j++) {
        String type = mapData[j][i];
        grid[i][j] = new Tile(i, j, type);
      }
    }
  }

  void placeInitialUnits(Player player, Player enemy) {
    grid[1][1].unit = new InfantryUnit(player, 1, 1);
    grid[1][3].unit = new InfantryUnit(player, 1, 3);
    grid[2][2].unit = new InfantryUnit(player, 2, 2);

    grid[8][1].unit = new InfantryUnit(enemy, 8, 1);
    grid[8][3].unit = new InfantryUnit(enemy, 8, 3);
    grid[7][2].unit = new InfantryUnit(enemy, 7, 2);
  }

  String getObjective() {
    return "Learn the basics: move infantry units and destroy the enemies";
  }
}
