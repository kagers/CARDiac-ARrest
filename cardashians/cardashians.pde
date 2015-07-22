import processing.video.*;

imgProcess ip;
Capture cam;
ArrayList<PVector> Beret;
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

  if(cam.available()){
    cam.read();
  }
  opencv = new OpenCV(this,cam);
  ip = new imgProcess(opencv,2); 
  Parray = ip.unwarpCards();
  //image(ip.threshed,0,0); //depicts image in black'n'white
  image(cam,0,0);
  ip.outlineCards();
  Beret=ip.getBenters();
  for (PVector p:Beret) {
    fill(255,0,0);
    ellipse(p.x,p.y,10,10);
  }
    
  if(p1.isWinner()){
    noLoop();
    text("p1 winnerp1  winner chp1icken dinner",100,100);
  } else if (p2.isWinner()){
    noLoop();
    text("p2 Congragulations collect your prize at the front desk!",100,100);
  }

    

  stroke(0);
  fill(255);
  textSize(10);
  text("P1 has " + p1.cardCount + " cards", width/4,height-100);
  text("P2 has " + p2.cardCount + " cards", width*(3/4), height-100);

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
      text(numToCard(picNum),300,750);
      PVector center=ip.findBenter(ip.cards.get(0));
      fill(255,0,0);
      if (center!=null) {
      ellipse(center.x,center.y,10,10);
    */

    try{
      p1card=new Card(ip.minDif(Parray.get(0)));
      p2card=new Card(ip.minDif(Parray.get(1)));
      if(p1card.compareTo(p2card) > 0){
        p1.wonHand();
        p2.lostHand();
      } else if (p1card.compareTo(p2card) < 0){
        p1.lostHand();
        p2.wonHand();
      } else {
        //war
      } 
    } catch (NullPointerException e){}
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
    

