import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 
import gab.opencv.*; 
import org.opencv.core.*; 
import org.opencv.imgproc.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class cardashians extends PApplet {



imgProcess ip;
Capture cam;
ArrayList<PVector> Beret;
ArrayList<PImage> Parray;
OpenCV opencv;
Card c1, c2;
Player p1, p2;
Sprite s1, s2;
int n=0;
boolean intro,s1win,s2win;
PFont fanta, fanta2, fanta3;
PImage hertz, heartz, borda, s, m, d, k, cardTest, img;
int pre1, pre2, picNum1, picNum2;

public void setup() {
  int width = 1000;
  int height = 1000;
  size(width, height);
  frameRate(90);
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

public void draw() {
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

      try{
        Beret=ip.getBenters();

        picNum1 = ip.minDif(Parray.get(0));
        picNum2 =  ip.minDif(Parray.get(1));

        if (picNum1 != pre1 && picNum2 != pre2) {
          s1 = new Sprite((int)Beret.get(0).x,(int)Beret.get(0).y,picNum1,false);
          s2 = new Sprite((int)Beret.get(2).x,(int)Beret.get(2).y,picNum2,true);
          pre1=picNum1;
          pre2 = picNum2;
          println("phase1");
          c1=new Card(picNum1);
          c2=new Card(picNum2);
          s1win=false;
          s2win=false;
          
        } else if (!( s1.centered && s2.centered)) {
          s1.display();
          s2.display();
          int w = width/2;
          int h = cam.height/2;
          s1.moveToCenter(w, h);
          s2.moveToCenter(w, h);
          println("phase 2");

        } else if (!s1win && !s2win){
          if(c1.compareTo(c2)>0){
            s1win=s1.displayAttack();
            s2.displayExplosion();
          } else if (c1.compareTo(c2)<0){
            s2win=s2.displayAttack();
            s1.displayExplosion();
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

public void keyPressed() {
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

public void mouseClicked(){
  if(intro){
    background(255);
    intro=false;
  }
}


public String numToCard(int picNum) {
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

public void introSequence() {
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

public void faceOff(Card p1card, Card p2card){
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
class Card {
  PImage photo;
  
  //0->3, diamond->spade respectively
  int suit;
  
  //0->8, six->ace respectively 
  int value;
  
  //something for animation
  String animationType; //to be changed
  
  Card(int s, int v) {
    suit=s;
    value=v;
    int pindex=(4*v)+s;
    String filename="../pics/cards/c"+pindex+".png";
    photo=loadImage(filename);
  }

  Card (int p) {
    suit=p%4;
    value=(p/4);
    String filename="../pics/cards/c"+p+".png";
    photo=loadImage(filename);
  }
  
  public int compareTo(Card other) {
    /* for testing
       int suitSame=suit-other.suit; */
    int valueSame=value-other.value;
    return valueSame;
  }

  public String toString() {
    String[] suits={"diamonds","clubs","hearts","spades"};
    String[] faces={"jack","queen","king","ace"}; //0,1,2,3
    String s=suits[suit];
    String v=""+value;
    if (value>5)
      v=faces[value-5];
    return v+" of "+s;
  }
}
class FaceCard extends Card {
  FaceCard(int s, int v) {
    super(s,v);
    animationType="face";
  }
}
class NumCard extends Card {
  NumCard(int s, int v) {
    super(s,v);
    animationType="number";
  }
}
class Player {
  int cardCount;
  Card currentCard;
  Boolean isWar;
  int numWar;
  ArrayList<Card> myCards;
 
  Player() {
    cardCount=18;
    myCards=new ArrayList<Card>();
    isWar = false;
  }

  public void wonHand(){
    cardCount++;
    if(isWar){
      cardCount+=numWar*3;
      isWar = false;
      numWar=0;
    }
  }

  public void lostHand() {
    cardCount--;
    if(isWar){
      cardCount-=numWar*3;
      isWar = false;
      numWar=0;
    }
  }

  public void war(){
    isWar=true;
    numWar+=1;
  }

  public boolean isWinner() {
    return cardCount==36;
  }

}
class Sprite {

  int xCor, yCor;
  int picNum;
  int frame,sframe;
  ArrayList<PImage> frames;
  ArrayList<PImage> sexFrames;
  String prefix;
  Boolean centered, faceleft;

  Sprite( int x, int y, int n , boolean fleft) {
    prefix = "../pics/sprites/reggae/";
    xCor = x;
    yCor = y;
    picNum = n;
    frames = new ArrayList<PImage>();
    sexFrames=new ArrayList<PImage>();
    centered = false;
    faceleft=fleft;
    /*
    delay[0] = 3;
    delay[1] = 2;
    delay[2] = 1;
    delay[3] = 1;
    delay[4] = 1;
   
    String fixed=""+n;
    if (fixed.length()==1) 
      fixed="0"+n;
    for (int i=0;i<5;i++) {
      for (int j=0;j<delay[i];j++) {
        frames.add(loadImage("../pics/sprites/reggae/"+fixed+"/"+i+".png"));
        numFrames++;
      }
    }
    loadSequence(n);
    loadSexplosion(n);
    frame=0;
    */
    loadSequence();
    loadSexplosion();
  }

  /*void display() {    
    frame = (frame+1) % numFrames;
    imageMode(CENTER);
    image( frames.get(frame), xCor, yCor );
  }

  void displaySexplosion() {
    sframe=(sframe
    }*/

  public void display() {
    imageMode(CENTER);
    PImage current=frames.get(0);
    if (faceleft) {
      pushMatrix();
      scale(-1.0f,1.0f);
      image(current,-xCor,yCor);
      popMatrix();
    } else {
      image(current,xCor,yCor);
    }
  }

  public void moveToCenter(int cx, int cy) {
    int buffer =200;
    if ((xCor <= cx+buffer && xCor >= cx -buffer) &&
        (yCor<= cy+buffer && yCor >= cy-buffer)){
      centered=true;
    } 
    
    if (xCor>cx) {
      xCor-=50;
    }
    if (xCor<cx) {
      xCor+=50;
    }
    if (yCor>cy) {
      yCor-=50;
    }
    if (yCor<cy) {
      yCor+=50;
    }
  }

  public boolean displayAttack() {
    imageMode(CENTER);
    if (frame<frames.size()) {
      PImage current=frames.get(frame);
      if (faceleft) {
        pushMatrix();
        scale(-1.0f,1.0f);
        image(current,-xCor,yCor);
        popMatrix();
      } else {
        image(current,xCor,yCor);
      }
      frame++;
      return false;
    } else {
      return true;
    }
  }

  public void displayExplosion() {
    imageMode(CENTER);
    if (sframe<sexFrames.size()) {
      PImage current=sexFrames.get(sframe);
      if (!faceleft) {
        pushMatrix();
        scale(-1.0f,1.0f);
        image(current,-xCor,yCor);
        popMatrix();
      }
      image(current,xCor,yCor);
      sframe++;
    }
  }
      
  public void loadSequence() {
    ArrayList<PImage> newFrames=new ArrayList<PImage>();
    for (int i=0; i<10;i++) {
      if(i<5){  
        //newFrames.add(
        newFrames.add(loadImage(prefix+picNum+ "/" +i +".png"));
      } else if (i==5){
        newFrames.add(newFrames.get(4));
      } else {
        newFrames.add(newFrames.get(0));
      }
        
    }
    
    frames=newFrames;
  }

  public void loadSexplosion() {
    sexFrames.add(frames.get(0));
    sexFrames.add(frames.get(0));
    sexFrames.add(loadImage("../pics/sprites/sexplosion/e"+(picNum%4)*2+".png"));
    //sexFrames.add(loadImage("../pics/sprites/sexplosion/e0.png"));
    sexFrames.add(loadImage("../pics/sprites/sexplosion/e"+(((picNum%4)*2)+1)+".png"));
    for (int e=8;e<13;e++) {
      sexFrames.add(loadImage("../pics/sprites/sexplosion/e"+e+".png"));
    }
  }
  
}






class imgProcess {

  /*--------------------------Variables-----------------------------------*/
  OpenCV opencv;
  PImage threshed; //image after adaptive threshold
  ArrayList<Contour> cards; //stores contours of all the cards
  int ch, cw; //unwarped card demensions
  int numCs; //number of cards
  ArrayList<PVector> benters;

  /*-------------------------Constructors--------------------------------*/

  imgProcess(OpenCV op, int numCards, int th) {
    opencv = op;
    cw = 310;
    ch = 210;
    numCs = numCards;
    thresh(th);
    cards =  biggestC(opencv.findContours(), numCs);
  }

  imgProcess(OpenCV op, int numCards) {
    this(op, numCards, -50);
  }

  imgProcess(OpenCV op) {
    this(op, 2, -50);
  }

  /*-------------------------------Methods--------------------------------*/

  /*
    sets dimensions for unwarped card
   */
  public void setCardD(int newCh, int newCw) {
    ch = newCh;
    cw = newCw;
  }


  /*
    runs adaptive threshold
   */
  public void thresh(int threshold) {
    opencv.adaptiveThreshold(591, threshold);
    threshed = opencv.getSnapshot();    
    opencv.loadImage(threshed);
  }


  /*-----------------------------Contour Methods----------------------------*/

  /*
    finds numCard biggest contours in conts
   based on area and stores in arraylist
   */
  public ArrayList<Contour> biggestC(ArrayList<Contour> conts, int numCards) {
    Contour max = conts.get(0);   // 
    ArrayList<Contour> biggest = new ArrayList<Contour>();
    int n=0;
    for (int i=0; i <numCards; i++) {
      for (int j = 0; j<conts.size (); j++) {
        Contour c = conts.get(j);
        if (c.area()>max.area()) {
          max = c;
          n=j;
        }
      }
      biggest.add(conts.remove(n).getPolygonApproximation());
      if (conts.size() > 0) {
        max = conts.get(0);
      } else {
        break;
      }
    }
    return biggest;
  }

  /*
    outlines the cards into a green rectangle
   must be run after image is displayed in main
   */
  public void outlineRects(ArrayList<Contour> conts) {
    noFill();
    for (Contour c : conts) {
      beginShape();
      strokeWeight(4);
      stroke(0, 255, 0);
      for (PVector point : c.getPoints()) {
        vertex(point.x, point.y);
      }
      endShape(CLOSE);
    }
  }

  public void outlineCards() {
    outlineRects(cards);
  }

  public PVector findBenter(Contour c) {
    if (c.numPoints()==4) {
      //gets points of the contour of a card
      ArrayList<PVector> points = c.getPoints();
      for (PVector p : points) {
        p.z=1.0f;
      }

      //initialize array of all distances from first point??
      ArrayList<Float> dists = new ArrayList<Float>();
      for (int i=0; i<points.size (); i++) {
        dists.add(points.get(0).dist(points.get(i)));
      }

      //find point index with greatest distance from first point. to find diagonal?
      int max = 0;
      for (int i=0; i<dists.size (); i++) {
        if (dists.get(i)>dists.get(max)) {
          max = i;
        }
      }

      //orders the point indexes so that diagonals are next to each other?
      int[] order = new int[4];
      order[0] = 0;
      order[1] = max;
      if (max==1) {
        order[2] = 2;
        order[3] = 3;
      } else if (max==2) {
        order[2] = 1;
        order[3] = 3;
      } else if (max==3) {
        order[2] = 1;
        order[3] = 2;
      }

      //finds cross product of diagonal points
      PVector l1 = points.get(order[0]).cross(points.get(order[1]));

      PVector l2 = points.get(order[2]).cross(points.get(order[3]));

      //finds intersection of the two diagonals
      PVector intersex = l1.cross(l2);

      PVector result=new PVector(intersex.x/intersex.z, intersex.y/intersex.z);

      return result;
    } else {
      return null;
    }
  }

  public ArrayList<PVector> getBenters() {
    ArrayList<PVector> result=new ArrayList<PVector>();
    PVector max=findBenter(cards.get(0));
    result.add(max);
    for (int i=0; i<cards.size (); i++) {
      PVector tmp=findBenter(cards.get(i));
      if (tmp.x<max.x) {
        result.set(0, tmp);
        result.set(1, max);
      } else {
        result.add(tmp);
      }
    }
    return result;
  }

  public ArrayList<Contour> getSortedCards() {
    ArrayList<Contour> tmp=new ArrayList<Contour>();
    if (findBenter(cards.get(0)).x<findBenter(cards.get(1)).x) {
      tmp.add(cards.get(0));
      tmp.add(cards.get(1));
    } else {
      tmp.add(cards.get(1));
      tmp.add(cards.get(0));
    }
    cards=tmp;
    return cards;
  }  


  /* ----------------------Warp Persepective Methods-----------------------------*/

  /*
    unwarps a single contour
   */
  public PImage unwarpC(Contour c) {    
    PImage newImg =createImage(ch, cw, ARGB);
    ArrayList<PVector> pv = realign(c);
    if(pv == null){
      return null;
    }
    opencv.toPImage(warpPerspective(pv, ch, cw), newImg);
    return newImg;
  }

  /*
    unwarps a list of contours
   */
  public ArrayList<PImage> unwarpCards(ArrayList<Contour> contours) {
    ArrayList<PImage> p = new ArrayList<PImage>();
    for (Contour c : contours) {
      p.add(unwarpC(c));
    }
    return p;
  }

  public ArrayList<PImage> unwarpCards() {
    return unwarpCards(cards);
  }
  
  public ArrayList<PVector> fixCorners( ArrayList<PVector> points ){
    PVector upleft, upright, downleft, downright;
    upleft = new PVector();
    upright = new PVector();
    downleft = new PVector();
    downright = new PVector();
    
    ArrayList<PVector> newPoints = new ArrayList<PVector>();
    float middleX = (abs( points.get(0).x - points.get(2).x ) / 2) + min( points.get(0).x, points.get(2).x);
    float middleY = (abs( points.get(0).y - points.get(2).y ) / 2) + min( points.get(0).y, points.get(2).y);
    for ( int i = 0; i < points.size(); i++ ){
      PVector temp = points.get(i);
      if ( temp.x < middleX && temp.y < middleY ){
        upleft = points.get(i);
      }
      else if ( temp.x > middleX && temp.y < middleY ){
        upright = points.get(i);
      }
      else if ( temp.x < middleX && temp.y > middleY ){
        downleft = points.get(i);
      }
      else if ( temp.x > middleX && temp.y > middleY ){
        downright = points.get(i);
      }
    }
      
      newPoints.add(upleft);
      newPoints.add(downleft);
      newPoints.add(downright);
      newPoints.add(upright);
      
      return newPoints;
    
  }
  public ArrayList<PVector> realign( Contour c ){
    if (c.numPoints()==4) {    
    ArrayList<PVector> points;
    
    points = c.getPolygonApproximation().getPoints();
    

    
    if ( points.get(0).x  > points.get(1).x ){ // if the first point is upper right not upper left
      points = fixCorners(points);
    }
    
    /* fill(255,0,0);
    ellipse( points.get(0).x, points.get(0).y, 20, 20);
    fill(0,255,0);
    ellipse( points.get(1).x, points.get(1).y, 20, 20);*/
    
    return points;
    } else { 
      return null;
    }
  }

  public Mat getPerspectiveTransformation(ArrayList<PVector> inputPoints, int w, int h) {
    //sets up the temporary location for the warped image
    Point[] canons=new Point[4];
    canons[0]=new Point(w, h);
    canons[1]=new Point(w, 0);
    canons[2]=new Point(0, 0);
    canons[3]=new Point(0, h);
    // canons[0] = new Point(w, 0);
    // canons[1] = new Point(0, 0);
    // canons[2] = new Point(0, h);
    // canons[3] = new Point(w, h);

    //makes matrix of those points
    MatOfPoint2f canonMarker=new MatOfPoint2f();
    canonMarker.fromArray(canons);

    //makes array of the actual coordinates of the original image
    Point[] reals=new Point[4];
    for (int i=0; i<4; i++) {
      reals[i]=new Point(inputPoints.get(i).x, inputPoints.get(i).y);
    }
    MatOfPoint2f realMarker=new MatOfPoint2f(reals);

    //calculates diff in perspective b/w straight temp image and original skewed image
    return Imgproc.getPerspectiveTransform(realMarker, canonMarker);
  }

  public Mat warpPerspective(ArrayList<PVector> inputPoints, int w, int h) {
    //gets the perspective transform diff b/w original and straight temp
    Mat transform=getPerspectiveTransformation(inputPoints, w, h);

    //makes location for final processed image
    Mat endMarker=new Mat(w, h, CvType.CV_8UC1);
    //applies perspective difference to create final image 
    Imgproc.warpPerspective(opencv.getColor(), endMarker, transform, new Size(w, h));
    return endMarker;
  }




  /*-------------------------COMPARING------------------*/


  public long absDif(PImage a, PImage b, boolean reverse) {
    a.loadPixels();
    int[] aa = a.pixels;
    b.loadPixels();
    int[] bb = b.pixels;
    int[] cc = new int[aa.length];
    for (int i=0; i<aa.length; i++) {
      if (reverse) {
        cc[i] = abs(aa[i]-bb[bb.length-i-1]);
      } else {
        cc[i] = abs(aa[i]-bb[i]);
      }
    }
    long ret = 0L;
    for (int i=0; i<aa.length; i++) {
      ret += cc[i];
    }
    /*loadPixels();
     for (int i=0; i<aa.length; i++) {
     pixels[i] = color((int)cc[i]);
     }
     updatePixels();*/
    return ret;
  }

  public int minDif(PImage a) {
    ArrayList<PImage> L=new ArrayList<PImage>();
    for (int i=0; i<36; i++) {
      PImage newCard=loadImage("../pics/cards/c"+i+".png");
      L.add(newCard);
    }
    long dif = absDif(a, L.get(0), true);
    int ret = 0;
    long b;
    for (int i=0; i<L.size (); i++) {
      b = absDif(a, L.get(i), true);
      if (b<dif) {
        dif=b;
        ret=i;
        
      }
      b = absDif(a, L.get(i), false);
      if (b<dif) {
        dif=b;
        ret=i;
        
      }
    }
   
    
    return ret;
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "cardashians" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
