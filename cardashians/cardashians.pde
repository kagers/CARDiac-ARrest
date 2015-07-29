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
boolean intro, s1win, s2win, war;
PFont fanta, fanta2, fanta3;
PImage hertz, heartz, borda, s, m, d, k, cardTest, img;
PImage tb, dw, yg, sk, cts, cts1, mz;
int pre1, pre2, picNum1, picNum2;
int markX, markY, markX1, markY1, markX2, markY2;
boolean flash;
int timer, winner, mode;

void setup() {
  int width = 800;
  int height = 800;
  size(width, height);
  frameRate(90);
  cam = new Capture(this);
  cam.start();
  //intro = true;
  war=false;
  p1=new Player();
  p2=new Player();
  noStroke();
  fanta = loadFont("URWChanceryL-MediItal-30.vlw");
  fanta2 = loadFont("FreeSans-48.vlw");
  fanta3 = loadFont("Courier10PitchBT-Roman-48.vlw");
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
  tb=loadImage("../pics/outro/tbt.jpg");
  dw=loadImage("../pics/outro/dw.jpg");
  yg=loadImage("../pics/outro/yg.jpg");
  sk=loadImage("../pics/outro/sk.jpg");
  cts=loadImage("../pics/outro/t1.png");
  cts1=loadImage("../pics/outro/t2.png");
  mz=loadImage("../pics/outro/mz.jpg");
  markX=width/2;
  markY=height*1/8;
  markX1=width/2;
  markY1=height*2/3+125;
  markX2=width/2;
  markY2=height*2/3+210;
  flash=true;
  timer=0;
  winner=0;
  mode=0;
}

void draw() {
  if (mode==0) {
    //stuff happens
    outroSequence();
  } else if (mode==1) {

    if (cam.available()) {
      cam.read();

      opencv = new OpenCV(this, cam);
      ip = new imgProcess(opencv, 2);

      imageMode(NORMAL);
      image(cam, 0, 0);
      //image(ip.threshed,0,0);
      ip.outlineCards();
      Parray = ip.unwarpCards();

      try {
        Beret=ip.getBenters();

        picNum1 = ip.minDif(Parray.get(0));
        picNum2 =  ip.minDif(Parray.get(1));

        if (picNum1 != pre1 && picNum2 != pre2) {
          println("picnums!=pres");
          try {
            s1 = new Sprite((int)Beret.get(0).x, (int)Beret.get(0).y, picNum1, false);
            s2 = new Sprite((int)Beret.get(1).x, (int)Beret.get(1).y, picNum2, true);
            pre1=picNum1;
            pre2 = picNum2;
            println("phase1");
            c1=new Card(picNum1);
            c2=new Card(picNum2);
            println("player 1: "+numToCard(pre1));
            println("player 2: "+numToCard(pre2));
            s1win=false;
            s2win=false;
          } 
          catch (IndexOutOfBoundsException e) {
          }
        } else if (!( s1.centered && s2.centered)) {
          println("sprites not centered");
          s1.display();
          s2.display();
          int w = width/2;
          int h = cam.height/2;
          s1.moveToCenter(w, h);
          s2.moveToCenter(w, h);
          println("phase 2");
        } else if (!s1win && !s2win) {
          println("neither s1 nor s2 won");
          if (c1.compareTo(c2)>0) {
            println("player 1 is bigger");
            s1win=s1.displayAttack();
            s2.displayExplosion();
            if (war) war=false;
          } else if (c1.compareTo(c2)<0) {
            println("player 2 is bigger");
            s2win=s2.displayAttack();
            s1.displayExplosion();
            if (war) war=false;
          } else {
            //war
            println("war!");
            if (!war) {
              p1.war();
              p2.war();
              war=true;
            }
            textSize(300);
            textFont(fanta3);
            fill(255, 0, 0);
            text("WAR", 500, 100);
          }
          if (s1win) {
            p1.wonHand();
            p2.lostHand();
            //s1win=false;
          } else if (s2win) {
            p1.lostHand();
            p2.wonHand();
            //s2win=false;
          }
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
      //noLoop();
      winner=1;
      mode=2;
      //text("p1 winnerp1  winner chp1icken dinner", 100, 100);
    } else if (p2.isWinner()) {
      //noLoop();
      winner=2;
      mode=2;
      //text("p2 Congragulations collect your prize at the front desk!", 100, 100);
    }
    fill(255);
    textSize(36);
    //println("ay");
    text("P1 has " + p1.cardCount + " cards", width-800, height-100);
    text("P2 has " + p2.cardCount + " cards", width-200, height-100);
    //s = new Sprite(100,100,"../pics/frames/frame",5);
  } else if (mode==2) {
    outroSequence();
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
  if (key == TAB && mode==0) {
    //intro=false;
    mode=1;
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

void mouseClicked() {
  if (mode==0) {
    //background(255);
    //intro=false;
    mode=1;
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

void outroSequence() {
  background(0);
  PImage t = cts;

  //marquee
  textSize(50);
  fill(0, 255, 0);
  text("WINNER", markX, markY);
  markX-=3.5;
  text("CHICKEN DINNER", markX2, markY2);
  markX2-=2.5;
  textSize(70);
  text("WINNER", markX1, markY1);
  markX1+=2;
  if (markX<-width/4) {
    markX=width+5;
  }
  if (markX1>width+width*1/3) {
    markX1=-width/3;
  }
  if (markX2<-width/2) {
    markX2=width+5;
  }

  //blink
  if (timer<=30) {
    fill(255, 0, 0);
    textAlign(CENTER);
    textSize(80);
    text("WINNER   WINNER", width/2, height/2); 
    fill(255, 0, 255);
    t = cts;
    timer++;
  } else if (timer>30 && timer<=60) {
    fill(0, 255, 255);
    t = cts1;
    timer++;
  } else if (timer>60) {
    timer=0;
  }

  //border
  noStroke();
  rect(0, 0, 10, height);
  rect(width-10, 0, 10, height);
  rect(0, height-10, width, 10);
  rect(0, 0, width, 10);

  //regular text
  fill(255, 0, 0);
  textSize(25);
  text("!! PLAYER "+winner+" WON THE GAME !!", width/2, height/2+50);

  //pics
  imageMode(CENTER);
  image(t, width/2, height/3.5);
  image(mz, width*3/4, height/3.5, mz.width/3, mz.height/3);
  image(dw, width/4, height/3.5, dw.width/4, dw.height/4);
  image(tb, width/4-40, height*2/3, tb.width/3, tb.height/3);
  image(yg, width/2, height*2/3, yg.width/5.5, yg.height/5.5);
  image(sk, width*3/4+40, height*2/3, sk.width/2.5, sk.height/2.5);
  flash = !flash;
}

void faceOff(Card p1card, Card p2card) {
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

