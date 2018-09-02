class Bullet {
  public float BaseDamage;
  public float ShieldOnlyDamage;
  public float HullOnlyDamage;

  public float Speed;
  public float DistanceTraveled;

  public Bullet(float speed, float baseDamage, float shieldOnlyDamage, float hullOnlyDamage) {
    BaseDamage = baseDamage;
    ShieldOnlyDamage = shieldOnlyDamage;
    HullOnlyDamage = hullOnlyDamage;

    Speed = speed;
    DistanceTraveled = 0;
  }

  public boolean Update() {
    DistanceTraveled += Speed;
    return DistanceTraveled >= 500;
  }

  public void Draw(float yPos, boolean flipSide) {
    noStroke();
    fill(255);
    float xPos = map(DistanceTraveled, 0, 500, -150 * SCALE, 150 * SCALE);
    if (flipSide)
      xPos *= -1;
    float size = 10 * SCALE;
    ellipse(xPos, yPos, size, size);
  }
}