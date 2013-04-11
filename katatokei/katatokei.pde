// GLOBAL VARS
// ================================================================================

// constants
// ------------------------------------------------------------
int width = 600, height = 800;

int SEC_IN_MIN = 60,
    MIN_IN_HR = 60,
    HR_IN_DAY = 24;

// bounds for the stars in space
int SPACE_MIN_X = 0,
    SPACE_MAX_X = width,
    SPACE_MIN_Y = 0,
    SPACE_MAX_Y = height/4,
    STARSIZE_MIN = 5,
    STARSIZE_MAX = 50;

// not constants
// ------------------------------------------------------------
PImage prince1, prince2, ball, grass;

Star[] stars = new Star[MIN_IN_HR];
Star newStar = null;


// SETUP
// ================================================================================
void setup() {
  frameRate(60);
  
  prince1 = loadImage("prince1.png");
  prince2 = loadImage("prince2.png");
  ball = loadImage("ball1.png");
  grass = loadImage("grassmove.png");
  
  size(600, 800); // or whatever res our phone is
  noStroke();
  
  int hour = hour();
  background(188,222,255);
  /*
  if(hour >= 7 && hour < 10) { //morning
    background(188,222,255);
  } else if(hour >= 10 && hour < 16) { //day
    background(89,176,246);
  } else if(hour >= 16 && hour < 20) { //dusk
    background(255,104,10);
  } else if(hour >= 20 || hour < 7) { //nighttime
    background(46,95,132);
  }
  */
}


// DRAW
// ================================================================================
void draw() {  
  // current time
  // modulus'd for testing purposes, if we want smaller values
  int hour = hour() % HR_IN_DAY;
  int min = minute() % MIN_IN_HR;
  int sec = second() % SEC_IN_MIN;
  
  // time since program start
  float mil = millis();
  float relSec = (mil/1000) % SEC_IN_MIN;
  
  // overlay bg
  background(188,222,255);
    
  drawEnvironment(hour);

  // base
  fill(76,197,82);
  image(grass,-30,700,670,183);
  
  drawBall(relSec);
  drawPrince(mil, relSec);

  // stars
  configureStars(sec, min);
  drawStars();
}

// Environment Effects
// ------------------------------------------------------------
void drawEnvironment(int hour) {
  boolean clouds=false, sun=false, sunrays=false;
  
  // determine effects
  if(hour >= 7 && hour < 10) { //morning
    sunrays = true; //moving in circle would look nice
    clouds = true;
    sun = false;
  } else if(hour >= 10 && hour < 4) { //day
    sun = true;
    clouds = true;
    sunrays = false;
  } else if(hour >= 4 && hour < 7) { //dusk
    sunrays = true;
    clouds = false;
    sun = false;
  } else if(hour > 20 || hour < 7) { // night
    clouds = true;
    sunrays = false;
    sun = false;
  }
  
  // apply effects
  if(sun) {
  
  }
  if(sunrays) {
    
  }
  if(clouds) {
    
  }  
}

// Ball
// ------------------------------------------------------------
void drawBall(float relSec) {
  pushMatrix();
  float change = 3*relSec/2;
  translate(
    width*.43+80+change,
    height-(height*.08+80+change)
  );
  rotate(frameCount*radians(90)/15);
  translate(-80-change, -80-change);
  image(ball, 0, 0, 160+3*relSec, 160+3*relSec);
  translate(-width*.43, -height*.7);
  popMatrix();
}

// Prince
// ------------------------------------------------------------
void drawPrince(float mil, float relSec) {
  PImage prince;
  if(mil%2 == 0) {
    prince = prince1;
  } else {
    prince = prince2;
  }
  
  image(
    prince,
    width*.3+relSec/2,
    height*.7+relSec/6,
    100-relSec/4,
    160-relSec/4
  );
}

// Stars
// ------------------------------------------------------------
void addStar(int idx) {
  if (stars[idx] == null) {
    stars[idx] = new Star(
      random(SPACE_MIN_X, SPACE_MAX_X),
      random(SPACE_MIN_Y, SPACE_MAX_Y),
      random(STARSIZE_MIN, STARSIZE_MAX)
    );
  }
}

void configureStars(int sec, int min) {
  // add a star every minute
  if (sec == 0) {
    // print("Time: sec=" + sec + "; min=" + min + "\n");
    addStar(min);
  }

  // reset the stars every hour
  if (min == 0) {
    stars = new Star[MIN_IN_HR];
  }
}

void drawStars() {
  for (int i = 0; i < MIN_IN_HR; i++) {
    if (stars[i] != null) {
      stars[i].draw();
    }
  }
}


// CLASSES
// ================================================================================

// Star
// ------------------------------------------------------------
class Star {
  float x, y, size;
  PImage img = ball;

  Star(float xP, float yP, float sizeP) {
    x = xP;
    y = yP;
    size = sizeP;
  }

  void draw() {
    image(img, x, y, size, size);
  }
}
