class Field {
  public Cell[][] Cells;

  private Cell HoldingCell;
  private int _xGrabbed;
  private int _yGrabbed;

  private int _fieldSize;

  public Field(int fieldSize) {
    _fieldSize = fieldSize;

    Cells = new Cell[fieldSize][];
    for (int x = 0; x < fieldSize; x++) {
      Cells[x] = new Cell[fieldSize];
      for (int y = 0; y < fieldSize; y++)
        Cells[x][y] = new Cell();
    }

    // Openings:
    Cell model = new Cell();
    int position = 0;
    int completeCount = fieldSize * fieldSize;

    // LD
    int count = floor(fieldSize / 2);
    model.OpenUp = false;
    model.OpenDown = true;
    model.OpenLeft = true;
    model.OpenRight = false;
    for (int i = 0; i < count; i++) {
      ApplyCell(position, model);
      position++;
    }

    // RD
    model.OpenUp = false;
    model.OpenDown = true;
    model.OpenLeft = false;
    model.OpenRight = true;
    for (int i = 0; i < count; i++) {
      ApplyCell(position, model);
      position++;
    }

    // LU
    model.OpenUp = true;
    model.OpenDown = false;
    model.OpenLeft = true;
    model.OpenRight = false;
    for (int i = 0; i < count; i++) {
      ApplyCell(position, model);
      position++;
    }

    // RU
    model.OpenUp = true;
    model.OpenDown = false;
    model.OpenLeft = false;
    model.OpenRight = true;
    for (int i = 0; i < count; i++) {
      ApplyCell(position, model);
      position++;
    }

    // URD
    model.OpenUp = true;
    model.OpenDown = true;
    model.OpenLeft = false;
    model.OpenRight = true;
    for (int i = 0; i < count; i++) {
      ApplyCell(position, model);
      position++;
    }

    // ULD
    model.OpenUp = true;
    model.OpenDown = true;
    model.OpenLeft = true;
    model.OpenRight = false;
    for (int i = 0; i < count; i++) {
      ApplyCell(position, model);
      position++;
    }

    // RDL
    model.OpenUp = false;
    model.OpenDown = true;
    model.OpenLeft = true;
    model.OpenRight = true;
    for (int i = 0; i < count; i++) {
      ApplyCell(position, model);
      position++;
    }

    // RUL
    model.OpenUp = true;
    model.OpenDown = false;
    model.OpenLeft = true;
    model.OpenRight = true;
    for (int i = 0; i < count; i++) {
      ApplyCell(position, model);
      position++;
    }

    count = floor((completeCount - (4 * count)) / 4);
    // LR
    model.OpenUp = false;
    model.OpenDown = false;
    model.OpenLeft = true;
    model.OpenRight = true;
    for (int i = 0; i < count; i++) {
      ApplyCell(position, model);
      position++;
    }

    // UD
    model.OpenUp = true;
    model.OpenDown = true;
    model.OpenLeft = false;
    model.OpenRight = false;
    for (int i = 0; i < count; i++) {
      ApplyCell(position, model);
      position++;
    }

    while (position < completeCount) {
      // LURD
      model.OpenUp = true;
      model.OpenDown = true;
      model.OpenLeft = true;
      model.OpenRight = true;
      ApplyCell(position, model);
      position++;
    }

    ShuffleField(5000);
  }

  void ApplyCell(int pos, Cell model) {
    int xPos = 0;
    int yPos = 0;
    while (pos >= _fieldSize) {
      xPos++;
      pos -= _fieldSize;
    }
    yPos = pos;
    Cells[xPos][yPos].OpenUp = model.OpenUp;
    Cells[xPos][yPos].OpenDown = model.OpenDown;
    Cells[xPos][yPos].OpenLeft = model.OpenLeft;
    Cells[xPos][yPos].OpenRight = model.OpenRight;
  }

  public void ShuffleField(int shuffleTimes) {
    for (int i = 0; i < shuffleTimes; i++) {
      int originX = floor(random(_fieldSize));
      int originY = floor(random(_fieldSize));
      int targetX = floor(random(_fieldSize));
      int targetY = floor(random(_fieldSize));

      Cell tmp = Cells[originX][originY];
      Cells[originX][originY] = Cells[targetX][targetY];
      Cells[targetX][targetY] = tmp;
    }
    RecalculatePower();
  }

