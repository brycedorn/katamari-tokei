// GLOBAL VARS
// ================================================================================
PImage prince1, prince2, ball, grass;

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
  
  //overlay bg
  background(188,222,255);
    
  drawEnvironment(hour);

  //base
  fill(76,197,82);
  image(grass,-30,700,300,183);
  
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

// Ball
// ------------------------------------------------------------
void drawBall(float relSec) {
  pushMatrix();
  translate(width*.4, height*.7);
  rotate(radians(frameCount));
  translate(-(ball.width), -(ball.height));
  image(ball,
        width*.4+relSec,
        height*.7-relSec,
        160+relSec,
        160+relSec
  );
  popMatrix();
}

// Ball
// ------------------------------------------------------------
void drawPrince(float mil, float relSec) {
  PImage prince;
  if(mil%2 == 0) {
    prince = prince1;
  } else {
    prince = prince2;
  }
  image(prince,
        width*.3+relSec/2,
        height*.7+relSec/6,
        100-relSec/4,
        160-relSec/4
  );
}
