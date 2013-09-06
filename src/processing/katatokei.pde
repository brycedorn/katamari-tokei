// GLOBAL VARS
// ------------------------------------------------------------
PImage ball, grass, clouds, stars, bg_gradient, bg_gradient_w;
PImage p1,p2,p3,p4,p5,p6;
PFont font;
int princeFrames; //for prince animation
float oldWidth;
float oldHeight;

// SETUP
// ================================================================================
void setup() {
  oldWidth = window.innerWidth;
  oldHeight = window.innerHeight;
  size(window.innerWidth,window.innerHeight);
  
  frameRate(50);
  noStroke();

  p1 = loadImage("src/img/p1.png");
  p2 = loadImage("src/img/p2.png");
  p3 = loadImage("src/img/p3.png");
  p4 = loadImage("src/img/p4.png");
  p5 = loadImage("src/img/p5.png");
  p6 = loadImage("src/img/p6.png");

  ball = loadImage("src/img/blur.png");
  grass = loadImage("src/img/grass.png");
  stars = loadImage("src/img/stars.png");
  cloudz = loadImage("src/img/clouds.png");
  bg_gradient = loadImage("src/img/bg-gradient.png");
  bg_gradient_w = loadImage("src/img/bg-gradient-w.png");

  int hr = hour();
  if(hr >= 7 && hr < 10) { //morning
    background(188,222,255);
  } else if(hr >= 10 && hr < 16) { //day
    background(89,176,246);
  } else if(hr >= 16 && hr < 19) { //dusk
    background(255,104,10);
  } else if(hr >= 19 || hr < 7) { //nighttime
    background(46,95,132);
  }
}


// DRAW
// ================================================================================
void draw() {  
  int hr = hour();
  int min = minute();
  float mil = millis();
  float sec = second();
  
  // overlay bg
  if(hr >= 7 && hr < 10) { //morning
    background(225, 229, 13);
    image(bg_gradient_w, 0, 0, width, height);
  } else if(hr >= 10 && hr < 16) { //day
    background(89,176,246);
    image(bg_gradient_w, 0, 0, width, height);
  } else if(hr >= 16 && hr < 19) { //dusk
    background(232, 35, 12);
    image(bg_gradient, 0, 0, width, height);
  } else if(hr >= 19 || hr < 7) { //nighttime
    background(0,5,110);
    image(bg_gradient, 0, 0, width, height);
  }
  
  // write text in bg
  font = loadFont("HelveticaNeue-Bold-48.vlw");
  fill(255, 255, 255, 100);
  int hrdisp = hr%12;
  if(hrdisp>9) {
    textFont(font, 750);
    textAlign(CENTER);
    text(hrdisp, width/2, height-100);
  }
  else {
    if(hrdisp==0) {
      hrdisp = 12;
    }
    textFont(font, 850);
    textAlign(CENTER);
    text(hrdisp, width/2, height-100);
  }
  
  drawEnvironment(hr);
  drawGrass(sec);
  drawBall(sec);
  drawPrince(mil, sec);
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
  // 
  // TODO: clean this up into separate functions
  // 
  if(sun) { //rotating sun
    pushMatrix();
    translate(width/2,width*1.43); //center coords (+)
    rotate(-frameCount*radians(90)/2500);
    translate(-width/4,-width*1.3); //radius
    fill(255,220,0);
    ellipse(0,0,100,100); //make sure it's at 0,0
    translate(-width/2, -width*1.43); //center coords (-)
    popMatrix();
  }
  if(clouds) { //rotating clouds
    pushMatrix();
    translate(width/2,height*1.5); //center coords (+)
    rotate(-frameCount*radians(90)/1000);
    translate(-width*1.6,-width*1.6); //radius
    image(cloudz,0,0,width*3.2,width*3.2);
    popMatrix();
  }
  if(starry) { //rotating clouds
    pushMatrix();
    translate(width/2,height); //center coords (+)
    rotate(-frameCount*radians(90)/1200);
    translate(-width,-width); //radius
    image(stars,0,0,width*2,width*2);
    popMatrix();
  }
}

// Ground
// ------------------------------------------------------------
void drawGrass(float sec) {
  pushMatrix();
  translate(width/2,width*1.43);
  if(sec>=2 && sec <58)
    rotate(-frameCount*radians(90)/100);
  else 
    rotate(-frameCount*radians(90)/100); //frame of reference, should make more fluid tho
  translate(-width, -width);
  image(grass,0,0,width*2,width*2);
  popMatrix();
}

