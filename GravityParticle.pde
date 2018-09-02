class GravityParticle extends IParticle {
  PVector _position;
  float _xMovement;
  float _yMovement;
  float _size;
  color _colorValue;

  public GravityParticle(float xPos, float yPos, float heading, float speed, float size, color colorValue) {
    _position = new PVector(xPos, yPos);
    _xMovement = speed * cos(heading) * SCALE;
    _yMovement = speed * sin(heading) * SCALE;
    _size = size * SCALE;
    _colorValue = colorValue;
  }

  public boolean Update() {
    _position.x += _xMovement;
    _position.y += _yMovement;
    _yMovement += 0.2;

    return _position.y > (height / 2) + _size;
  }

  void Draw() {
    noStroke();
    fill(_colorValue);
    ellipse(_position.x, _position.y, _size, _size);
  }
}