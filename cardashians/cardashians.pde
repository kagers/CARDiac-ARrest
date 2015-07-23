import processing.video.*;

imgProcess ip;
Capture cam;
ArrayList<PVector> Beret;
ArrayList<PImage> Parray;
OpenCV opencv;
PImage img;
Card p1card,p2card;
Player p1,p2;
Sprite s1,s2;
int n=0;
PImage cardTest;
boolean intro;

void setup(){
  int width = 1000;
  int height = 1000;
  size(width,height);
  cam = new Capture(this);
  cam.start();
  intro = true;
  p1=new Player();
  p2=new Player();
  noStroke();
  s1=new Sprite(0,0,"../pics/sprites/frame",5);
  s2=new Sprite(0,0,"../pics/sprites/frame",5);
}

void draw(){
  if(intro){
    //stuff happens
    intro=false;
  } else {

    if(cam.available()){
      cam.read();

      opencv = new OpenCV(this,cam);
      ip = new imgProcess(opencv,2);
      Parray = ip.unwarpCards();
      imageMode(NORMAL);
      image(cam,0,0);
      ip.outlineCards();
      try{
        Beret=ip.getBenters();
        //for (PVector p:Beret) {
        //fill(255,0,0);
        // ellipse(p.x,p.y,10,10);
        //}
        s1.xCor=(int)Beret.get(0).x;
        s1.yCor=(int)Beret.get(0).y;
        s1.display();
        s2.xCor=(int)Beret.get(1).x;
        s2.yCor=(int)Beret.get(1).y;
        s2.display();
      } catch(NullPointerException e){}
      try{
        image(Parray.get(n),790,0);
      } catch(IndexOutOfBoundsException e){
      }
    }
 
    
    if(p1.isWinner()){
      noLoop();
      text("p1 winnerp1  winner chp1icken dinner",100,100);
    } else if (p2.isWinner()){
      noLoop();
      text("p2 Congragulations collect your prize at the front desk!",100,100);
    }
    fill(0);
    textSize(36);
    //println("ay");
    text("P1 has " + p1.cardCount + " cards", width/12,height-400);
    text("P2 has " + p2.cardCount + " cards", width-400, height-400);
    //s = new Sprite(100,100,"../pics/frames/frame",5);

  }
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
    int picNum = ip.minDif(Parray.get(0));
    println("p1 "+numToCard(picNum));
    int ind1=ip.minDif(Parray.get(0));
    p1card=new Card(ind1);
    int ind2=ip.minDif(Parray.get(1));
    p2card=new Card(ind2);

    int picNum2 = ip.minDif(Parray.get(1));
    println("p2 "+numToCard(picNum2));

    if(p1card.compareTo(p2card) > 0){
      p1.wonHand();
      p2.lostHand();
      println("p1 won hand");
    } else if (p1card.compareTo(p2card) < 0){
      p1.lostHand();
      p2.wonHand();
      println("p2 won hand");
    } else {
      p1.war();
      p2.war();
    }

    fill(255);
    rect(0,cam.height,width,height-cam.height);
    println("outside");

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
