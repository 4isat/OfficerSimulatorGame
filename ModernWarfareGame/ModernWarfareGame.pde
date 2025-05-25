MainGame game;

void setup() {
  size(800, 600);
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

  Unit selectedUnit = null;
  String mode = "move";

  Button toggleButton;
  Button unselectButton;
  Button endTurnButton;

  MainGame() {
    player1 = new Player("Player 1", true);
    enemy = new Player("Enemy", false);
    endTurnButton = new Button(width - 150, 500, 120, 40, "End Turn");
  }

  void display() {
    if (showMenu) {
      displayMenu();
    } else if (currentLevel != null) {
      currentLevel.display();
      if (selectedUnit != null) {
        displayUnitGUI(selectedUnit);
        toggleButton.display();
        unselectButton.display();
      }
      endTurnButton.display();
      fill(0);
      textAlign(LEFT, TOP);
      text(currentLevel.getObjective(), 10, 10);
    }
  }

  void displayMenu() {
    background(100, 150, 200);
    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("Modern Warfare Game", width / 2, height / 4);
    fill(50, 200, 50);
    rect(width / 2 - 100, height / 2 - 25, 200, 50);
    fill(0);
    textSize(20);
    text("Start Training Camp", width / 2, height / 2);
  }

  void handleClick(float mx, float my) {
    if (showMenu) {
      if (mx >= width / 2 - 100 && mx <= width / 2 + 100 &&
          my >= height / 2 - 25 && my <= height / 2 + 25) {
        startTrainingCamp();
        showMenu = false;
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
          toggleButton = new Button(width - 150, 300, 120, 40, "Toggle Mode");
          unselectButton = new Button(width - 150, 350, 120, 40, "Unselect");
        }
      }
    }
  }

  void startTrainingCamp() {
    currentLevel = new TrainingCampLevel();
    currentLevel.placeInitialUnits(player1, enemy);
  }

  void displayUnitGUI(Unit unit) {
    fill(200);
    rect(width - 200, 0, 200, height);
    fill(0);
    textSize(14);
    textAlign(LEFT, TOP);
    text("Unit Info", width - 190, 10);
    text("Type: Infantry", width - 190, 40);
    text("Health: " + unit.health, width - 190, 70);
    text("Morale: 100", width - 190, 100);
    text("Ammo: 10", width - 190, 130);
    text("Fuel: 5", width - 190, 160);
    text("Mode: " + mode.toUpperCase(), width - 190, 200);
  }
}
