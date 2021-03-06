// GLOBAL VARS
// ------------------------------------------------------------
PImage ball, grass, clouds, stars, king, bg_gradient, bg_gradient_w;
PImage p1,p2,p3,p4,p5,p6;
PFont font;
int princeFrames; //for prince animation
float oldWidth;
float oldHeight;
float offset;
float ballOffset;
float princeOffset;

// SETUP
// ================================================================================
void setup() {
  oldWidth = window.innerWidth;
  oldHeight = window.innerHeight;
  size(window.innerWidth,window.innerHeight);
  offset = oldHeight*.75;

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
  rayz = loadImage("src/img/rays.png");
  king = loadImage("src/img/king.png");
  cloudz = loadImage("src/img/clouds.png");
  cloudztran = loadImage("src/img/cloudstran.png");
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
    background(255,168,2);
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
    text(hrdisp, width/2, offset+100);
  }
  else {
    if(hrdisp==0) {
      hrdisp = 12;
    }
    textFont(font, 850);
    textAlign(CENTER);
    text(hrdisp, width/2, offset+100);
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
  boolean clouds=false, miniclouds=false; sun=false, rays=false, starry=false;

  // determine effects
  if(hr >= 7 && hr < 10) { //morning
    sunrays = true;
    clouds = true;
    sun = false;
    starry = false;
    rays = false;
  } else if(hr >= 10 && hr < 16) { //day
    sun = true;
    clouds = true;
    starry = false;
    rays = false;
  } else if(hr >= 16 && hr < 19) { //dusk
    clouds = false;
    miniclouds = true;
    sun = false;
    starry = false;
    rays = true;
  } else if(hr >= 19 || hr < 7) { // night
    clouds = false;
    miniclouds = true;
    sun = false;
    starry = true;
    rays = false;
  }
  
  // apply effects
  // 
  // TODO: clean this up into separate functions
  // 
  if(sun) { //rotating sun
    pushMatrix();
    translate(width/2,offset); //center coords (+)
    rotate(-frameCount*radians(90)/2500);
    translate(-width,-offset); //radius
    fill(255,220,0);
    ellipse(0,0,100,100); //make sure it's at 0,0
    popMatrix();
  }
  if(clouds) { //rotating clouds
    pushMatrix();
    translate(width/2,offset); //center coords (+)
    rotate(-frameCount*radians(90)/1000);
    translate(-width,-width); //radius
    image(cloudz,0,0,width*2,width*2);
    popMatrix();
  }
  if(starry) { //rotating stars
    pushMatrix();
    translate(width/2,offset); //center coords (+)
    rotate(-frameCount*radians(90)/1200);
    translate(-width,-width); //radius
    image(stars,0,0,width*2,width*2);
    popMatrix();
  }
  if(rays) { //rotating sun rays
    pushMatrix();
    translate(width/2,offset); //center coords (+)
    rotate(-frameCount*radians(90)/1000);
    translate(-width,-width); //radius
    image(rayz,0,0,width*2,width*2);
    popMatrix();
  }
  if(miniclouds) { //rotating transparent clouds
    pushMatrix();
    translate(width/2,offset); //center coords (+)
    rotate(-frameCount*radians(90)/500);
    translate(-width,-width); //radius
    image(cloudztran,0,0,width*2,width*2);
    popMatrix();
  }

  //king 
  pushMatrix();
  translate(width/2,offset); //center coords (+)
  rotate(-frameCount*radians(90)/1000);
  translate(-width*1.6,-width*1.6); //radius
  image(king,0,0,width*3.2,width*3.2);
  popMatrix();
}

// Ground
// ------------------------------------------------------------
void drawGrass(float sec) {
  pushMatrix();
  translate(width/2,width+offset);
  rotate(-frameCount*radians(90)/100);
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
float diameter;
float rollingTime;
void drawBall(float sec) {
  float growFactor = 6*sec;
  float change = growFactor/2;
  float ballDiameter = 160+growFactor;
  diameter = ballDiameter;
  float rotAngle = radians(90)/1000;
  float rotDistance = ballDiameter-ballDiameter*Math.sin(90-rotAngle);
  float rollSpeed = 10*rotDistance;
  float rollTime = (((width-ballDiameter/2)*PI/4)+ballDiameter/2)/rollSpeed;
  rollingTime = rollTime;
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
    translate(-width/2+xTranslate-ballDiameter/2,width+offset-yTranslate-change);
    rotate(onCount*rotAngle);
    translate(-ballDiameter/2, -ballDiameter/2);
    image(ball, 0, 0, ballDiameter, ballDiameter);
  }
  else if(sec>=rollTime && sec<(59-rollTime)) {
    onCount = 0;
    onAngleBall=0;
    translate(width/2,offset-change);
    rotate(frameCount*radians(90)/20);
    translate(-ballDiameter/2, -ballDiameter/2);
    image(ball, 0, 0, ballDiameter, ballDiameter);
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
    translate(width/2+xTranslate,offset+yTranslate-change);
    rotate(offCount*rotAngle);
    translate(xTranslate-prevDiam/2, yTranslate-prevDiam/2);
    image(ball, 0, 0, ballDiameter, ballDiameter);
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
double prevTranslate = 0;
double prevXTranslate = 0;
void drawPrince(float mil, float sec) {
  float growFactor = 6*sec;
  float change = growFactor/2;
  float ballDiameter = 160+growFactor;
  float rotAngle = radians(90)/100;
  float rotDistance = diameter-diameter*Math.sin(90-rotAngle);
  float rollSpeed = 10*rotDistance;
  float rollTime = (((width-diameter/2)*PI/4)+diameter/2)/rollSpeed;
  float princeWidth = 180*.6-sec*.8;
  float princeHeight = 253*.6-sec*180/253*.8;
  double numFrame = ((diameter-160)/6)*50;
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
  double degChange = 90/rollingTime/frameRate;
  if(sec<rollingTime) {
    offAngle = 0;
    onAngle = radians(degrees(onAngle)+degChange);
    double side = Math.sqrt(2*width*width-2*width*width*Math.cos(onAngle));
    double theta = Math.asin(width*Math.sin(onAngle)/side);
    double phi = radians(90-degrees(theta));
    double xTranslate = side*Math.sin(phi);
    double yTranslate = side*Math.sin(theta);
    image(
      prince,
      -width/2+xTranslate-ballDiameter-princeWidth*.4,
      width+offset-yTranslate-ballDiameter/2+princeHeight*.4,
      princeWidth,
      princeHeight
    );
  }
  else if(sec>=(59-rollingTime)) {
    double degChange = 45/rollingTime/frameRate;
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
      width/2+xTranslate-princeWidth*.7,
      offset+prevTranslate+yTranslate-ballDiameter/2+princeHeight*.4,
      180*.6-sec*.3,
      253*.6-sec*180/253*.8
    );
    princeAngle = 0;
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
      offset-radius+yTranslate+princeHeight*.4,
      180*.6-sec*.3,
      253*.6-sec*180/253*.8
    );
    prevTranslate = yTranslate;
    prevXTranslate = xTranslate;
  }
}

// Minutes
// ------------------------------------------------------------
void drawMins(int minutes) {
  int hspacing = width/30.3;
  int vspacing = height/24;
  int dot_size = 10;
  int row=1,col=-1;
  for(int m=0;m<minutes;m++) {
    col++;
    if(m==30) {
      row += 1;
      col = 0;
    }
    fill(255,255,255);
    ellipse(24+hspacing*col,24+vspacing*(row-1),dot_size,dot_size);
  }
}
