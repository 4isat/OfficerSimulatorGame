abstract class Unit {
  Player owner;
  int gridX, gridY;
  int health;
  int maxHealth;
  int attackPower;

  boolean moved = false;
  boolean attacked = false;

  Unit(Player owner, int gridX, int gridY) {
    this.owner = owner;
    this.gridX = gridX;
    this.gridY = gridY;
  }

  abstract void display(float centerX, float centerY);
  abstract int getRange();

  void move(int newX, int newY) {
    this.gridX = newX;
    this.gridY = newY;
    this.moved = true;
  }

  void attack(Unit target) {
    target.health -= this.attackPower;
    if (target.health < 0) target.health = 0;
    this.attacked = true;
  }

  boolean hasActed() {
    return moved && attacked;
  }
}

class InfantryUnit extends Unit {

  InfantryUnit(Player owner, int gridX, int gridY) {
    super(owner, gridX, gridY);
    this.attackPower = 25;
    this.maxHealth = 120;
    this.health = maxHealth;
  }

  @Override
  void display(float centerX, float centerY) {
    if (owner.isHuman) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    ellipse(centerX, centerY, 30, 30);
  }

  @Override
  int getRange() {
    return 3;
  }
}
