class FirstSkirmish extends Level {

  private ArrayList<Unit> enemyList = new ArrayList<Unit>();
  private ArrayList<Unit> playerList = new ArrayList<Unit>();

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
    Unit player2 = new InfantryUnit(player, 2, 2, 2);
    getGrid()[2][2].setUnit(player2);
    playerList.add(player2);
    Unit player3 = new InfantryUnit(player, 3, 3, 3);
    getGrid()[3][3].setUnit(player3);
    playerList.add(player3);
    Unit player4 = new InfantryUnit(player, 2, 4, 4);
    getGrid()[2][4].setUnit(player4);
    playerList.add(player4);
    Unit player5 = new InfantryUnit(player, 1, 5, 5);
    getGrid()[1][5].setUnit(player5);
    playerList.add(player5);
    Unit player6 = new CavalryUnit(player, 1, 2, 6);
    getGrid()[1][2].setUnit(player6);
    playerList.add(player6);
    Unit player7 = new CavalryUnit(player, 1, 4, 7);
    getGrid()[1][4].setUnit(player7);
    playerList.add(player7);
    Unit player8 = new ArtilleryUnit(player, 0, 3, 8);
    getGrid()[0][3].setUnit(player8);
    playerList.add(player8);
    Unit player9 = new LogisticsUnit(player, 1, 3, 9);
    getGrid()[1][3].setUnit(player9);
    playerList.add(player9);
    Unit player10 = new LogisticsUnit(player, 2, 3, 10);
    getGrid()[2][3].setUnit(player10);
    playerList.add(player10);
    Unit player11 = new DroneUnit(player, 0, 2, 11);
    getGrid()[0][2].setUnit(player11);
    playerList.add(player11);
    Unit player12 = new DroneUnit(player, 0, 4, 12);
    getGrid()[0][4].setUnit(player12);
    playerList.add(player12);

    Unit enemy1 = new DroneUnit(enemy, 13, 10, 1);
    getGrid()[13][10].setUnit(enemy1);
    enemyList.add(enemy1);
    Unit enemy6 = new DroneUnit(enemy, 13, 11, 6);
    getGrid()[13][11].setUnit(enemy6);
    enemyList.add(enemy6);
    Unit enemy7 = new InfantryUnit(enemy, 13, 9, 7);
    getGrid()[13][9].setUnit(enemy7);
    enemyList.add(enemy7);
    Unit enemy9 = new InfantryUnit(enemy, 13, 8, 9);
    getGrid()[13][8].setUnit(enemy9);
    enemyList.add(enemy9);
    Unit enemy8 = new InfantryUnit(enemy, 13, 7, 8);
    getGrid()[13][7].setUnit(enemy8);
    enemyList.add(enemy8);
    Unit enemy10 = new InfantryUnit(enemy, 13, 6, 10);
    getGrid()[13][6].setUnit(enemy10);
    enemyList.add(enemy10);
    Unit enemy11 = new InfantryUnit(enemy, 14, 6, 11);
    getGrid()[14][6].setUnit(enemy11);
    enemyList.add(enemy11);
    Unit enemy12 = new InfantryUnit(enemy, 15, 6, 12);
    getGrid()[15][6].setUnit(enemy12);
    enemyList.add(enemy12);
    Unit enemy13 = new InfantryUnit(enemy, 14, 5, 13);
    getGrid()[14][5].setUnit(enemy13);
    enemyList.add(enemy13);
    Unit enemy2 = new CavalryUnit(enemy, 14, 7, 2);
    getGrid()[14][7].setUnit(enemy2);
    enemyList.add(enemy2);
    Unit enemy3 = new ArtilleryUnit(enemy, 15, 9, 3);
    getGrid()[15][9].setUnit(enemy3);
    enemyList.add(enemy3);
    Unit enemy5 = new DroneUnit(enemy, 14, 8, 5);
    getGrid()[14][8].setUnit(enemy5);
    enemyList.add(enemy5);
    Unit enemy15 = new DroneUnit(enemy, 15, 8, 15);
    getGrid()[15][8].setUnit(enemy15);
    enemyList.add(enemy15);
    Unit enemy16 = new DroneUnit(enemy, 14, 9, 16);
    getGrid()[14][9].setUnit(enemy16);
    enemyList.add(enemy16);
    Unit enemy17 = new DroneUnit(enemy, 15, 10, 17);
    getGrid()[15][10].setUnit(enemy17);
    enemyList.add(enemy17);
    /*
    Unit enemy18 = new DroneUnit(enemy, 15, 5);
    getGrid()[15][5].setUnit(enemy18);
    enemyList.add(enemy18);
    Unit enemy19 = new DroneUnit(enemy, 15, 11);
    getGrid()[15][11].setUnit(enemy19);
    enemyList.add(enemy19);
    Unit enemy20 = new DroneUnit(enemy, 14, 11);
    getGrid()[14][11].setUnit(enemy20);
    enemyList.add(enemy20);
    */
  }

  String getObjective() {
    return """
    Welcome to the First Skirmish! Defeat all other units
    """;
  }
}
