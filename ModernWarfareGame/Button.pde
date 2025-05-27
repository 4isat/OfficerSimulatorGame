class Button {
  private float x, y, w, h;
  private String label;

  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  float getX() { return x; }
  float getY() { return y; }
  float getWidth() { return w; }
  float getHeight() { return h; }
  String getLabel() { return label; }

  void setX(float x) { this.x = x; }
  void setY(float y) { this.y = y; }
  void setWidth(float w) { this.w = w; }
  void setHeight(float h) { this.h = h; }
  void setLabel(String label) { this.label = label; }

  void display() {
    fill(180);
    rect(x, y, w, h);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(16);
    text(label, x + w / 2, y + h / 2);
  }

  boolean isClicked(float mx, float my) {
    return (mx >= x && mx <= x + w && my >= y && my <= y + h);
  }
}
