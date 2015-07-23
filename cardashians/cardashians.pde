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
Sprite s;

void setup(){
  int width = 1000;
  int height = 1000;
  size(width,height);
  cam = new Capture(this);
  cam.start();
  p1=new Player();
  p2=new Player();
  noStroke();
}

void draw(){
    if(cam.available()){
      cam.read();
    }
    try {
      opencv = new OpenCV(this,cam);
      ip = new imgProcess(opencv,2);
      Parray = ip.unwarpCards();
      image(cam,0,0);
      ip.outlineCards();
      Beret=ip.getBenters();
      for (PVector p:Beret) {
        fill(255,0,0);
        ellipse(p.x,p.y,10,10);
      }
    } catch (Exception e) {}
    
    if(p1.isWinner()){
      noLoop();
      text("p1 winnerp1  winner chp1icken dinner",100,100);
    } else if (p2.isWinner()){
      noLoop();
      text("p2 Congragulations collect your prize at the front desk!",100,100);
    }
    
    fill(0);
    textSize(36);
    println("ay");
    text("P1 has " + p1.cardCount + " cards", width/12,height-100);
    text("P2 has " + p2.cardCount + " cards", width-400, height-100);
    //s = new Sprite(100,100,"../pics/frames/frame",5);
}

void draw(){
  background(255);
  //try {
    /*if(cam.available()){
      cam.read();
    }
    //PImage lectanger=loadImage("v7CDE.png");
    //image(lectanger,0,0);
    opencv = new OpenCV(this,cam);
    //opencv=new OpenCV(this,lectanger);
    ip = new imgProcess(opencv,2); 
    //Parray = ip.unwarpCards();
    //image(ip.threshed,0,0); //depicts image in black'n'white
    image(cam,0,0);
    ip.outlineCards();
    Carray=ip.getBenters();
    for (PVector p:Carray) {
      fill(255,0,0);
      ellipse(p.x,p.y,10,10);
    }*/
    /*
    //try{
      p1card=new Card(ip.minDif(Parray.get(0)));
      //p2card=new Card(ip.minDif(Parray.get(1)));
>>>>>>> a9126fea59a97e4cef11d1276bae0691053249a1

    fill(0);
    textSize(36);
    println("ay");
    text("P1 has " + p1.cardCount + " cards", width/12,height-100);
    text("P2 has " + p2.cardCount + " cards", width-400, height-100);

    }*/

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

    //try{
      p1card=new Card(ip.minDif(Parray.get(0)));
      println("p1 card:"+numToCard(ip.minDif(Parray.get(0))));
      p2card=new Card(ip.minDif(Parray.get(1)));
      println("P2 card:"+numToCard(ip.minDif(Parray.get(1))));
      if(p1card.compareTo(p2card) > 0){
        p1.wonHand();
        p2.lostHand();
        println("p1 won hand");
      } else if (p1card.compareTo(p2card) < 0){
        p1.lostHand();
        p2.wonHand();
        println("p2 won hand");
      } else {
        //war
      }
      fill(255);
      rect(0,cam.height,width,height-cam.height);
      println("outside");
      //} catch (NullPointerException e){}
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
    
/*int war() {
  //int c=new Card(ip.minDif(Parray.get(0)));
  }*/
