class Button {
  String _text;
  float _xPos;
  float _yPos;
  float _buttonWidth;
  float _buttonHeight;
  color _buttonColor;
  color _inactiveColor;
  color _textColor;
  float _textSize;

  public boolean IsActive;

  public Button(String text, float xPos, float yPos, float buttonWidth, float buttonHeight, color buttonColor, color inactiveColor, color textColor, float textSize) {
    _text = text;
    _xPos = xPos * SCALE;
    _yPos = yPos * SCALE;
    _buttonWidth = buttonWidth * SCALE;
    _buttonHeight = buttonHeight * SCALE;
    _buttonColor = buttonColor;
    _inactiveColor = inactiveColor;
    _textColor = textColor;
    _textSize = textSize * SCALE;

    IsActive = true;
  }

  public void Draw() {
    textAlign(CENTER, CENTER);
    textSize(_textSize);
    noStroke();
    if (IsActive)
      fill(_buttonColor);
    else
      fill(_inactiveColor);
    rect(_xPos - (_buttonWidth / 2), _yPos - (_buttonHeight / 2), _buttonWidth, _buttonHeight);
    fill(_textColor);
    text(_text, _xPos, _yPos);
  }

  public boolean IsClicked(float mouseXPos, float mouseYPos) {
    boolean clicked = false;

    if (IsActive) {
      if (mouseXPos >= _xPos - (_buttonWidth / 2) && mouseXPos < _xPos + (_buttonWidth / 2)) {
        if (mouseYPos >= _yPos - (_buttonHeight / 2) && mouseYPos <= _yPos + (_buttonHeight / 2))
          clicked = true;
      }
    }

    return clicked;
  }
}