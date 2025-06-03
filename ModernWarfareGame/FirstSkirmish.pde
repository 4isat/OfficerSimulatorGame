class FirstSkirmish extends Level {

  private ArrayList<Unit> enemyList = new ArrayList<Unit>();

  private String[][] mapData = {
    {"P", "P", "S", "S", "S", "S", "S", "S", "S", "T", "T", "P", "P", "P", "P", "P"},
    {"P", "P", "S", "S", "S", "S", "S", "S", "S", "S", "S", "P", "P", "P", "T", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    {"P", "P", "T", "T", "P", "P", "T", "T", "P", "P", "T", "T", "P", "P", "P", "P"},
    {"P", "P", "T", "T", "S", "S", "T", "T", "S", "S", "S", "T", "P", "P", "S", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "S", "S", "S", "S", "P", "P", "P", "P"},
    {"P", "P", "P", "P", "S", "S", "S", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    {"P", "P", "T", "T", "S", "S", "T", "T", "S", "S", "T", "T", "P", "P", "P", "P"},
    {"P", "P", "T", "T", "S", "S", "T", "T", "S", "S", "S", "T", "P", "P", "P", "P"},
    {"P", "P", "P", "P", "S", "S", "P", "T", "P", "P", "T", "T", "P", "P", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P"}
  };

  FirstSkirmish(int availableWidth, int availableHeight) {
    super(16, 12, availableWidth, availableHeight-55);  // adjust for taskbar at bottom on some computers
    setupMap();
  }

  ArrayList<Unit> getEnemyList() {
    return enemyList;
  }

  void setEnemyList(ArrayList<Unit> enemyList) {
    this.enemyList = enemyList;
  }

  String[][] getMapData() {
    return mapData;
  }

  void setMapData(String[][] mapData) {
    this.mapData = mapData;
  }

  void setupMap() {
    for (int i = 0; i < getCols(); i++) {
      for (int j = 0; j < getRows(); j++) {
        String type = mapData[j][i];
        getGrid()[i][j] = new Tile(i, j, type, getTileSize());
      }
    }
  }

  void placeInitialUnits(Player player, Player enemy) {
    getGrid()[1][1].setUnit(new InfantryUnit(player, 1, 1));
    getGrid()[1][3].setUnit(new CavalryUnit(player, 1, 3));
    getGrid()[2][2].setUnit(new ArtilleryUnit(player, 2, 2));
    getGrid()[1][2].setUnit(new LogisticsUnit(player, 1, 2));
    getGrid()[0][2].setUnit(new DroneUnit(player, 0, 2));

    Unit enemy1 = new InfantryUnit(enemy, 14, 1);
    getGrid()[14][1].setUnit(enemy1);
    enemyList.add(enemy1);

    Unit enemy2 = new CavalryUnit(enemy, 13, 3);
    getGrid()[13][3].setUnit(enemy2);
    enemyList.add(enemy2);

    Unit enemy3 = new ArtilleryUnit(enemy, 12, 2);
    getGrid()[12][2].setUnit(enemy3);
    enemyList.add(enemy3);

    Unit enemy4 = new LogisticsUnit(enemy, 14, 4);
    getGrid()[14][4].setUnit(enemy4);
    enemyList.add(enemy4);

    Unit enemy5 = new DroneUnit(enemy, 13, 5);
    getGrid()[13][5].setUnit(enemy5);
    enemyList.add(enemy5);
  }

  String getObjective() {
    return """
    Welcome to the First Skirmish! Defeat all other units
    """;
  }
}
