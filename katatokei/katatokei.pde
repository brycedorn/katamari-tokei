PImage prince;

void setup() {
  prince = loadImage("http://www.freewebs.com/katamari_fan/prince.jpg");
  size(600, 800);
  smooth();
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
  int s = mil / 100;
  
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
  if(hour > 20 || hour < 7) { //nighttime
    stars = true;
    clouds = true;
    sunrays = false;
    sun = false;
  }
  
  if(sun) { //draw the sun
    
  }
  if(sunrays) { //draw sunrays
    
  }
  if(clouds) { //draw clouds
    
  }
  if(stars) { //draw clouds
    
  }

  //ball
  fill(76,197,82);
  ellipse(350+s/4,700-s,s*2,s*2);
  
  //prince
  image(prince,250-s/2,600-s/8,100-s/4,160-s/4);
  
  //hours
  for(int i=0;i<hour;i++) {
    ellipse(30+30*i,20,20,20); //change to arc perhaps
  }
  
  //base
  ellipse(300,1500,1600,1600);
}
