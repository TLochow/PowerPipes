import java.text.DecimalFormat;

class Game extends IGameModule {
  Field _field;
  int _fieldSize;
  float _fieldYPosition;

  Cell _shieldCell;
  Cell _weaponsCell;
  Cell _repairCell;
  Cell _lifeSupportCell;

  Player _player;

  float _shield;
  float _weaponFire;
  float _hull;
  float _lifeSupport;

  float _hullCritical;
  float _lifeSupportCritical;

  float _screenShake;
  float _alarmCounter;

  EnemyGenerator _enemyGenerator;
  Enemy _currentEnemy;
  int _counterUntilNextEnemy;

  int _distanceToHomePlanet;

  ArrayList<Bullet> _playerBullets;
  ArrayList<Bullet> _enemyBullets;

  DecimalFormat _decimalFormat;

  ArrayList<IParticle> _particles;

  ArrayList<Scrap> _scrap;

  public Game(int fieldSize) {
    _fieldSize = fieldSize;
    _fieldYPosition = 160 * SCALE;

    _field = new Field(_fieldSize);

    _shieldCell = new Cell();
    _shieldCell.OpenDown = true;
    _shieldCell.HasPower = true;
    _weaponsCell = new Cell();
    _weaponsCell.OpenDown = true;
    _weaponsCell.HasPower = true;
    _repairCell = new Cell();
    _repairCell.OpenUp = true;
    _repairCell.HasPower = true;
    _lifeSupportCell = new Cell();
    _lifeSupportCell.OpenUp = true;
    _lifeSupportCell.HasPower = true;

    _player = new Player();

    _shield = 100;
    _weaponFire = 0;
    _hull = 100;
    _lifeSupport = 100;

    _hullCritical = _hull * 0.4;
    _lifeSupportCritical = _lifeSupport * 0.4;

    _screenShake = 100;
    _alarmCounter = 0;

    _enemyGenerator = new EnemyGenerator();
    _currentEnemy = null;
    _counterUntilNextEnemy = 1000;

    _distanceToHomePlanet = 150000;

    _playerBullets = new ArrayList<Bullet>();
    _enemyBullets = new ArrayList<Bullet>();
    _particles = new ArrayList<IParticle>();
    _scrap = new ArrayList<Scrap>();

    _decimalFormat = new DecimalFormat();
    _decimalFormat.setGroupingUsed(true);
    _decimalFormat.setGroupingSize(3);
    
    
        SpawnScrap(100);
  }

