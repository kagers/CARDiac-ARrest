import processing.video.*;

imgProcess ip;
Capture cam;
ArrayList<PImage> Parray;
int n=0;
OpenCV opencv;
PImage img;

void setup(){
  int width = 1000;
  int height = 1000;
  size(width,height);
  cam = new Capture(this);
  cam.start();
   
}

void draw(){
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
    try{
      image(Parray.get(n),790,0);
    } catch(IndexOutOfBoundsException e){
    }
  } catch (Exception e) {}
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
    String s=""+n;
    println("text");
    //Parray.get(n).save("../pics/c"+n+".png");
    textSize(72);
    fill(255);
    text(n,790,1000);
    int suit=n%4;
    int number=(n/4)+6;
  }
}

String numToCard(int s, int n) {
  String[] suits={"diamonds","clubs","hearts","spades"};
  String[] faces={"jack","queen","king","ace"};
  String suit=suits[s];
  String face;
  if (n>5) {
    int t=n%5;
    face=faces[t];
  }
  return face+" of "+suit;
}
    

