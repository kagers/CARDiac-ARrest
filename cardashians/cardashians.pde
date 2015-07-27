import processing.video.*;

imgProcess ip;
Capture cam;
ArrayList<PVector> Beret;
ArrayList<PImage> Parray;
OpenCV opencv;
Card p1card, p2card;
Player p1, p2;
Sprite s1, s2;
int n=0;
boolean intro, hasDrawn;
PFont fanta, fanta2, fanta3;
PImage hertz, heartz, borda, s, m, d, k, cardTest, img;
int preX, preY, picNum1, picNum2;

void setup() {
  int width = 800;
  int height = 800;
  size(width, height);
  cam = new Capture(this);
  cam.start();
  intro = true;
  //hasCenter=false;
  hasDrawn=false;
  p1=new Player();
  p2=new Player();
  noStroke();
  s1=new Sprite(0, 0, 3);
  s2=new Sprite(0, 0, 3);
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
  preX=1;
  preY=1;
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
      try {
        ip.outlineCards();
        Parray = ip.unwarpCards();
        Beret=ip.getBenters();
        //for (PVector p:Beret) {
        //fill(255,0,0);
        // ellipse(p.x,p.y,10,10);
        //}
        
        
        if (picNum1 != preX && picNum2 != preY) {
           int x1 = (int)Beret.get(0).x;
           int y1 = (int)Beret.get(0).y;
          s1.xCor= x1;
          s1.yCor= y1;
          picNum1 = ip.minDif(Parray.get(0));
          picNum2 =  ip.minDif(Parray.get(1));
          hasDrawn=false;
          s1.loadSequence(picNum1);
          s2.loadSequence(picNum2);
          preX=picNum1;
          preY = picNum2;
          println("phase1");
      } else if (!hasDrawn) {
          
          //s2.display();
          hasDrawn = s1.moveToCenter(width/2, height/2) &&  s2.moveToCenter(width/2, height/2);
        println("phase2");
      } else {

          s1.displayAttack();
          s2.displayExplosion();
          s2.xCor=(int)Beret.get(2).x;
          s2.yCor=(int)Beret.get(2).y;
          println("phase3");
        }
      } 
      catch(NullPointerException e) {
      }
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
      intro=false;
      background(255);
    } else if (keyCode==LEFT) {
      n--;
    }
  }
  if (keyCode == ENTER) {
/*
    println("p1 "+numToCard(picNum));
    int ind1=ip.minDif(Parray.get(0));
    p1card=new Card(ind1);
    int ind2=ip.minDif(Parray.get(1));
    p2card=new Card(ind2);
    int picNum2 = ip.minDif(Parray.get(1));
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

    fill(255);
    rect(0, cam.height, width, height-cam.height);
    println("outside");
  */
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
