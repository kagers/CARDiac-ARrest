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
ArrayList<PImage> Parray;
int n=0;
OpenCV opencv;
PImage img;
Card p1card,p2card;
Player p1,p2;

public void setup(){
  int width = 1000;
  int height = 1000;
  size(width,height);
  cam = new Capture(this);
  cam.start();
  
}

public void draw(){
  try {
    if(cam.available()){
      cam.read();
    }
    opencv = new OpenCV(this,cam);
    ip = new imgProcess(opencv); 
    Parray = ip.unwarpCards();
    //image(ip.threshed,0,0); //depicts image in black'n'white
    image(cam,0,0);
    ip.outlineCards();
    //try{
      p1card=new Card(ip.minDif(Parray.get(0)));
      println("p1: "+p1card);
      p2card=new Card(ip.minDif(Parray.get(1)));
      println("p2: "+p2card);
      //image(Parray.get(n),790,0);
      
      //} catch(IndexOutOfBoundsException e){}
  } catch (NullPointerException e) {}
}

/*void keyPressed(){
  if(key==CODED){
    if (keyCode==RIGHT) {
      n++;
    } else if (keyCode==LEFT){
      n--;
    }
  }
  if (keyCode == ENTER){
    int picNum=ip.minDif(Parray.get(n)); 
    textSize(72);
    fill(255);
    stroke(0);
    text(numToCard(picNum),300,750);
  }
}*/

public String numToCard(int picNum) {
  int s=picNum%4;
  int n =(picNum/4)+6;
  String[] suits={"diamonds","clubs","hearts","spades"};
  String[] faces={"jack","queen","king","ace"};
  String suit=suits[s];
  String face=""+n;
  if (n>10) {
    int t=n%10;
    face=faces[t-1];
  }
  return face+" of "+suit;
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
    String filename="../pics/c"+pindex+".png";
    photo=loadImage(filename);
  }

  Card (int p) {
    suit=p%4;
    value=(p/4);
    String filename="../pics/c"+p+".png";
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
  ArrayList<Card> myCards;
  Player() {
    cardCount=18;
    myCards=new ArrayList<Card>();
  }
  public void addToDeck(Card c){
    myCards.add(c);
    cardCount++;
  }
  public Card withdraw() {
    cardCount--;
    return myCards.remove(0);
  }
  public boolean isWinner() {
    return cardCount==36;
  }

}





class imgProcess{

  /*--------------------------Variables-----------------------------------*/
  OpenCV opencv;
  PImage threshed; //image after adaptive threshold
  ArrayList<Contour> cards; //stores contours of all the cards
  int ch, cw; //unwarped card demensions
  int numCs; //number of cards


  /*-------------------------Constructors--------------------------------*/

  imgProcess(OpenCV op, int numCards, int th){
    opencv = op;
    cw = 310;
    ch = 210;
    numCs = numCards;
    thresh(th);
    cards =  biggestC(opencv.findContours(),numCs);
  }
  
  imgProcess(OpenCV op, int numCards){
    this(op, numCards, -50);
  }
  
  imgProcess(OpenCV op){
    this(op, 2, -50);
  }
  
  /*-------------------------------Methods--------------------------------*/
  
  /*
    sets dimensions for unwarped card
  */
  public void setCardD(int newCh,int newCw){
    ch = newCh;
    cw = newCw;
  }
  
  
  /*
    runs adaptive threshold
  */
  public void thresh(int threshold){
    opencv.adaptiveThreshold(591,threshold);
    threshed = opencv.getSnapshot();    
    opencv.loadImage(threshed);
  }

  
  /*-----------------------------Contour Methods----------------------------*/
                   
