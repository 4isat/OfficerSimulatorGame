import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

public class EnemyController {
  private Player enemyPlayer;
  private ArrayList<Unit> enemyUnits;
  private Level level;
  private Tile[][] grid;

  public EnemyController(Player enemyPlayer, ArrayList<Unit> enemyUnits, Level level) {
    this.enemyPlayer = enemyPlayer;
    this.enemyUnits = enemyUnits;
    this.level = level;
    this.grid = level.getGrid();
  }

  public void takeTurn(ArrayList<Unit> playerUnits) {
    for (int i = 0; i < enemyUnits.size(); i++) {
      Unit enemy = enemyUnits.get(i);
      if (enemy.getHealth() <= 0) {
        continue;
      }
      Unit target = findClosestTarget(enemy, playerUnits);
      if (target != null) {
        if (enemy.getMorale() < 25 && enemy.getFuel() > 0 && !enemy.hasMoved()) {
          int moveRange = enemy.getRange();
          int startX = enemy.getGridX();
          int startY = enemy.getGridY();
          ArrayList<int[]> retreatCandidates = new ArrayList<int[]>();
        
          for (int dxOffset = -moveRange; dxOffset <= moveRange; dxOffset++) {
            for (int dyOffset = -moveRange; dyOffset <= moveRange; dyOffset++) {
              int newX = startX + dxOffset;
              int newY = startY + dyOffset;
              if (Math.abs(dxOffset) + Math.abs(dyOffset) <= moveRange && level.isValidCoordinate(newX, newY)) {
                if (grid[newX][newY].getUnit() == null) {
                  retreatCandidates.add(new int[]{ newX, newY });
                }
              }
            }
          }
          Collections.sort(retreatCandidates, new Comparator<int[]>() {
            public int compare(int[] a, int[] b) {
              int da = Math.abs(a[0] - target.getGridX()) + Math.abs(a[1] - target.getGridY());
              int db = Math.abs(b[0] - target.getGridX()) + Math.abs(b[1] - target.getGridY());
              return Integer.compare(db, da);
            }
          });
          if (!retreatCandidates.isEmpty()) {
            int[] farthest = retreatCandidates.get(0);
            level.moveUnitOnGrid(enemy, farthest[0], farthest[1]);
            enemy.setMoved(true);
            continue;
          }
        }
        int dx = target.getGridX() - enemy.getGridX();
        int dy = target.getGridY() - enemy.getGridY();
        int dist = Math.abs(dx) + Math.abs(dy);
        if (dist > enemy.getAttackRange() && enemy.getFuel() > 0 && !enemy.hasMoved()) {
          int moveRange = enemy.getRange();
          int startX = enemy.getGridX();
          int startY = enemy.getGridY();
          ArrayList<int[]> candidates = new ArrayList<int[]>();

          for (int dxOffset = -moveRange; dxOffset <= moveRange; dxOffset++) {
            for (int dyOffset = -moveRange; dyOffset <= moveRange; dyOffset++) {
              int newX = startX + dxOffset;
              int newY = startY + dyOffset;
              if (Math.abs(dxOffset) + Math.abs(dyOffset) <= moveRange && level.isValidCoordinate(newX, newY)) {
                if (grid[newX][newY].getUnit() == null) {
                  candidates.add(new int[]{ newX, newY });
                }
              }
            }
          }
          Collections.sort(candidates, new Comparator<int[]>() {
            public int compare(int[] a, int[] b) {
              int da = Math.abs(a[0] - target.getGridX()) + Math.abs(a[1] - target.getGridY());
              int db = Math.abs(b[0] - target.getGridX()) + Math.abs(b[1] - target.getGridY());
              return Integer.compare(da, db);
            }
          });
          if (!candidates.isEmpty()) {
            int[] best = candidates.get(0);
            level.moveUnitOnGrid(enemy, best[0], best[1]);
          }
        }
        int newDist = Math.abs(target.getGridX() - enemy.getGridX()) + Math.abs(target.getGridY() - enemy.getGridY());
        if (newDist <= enemy.getAttackRange() && enemy.getAmmo() > 0 && !enemy.hasAttacked()) {
          String terrain = grid[target.getGridX()][target.getGridY()].getTerrain();
          if (terrain.equals("forest") || terrain.equals("building")) {
            int damageToTile;
            if (enemy.getType().equals("Artillery")) {
              damageToTile = 100;
            } else {
              damageToTile = enemy.getEffectiveDamage();
            }
            int currentHealth = grid[target.getGridX()][target.getGridY()].getHealth();
            grid[target.getGridX()][target.getGridY()].setHealth(currentHealth - damageToTile);

            if (grid[target.getGridX()][target.getGridY()].getHealth() <= 0) {
              grid[target.getGridX()][target.getGridY()].setTerrain("P");
              grid[target.getGridX()][target.getGridY()].setHealth(0);
            }
          } else {
            enemy.attack(target);
          }
          boolean killed = target.getHealth() <= 0;
          if (killed) {
            grid[target.getGridX()][target.getGridY()].setUnit(null);
          }
        }
        enemy.setMoved(false);
        enemy.setAttacked(false);
      }
    }
  }

  private Unit findClosestTarget(Unit enemy, ArrayList<Unit> playerUnits) {
    Unit closest = null;
    int minDist = Integer.MAX_VALUE;
    for (int i = 0; i < playerUnits.size(); i++) {
      Unit unit = playerUnits.get(i);
      if (unit.getHealth() <= 0) {
        continue;
      }
      int dist = Math.abs(enemy.getGridX() - unit.getGridX()) + Math.abs(enemy.getGridY() - unit.getGridY());
      if (dist < minDist) {
        minDist = dist;
        closest = unit;
      }
    }
    return closest;
  }

  public Player getEnemyPlayer() {
    return enemyPlayer;
  }

  public ArrayList<Unit> getEnemyUnits() {
    return enemyUnits;
  }

  public void setEnemyPlayer(Player enemyPlayer) {
    this.enemyPlayer = enemyPlayer;
  }

  public void setEnemyUnits(ArrayList<Unit> enemyUnits) {
    this.enemyUnits = enemyUnits;
  }
}
