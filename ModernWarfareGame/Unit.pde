abstract class Unit {
  private Player owner;
  private int gridX, gridY;
  private int health;
  private int baseMaxHealth;
  private int attackPower;
  private int morale;
  private int ammo;
  private int fuel;
  private int ID;

  private boolean moved = false;
  private boolean attacked = false;

  Unit(Player owner, int gridX, int gridY, int ID) {
    this.owner = owner;
    this.gridX = gridX;
    this.gridY = gridY;
    this.morale = 100;
    this.ammo = 7;
    this.fuel = 10;
    if (this.owner.getName().equals("Enemy")){
      this.fuel = 9999;
      this.ammo = 9999;
    }
    this.ID = ID;
  }

  Player getOwner() { return owner; }
  void setOwner(Player owner) { this.owner = owner; }

  int getID() { return ID; }
  void setID(int x) { this.ID = x; }

  int getGridX() { return gridX; }
  void setGridX(int x) { this.gridX = x; }

  int getGridY() { return gridY; }
  void setGridY(int y) { this.gridY = y; }

  int getHealth() { return health; }
  void setHealth(int health) { this.health = health; }

  int getBaseMaxHealth() { return baseMaxHealth; }
  void setBaseMaxHealth(int maxHealth) { this.baseMaxHealth = maxHealth; }

  int getAttackPower() { return attackPower; }
  void setAttackPower(int attackPower) { this.attackPower = attackPower; }

  int getMorale() { return morale; }
  void setMorale(int morale) { this.morale = morale; }

  int getAmmo() { return ammo; }
  void setAmmo(int ammo) { this.ammo = ammo; }

  int getFuel() { return fuel; }
  void setFuel(int fuel) { this.fuel = fuel; }

  boolean hasMoved() { return moved; }
  void setMoved(boolean moved) { this.moved = moved; }

  boolean hasAttacked() { return attacked; }
  void setAttacked(boolean attacked) { this.attacked = attacked; }

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
      setGridX(newX);
      setGridY(newY);
      setMoved(true);
      setFuel(fuel - 1);
    }
  }

  void attack(Unit target) {
    if (ammo > 0) {
      int damage = getEffectiveDamage();
      target.setHealth(target.getHealth() - damage);
      if (target.getHealth() <= 0) {
        target.setHealth(0);
        setMorale(morale + 40);
      } else {
        target.setMorale(target.getMorale() - 20);
        if (target.getMorale() < 0) target.setMorale(0);
      }
      setAttacked(true);
      setAmmo(ammo - 1);
      morale += 5;
    }
  }

  void consumeAmmo(){
   this.ammo -= 1; 
  }

  void updateEffectiveHealth() {
    int effectiveMax = getEffectiveMaxHealth();
    if (health > effectiveMax) {
      setHealth(effectiveMax);
    }
  }

  boolean hasActed() {
    return moved && attacked;
  }
}

class InfantryUnit extends Unit {

  InfantryUnit(Player owner, int gridX, int gridY, int ID) {
    super(owner, gridX, gridY, ID);
    setAttackPower(25);
    setBaseMaxHealth(120);
    setHealth(getBaseMaxHealth());
  }

  @Override
  void display(float centerX, float centerY, float size) {
    if (getOwner().isHuman) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    ellipse(centerX, centerY, size * 0.6, size * 0.6);
  }

  @Override
  int getRange() { return 3; }

  @Override
  int getAttackRange() { return 1; }

  @Override
  String getType() { return "Infantry"; }
}

class CavalryUnit extends Unit {

  CavalryUnit(Player owner, int gridX, int gridY, int ID) {
    super(owner, gridX, gridY, ID);
    setAttackPower(35);
    setBaseMaxHealth(250);
    setHealth(getBaseMaxHealth());
  }

  @Override
  void display(float centerX, float centerY, float size) {
    if (getOwner().isHuman) {
      fill(128, 0, 128);
    } else {
      fill(139, 69, 19);
    }
    ellipse(centerX, centerY, size * 0.7, size * 0.7);
  }

  @Override
  int getRange() { return 6; }

  @Override
  int getAttackRange() { return 2; }

  @Override
  String getType() { return "Cavalry"; }
}

class ArtilleryUnit extends Unit {
  
  private int damageDealt = 80;

  ArtilleryUnit(Player owner, int gridX, int gridY, int ID) {
    super(owner, gridX, gridY, ID);
    setAttackPower(80);
    setBaseMaxHealth(60);
    setHealth(getBaseMaxHealth());
    setFuel(6);
    setAmmo(4);
    if (this.getOwner().getName().equals("Enemy")){
      this.setFuel(9999);
      this.setAmmo(9999);
    }
  }

