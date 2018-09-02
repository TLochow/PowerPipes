class Scrap {
  public PVector Position;
  public int Value;

  private float _direction;
  private float _rotation;
  private float _rotationSpeed;
  private float[] _spikes;

  private float dist;

  public Scrap(float xPos, float yPos, int value) {
    Position = new PVector(xPos, yPos);
    Value = value;
    dist = 1000;

    _direction = random(0, TWO_PI);
    _rotation = 0.0;
    _rotationSpeed = random(-0.1, 0.1);
    _spikes = new float[value + 4];
    for (int i = 0; i < value + 4; i++) {
      _spikes[i] = random(0.0, 1.0);
    }
  }

  public boolean Update(float playerXPos, float playerYPos) {
    PVector playerPosition = new PVector(playerXPos, playerYPos);

    _direction = lerp(_direction, playerPosition.sub(Position).heading(), 0.5);
    Position.x += cos(_direction) * 3 * SCALE;
    Position.y += sin(_direction) * 3 * SCALE;

    _rotation += _rotationSpeed;
    if (_rotation > TWO_PI)
      _rotation -= TWO_PI;
    else if (_rotation < 0)
      _rotation += TWO_PI;
    float d = playerPosition.dist(Position);
    if (d < dist)
      dist = d;
    return playerPosition.dist(Position) < 140;
  }

  public void Draw() {
    fill(175);
    beginShape();
    for (int i = 0; i < _spikes.length; i++) {
      float rotation = map(i, 0, _spikes.length, 0, TWO_PI) + _rotation;
      float x = (Position.x + (cos(rotation) * (Value / 10) * _spikes[i])) * SCALE;
      float y = (Position.y + (sin(rotation) * (Value / 10) * _spikes[i])) * SCALE;
      vertex(x, y);
    }
    endShape(CLOSE);
    fill(255);
    stroke(255);
    text(dist, Position.x, Position.y);
  }
}
