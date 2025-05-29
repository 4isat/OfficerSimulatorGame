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
  private Player player1;
  private Player enemy;
  private Level currentLevel;
  private boolean showMenu = true;
  private boolean victoryAchieved = false;
  private Unit selectedUnit = null;
  private String mode = "move";
  private Button toggleButton;
  private Button unselectButton;
  private Button endTurnButton;
  private Button returnToMenuButton;
  private final int guiWidth = 200;

  MainGame() {
    player1 = new Player("Player 1", true);
    enemy = new Player("Enemy", false);
    endTurnButton = new Button(width - guiWidth + 25, height - 140, 150, 40, "End Turn");
    returnToMenuButton = new Button(width - guiWidth + 25, height - 180, 150, 40, "Return to Menu");
  }
  Player getPlayer1() { return player1; }
  void setPlayer1(Player p) { player1 = p; }

  Player getEnemy() { return enemy; }
  void setEnemy(Player e) { enemy = e; }

  Level getCurrentLevel() { return currentLevel; }
  void setCurrentLevel(Level l) { currentLevel = l; }

  boolean isShowMenu() { return showMenu; }
  void setShowMenu(boolean s) { showMenu = s; }

  boolean isVictoryAchieved() { return victoryAchieved; }
  void setVictoryAchieved(boolean v) { victoryAchieved = v; }

  Unit getSelectedUnit() { return selectedUnit; }
  void setSelectedUnit(Unit u) { selectedUnit = u; }

  String getMode() { return mode; }
  void setMode(String m) { mode = m; }

  Button getToggleButton() { return toggleButton; }
  void setToggleButton(Button b) { toggleButton = b; }

  Button getUnselectButton() { return unselectButton; }
  void setUnselectButton(Button b) { unselectButton = b; }

  Button getEndTurnButton() { return endTurnButton; }
  void setEndTurnButton(Button b) { endTurnButton = b; }

  Button getReturnToMenuButton() { return returnToMenuButton; }
  void setReturnToMenuButton(Button b) { returnToMenuButton = b; }

  int getGuiWidth() { return guiWidth; }

  void display() {
    if (showMenu) {
      displayMenu();
    } else {
      if (victoryAchieved) {
        displayVictoryScreen();
      } else {
        if (currentLevel != null) {
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
      if (mx >= width / 2 - 150 && mx <= width / 2 + 150 && my >= height / 2 - 40 && my <= height / 2 + 40) {
        startTrainingCamp();
        showMenu = false;
      }
    } else {
      if (victoryAchieved) {
        if (returnToMenuButton.isClicked(mx, my)) {
          resetToMenu();
        }
      } else {
        if (selectedUnit != null && toggleButton.isClicked(mx, my)) {
          if (mode.equals("move")) {
            mode = "attack";
          } else {
            mode = "move";
          }
          currentLevel.highlightRange(selectedUnit, mode);
        } else {
          if (selectedUnit != null && unselectButton.isClicked(mx, my)) {
            currentLevel.clearHighlights();
            selectedUnit = null;
          } else {
            if (endTurnButton.isClicked(mx, my)) {
              currentLevel.resetUnitActions(player1);
              selectedUnit = null;
              currentLevel.clearHighlights();
              checkVictoryCondition();
            } else {
              if (currentLevel != null) {
                if (selectedUnit != null) {
                  boolean actionCompleted = currentLevel.handleTileAction(mx, my, selectedUnit, mode);
                  if (actionCompleted) {
                    selectedUnit = null;
                    currentLevel.clearHighlights();
                  }
                } else {
                  Unit clicked = currentLevel.selectUnit(mx, my, player1);
                  if (clicked != null) {
                    if (!clicked.hasMoved() || !clicked.hasAttacked()) {
                      selectedUnit = clicked;
                      mode = "move";
                      toggleButton = new Button(width - guiWidth + 25, 370, 150, 40, "Toggle Mode");
                      unselectButton = new Button(width - guiWidth + 25, 320, 150, 40, "Unselect");
                    }
                  }
                }
              }
            }
          }
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
      if (u.getHealth() > 0) {
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
    text("Type: " + unit.getType(), width - guiWidth + 10, 40);
    text("Health: " + unit.getHealth() + " / " + unit.getEffectiveMaxHealth(), width - guiWidth + 10, 70);
    text("Morale: " + unit.getMorale(), width - guiWidth + 10, 100);
    text("Effective Dmg: " + unit.getEffectiveDamage(), width - guiWidth + 10, 130);
    text("Ammo: " + unit.getAmmo(), width - guiWidth + 10, 160);
    text("Fuel: " + unit.getFuel(), width - guiWidth + 10, 190);
    text("Mode: " + mode.toUpperCase(), width - guiWidth + 10, 230);
  }
}
