class TrainingCampLevel extends Level {

  private ArrayList<Unit> enemyList = new ArrayList<Unit>();
  private ArrayList<Unit> playerList = new ArrayList<Unit>();

  private String[][] mapData = {
    {"P", "P", "T", "T", "S", "S", "T", "T", "P", "P"},
    {"P", "P", "T", "S", "S", "S", "T", "T", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    {"P", "P", "T", "T", "P", "P", "T", "T", "P", "P"},
    {"P", "P", "T", "S", "S", "S", "T", "T", "P", "P"},
    {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"}
  };

  TrainingCampLevel(int availableWidth, int availableHeight) {
    super(10, 8, availableWidth, availableHeight-55);
    setupMap();
  }

  ArrayList<Unit> getEnemyList() {
    return enemyList;
  }

  ArrayList<Unit> getPlayerList() {
    return playerList;
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
    Unit player1 = new InfantryUnit(player, 1, 1, 1);
    getGrid()[1][1].setUnit(player1);
    playerList.add(player1);
    
    Unit player2 = new CavalryUnit(player, 1, 3, 2);
    getGrid()[1][3].setUnit(player2);
    playerList.add(player2);
    
    Unit player3 = new ArtilleryUnit(player, 2, 2, 3);
    getGrid()[2][2].setUnit(player3);
    playerList.add(player3);
    
    Unit player4 = new LogisticsUnit(player, 1, 2, 4);
    getGrid()[1][2].setUnit(player4);
    playerList.add(player4);
    
    Unit player5 = new DroneUnit(player, 0, 2, 5);
    getGrid()[0][2].setUnit(player5);
    playerList.add(player5);

    Unit enemy1 = new InfantryUnit(enemy, 8, 1, 1);
    getGrid()[8][1].setUnit(enemy1);
    enemyList.add(enemy1);

    Unit enemy2 = new InfantryUnit(enemy, 8, 3, 2);
    getGrid()[8][3].setUnit(enemy2);
    enemyList.add(enemy2);

    Unit enemy3 = new InfantryUnit(enemy, 7, 2, 3);
    getGrid()[7][2].setUnit(enemy3);
    enemyList.add(enemy3);
    
    Unit enemy4 = new InfantryUnit(enemy, 8, 2, 4);
    getGrid()[8][2].setUnit(enemy4);
    enemyList.add(enemy4);
  }

  String getObjective() {
    return """
    Learn the basics: move infantry units and destroy the enemies.
    Click on a unit to move them, toggle mode and click on an enemy to attack.
    Artillery do high damage to buildings and vehicles, low damage to troops.
    Drones are countered by infantry (sometimes). 
    Buildings and forests offer shelter and protection to units (grey and green tiles).
    Supply units resupply other units' ammo, fuel and health.
    Range units are square, your vehicle units are purple.
    """;
  }
}