  public IGameModule Update() {
    if (_currentEnemy == null)
      _distanceToHomePlanet -= 5;
    else
      _distanceToHomePlanet--;

    float fieldMouseX = MOUSEX;
    float fieldMouseY = MOUSEY - _fieldYPosition;
    _field.Update(fieldMouseX, fieldMouseY);

    int max = _fieldSize - 1;
    float cellSize = (400 / _fieldSize) * SCALE;
    float xOffset = cellSize * (_fieldSize / 2);
    float yOffset = xOffset + cellSize;
    boolean beforeValue = _shieldCell.HasPower;
    _shieldCell.HasPower = _field.Cells[0][0].HasPower && _field.Cells[0][0].OpenUp;
    if (beforeValue != _shieldCell.HasPower) {
      for (int i = 0; i < 10; i++) {
        _particles.add(new GravityParticle(-xOffset, (_fieldYPosition - yOffset) + (cellSize / 4), random(TWO_PI), random (5, 10), 5, color(255, 255, 0)));
      }
    }

    beforeValue = _repairCell.HasPower;
    _repairCell.HasPower = _field.Cells[0][max].HasPower && _field.Cells[0][max].OpenDown;
    if (beforeValue != _repairCell.HasPower) {
      for (int i = 0; i < 10; i++) {
        _particles.add(new GravityParticle(-xOffset, (_fieldYPosition + yOffset) - (cellSize / 4), random(TWO_PI), random (5, 10), 5, color(255, 255, 0)));
      }
    }

    beforeValue = _weaponsCell.HasPower;
    _weaponsCell.HasPower = _field.Cells[max][0].HasPower && _field.Cells[max][0].OpenUp;
    if (beforeValue != _weaponsCell.HasPower) {
      for (int i = 0; i < 10; i++) {
        _particles.add(new GravityParticle(xOffset, (_fieldYPosition - yOffset) + (cellSize / 4), random(TWO_PI), random (5, 10), 5, color(255, 255, 0)));
      }
    }

    beforeValue = _lifeSupportCell.HasPower;
    _lifeSupportCell.HasPower = _field.Cells[max][max].HasPower && _field.Cells[max][max].OpenDown;
    if (beforeValue != _lifeSupportCell.HasPower) {
      for (int i = 0; i < 10; i++) {
        _particles.add(new GravityParticle(xOffset, (_fieldYPosition + yOffset) - (cellSize / 4), random(TWO_PI), random (5, 10), 5, color(255, 255, 0)));
      }
    }

    if (_weaponsCell.HasPower) {
      _weaponFire += 1;
      if (_weaponFire >= 100) {
        if (_currentEnemy == null) {
          _weaponFire = 100;
        } else {
          _weaponFire = 0;
          _playerBullets.add(new Bullet(2, 30, 0, 0));
          MISSILE.play();
        }
      }
    } else {
      if (_weaponFire > 0) {
        _weaponFire -= 0.1;
      }
    }

    if (_shieldCell.HasPower) {
      _shield += 0.1;
      if (_shield > 100) {
        _shield = 100;
      }
    } else {
      if (_shield > 0) {
        _shield -= 0.1;
      }
    }

    if (_repairCell.HasPower) {
      _hull += 0.05;
      if (_hull > 100) {
        _hull = 100;
      }
    }

    if (_lifeSupportCell.HasPower) {
      _lifeSupport += 0.05;
      if (_lifeSupport > 100) {
        _lifeSupport = 100;
      }
    } else {
      if (_lifeSupport > 0) {
        _lifeSupport -= 0.05;
      }
    }

    for (int i = _scrap.size() - 1; i >= 0; i--) {
      Scrap scrap = _scrap.get(i);
      if (scrap.Update(-175 * SCALE, -135 * SCALE)) {
        _player.Scrap += scrap.Value;
        _scrap.remove(i);
      }
    }

    for (int i = _playerBullets.size() - 1; i >= 0; i--) {
      Bullet currentBullet = _playerBullets.get(i);
      if (currentBullet.Update()) {
        if (_currentEnemy != null) {
          _currentEnemy.Health -= currentBullet.BaseDamage;
        }
        _playerBullets.remove(i);
        SpawnScrap(floor(random(1, 6)));
      }
    }
    for (int i = _enemyBullets.size() - 1; i >= 0; i--) {
      Bullet currentBullet = _enemyBullets.get(i);
      if (currentBullet.Update()) {
        _field.ShuffleField(round(currentBullet.BaseDamage / 10));
        _field.HoldingCell = null;
        _screenShake += currentBullet.BaseDamage;
        _shield -= currentBullet.BaseDamage;
        if (_shield < 0) {
          _hull += _shield;
          _shield = 0;
        }

        _hull -= currentBullet.HullOnlyDamage;
        _shield -= currentBullet.ShieldOnlyDamage;
        if (_shield < 0)
          _shield = 0;
        _enemyBullets.remove(i);
        EXPLOSION.play();
      }
    }

    if (_currentEnemy == null) {
      _counterUntilNextEnemy--;
      if (_counterUntilNextEnemy <= 0) {
        _counterUntilNextEnemy = 1000;
        _currentEnemy = _enemyGenerator.GenerateEnemy();
      }
    } else {
      if (_currentEnemy.Health <= 0) {
        SpawnScrap(_currentEnemy.StartHealth);
        _currentEnemy = null;
      }
      else {
        Bullet shot = _currentEnemy.Update();
        if (shot != null)
          _enemyBullets.add(shot);
      }
    }

    for (int i = _particles.size() - 1; i >= 0; i--) {
      if (_particles.get(i).Update())
        _particles.remove(i);
    }

    Menu menu = null;
    if (_hull <= 0 || _lifeSupport <= 0)
      menu = new Menu(_fieldSize);
    return menu;
  }

