PImage prince;

void setup() {
  //prince = loadImage("prince.jpg");
  size(800, 800);
  frameRate(60);
}

void draw() {
  background(230);
  int mil = millis();
  int min = minute();
  
  int s = mil / 100;
  
  fill(130,202,250);
  ellipse(400,400,700,700); //change to depend on hour
  
  fill(76,197,82);
  //stroke(76,197,82);

  ellipse(450+s/4,600-s,s*2,s*2);
  rect(350-s/2,500-s/8,100-s/4,160-s/4);
    //image(prince,250,450);
    //prince.resize(w,h);
  ellipse(400,1400,1600,1600); //base
  
  noFill();
  stroke(0);
  ellipse(400,400,700,700); //border
}
