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
PImage ball, grass, cloudspng, starspng, bg_gradient;
PImage p1,p2,p3,p4,p5,p6;
PFont font;
int princeFrames; //for prince animation

/*
Star[] stars = new Star[MIN_IN_HR];
Star newStar = null;
*/

// SETUP
// ================================================================================
void setup() {
  frameRate(60);

  p1 = loadImage("p1.png");
  p2 = loadImage("p2.png");
  p3 = loadImage("p3.png");
  p4 = loadImage("p4.png");
  p5 = loadImage("p5.png");
  p6 = loadImage("p6.png");
  ball = loadImage("blur.png");
  grass = loadImage("grass.png");
  cloudspng = loadImage("cloudspng.png");
  starspng = loadImage("starspng.png");
  bg_gradient = loadImage("bg-gradient.png");
  
  size(600, 800); // or whatever res our phone is
  noStroke();
  
  int hour = hour();
  background(188,222,255);
  
  if(hour >= 7 && hour < 10) { //morning
    background(188,222,255);
  } else if(hour >= 10 && hour < 16) { //day
    background(89,176,246);
  } else if(hour >= 16 && hour < 19) { //dusk
    background(255,104,10);
  } else if(hour >= 19 || hour < 7) { //nighttime
    background(46,95,132);
  }
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
  float relSec = second();
  
  // overlay bg
  if(hour >= 7 && hour < 10) { //morning
    background(225, 229, 13);
    //background(188,222,255);
  } else if(hour >= 10 && hour < 16) { //day
    background(89,176,246);
  } else if(hour >= 16 && hour < 19) { //dusk
    background(232, 35, 12);
    //background(255,104,10);
    image(bg_gradient, 0, 0, width, height);
  } else if(hour >= 19 || hour < 7) { //nighttime
    background(0,5,110);
    image(bg_gradient, 0, 0, width, height);
  }
  
  // write text in bg
  font = loadFont("HelveticaNeue-Bold-48.vlw");
  fill(255, 255, 255, 100);
  int hourdisp = hour%12;
  if(hourdisp>9) {
    textFont(font, 650);
    textAlign(CENTER);
    text(hourdisp, width/2, height-100);
  }
  else {
    textFont(font, 800);
    textAlign(CENTER);
    text(hourdisp, width/2, height-100);
  }
  //fill(255, 255, 255, 100);
  //text(hour, width/7, height-100);
  drawEnvironment(hour);

  drawGrass(relSec);
  drawBall(relSec);
  drawPrince(mil, relSec);
  drawMins(min);
  /* stars
  configureStars(sec, min);
  drawStars();
  */
}

// Environment Effects
// ------------------------------------------------------------
void drawEnvironment(int hour) {
  boolean clouds=false, smclouds=false, sun=false, sunrays=false, starry=false;
  
  // determine effects
  
  if(hour >= 7 && hour < 10) { //morning
    sunrays = true; //moving in circle would look nice
    clouds = true;
    sun = false;
    starry = false;
    smclouds = true;
  } else if(hour >= 10 && hour < 16) { //day
    sun = true;
    clouds = true;
    sunrays = false;
    starry = false;
    smclouds = false;
  } else if(hour >= 16 && hour < 19) { //dusk
    sunrays = true;
    clouds = false;
    sun = false;
    starry = false;
    smclouds = true;
  } else if(hour >= 19 || hour < 7) { // night
    clouds = false;
    sunrays = false;
    sun = false;
    starry = true;
    smclouds = true;
  }
  
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
    translate(-width/2, -1200);
    tint(255, 255);
    popMatrix();
    }
  if(smclouds) {
    pushMatrix();
    translate(width/2,1200);
    rotate(-frameCount*radians(90)/600);
    translate(-1200,-1200);
    tint(255,40);
    image(cloudspng,0,0,2400,2400);
    translate(-width/2, -1200);
    tint(255, 255);
    popMatrix();
    }
   if(starry) {
    pushMatrix();
    translate(width/2,800);
    rotate(-frameCount*radians(90)/800);
    translate(-800,-800);
    tint(255, 210);
    image(starspng,0,0,1600,1600);
    translate(-width/2, -800);
    tint(255, 255);
    popMatrix();
   }  
}

// Ground
// ------------------------------------------------------------
void drawGrass(float relSec) {
  pushMatrix();
  translate(width/2,1450);
  rotate(-frameCount*radians(90)/100);
  translate(-800,-800);
  image(grass,0,0,1600,1600);
  translate(-width*.43, -height*.7);
  popMatrix();
}

// Ball
// ------------------------------------------------------------
float t = 10.0;
float p = 500.0;
void drawBall(float relSec) {
  pushMatrix();
  float change = 6*relSec/2;
  if(relSec<2) {
    t=0;
    translate(
    -p,
    height-(height*.1+80+change)
    );
    p = p-5.48;
    rotate(frameCount*radians(90)/10);
    translate(-80-change, -80-change);
    image(ball, 0, 0, 160+6*relSec, 160+6*relSec);
    translate(-(width*.5-80), -height*.9);
  }   
  else if(relSec>=2 && relSec<58) {
    p=0;
  translate(
    width*.5,
    height-(height*.1+80+change)
    );
    rotate(frameCount*radians(90)/10);
    translate(-80-change, -80-change);
    image(ball, 0, 0, 160+6*relSec, 160+6*relSec);
    translate(-(width*.5-80), -height*.9);
  }
  else if(relSec>=58){
    translate(
      width*.5+t,
      height-(height*.1+80+change)+t/10
    );
    t = t+10;
    rotate(frameCount*radians(90)/10);
    translate(-80-change, -80-change);
    image(ball, 0, 0, 160+6*relSec, 160+6*relSec);
    translate(-(width*.5-80), -height*.9);
  }
  
  popMatrix();
}

// Prince
// ------------------------------------------------------------
void drawPrince(float mil, float relSec) {
  PImage prince = p1;
  float numFrames = 1;
  princeFrames++;
  if(princeFrames>numFrames*1) prince = p2;
  if(princeFrames>numFrames*2) prince = p3;
  if(princeFrames>numFrames*3) prince = p4;
  if(princeFrames>numFrames*4) prince = p5;
  if(princeFrames>numFrames*5) prince = p6;
  if(princeFrames>numFrames*6) princeFrames=0;
  
  float change = 6*relSec/2;
  if(relSec<2) {
    image(
    prince,
    -p-170,
    height*.7+change/(relSec+1),
    100-relSec/4,
    160-relSec/4
  );
  }
  else if(relSec>=58) {
    image(
    prince,
    width*.21+ball.width/(change+80)+t,
    height*.7+change/(relSec+1)+t/10,
    100-relSec/4,
    160-relSec/4
  );
  }
  else {
    image(
      prince,
      width*.21+ball.width/(change+80),
      height*.7+change/(relSec+1),
      100-relSec/4,
      160-relSec/4
    );
  }
}

// Minutes
// ------------------------------------------------------------
void drawMins(int minutes) {
  int row=1,num=-1;
  for(int m=0;m<minutes;m++) {
    num++;
    if(15+num*30>=width) {
      row += 1;
      num = 0;
    }
    fill(255,255,255);
    ellipse(15+30*num,15+30*(row-1),10,10);
  }
}

// Stars
// ------------------------------------------------------------
/*
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
*/