  public void RecalculatePower() {
    for (int x = 0; x < _fieldSize; x++) {
      for (int y = 0; y < _fieldSize; y++)
        Cells[x][y].HasPower = false;
    }

    int xMiddle = _fieldSize / 2;
    int yMiddle = _fieldSize / 2;
    Cells[xMiddle][yMiddle].HasPower = true;

    boolean somethingChanged = true;
    while (somethingChanged) {
      somethingChanged = false;
      for (int x = 0; x < _fieldSize; x++) {
        for (int y = 0; y < _fieldSize; y++) {
          if (Cells[x][y].HasPower) {
            Cell currentCell = Cells[x][y];
            if (currentCell.OpenUp) {
              if (y > 0) {
                if (Cells[x][y - 1].OpenDown) {
                  if (!Cells[x][y - 1].HasPower) {
                    Cells[x][y - 1].HasPower = true;
                    somethingChanged = true;
                  }
                }
              }
            }
            if (currentCell.OpenDown) {
              if (y < _fieldSize - 1) {
                if (Cells[x][y + 1].OpenUp) {
                  if (!Cells[x][y + 1].HasPower) {
                    Cells[x][y + 1].HasPower = true;
                    somethingChanged = true;
                  }
                }
              }
            }
            if (currentCell.OpenLeft) {
              if (x > 0) {
                if (Cells[x - 1][y].OpenRight) {
                  if (!Cells[x - 1][y].HasPower) {
                    Cells[x - 1][y].HasPower = true;
                    somethingChanged = true;
                  }
                }
              }
            }
            if (currentCell.OpenRight) {
              if (x < _fieldSize - 1) {
                if (Cells[x + 1][y].OpenLeft) {
                  if (!Cells[x + 1][y].HasPower) {
                    Cells[x + 1][y].HasPower = true;
                    somethingChanged = true;
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  public void Update(float relativeMouseX, float relativeMouseY) {
    if (mousePressed) {
      if (HoldingCell == null) {
        if (relativeMouseX >= -200 * SCALE && relativeMouseX <= 200 * SCALE) {
          if (relativeMouseY >= -200 * SCALE && relativeMouseY <= 200 * SCALE) {
            _xGrabbed = round(map(relativeMouseX, -200 * SCALE, 200 * SCALE, -0.5, _fieldSize - 0.6));
            _yGrabbed = round(map(relativeMouseY, -200 * SCALE, 200 * SCALE, -0.5, _fieldSize - 0.6));
            HoldingCell = Cells[_xGrabbed][_yGrabbed];
            FASTCLICK.play();
          }
        }
      }
    } else {
      if (HoldingCell != null) {
        if (relativeMouseX < -200 * SCALE || relativeMouseX > 200 * SCALE || relativeMouseY < -200 * SCALE || relativeMouseY > 200 * SCALE) {
          HoldingCell = null;
        } else {
          int xToPut = round(map(relativeMouseX, -200 * SCALE, 200 * SCALE, -0.5, _fieldSize - 0.6));
          int yToPut = round(map(relativeMouseY, -200 * SCALE, 200 * SCALE, -0.5, _fieldSize - 0.6));
          Cell tmp = Cells[xToPut][yToPut];
          Cells[xToPut][yToPut] = HoldingCell;
          Cells[_xGrabbed][_yGrabbed] = tmp;
          HoldingCell = null;
          RecalculatePower();
          FASTCLICK.play();
        }
      }
    }
  }

  public void Draw(float xMiddlePos, float yMiddlePos) {
    fill(255);
    int xMiddle = _fieldSize / 2;
    int yMiddle = _fieldSize / 2;

    float cellSize = (400 / _fieldSize) * SCALE;

    for (int x = 0; x < _fieldSize; x++) {
      for (int y = 0; y < _fieldSize; y++) {
        Cells[x][y].Draw(xMiddlePos + ((x - xMiddle) * cellSize), yMiddlePos + ((y - yMiddle) * cellSize), cellSize);
      }
    }
  }
}