// GLOBAL VARS
//
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
PImage prince1, prince2, ball, grass, cloudspng, starspng;
PFont font;
int princeFrames; //for prince animation

Star[] stars = new Star[MIN_IN_HR];
Star newStar = null;


// SETUP
// ================================================================================
void setup() {
  frameRate(60);

  prince1 = loadImage("data/prince1.png");
  prince2 = loadImage("data/prince2.png");
  ball = loadImage("data/blur.png");
  grass = loadImage("data/grassmove.png");
  cloudspng = loadImage("data/cloudspng.png");
  starspng = loadImage("data/starspng.png");
  
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
  
   //write text in bg
  font = loadFont("data/HelveticaNeue-Bold-48.vlw");
  textFont(font, 800);
  int hourdisp = hour%12;
  fill(255, 255, 255, 100);
  text(hour, width/7, height-100);
    
  drawEnvironment(hour);

  drawGrass(relSec);
  drawBall(relSec);
  drawPrince(mil, relSec);

  // stars
  configureStars(sec, min);
  drawStars();
}

// Environment Effects
// ------------------------------------------------------------
void drawEnvironment(int hour) {
  boolean clouds=true, sun=false, sunrays=false, starry=false;
  
  // determine effects
  /*
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
  */
  
  // apply effects
  if(sun) {
    pushMatrix();
    translate(width/2,800); //center coords (pos)
    rotate(-frameCount*radians(90)/1000);
    translate(-400,-400); //radius
    fill(255,220,0);
    ellipse(0,0,100,100); //make sure it's at 0,0
    translate(-width/2, -800); //center coords (neg)
    popMatrix();
  }
  if(sunrays) {
    //eh, do later
  }
  if(clouds) {
    pushMatrix();
    translate(width/2,1200);
    rotate(-frameCount*radians(90)/600);
    translate(-1200,-1200);
    tint(255, 240);
    image(cloudspng,0,0,2400,2400);
    tint(255,255);
    translate(-width/2, -1200);
    popMatrix();
    }
   if(starry) {
    pushMatrix();
    translate(width/2,800);
    rotate(-frameCount*radians(90)/600);
    translate(-800,-800);
    image(starspng,0,0,1600,1600);
    translate(-width/2, -800);
    popMatrix();
   }  
}

// Ground
// ------------------------------------------------------------
void drawGrass(float relSec) {
  pushMatrix();
  translate(width/2,1450);
  rotate(-frameCount*radians(90)/150);
  translate(-800,-800);
  image(grass,0,0,1600,1600);
  translate(-width*.43, -height*.7);
  popMatrix();
}

// Ball
// ------------------------------------------------------------
void drawBall(float relSec) {
  pushMatrix();
  float change = 7*relSec/2;
  translate(
    width*.43+80+change,
    height-(height*.08+80+change)
  );
  rotate(frameCount*radians(90)/15);
  translate(-80-change, -80-change);
  image(ball, 0, 0, 160+7*relSec, 160+7*relSec);
  translate(-width*.43, -height*.7);
  popMatrix();
}

// Prince
// ------------------------------------------------------------
void drawPrince(float mil, float relSec) {
  PImage prince;
  princeFrames++;
  if(princeFrames>12) prince = prince2;
  else prince = prince1;
  if(princeFrames>25) princeFrames=0;
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
