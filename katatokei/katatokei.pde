PImage prince1, prince2, ball,grass;
int width = 600, height = 800;

void setup() {
  frameRate(60);
  prince1 = loadImage("img/prince1.png");
  prince2 = loadImage("img/prince2.png");
  ball = loadImage("img/ball1.png");
  grass = loadImage("img/grassmove.png");
  size(width, height); //or whatever res our phone is
  noStroke();
  int hour = hour();
  //if(hour >= 7 && hour < 10) //morning
    background(188,222,255);
  /*
  else if(hour >= 10 && hour < 16) //day
    background(89,176,246);
  else if(hour >= 16 && hour < 20) //dusk
    background(255,104,10);
  else if(hour >= 20 || hour < 7) //nighttime
    background(46,95,132); 
  */
}

void draw() {
  //time vars
  int mil = millis();
  int sec = second();
  int min = minute();
  int hour = hour();
  float s = mil/100;
  float t = (mil/1000)%30;
  
  //environment effects
  boolean stars=false, clouds=false, sun=false, sunrays=false;
  
  //overlay bg
  background(188,222,255);
  
  if(hour >= 7 && hour < 10) { //morning
    sunrays = true; //moving in circle would look nice
    clouds = true;
    sun = false;
    stars = false;
  }
  if(hour >= 10 && hour < 4) { //day
    sun = true;
    clouds = true;
    sunrays = false;
    stars = false;
  }
  if(hour >= 4 && hour < 7) { //dusk
    sunrays = true;
    clouds = false;
    sun = false;
    stars = false;
  }
  else if(hour > 20 || hour < 7) { //nighttime
    stars = true;
    clouds = true;
    sunrays = false;
    sun = false;
  }
  
  if(sun) { //draw the sun
      //fill();
  }
  if(sunrays) { //draw sunrays
    
  }
  if(clouds) { //draw clouds
    
  }
  if(stars) { //draw stars lol
    
  }
  
  //base
  fill(76,197,82);
  image(grass,-30,700,300,183);


  //ball
  pushMatrix();
  translate(width*.4, height*.7);
  rotate(radians(frameCount));
  translate(-(ball.width), -(ball.height));
  //translate(-(-50+ball.width/2)/4, -(-50+ball.height/2));
  image(ball,width*.4+t,height*.7-t,160+t,160+t);
  popMatrix();
  
  //prince
  PImage prince;
  if(s%2==0) prince = prince1;
  else prince = prince2;
  image(prince,width*.3+t/2,height*.7+t/6,100-t/4,160-t/4);
  
  //hours -- could go for arc but that's trickier            
  int j = 0;
  int h = 1;
  for(int i=0;i<hour;i++) {
    j += 1;
    if(j*50>width) {
      j = 1;
      h += 1;
    }
    image(ball,20+40*j,40*h,30,30);
  }
}
