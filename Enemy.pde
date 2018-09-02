class Enemy {
  public float Health;

  int _counterUntilShooting;
  int _shootingSpeed;
  float _baseDamage;
  float _shieldOnlyDamage;
  float _shieldBustingDamage;
  
  float _baseSize;
  float _baseDamageRatio;
  float _shieldOnlyRatio;
  float _shieldBustingRatio;

  public Enemy(float health, int shootingSpeed, float baseDamage, float shieldOnlyDamage, float shieldBustingDamage) {
    Health = health;
    _shootingSpeed = shootingSpeed;
    _counterUntilShooting = 1000 - (shootingSpeed * 10);
    _baseDamage = baseDamage;
    _shieldOnlyDamage = shieldOnlyDamage;
    _shieldBustingDamage = shieldBustingDamage;
    
    float damageTotal = _baseDamage + _shieldOnlyDamage + _shieldBustingDamage;
    _baseSize = max(min(damageTotal / 3.0, 10), 1) * SCALE;
    _baseDamageRatio = (_baseDamage / damageTotal) * 2;
    _shieldOnlyRatio = (_shieldOnlyDamage / damageTotal) * 2;
    _shieldBustingRatio = (_shieldBustingDamage / damageTotal) * 2;
  }

  public Bullet Update() {
    Bullet shot = null;
    _counterUntilShooting--;
    if (_counterUntilShooting <= 0) {
      _counterUntilShooting = 250 - (_shootingSpeed * 10);
      shot = new Bullet(1, 15, 5, 5);
    }
    return shot;
  }

  public void Draw() {
    fill(255);
    noStroke();
    beginShape();
    vertex(_baseSize, 0);
    
    vertex(2 * _baseSize, (1 + _shieldBustingRatio) * _baseSize);
    vertex(0, (1 + _baseDamageRatio) * _baseSize);
    vertex(-2 * _baseSize, (1 - _shieldOnlyRatio) * _baseSize);
    
    vertex(-1 * _baseSize, 0);
    
    vertex(-2 * _baseSize, (-1 + _shieldOnlyRatio) * _baseSize);
    vertex(0, (-1 - _baseDamageRatio) * _baseSize);
    vertex(2 * _baseSize, (-1 - _shieldBustingRatio) * _baseSize);
    endShape(CLOSE);
    
    fill(255, 0, 0);
  }
}