MainGame game;

void settings() {
  fullScreen();
}

void setup() {
  game = new MainGame();
}

void draw() {
  game.display();
}

void mousePressed() {
  game.handleClick(mouseX, mouseY);
}

class MainGame {
  Player player1;
  Player enemy;
  Level currentLevel;

  boolean showMenu = true;
  boolean victoryAchieved = false;

  Unit selectedUnit = null;
  String mode = "move";

  Button toggleButton;
  Button unselectButton;
  Button endTurnButton;
  Button returnToMenuButton;

  final int guiWidth = 200;

  MainGame() {
    player1 = new Player("Player 1", true);
    enemy = new Player("Enemy", false);
    endTurnButton = new Button(width - guiWidth + 25, height - 60, 150, 40, "End Turn");
    returnToMenuButton = new Button(width / 2 - 100, height / 2 + 40, 200, 50, "Return to Menu");
  }

  void display() {
    if (showMenu) {
      displayMenu();
    } else if (victoryAchieved) {
      displayVictoryScreen();
    } else if (currentLevel != null) {
      currentLevel.display(width - guiWidth, height);
      if (selectedUnit != null) {
        displayUnitGUI(selectedUnit);
        toggleButton.display();
        unselectButton.display();
      }
      endTurnButton.display();
      fill(0);
      textAlign(LEFT, TOP);
      textSize(20);
      text(currentLevel.getObjective(), 10, 10);
    }
  }

  void displayMenu() {
    background(100, 150, 200);
    fill(255);
    textSize(48);
    textAlign(CENTER, CENTER);
    text("Modern Warfare Game", width / 2, height / 4);
    fill(50, 200, 50);
    rect(width / 2 - 150, height / 2 - 40, 300, 80);
    fill(0);
    textSize(28);
    text("Start Training Camp", width / 2, height / 2);
  }

  void displayVictoryScreen() {
    background(50, 180, 70);
    fill(255);
    textSize(48);
    textAlign(CENTER, CENTER);
    text("Victory: Objective Completed", width / 2, height / 2 - 50);
    returnToMenuButton.display();
  }

  void handleClick(float mx, float my) {
    if (showMenu) {
      if (mx >= width / 2 - 150 && mx <= width / 2 + 150 &&
          my >= height / 2 - 40 && my <= height / 2 + 40) {
        startTrainingCamp();
        showMenu = false;
      }
    } else if (victoryAchieved) {
      if (returnToMenuButton.isClicked(mx, my)) {
        resetToMenu();
      }
    } else if (selectedUnit != null && toggleButton.isClicked(mx, my)) {
      mode = mode.equals("move") ? "attack" : "move";
    } else if (selectedUnit != null && unselectButton.isClicked(mx, my)) {
      currentLevel.clearHighlights();
      selectedUnit = null;
    } else if (endTurnButton.isClicked(mx, my)) {
      currentLevel.resetUnitActions(player1);
      selectedUnit = null;
      currentLevel.clearHighlights();
      checkVictoryCondition();
    } else if (currentLevel != null) {
      if (selectedUnit != null) {
        boolean actionCompleted = currentLevel.handleTileAction(mx, my, selectedUnit, mode);
        if (actionCompleted) {
          if (selectedUnit.hasActed()) {
            selectedUnit = null;
          }
        }
      } else {
        Unit clicked = currentLevel.selectUnit(mx, my, player1);
        if (clicked != null && (!clicked.moved || !clicked.attacked)) {
          selectedUnit = clicked;
          mode = "move";
          toggleButton = new Button(width - guiWidth + 25, 240, 150, 40, "Toggle Mode");
          unselectButton = new Button(width - guiWidth + 25, 290, 150, 40, "Unselect");
        }
      }
    }
  }

  void startTrainingCamp() {
    currentLevel = new TrainingCampLevel(width - guiWidth, height);
    currentLevel.placeInitialUnits(player1, enemy);
    victoryAchieved = false;
  }

  void resetToMenu() {
    showMenu = true;
    victoryAchieved = false;
    currentLevel = null;
    selectedUnit = null;
  }

  void checkVictoryCondition() {
    ArrayList<Unit> enemyList = currentLevel.getEnemyList();
    boolean enemyUnitsLeft = false;
    for (int i = 0; i < enemyList.size(); i++) {
      Unit u = enemyList.get(i);
      if (u.health > 0) {
        enemyUnitsLeft = true;
      break;
      }
    }
    if (!enemyUnitsLeft) {
      victoryAchieved = true;
    }
}

  void displayUnitGUI(Unit unit) {
    fill(200);
    rect(width - guiWidth, 0, guiWidth, height);
    fill(0);
    textSize(18);
    textAlign(LEFT, TOP);
    text("Unit Info", width - guiWidth + 10, 10);
    text("Type: Infantry", width - guiWidth + 10, 40);
    text("Health: " + unit.health, width - guiWidth + 10, 70);
    text("Morale: 100", width - guiWidth + 10, 100);
    text("Ammo: 10", width - guiWidth + 10, 130);
    text("Fuel: 5", width - guiWidth + 10, 160);
    text("Mode: " + mode.toUpperCase(), width - guiWidth + 10, 200);
  }
}