  /*
    finds numCard biggest contours in conts
    based on area and stores in arraylist
  */
  public ArrayList<Contour> biggestC(ArrayList<Contour> conts, int numCards){
    Contour max = conts.get(0);   // 
    ArrayList<Contour> biggest = new ArrayList<Contour>();
    int n=0;
    for(int i=0; i <numCards;i++){
      for(int j = 0;j<conts.size();j++){
        Contour c = conts.get(j);
        if(c.area()>max.area()){
          max = c;
          n=j;
        }
      }
      biggest.add(conts.remove(n));
      if(conts.size() > 0){
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
  public void outlineRects(ArrayList<Contour> conts){
    noFill();
    for(Contour c : conts){
      beginShape();
      strokeWeight(4);
      stroke(0,255,0);
      for (PVector point : c.getPolygonApproximation().getPoints()) {
        vertex(point.x, point.y);
      }
      endShape(CLOSE);
    }  
  }
  
  public void outlineCards(){
    outlineRects(cards);
  }

  /* ----------------------Warp Persepective Methods-----------------------------*/

  /*
    unwarps a single contour
  */
  public PImage unwarpC(Contour c){    
    PImage newImg =createImage(ch,cw, ARGB);
    opencv.toPImage(warpPerspective(c.getPolygonApproximation().getPoints(),ch,cw), newImg);
    return newImg;
  }

  /*
    unwarps a list of contours
  */
  public ArrayList<PImage> unwarpCards(ArrayList<Contour> contours){
    ArrayList<PImage> p = new ArrayList<PImage>();
    for(Contour c: contours){
      p.add(unwarpC(c));
    }
    return p;
  }

  public ArrayList<PImage> unwarpCards(){
    return unwarpCards(cards);
  }

  public Mat getPerspectiveTransformation(ArrayList<PVector> inputPoints, int w, int h) {
    //sets up the temporary location for the warped image
    Point[] canons=new Point[4];
    canons[0]=new Point(w,h);
    canons[1]=new Point(w,0);
    canons[2]=new Point(0,0);
    canons[3]=new Point(0,h);
    // canons[0] = new Point(w, 0);
    // canons[1] = new Point(0, 0);
    // canons[2] = new Point(0, h);
    // canons[3] = new Point(w, h);
  
    //makes matrix of those points
    MatOfPoint2f canonMarker=new MatOfPoint2f();
    canonMarker.fromArray(canons);
  
    //makes array of the actual coordinates of the original image
    Point[] reals=new Point[4];
    for (int i=0;i<4;i++) {
      reals[i]=new Point(inputPoints.get(i).x, inputPoints.get(i).y);
    }
    MatOfPoint2f realMarker=new MatOfPoint2f(reals);

    //calculates diff in perspective b/w straight temp image and original skewed image
    return Imgproc.getPerspectiveTransform(realMarker,canonMarker);
  }

  public Mat warpPerspective(ArrayList<PVector> inputPoints, int w, int h) {
    //gets the perspective transform diff b/w original and straight temp
    Mat transform=getPerspectiveTransformation(inputPoints,w,h);
  
    //makes location for final processed image
    Mat endMarker=new Mat(w,h,CvType.CV_8UC1);
    //applies perspective difference to create final image 
    Imgproc.warpPerspective(opencv.getColor(), endMarker, transform, new Size(w,h));
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
    loadPixels();
    for (int i=0; i<aa.length; i++) {
      pixels[i] = color((int)cc[i]);
    }
    updatePixels();
    return ret;
  }

  public int minDif(PImage a) {
    ArrayList<PImage> L=new ArrayList<PImage>();
    for (int i=0;i<36;i++) {
      PImage newCard=loadImage("../pics/c"+i+".png");
      L.add(newCard);
    }
    long dif = absDif(a, L.get(0),true);
    int ret = 0;
    long b;
    for (int i=0; i<L.size (); i++) {
      b = absDif(a, L.get(i), true);
      if (b<dif) {
        dif=b;
        ret=i;
        println(i);
      }
      b = absDif(a, L.get(i), false);
      if (b<dif) {
        dif=b;
        ret=i;
        println(i);
      }
    }
    println(dif);
    println(ret);
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