  public void Draw() {
    textAlign(CENTER, CENTER);
    if (_screenShake > 0) {
      translate(random(-_screenShake, _screenShake), random(-_screenShake, _screenShake));
      _screenShake -= 3;
      if (_screenShake < 0)
        _screenShake = 0;
    }
    noStroke();
    fill(255, 0, 0);
    rect(-180 * SCALE, map(_weaponFire, 100, 0, -290 * SCALE, -190 * SCALE), 20 * SCALE, map(_weaponFire, 0, 100, 0, 100 * SCALE));
    fill(0, 0, 255);
    rect(-150 * SCALE, map(_shield, 100, 0, -290 * SCALE, -190 * SCALE), 20 * SCALE, map(_shield, 0, 100, 0, 100 * SCALE));
    fill(150);
    rect(-130 * SCALE, map(_hull, 100, 0, -290 * SCALE, -190 * SCALE), 20 * SCALE, map(_hull, 0, 100, 0, 100 * SCALE));
    fill(0, 255, 0);
    rect(-100 * SCALE, map(_lifeSupport, 100, 0, -290 * SCALE, -190 * SCALE), 20 * SCALE, map(_lifeSupport, 0, 100, 0, 100 * SCALE));

    strokeWeight(3 * SCALE);
    stroke(255);
    noFill();
    rect(-200 * SCALE, -380 * SCALE, 400 * SCALE, 200 * SCALE);

    rect(-180 * SCALE, -290 * SCALE, 20 * SCALE, 100 * SCALE);
    rect(-150 * SCALE, -290 * SCALE, 20 * SCALE, 100 * SCALE);
    rect(-130 * SCALE, -290 * SCALE, 20 * SCALE, 100 * SCALE);
    rect(-100 * SCALE, -290 * SCALE, 20 * SCALE, 100 * SCALE);

    rect(-200 * SCALE, -160 * SCALE, 50 * SCALE, 50 * SCALE);
    rect(150 * SCALE, -160 * SCALE, 50 * SCALE, 50 * SCALE);
    line(-150 * SCALE, -135 * SCALE, 150 * SCALE, -135 * SCALE);

    noStroke();
    fill(255);
    rect(-70 * SCALE, -350 * SCALE, 250 * SCALE, 50 * SCALE);
    textSize(30 * SCALE);
    fill(0);
    text("UPGRADES", 55 * SCALE, -325 * SCALE);

    fill(255);
    textSize(15 * SCALE);
    text("S", -170 * SCALE, -352 * SCALE);
    text("H", -170 * SCALE, -339 * SCALE);
    text("O", -170 * SCALE, -326 * SCALE);
    text("O", -170 * SCALE, -313 * SCALE);
    text("T", -170 * SCALE, -300 * SCALE);

    text("S", -140 * SCALE, -365 * SCALE);
    text("H", -140 * SCALE, -352 * SCALE);
    text("I", -140 * SCALE, -339 * SCALE);
    text("E", -140 * SCALE, -326 * SCALE);
    text("L", -140 * SCALE, -313 * SCALE);
    text("D", -140 * SCALE, -300 * SCALE);

    text("H", -120 * SCALE, -339 * SCALE);
    text("U", -120 * SCALE, -326 * SCALE);
    text("L", -120 * SCALE, -313 * SCALE);
    text("L", -120 * SCALE, -300 * SCALE);

    text("L", -90 * SCALE, -339 * SCALE);
    text("I", -90 * SCALE, -326 * SCALE);
    text("F", -90 * SCALE, -313 * SCALE);
    text("E", -90 * SCALE, -300 * SCALE);

    for (Bullet currentBullet : _playerBullets)
      currentBullet.Draw(-135 * SCALE, false);
    for (Bullet currentBullet : _enemyBullets)
      currentBullet.Draw(-135 * SCALE, true);
    for (Scrap currentScrap : _scrap)
      currentScrap.Draw();

    // Draw Ship:
    fill(150);
    noStroke();
    pushMatrix();
    translate(-175 * SCALE, -135 * SCALE);
    beginShape();
    vertex(10 * SCALE, -2 * SCALE);
    vertex(-3 * SCALE, -3 * SCALE);
    vertex(-6 * SCALE, -10 * SCALE);
    vertex(-10 * SCALE, -10 * SCALE);
    vertex(-8 * SCALE, -5 * SCALE);
    vertex(-10 * SCALE, -3 * SCALE);

    vertex(-10 * SCALE, 3 * SCALE);
    vertex(-8 * SCALE, 5 * SCALE);
    vertex(-10 * SCALE, 10 * SCALE);
    vertex(-6 * SCALE, 10 * SCALE);
    vertex(-2 * SCALE, 3 * SCALE);
    vertex(8 * SCALE, 2 * SCALE);
    endShape(CLOSE);

    noFill();
    stroke(0, 0, 255, map(_shield, 0, 100, 0, 255));
    strokeWeight(2 * SCALE);
    beginShape();
    vertex(11 * SCALE, -3 * SCALE);
    vertex(-4 * SCALE, -4 * SCALE);
    vertex(-7 * SCALE, -11 * SCALE);
    vertex(-11 * SCALE, -11 * SCALE);
    vertex(-9 * SCALE, -6 * SCALE);
    vertex(-11 * SCALE, -4 * SCALE);

    vertex(-11 * SCALE, 4 * SCALE);
    vertex(-9 * SCALE, 6 * SCALE);
    vertex(-11 * SCALE, 11 * SCALE);
    vertex(-7 * SCALE, 11 * SCALE);
    vertex(-3 * SCALE, 4 * SCALE);
    vertex(9 * SCALE, 3 * SCALE);
    endShape(CLOSE);
    popMatrix();

    if (_currentEnemy != null) {
      pushMatrix();
      translate(175 * SCALE, -135 * SCALE);
      _currentEnemy.Draw();
      popMatrix();
    }

    fill(255, 0, 0);
    float cellSize = (400 / _fieldSize) * SCALE;
    float xOffset = cellSize * (_fieldSize / 2);
    float yOffset = xOffset + cellSize;

    if (_shieldCell.HasPower)
      fill(0, 0, 200);
    else
      fill(0, 0, 100);
    _shieldCell.Draw(-xOffset, (_fieldYPosition - yOffset) + (cellSize / 4), cellSize / 2);
    if (_weaponsCell.HasPower)
      fill(200, 0, 0);
    else
      fill(100, 0, 0);
    _weaponsCell.Draw(xOffset, (_fieldYPosition - yOffset) + (cellSize / 4), cellSize / 2);
    if (_repairCell.HasPower)
      fill(150);
    else
      fill(100);
    _repairCell.Draw(-xOffset, (_fieldYPosition + yOffset) - (cellSize / 4), cellSize / 2);
    if (_lifeSupportCell.HasPower)
      fill(0, 200, 0);
    else
      fill(0, 100, 0);
    _lifeSupportCell.Draw(xOffset, (_fieldYPosition + yOffset) - (cellSize / 4), cellSize / 2);

    DrawSymbols(xOffset, cellSize);

    fill(255);
    noStroke();
    textAlign(LEFT);
    text("DISTANCE TO HOME: " + AddSeperatorsToNumber(_distanceToHomePlanet), -80 * SCALE, -360 * SCALE);
    text("THRUSTER LEVEL:", -70 * SCALE, -280 * SCALE);
    text(_player.ThrusterLevel, 115 * SCALE, -280 * SCALE);
    text("SHIELD LEVEL:", -70 * SCALE, -265 * SCALE);
    text(_player.ShieldLevel, 115 * SCALE, -265 * SCALE);
    text("HULL LEVEL:", -70 * SCALE, -250 * SCALE);
    text(_player.HullLevel, 115 * SCALE, -250 * SCALE);
    text("STABILIZER LEVEL:", -70 * SCALE, -235 * SCALE);
    text(_player.StabilizerLevel, 115 * SCALE, -235 * SCALE);
    text("SCRAP: " + AddSeperatorsToNumber(_player.Scrap), -70 * SCALE, -200 * SCALE);

    _field.Draw(0, _fieldYPosition);

    if (_currentEnemy == null) {
      textAlign(CENTER);
      if (_counterUntilNextEnemy <= 250) {
        float opacity = 150;
        if (_counterUntilNextEnemy >= 200)
          opacity = map(_counterUntilNextEnemy, 250, 200, 0, 150);
        stroke(0);
        fill(255, 0, 0, opacity);
        textSize(38 * SCALE);
        text("!!! WARNING !!!", 0, 100 * SCALE);
        text("ENEMY", 0, 140 * SCALE);
        text("APPROACHING", 0, 180 * SCALE);
        text(_counterUntilNextEnemy + "u", 0, 220 * SCALE);
      }
    }

    for (IParticle currentParticle : _particles) {
      currentParticle.Draw();
    }

    if (_field.HoldingCell != null) {
      fill(255, 255, 255, 100);
      _field.HoldingCell.Draw(MOUSEX, MOUSEY, (400 / _fieldSize) * SCALE);
    }

    if (_hull <= _hullCritical || _lifeSupport <= _lifeSupportCritical || _alarmCounter > 0) {
      _alarmCounter++;
      if (_alarmCounter > 200)
        _alarmCounter = 0;
      float opacity = map(sin(map(_alarmCounter, 0, 200, 0, PI)), 0, 1, 0, 100);
      noStroke();
      fill(255, 0, 0, opacity);
      rect(-(width / 2), -(height / 2), width, height);
    }
  }