  @Override
  void display(float centerX, float centerY, float size) {
    if (getOwner().isHuman) {
      fill(128, 0, 128);
    } else {
      fill(139, 69, 19);
    }
    rect(centerX - size * 0.3, centerY - size * 0.3, size * 0.6, size * 0.6);
  }

  @Override
  int getRange() { return 2; }

  @Override
  int getAttackRange() { return 9; }

  @Override
  String getType() { return "Artillery"; }

  @Override
  void attack(Unit target) {
    if (getAmmo() > 0) {
      if (target.getType().equals("Cavalry") || target.getType().equals("Artillery")) {
        target.setHealth(target.getHealth() - getAttackPower());
        damageDealt = getAttackPower();
      } else {
        target.setHealth((int)(target.getHealth() - getAttackPower() * 0.3));
        damageDealt = (int)(getAttackPower() * 0.3);
      }
      if (target.getHealth() <= 0) {
        target.setHealth(0);
        setMorale(getMorale() + 40);
      } else {
        target.setMorale(target.getMorale() - 20);
        if (target.getMorale() < 0) target.setMorale(0);
      }
      
      setAttacked(true);
      setAmmo(getAmmo() - 1);
    }
  }
  
  @Override
  int getEffectiveDamage(){
    
    return damageDealt;
  }
}

class LogisticsUnit extends Unit {

  LogisticsUnit(Player owner, int gridX, int gridY, int ID) {
    super(owner, gridX, gridY, ID);
    setAttackPower(15);
    setBaseMaxHealth(80);
    setHealth(getBaseMaxHealth());
    setFuel(45);
    setAmmo(99);
  }

  @Override
  void display(float centerX, float centerY, float size) {
    if (getOwner().isHuman) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    ellipse(centerX, centerY, size * 0.6, size * 0.6);
  }

  @Override
  int getRange() { return 3; }

  @Override
  int getAttackRange() { return 1; }

  @Override
  String getType() { return "Supply"; }

  @Override
  void attack(Unit target) {
    if (getAmmo() > 0) {
      if (target.getHealth() < target.getBaseMaxHealth()) {
        int heal = getEffectiveDamage();
        target.setHealth(target.getHealth() + heal);
        if (target.getHealth() >= target.getBaseMaxHealth()) {
          target.setHealth(target.getBaseMaxHealth());
        }
      }
      target.setAmmo(target.getAmmo() + 15);
      target.setFuel(target.getFuel() + 15);
      target.setMorale(target.getMorale() + 15);
      setMorale(getMorale() + 10);
      setAttacked(true);
    }
  }
}

class DroneUnit extends Unit {

  private boolean didHit = true;
  
  DroneUnit(Player owner, int gridX, int gridY, int ID) {
    super(owner, gridX, gridY, ID);
    setAttackPower(60);
    setBaseMaxHealth(80);
    setHealth(getBaseMaxHealth());
    if (this.getOwner().getName().equals("Enemy")){
      this.setFuel(9999);
      this.setAmmo(9999);
    }
  }

  @Override
  void display(float centerX, float centerY, float size) {
    if (getOwner().isHuman) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    rect(centerX - size * 0.3, centerY - size * 0.3, size * 0.6, size * 0.6);
  }

  @Override
  int getRange() { return 3; }

  @Override
  int getAttackRange() { return 7; }

  @Override
  String getType() { return "Drone Unit"; }

  @Override
  void attack(Unit target) {
    if (getAmmo() > 0) {
      double probability = 1;
      double actualProbability = Math.random();
      if (target.getType().equals("Infantry")) {
        probability = 0.5;
      }
      if (actualProbability < probability) {
        didHit = true;
        int damage = getEffectiveDamage();
        target.setHealth(target.getHealth() - damage);
        if (target.getHealth() <= 0) {
          target.setHealth(0);
          setMorale(getMorale() + 40);
        } else {
          target.setMorale(target.getMorale() - 20);
          if (target.getMorale() < 0) target.setMorale(0);
        }
      }
      else{
        didHit = false;   
      }
      setAmmo(getAmmo() - 1);
      setAttacked(true);
    }
  }
  
  @Override
  int getEffectiveDamage(){
    if (didHit){
      return (int)(this.getAttackPower() * (this.getMorale() / 100.0));
    }
    else{
      return 0;
    }
  }  
}
