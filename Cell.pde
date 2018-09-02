class Cell {
  public boolean OpenUp;
  public boolean OpenDown;
  public boolean OpenLeft;
  public boolean OpenRight;

  public boolean HasPower;

  public Cell() {
    OpenUp = false;
    OpenDown = false;
    OpenLeft = false;
    OpenRight = false;

    HasPower = false;
  }

  public void Draw(float xPos, float yPos, float size) {
    pushMatrix();
    translate(xPos, yPos);
    strokeWeight(1 * SCALE);
    stroke(0);

    float posOffset = size / 2;
    rect(-posOffset, -posOffset, size, size);

    if (HasPower)
      stroke(0, 255, 0);
    else
      stroke(0);

    strokeWeight(2 * SCALE);
    posOffset -= 1 * SCALE;
    if (OpenUp)
      line(0, 0, 0, -posOffset);
    if (OpenDown)
      line(0, 0, 0, posOffset);
    if (OpenLeft)
      line(0, 0, -posOffset, 0);
    if (OpenRight)
      line(0, 0, posOffset, 0);

    popMatrix();
  }
}