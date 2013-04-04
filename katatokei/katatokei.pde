PImage prince;
import de.looksgood.ani.*;

void setup() {
  //prince = loadImage("prince.jpg");
  size(600, 800);
  smooth();
  noStroke();
  Ani.init(this);
}

void draw() {
  background(140,210,255); //gradient should go from blue to yellow to navy
  
  //ball
  fill(76,197,82);
  ellipse(350+s/4,700-s,s*2,s*2);
  
  //prince
  rect(250-s/2,600-s/8,100-s/4,160-s/4);
    //image(prince,250,450);
    //prince.resize(w,h);
  ellipse(300,1500,1600,1600); //base
}
 
void update(){
  int mil = millis();
  int min = minute();
  int s = mil / 100;
}
