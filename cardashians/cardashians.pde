import processing.video.*;

imgProcess ip;
Capture cam;
ArrayList<PVector> Beret;
ArrayList<PImage> Parray;
OpenCV opencv;
Card c1, c2;
Player p1, p2;
Sprite s1, s2;
int n=0;
boolean intro;
PFont fanta, fanta2, fanta3;
PImage hertz, heartz, borda, s, m, d, k, cardTest, img;
int pre1, pre2, picNum1, picNum2;

void setup() {
  int width = 1000;
  int height = 1000;
  size(width, height);
  cam = new Capture(this);
  cam.start();
  intro = true;
  p1=new Player();
  p2=new Player();
  noStroke();
  fanta = loadFont("URWChanceryL-MediItal-30.vlw");
  fanta2 = loadFont("FreeSans-48.vlw");
  fanta3 = loadFont("Courier10PitchBT-Roman-48.vlw");
  //fanta=loadFont("URWGothicL-Demi-48");
  hertz = loadImage("hattack.png");
  heartz = loadImage("flip.png");
  borda=loadImage("../pics/intro/border.png");
  borda.resize(width, height);
  s=loadImage("../pics/intro/s.jpg"); 
  s.resize(180, 277);
  m=loadImage("../pics/intro/m.jpg"); 
  m.resize(180, 277);
  d=loadImage("../pics/intro/d.jpg"); 
  d.resize(180, 277);
  k=loadImage("../pics/intro/k.jpg"); 
  k.resize(180, 277);
  pre1=-1;
  pre2=-1;
}

void draw() {
  if (intro) {
    //stuff happens
    introSequence();
  } else {

    if (cam.available()) {
      cam.read();

      opencv = new OpenCV(this, cam);
      ip = new imgProcess(opencv, 2);

      imageMode(NORMAL);
      image(cam, 0, 0);
      //image(ip.threshed,0,0);
      ip.outlineCards();
      Parray = ip.unwarpCards();
      int n=0;
      try{
        Beret=ip.getBenters();

        picNum1 = ip.minDif(Parray.get(0));
        picNum2 =  ip.minDif(Parray.get(1));

        if (picNum1 != pre1 && picNum2 != pre2) {
          s1 = new Sprite((int)Beret.get(0).x,(int)Beret.get(0).y,picNum1);
          s2 = new Sprite((int)Beret.get(1).x,(int)Beret.get(1).y,picNum2);
          pre1=picNum1;
          pre2 = picNum2;
          println("phase1");
          c1=new Card(picNum1);
          c2=new Card(picNum2);
          n = c1.compareTo(c2);
        } else if (!( s1.centered && s2.centered)) {
          s1.display();
          s2.display();
          int w = width/2;
          int h = cam.height/2;
          s1.moveToCenter(w, h);
          s2.moveToCenter(w, h);
          println("phase 2");

        } else {
          if(n > 0){
            s1.displayAttack();
            s2.displayExplosion();
          } else if (n <= 0){
            s2.displayAttack();
            s1.displayExplosion();
            }
        }
      }
      catch(NullPointerException e){}
      try {
        image(Parray.get(n), 790, 0);
      } 
      catch(Exception e) {
      }
    }


    if (p1.isWinner()) {
      noLoop();
      text("p1 winnerp1  winner chp1icken dinner", 100, 100);
    } else if (p2.isWinner()) {
      noLoop();
      text("p2 Congragulations collect your prize at the front desk!", 100, 100);
    }
    fill(0);
    textSize(36);
    //println("ay");
    text("P1 has " + p1.cardCount + " cards", width-800, height-100);
    text("P2 has " + p2.cardCount + " cards", width-200, height-100);
    //s = new Sprite(100,100,"../pics/frames/frame",5);
  }
}

void keyPressed() {
  if (key==CODED) {
    if (keyCode==RIGHT) {
      n++;
    } else if (keyCode==LEFT) {
      n--;
    }
  }
  if(key == TAB){
    intro=false;
    background(255);
  }
  if (keyCode == ENTER) {
    /*
    println("p1 "+numToCard(picNum1));
    p1card=new Card(picNum1);
    int ind2=ip.minDif(Parray.get(1));
    p2card=new Card(picNum2);
    println("p2 "+numToCard(picNum2));
    if (p1card.compareTo(p2card) > 0) {
      p1.wonHand();
      p2.lostHand();
      println("p1 won hand");
    } else if (p1card.compareTo(p2card) < 0) {
      p1.lostHand();
      p2.wonHand();
      println("p2 won hand");
    } else {
      p1.war();
      p2.war();
    }
    */
    
    fill(255);
    rect(0, cam.height, width, height-cam.height);
    println("outside");

  }
}

void mouseClicked(){
  if(intro){
    background(255);
    intro=false;
  }
}


String numToCard(int picNum) {
  int s=picNum%4;
  int n =(picNum/4)+6;
  String[] suits= {
    "diamonds", "clubs", "hearts", "spades"
  };
  String[] faces= {
    "jack", "queen", "king", "ace"
  };
  String suit=suits[s];
  String face=""+n;
  if (n>10) {
    int t=n%10;
    face=faces[t-1];
  }
  return face+" of "+suit;
}

void introSequence() {
  background(51, 102, 0);
  textFont(fanta, 40);
  textAlign(CENTER);
  fill(255);
  text("Team CARDiac ARrest\nPresents", width/2, height/6);
  if (mousePressed) {
    intro=false;
  }
  //image(heartz,width/5,height/6+10,heartz.width/8,heartz.height/8);
  //image(hertz,((width*4)/5)-(heartz.width/8),height/6+10,heartz.width/8,heartz.height/8);
  image(borda, 0, 0);
  //textFont(fanta2);
  textFont(fanta3);
  textSize(150);
  fill(255);
  text("WAR", width/2, height/2-140);
  fill(192, 192, 192);
  //rect(width/2-125,height/2-50,250,60);
  textSize(20);
  fill(255);
  text("PRESS RIGHT TO BEGIN", width/2, height/2-40);
  image(s, 125, height/2+40);
  image(m, 315, height/2+40);
  image(d, 505, height/2+40);
  image(k, 695, height/2+40);
}
/*int war() {
//int c=new Card(ip.minDif(Parray.get(0)));
}*/

void faceOff(Card p1card, Card p2card){
    if (p1card.compareTo(p2card) > 0) {
      p1.wonHand();
      p2.lostHand();
      println("p1 won hand");
    } else if (p1card.compareTo(p2card) < 0) {
      p1.lostHand();
      p2.wonHand();
      println("p2 won hand");
    } else {
      p1.war();
      p2.war();
    }
    fill(255);
    rect(0, cam.height, width, height-cam.height);
}
