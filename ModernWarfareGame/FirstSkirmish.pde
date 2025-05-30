class FirstSkirmish extends Level {

  private ArrayList<Unit> enemyList = new ArrayList<Unit>();

  private String[][] mapData = {
    {"P", "P", "T", "B", "B", "B", "B", "T", "P", "P"},
    {"P", "P", "B", "S", "S", "S", "S", "B", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    {"P", "P", "T", "T", "P", "P", "T", "T", "P", "P"},
    {"P", "P", "T", "B", "B", "B", "T", "T", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"}
  };

  FirstSkirmish(int availableWidth, int availableHeight) {
    super(10, 8, availableWidth, availableHeight);
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

    Unit enemy1 = new InfantryUnit(enemy, 8, 1);
    getGrid()[8][1].setUnit(enemy1);
    enemyList.add(enemy1);

    Unit enemy2 = new InfantryUnit(enemy, 8, 3);
    getGrid()[8][3].setUnit(enemy2);
    enemyList.add(enemy2);

    Unit enemy3 = new InfantryUnit(enemy, 7, 2);
    getGrid()[7][2].setUnit(enemy3);
    enemyList.add(enemy3);
  }

  String getObjective() {
    return """
    Learn the basics: move infantry units and destroy the enemies.
    Click on a unit to move them, toggle mode and click on an enemy to attack.
    """;
  }
}
