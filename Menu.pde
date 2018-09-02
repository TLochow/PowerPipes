class Menu extends IGameModule {
  float _textPos;
  float _textMargin;

  int _fieldSize;
  int _minFieldSize;
  int _maxFieldSize;

  Button _startButton;
  Button _smallerButton;
  Button _biggerButton;

  boolean _startGame;

  public Menu() {
    Initialize(7);
  }

  public Menu(int fieldSize) {
    Initialize(fieldSize);
  }

  private void Initialize(int fieldSize) {
    _fieldSize = fieldSize;
    _minFieldSize = 5;
    _maxFieldSize = 13;

    _startButton = new Button("START", 0, 280, 300, 100, color(255), color(150), color(0), 50);
    _smallerButton = new Button("SMALLER", -125, 165, 150, 50, color(255), color(150), color(0), 25);
    _biggerButton = new Button("BIGGER", 125, 165, 150, 50, color(255), color(150), color(0), 25);
  }

  public IGameModule Update() {
    _smallerButton.IsActive = _fieldSize > _minFieldSize;
    _biggerButton.IsActive = _fieldSize < _maxFieldSize;

    Game game = null;
    if (_startGame)
      game = new Game(_fieldSize);
    return game;
  }

  public void Draw() {
    textAlign(CENTER, CENTER);
    textSize(50 * SCALE);
    fill(255);
    text("POWER PIPES", 0, -340 * SCALE);

    _startButton.Draw();
    _smallerButton.Draw();
    _biggerButton.Draw();

    _textPos = -320;
    fill(255);
    _textMargin = 15;
    textSize(_textMargin * SCALE);
    DrawText("YOU ARE A SPACE PILOT ON");
    DrawText("YOUR WAY TO DISTANT GALAXIES.");
    _textPos += _textMargin;
    DrawText("YOU HAVE MET SEVERAL OTHER TRAVELERS,");
    DrawText("NONE OF THEM WERE FRIENDLY.");
    DrawText("BECAUSE OF THAT YOU DECIDED TO");
    DrawText("ABANDON YOUR MISSION AND RETURN BACK");
    DrawText("TO YOUR HOME-PLANET.");
    _textPos += _textMargin;
    DrawText("WILL YOU MAKE IT?");
    DrawText("OR WILL ENCOUNTERS WITH HOSTILE ALIENS");
    DrawText("LEAD TO YOUR UNTIMELY DEMISE?");
    _textPos += _textMargin;
    DrawText("WE JOIN IN ON THIS STORY JUST AFTER");
    DrawText("A COLLISION WITH AN ASTEROID WHICH");
    DrawText("COMPLETELY MESSED UP YOUR");
    DrawText("POWER-DISTRIBUTION-SYSTEM.");
    _textPos += _textMargin * 4;

    textSize(_textMargin * SCALE);
    fill(175);
    DrawText("Keep your system up by re-routing");
    DrawText("the power to the corresponding ports.");
    DrawText("If either your hull breaks or");
    DrawText("your life support fails you have lost");
    DrawText("all your chances of survival...");

    fill(255);
    textSize(25 * SCALE);
    text("FIELD SIZE", 0, 120 * SCALE);
    text(_fieldSize, 0, 165 * SCALE);
  }

  private void DrawText(String text) {
    _textPos += _textMargin;
    text(text, 0, _textPos * SCALE);
  }

  public void MousePressed() {
    _startGame = _startButton.IsClicked(MOUSEX, MOUSEY);
    if (_smallerButton.IsClicked(MOUSEX, MOUSEY)) {
      if (_fieldSize > _minFieldSize)
        _fieldSize -= 2;
    }
    if (_biggerButton.IsClicked(MOUSEX, MOUSEY)) {
      if (_fieldSize < _maxFieldSize)
        _fieldSize += 2;
    }
  }
}