// Ball
// ------------------------------------------------------------
double onAngleBall = 0;
double offAngleBall = 0;
double prevDiam = 0;
double prevChange = 0;
int onCount = 0;
int offCount = 0;
void drawBall(float sec) {
  float growFactor = 6*sec;
  float change = growFactor/2;
  float ballDiameter = 160+growFactor;
  float rotAngle = radians(90)/100;
  float rotDistance = ballDiameter-ballDiameter*Math.sin(90-rotAngle);
  float rollSpeed = frameRate*rotDistance;
  float rollTime = (width/2)/rollSpeed;
  double degChange = 45/rollTime/frameRate;
  pushMatrix();
  if(sec<rollTime) {
    offCount = 0;
    offAngleBall=0;
    onAngleBall = radians(degrees(onAngleBall)+90/rollTime/frameRate);
    double side = Math.sqrt(2*width*width-2*width*width*Math.cos(onAngleBall));
    double theta = Math.asin(width*Math.sin(onAngleBall)/side);
    double phi = 90-degrees(theta);
    phi = radians(phi);
    double xTranslate = side*Math.sin(phi);
    double yTranslate = side*Math.sin(theta);
    translate(-width/2+xTranslate-ballDiameter/2,width*1.5-yTranslate-ballDiameter/2);
    rotate(onCount*rotAngle);
    translate(-ballDiameter/2, -ballDiameter/2);
    image(ball, 0, 0, ballDiameter, ballDiameter);
    //translate(-(width*.5-80), -height*.9);
  }
  else if(sec>=rollTime && sec<(59-rollTime)) {
    onCount = 0;
    onAngleBall=0;
    translate(width/2,width*1.43-width-change);
    rotate(frameCount*radians(90)/40);
    translate(-ballDiameter/2, -ballDiameter/2);
    image(ball, 0, 0, ballDiameter, ballDiameter);
    //translate(-width/2+ballDiameter/2, -height*.9);
    prevDiam = ballDiameter;
    prevChange = change;
  }
  else if(sec>=(59-rollTime)){
    offAngleBall = radians(degrees(offAngleBall)+degChange);
    double side = Math.sqrt(2*width*width-2*width*width*Math.cos(offAngleBall));
    double theta = Math.asin(width*Math.sin(offAngleBall)/side);
    double phi = 90-degrees(theta);
    phi = radians(phi);
    double xTranslate = side*Math.sin(theta);
    double yTranslate = side*Math.sin(phi);
    translate(width/2,width*1.43-width-change);
    rotate(offCount*rotAngle);
    translate(-prevDiam/2+xTranslate, yTranslate-prevDiam/2);
    image(ball, 0, 0, ballDiameter, ballDiameter);
    //translate(-(width*.5-80), -height*.9);
  }
  popMatrix();
}

// Prince
// ------------------------------------------------------------
int princeOnCount = 0;
int princeOffCount = 0;
double onAngle = 0;
double offAngle = 0;
double xDist = 0;
double yDist = 0;
void drawPrince(float mil, float sec) {
  float growFactor = 6*sec;
  float change = growFactor/2;
  float ballDiameter = 160+growFactor;
  float rotAngle = radians(90)/100;
  float rotDistance = ballDiameter-ballDiameter*Math.sin(90-rotAngle);
  float rollSpeed = frameRate*rotDistance;
  float rollTime = (width/2)/rollSpeed;
  float princeWidth = 180*.6-sec*.8;
  float princeHeight = 253*.6-sec*180/253*.8;
  double numFrame = ((ballDiameter-160)/6)*50;
  double princeDegChange = 45/(59-2*rollTime)/50;
  double princeAngle = radians(princeDegChange*numFrame);
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
  
  float change = 6*sec/2;
  double degChange = 90/rollTime/frameRate;
  if(sec<rollTime) {
    offAngle = 0;
    onAngle = radians(degrees(onAngle)+degChange);
    double side = Math.sqrt(2*width*width-2*width*width*Math.cos(onAngle));
    double theta = Math.asin(width*Math.sin(onAngle)/side);
    double phi = radians(90-degrees(theta));
    double xTranslate = side*Math.sin(phi);
    double yTranslate = side*Math.sin(theta);
    image(
      prince,
      -width/2+xTranslate-ballDiameter/2-princeWidth*.7,
      width*1.43-yTranslate-ballDiameter/2+princeHeight*.4,
      princeWidth,
      princeHeight
    );
  }
  else if(sec>=(59-rollTime)) {
    princeAngle = 0;
    offAngle = radians(degrees(offAngle)+degChange);
    double side = Math.sqrt(2*width*width-2*width*width*Math.cos(offAngle));
    double theta = Math.asin(width*Math.sin(offAngle)/side);
    double phi = 90-degrees(theta);
    phi = radians(phi);
    double yTranslate = side*Math.sin(phi);
    double xTranslate = side*Math.sin(theta);
    image(
      prince,
      width/2+xTranslate-ballDiameter/2-princeWidth*.7,
      width*1.43-width-ballDiameter/2+yTranslate+princeHeight*.4,
      180*.6-sec*.3,
      253*.6-sec*180/253*.8
    );
  }
  else {
    double radius = ballDiameter/2;
    onAngle = 0;
    princeAngle = radians(degrees(princeAngle)+princeDegChange);
    double side = Math.sqrt(2*radius*radius-2*radius*radius*Math.cos(princeAngle));
    double theta = Math.asin(radius*Math.sin(princeAngle)/side);
    double phi = 90-degrees(theta);
    phi = radians(phi);
    double xTranslate = side*Math.sin(phi);
    double yTranslate = side*Math.sin(theta);
    image(
      prince,
      width/2-radius+xTranslate-princeWidth*.7,
      width*1.43-width-radius+yTranslate+princeHeight*.4,
      180*.6-sec*.3,
      253*.6-sec*180/253*.8
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
    //ellipse(15+30*col,15+30*(row-1),10,10);
    textSize(10);
    text(m+1,15+30*col,15+30*(row-1));
  }
}
