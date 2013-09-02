/*
TODO:

--Fixes--

 - make large pngs into slices
   - clouds, stars, grass
   - only visible above horizontal axis
 - make sure milliseconds is consistent
 - fix on/off animation

--Webpage--

 - resize elements to be more appropriate for web page
    - probably change minutes at top to be either 30 or 60 across
 - javascript alert that gives details about clock / what it's doing
 - git icon in bottom right

 */

// GLOBAL VARS
//
// constants
// ------------------------------------------------------------
int SEC_IN_MIN = 60,
    MIN_IN_HR = 60,
    HR_IN_DAY = 24;

// not constants
// ------------------------------------------------------------
PImage ball, grass, cloudspng, starspng, bg_gradient;
PImage p1,p2,p3,p4,p5,p6;
PFont font;
int princeFrames; //for prince animation

// SETUP
// ================================================================================
void setup() {
  int width = 1450;
  int height = 800;
  frameRate(60);

  p1 = loadImage("static/img/p1.png");
  p2 = loadImage("static/img/p2.png");
  p3 = loadImage("static/img/p3.png");
  p4 = loadImage("static/img/p4.png");
  p5 = loadImage("static/img/p5.png");
  p6 = loadImage("static/img/p6.png");
  ball = loadImage("static/img/blur.png");
  grass = loadImage("static/img/grass.png");
  //cloudspng = loadImage("static/img/cloudspng.png");
  starspng = loadImage("static/img/starspng.png");
  bg_gradient = loadImage("static/img/bg-gradient.png");
  
  size(width, height); // or whatever res our phone is
  noStroke();
  
  int hr = hour();
  
  if(hr >= 7 && hr < 10) { //morning
    background(188,222,255);
  } else if(hr >= 10 && hr < 16) { //day
    background(89,176,246);
  } else if(hr >= 16 && hr < 19) { //dusk
    background(255,104,10);
  } else if(hr >= 19 || hr < 7) { //nighttime
    background(46,95,132);            //why is night laggy?
  }
}


// DRAW
// ================================================================================
void draw() {  
  // current time
  // modulus'd for testing purposes, if we want smaller values
  int hr = hour() % HR_IN_DAY;
  int min = minute() % MIN_IN_HR;
  int sec = second() % SEC_IN_MIN;
  
  // time since program start
  float mil = millis();
  float relSec = second();
  
  // overlay bg
  if(hr >= 7 && hr < 10) { //morning
    background(225, 229, 13);
  } else if(hr >= 10 && hr < 16) { //day
    background(89,176,246);
  } else if(hr >= 16 && hr < 19) { //dusk
    background(232, 35, 12);
    image(bg_gradient, 0, 0, width, height);
  } else if(hr >= 19 || hr < 7) { //nighttime
    background(0,5,110);
    image(bg_gradient, 0, 0, width, height);
  }
  
  // write text in bg
  font = loadFont("Ming-Imperial-48.vlw");
  fill(255, 255, 255, 100);
  int hrdisp = hr%12;
  if(hrdisp>9) {
    textFont(font, 750);
    textAlign(CENTER);
    text(hrdisp, width/2, height-100);
  }
  else {
    textFont(font, 850);
    textAlign(CENTER);
    text(hrdisp, width/2, height-100);
  }
  
  drawEnvironment(hr);
  drawGrass(relSec);
  drawBall(relSec);
  drawPrince(mil, relSec);
  drawMins(min);
}

// Environment Effects
// ------------------------------------------------------------
void drawEnvironment(int hr) {
  boolean clouds=false, smclouds=false, sun=false, sunrays=false, starry=false;
  
  // determine effects
  if(hr >= 7 && hr < 10) { //morning
    sunrays = true;
    clouds = true;
    sun = false;
    starry = false;
    smclouds = true;
  } else if(hr >= 10 && hr < 16) { //day
    sun = true;
    clouds = true;
    sunrays = false;
    starry = false;
    smclouds = false;
  } else if(hr >= 16 && hr < 19) { //dusk
    sunrays = true;
    clouds = false;
    sun = false;
    starry = false;
    smclouds = true;
  } else if(hr >= 19 || hr < 7) { // night
    clouds = false;
    sunrays = false;
    sun = false;
    starry = true;
    smclouds = true;
  }
  
  // apply effects
  if(sun) { //rotating sun
    pushMatrix();
    translate(width/2,800); //center coords (+)
    rotate(-frameCount*radians(90)/1000);
    translate(-400,-400); //radius
    fill(255,220,0);
    ellipse(0,0,100,100); //make sure it's at 0,0
    translate(-width/2, -800); //center coords (-)
    popMatrix();
  }
  if(sunrays) { //rotating sun rays
    //eh, do later
  }
  if(clouds) { //rotating clouds
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
  if(smclouds) { //less-visible clouds
    pushMatrix();
    translate(width/2,1200);
    rotate(-frameCount*radians(90)/500);
    translate(-1200,-1200);
    tint(255,40);
    image(cloudspng,0,0,2400,2400);
    translate(-width/2, -1200);
    tint(255, 255);
    popMatrix();
  }
  if(starry) { //rotating stars
    pushMatrix();
    translate(width/2,800);
    rotate(-frameCount*radians(90)/850);
    translate(-800,-800);
    tint(255, 210);
    image(starspng,0,0,1600,1600);
    translate(-width/2, -800);
    tint(255, 255);
    popMatrix();
    //add moon?
  }
}

// Ground
// ------------------------------------------------------------
void drawGrass(float relSec) {
  pushMatrix();
  translate(width/2,1450);
  if(relSec>=2 && relSec <58)
    rotate(-frameCount*radians(90)/100);
  else 
    rotate(-frameCount*radians(90)/1000); //frame of reference, should make more fluid tho
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
    translate(-p*1.75,height-(height*.1+80+change));
    p = p-5.95;
    rotate(frameCount*radians(90)/10);
    translate(-80-change, -80-change);
    image(ball, 0, 0, 160+6*relSec, 160+6*relSec);
    translate(-(width*.5-80), -height*.9);
  }   
  else if(relSec>=2 && relSec<58) {
    p=0;
    translate(width*.5,height-(height*.1+80+change));
    rotate(frameCount*radians(90)/10);
    translate(-80-change, -80-change);
    image(ball, 0, 0, 160+6*relSec, 160+6*relSec);
    translate(-(width*.5-80), -height*.9);
  }
  else if(relSec>=58){
    translate(width*.5+3*t,height-(height*.1+80+change)+t/10);
    t+=10;
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
  if(princeFrames==0) prince = p1; //lol forgot bout this one earlier
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
    -p*1.75-180,
    height*.7+2*change/(relSec+1),
    180*.6-relSec*.8,
    253*.6-relSec*180/253*.8
  );
  }
  else if(relSec>=58) {
    image(
    prince,
    width*.21+ball.width/(change+80)+2.2*t,
    height*.7+3*change/(relSec+1)+t/10,
    180*.6-relSec*.8,
    253*.6-relSec*180/253*.8
  );
  }
  else {
    image(
    prince,
    width*.21+ball.width/(change+80),
    height*.7+3*change/(relSec+1),
    180*.6-relSec*.8,
    253*.6-relSec*180/253*.8
  );
  }
}

// Minutes
// ------------------------------------------------------------
void drawMins(int minutes) {
  int row=1,col=-1;
  for(int m=0;m<minutes;m++) {
    col++;
    if(15+col*30>=width) {
      row += 1;
      col = 0;
    }
    fill(255,255,255);
    ellipse(15+30*col,15+30*(row-1),10,10);
  }
}