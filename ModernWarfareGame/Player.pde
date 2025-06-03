class Player {
  private String name;
  private boolean isHuman;

  Player(String name, boolean isHuman) {
    this.name = name;
    this.isHuman = isHuman;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public boolean isHuman() {
    return isHuman;
  }

  public void setHuman(boolean isHuman) {
    this.isHuman = isHuman;
  }
}
