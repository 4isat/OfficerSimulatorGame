abstract class Unit {
  Player owner;
  int gridX, gridY;
  int health;
  int baseMaxHealth;
  int attackPower;
  int morale;
  int ammo;
  int fuel;

  boolean moved = false;
  boolean attacked = false;

  Unit(Player owner, int gridX, int gridY) {
    this.owner = owner;
    this.gridX = gridX;
    this.gridY = gridY;
    this.morale = 100;
    this.ammo = 7; 
    this.fuel = 10;  
  }

  abstract void display(float centerX, float centerY, float size);
  abstract int getRange();
  abstract int getAttackRange();
  abstract String getType();

  int getEffectiveDamage() {
    return (int)(attackPower * (morale / 100.0));
  }

  int getEffectiveMaxHealth() {
    int reduced = (int)(morale / 10.0);
    int effective = baseMaxHealth - reduced;
    return max(effective, 1);
  }

  void move(int newX, int newY) {
    if (fuel > 0) {
      this.gridX = newX;
      this.gridY = newY;
      this.moved = true;
      this.fuel -= 1;
    }
  }

  void attack(Unit target) {
    if (ammo > 0) {
      int damage = getEffectiveDamage();
      target.health -= damage;
      if (target.health <= 0) {
        target.health = 0;
        this.morale += 40;
      } else {
        target.morale -= 20;
        if (target.morale < 0) target.morale = 0;
      }
      this.attacked = true;
      this.ammo -= 1; 
    }
  }

  void updateEffectiveHealth() {
    int effectiveMax = getEffectiveMaxHealth();
    if (health > effectiveMax) {
      health = effectiveMax;
    }
  }

  boolean hasActed() {
    return moved && attacked;
  }
}

class InfantryUnit extends Unit {
  
  InfantryUnit(Player owner, int gridX, int gridY) {
    super(owner, gridX, gridY);
    this.attackPower = 25;
    this.baseMaxHealth = 120;
    this.health = baseMaxHealth;
  }

  @Override
  void display(float centerX, float centerY, float size) {
    if (owner.isHuman) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    ellipse(centerX, centerY, size * 0.6, size * 0.6);
  }

  @Override
  int getRange() {
    return 3;
  }
  
  @Override
  int getAttackRange(){
    return 1;
  }
  
  @Override
  String getType(){
    return "Infantry";
  }
}

class CavalryUnit extends Unit {
  
  CavalryUnit(Player owner, int gridX, int gridY) {
    super(owner, gridX, gridY);
    this.attackPower = 35;
    this.baseMaxHealth = 250;
    this.health = baseMaxHealth;
  }

  @Override
  void display(float centerX, float centerY, float size) {
    if (owner.isHuman) {
      fill(0, 0, 255);
    } else {
      fill(255, 165, 0); 
    }
    ellipse(centerX, centerY, size * 0.7, size * 0.7);
  }

  @Override
  int getRange() {
    return 6;
  }
  
  @Override
  int getAttackRange(){
    return 2;
  }
  
  @Override
  String getType(){
    return "Cavalry";
  }
}

class ArtilleryUnit extends Unit {

  ArtilleryUnit(Player owner, int gridX, int gridY) {
    super(owner, gridX, gridY);
    this.attackPower = 80;  
    this.baseMaxHealth = 60;
    this.health = baseMaxHealth;
    this.fuel = 6;    
    this.ammo = 4;   
  }

  @Override
  void display(float centerX, float centerY, float size) {
    if (owner.isHuman) {
      fill(128, 0, 128); 
    } else {
      fill(139, 69, 19);
    }
    rect(centerX - size * 0.3, centerY - size * 0.3, size * 0.6, size * 0.6);
  }

  @Override
  int getRange() {
    return 2; 
  }

  @Override
  int getAttackRange() {
    return 9; 
  }

  @Override
  String getType() {
    return "Artillery";
  }

  @Override
  void attack(Unit target) {
    if (ammo > 0) {
      int tx = target.gridX;
      int ty = target.gridY;
      //the above is leftover from when I wanted to implement splash damage but that might have to wait. 
      target.health -= attackPower;
      if (target.health <= 0) {
        target.health = 0;
        this.morale += 40;
      } else {
        target.morale -= 20;
        if (target.morale < 0) target.morale = 0;
      }
      this.attacked = true;
      this.ammo -= 1;
    }
  }
}