  private String AddSeperatorsToNumber(int number) {
    return _decimalFormat.format(number);
  }

  private void SpawnScrap(int value) {
    int currentType = 1;
    int current = 1;
    while (current < value)
      current *= 10;

    while (value > 0) {
      while (value >= current) {
        _scrap.add(new Scrap(175 * SCALE, -135 * SCALE, current));
        value -= current;
      }
      if (currentType == 1) {
        current *= 5;
        current /= 10;
        currentType = 5;
      } else if (currentType == 2) {
        current /= 2;
        currentType = 1;
      } else if (currentType == 5) {
        current /= 5;
        current *= 2;
        currentType = 2;
      }
    }
  }

  private void DrawSymbols(float xOffset, float cellSize) {
    xOffset = xOffset - (cellSize / 2);
    noStroke();
    fill(255);
    pushMatrix();
    translate(-xOffset, -55 * SCALE);
    beginShape();
    vertex(0, -10 * SCALE);
    vertex(7 * SCALE, -7 * SCALE);
    vertex(5 * SCALE, 7 * SCALE);
    vertex(0, 10 * SCALE);
    vertex(-5 * SCALE, 7 * SCALE);
    vertex(-7 * SCALE, -7 * SCALE);
    endShape(CLOSE);
    popMatrix();

    pushMatrix();
    translate(xOffset, -55 * SCALE);
    beginShape();
    vertex(10 * SCALE, 0);
    vertex(7 * SCALE, 3 * SCALE);
    vertex(-5 * SCALE, 3 * SCALE);
    vertex(-10 * SCALE, 8 * SCALE);
    vertex(-8 * SCALE, 0);
    vertex(-10 * SCALE, -8 * SCALE);
    vertex(-5 * SCALE, -3 * SCALE);
    vertex(7 * SCALE, -3 * SCALE);
    endShape(CLOSE);
    popMatrix();

    pushMatrix();
    translate(-xOffset, 375 * SCALE);
    beginShape();
    vertex(4 * SCALE, -5 * SCALE);
    vertex(8 * SCALE, -9 * SCALE);
    vertex(5 * SCALE, -9 * SCALE);
    vertex(2 * SCALE, -7 * SCALE);
    vertex(2 * SCALE, -5 * SCALE);
    vertex(-9 * SCALE, 6 * SCALE);
    vertex(-6 * SCALE, 9 * SCALE);
    vertex(5 * SCALE, -2 * SCALE);
    vertex(8 * SCALE, -3 * SCALE);
    vertex(9 * SCALE, -5 * SCALE);
    vertex(9 * SCALE, -8 * SCALE);
    vertex(5 * SCALE, -4 * SCALE);
    endShape(CLOSE);
    popMatrix();

    noFill();
    stroke(255);
    strokeWeight(1 * SCALE);
    pushMatrix();
    translate(xOffset, 375 * SCALE);
    beginShape();
    vertex(-10 * SCALE, 0);
    vertex(-5 * SCALE, 0);
    vertex(-4 * SCALE, 3 * SCALE);
    vertex(-3 * SCALE, 0);
    vertex(-1 * SCALE, 0);
    vertex(0, 4 * SCALE);
    vertex(1 * SCALE, 0);
    vertex(3 * SCALE, 0);
    vertex(4 * SCALE, -6 * SCALE);
    vertex(5 * SCALE, 0);
    vertex(10 * SCALE, 0);
    endShape();
    popMatrix();
  }
}
