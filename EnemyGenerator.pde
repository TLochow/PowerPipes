class EnemyGenerator {
  int _level;

  public EnemyGenerator() {
    _level = 1;
  }

  public Enemy GenerateEnemy() {
    float health = 100 * _level;
    int shootingSpeed = 1;
    float baseDamage = 1;
    float shieldOnlyDamage = 0;
    float shieldBustingDamage = 0;

    for (int i = 0; i < _level * 2; i++) {
      int attributeToIncrease = floor(random(4));
      switch (attributeToIncrease) {
      case 0:
        shootingSpeed++;
        break;
      case 1:
        baseDamage += 1;
        break;
      case 2:
        shieldOnlyDamage += 1;
        break;
      case 3:
        shieldBustingDamage += 1;
        break;
      }
    }

    _level++;

    return new Enemy(health, shootingSpeed, baseDamage, shieldOnlyDamage, shieldBustingDamage);
  }
}