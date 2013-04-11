// GLOBAL VARS
// ================================================================================
PImage prince1, prince2, ball, grass;
int i; //for prince animation

// Constants
// ------------------------------------------------------------
int width = 600, height = 800;

int SEC_IN_MIN = 5,
    MIN_IN_HR = 5;

int SPACE_MIN_X = 0,
    SPACE_MAX_X = width,
    SPACE_MIN_Y = 0,
    SPACE_MAX_Y = height/4,
    STARSIZE_MIN = 5,
    STARSIZE_MAX = 50;


// SETUP
// ================================================================================
void setup() {
  frameRate(60);
  
  prince1 = loadImage("img/prince1.png");
  prince2 = loadImage("img/prince2.png");
  ball = loadImage("img/ball1.png");
  grass = loadImage("img/grassmove.png");
  
  size(width, height); // or whatever res our phone is
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
  int hour = hour();
  int min = minute();
  int sec = second();
  
  // time since program start
  float mil = millis();
  float relSec = (mil/1000) % SEC_IN_MIN;
  
  // overlay bg
  background(188,222,255);
    
  drawEnvironment(hour);

  drawGrass(relSec);
  drawBall(relSec);
  drawPrince(mil, relSec);
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

// Ground
// ------------------------------------------------------------
void drawGrass(float relSec) {
  pushMatrix();
  translate(300,1450);
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
  i++;
  if(i>12) prince = prince2;
  else prince = prince1;
  if(i>25) i=0;
  /*
  if(mil%2 == 0) {
    prince = prince1;
  } else {
    prince = prince2;
  }
  */
  image(prince,
        width*.3+relSec/2,
        height*.7+relSec/6,
        100-relSec/4,
        160-relSec/4
  );
}
