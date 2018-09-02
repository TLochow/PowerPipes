import processing.sound.*;
SoundFile FASTCLICK;
SoundFile MISSILE;
SoundFile EXPLOSION;

float SCALE;
float MOUSEX;
float MOUSEY;
IGameModule _currentModule;

void setup() {
  size(450, 800);
  //fullScreen();

  FASTCLICK = new SoundFile(this, "fast-click.wav");
  MISSILE = new SoundFile(this, "missile.wav");
  EXPLOSION = new SoundFile(this, "explosion.wav");

  float originWidth = 450.0;
  float originHeight = 800.0;
  SCALE = width / originWidth;
  float heightScale = height / originHeight;
  if (heightScale < SCALE)
    SCALE = heightScale;

  textFont(createFont("Forvertz.ttf", 1000));

  _currentModule = new Menu();
}

void draw() {
  background(0);
  translate(width / 2, height / 2);
  // Translate Mouse:
  MOUSEX = mouseX - (width / 2);
  MOUSEY = mouseY - (height / 2);

  IGameModule nextModule = _currentModule.Update();
  _currentModule.Draw();

  if (nextModule != null)
    _currentModule = nextModule;
}

void mousePressed() {
  // Translate Mouse:
  MOUSEX = mouseX - (width / 2);
  MOUSEY = mouseY - (height / 2);
  
  _currentModule.MousePressed();
}
