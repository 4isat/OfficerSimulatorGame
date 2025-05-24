class Button {
  float x, y, w, h;
  String label;

  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  void display() {
    fill(180);
    rect(x, y, w, h);
    fill(0);
    textAlign(CENTER, CENTER);
    text(label, x+w/2, y+h/2);
  }

  boolean isClicked(float mx, float my) {
    return (mx >=x && mx <= x + w && my>=y && my <= y+h);
  }
}
