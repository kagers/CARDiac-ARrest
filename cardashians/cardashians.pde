import processing.video.*;

imgProcess ip;
Capture cam;
ArrayList<PImage> Parray;
int n=0;
OpenCV opencv;
PImage img;
Card p1card,p2card;
Player p1,p2;

void setup(){
  int width = 1000;
  int height = 1000;
  size(width,height);
  cam = new Capture(this);
  cam.start();
  
}

void draw(){
  // try {
    if(cam.available()){
      cam.read();
    }
    //PImage lectanger=loadImage("v7CDE.png");
    //image(lectanger,0,0);
    opencv = new OpenCV(this,cam);
    //opencv=new OpenCV(this,lectanger);
    ip = new imgProcess(opencv,2); 
    Parray = ip.unwarpCards();
    //image(ip.threshed,0,0); //depicts image in black'n'white
    image(cam,0,0);
    ip.outlineCards();
    PVector center=ip.findBenter(ip.cards.get(0));
    PVector center2=ip.findBenter(ip.cards.get(1));
    fill(255,0,0);
    if (center!=null) {
    ellipse(center.x,center.y,10,10);
    }
    if (center2!=null) {
       ellipse(center2.x,center2.y,10,10);
    }
    //ellipse(346.0,5.49*pow(10,7),10,10);
    /*
    //try{
      p1card=new Card(ip.minDif(Parray.get(0)));
      //p2card=new Card(ip.minDif(Parray.get(1)));

      PVector center = ip.findBenter(ip.cards.get(0));
      
      fill(255,0,0);
      ellipse(center.x,center.y,10,10);
      //image(Parray.get(n),790,0);
      
      //} catch(IndexOutOfBoundsException e){}*/
    // } catch (NullPointerException e) {}
}

void keyPressed(){
  if(key==CODED){
    if (keyCode==RIGHT) {
      n++;
    } else if (keyCode==LEFT){
      n--;
    }
  }
  if (keyCode == ENTER){
    /*int picNum=ip.minDif(Parray.get(n)); 
    textSize(72);
    fill(255);
    stroke(0);
    text(numToCard(picNum),300,750);*/
    PVector center=ip.findBenter(ip.cards.get(0));
    fill(255,0,0);
    if (center!=null) {
    ellipse(center.x,center.y,10,10);
    }
  }
}

String numToCard(int picNum) {
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
    

