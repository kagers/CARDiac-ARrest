import processing.video.*;

imgProcess ip;
Capture cam;
ArrayList<PImage> Parray;
int n=0;
OpenCV opencv;
PImage img;
PImage cardTest;

void setup(){
  int width = 1000;
  int height = 1000;
  size(width,height);
  cam = new Capture(this);
  cam.start();   
}

void draw(){
  delay(1000);
  try {
    if(cam.available()){
      cam.read();
      }
    opencv = new OpenCV(this,cam);
    //cardTest=loadImage("../pics/c0.png");
    //opencv=new OpenCV(this,cardTest);
    ip = new imgProcess(opencv); 
    Parray = ip.unwarpCards();
    image(ip.threshed,0,0); //depicts image in black'n'white
    image(cam,0,0);
    //image(cardTest,0,0);
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
    int picNum=ip.minDif(Parray.get(n)); 
    textSize(72);
    fill(0);
    text(numToCard(picNum),300,800);
  }
}

String numToCard(int picNum) {
  int s=picNum%4;
  int n=(picNum/4)+6;
  String[] suits={"diamonds","clubs","hearts","spades"};
  String[] faces={"jack","queen","king","ace"};
  String suit=suits[s];
  String face=""+n;
  if (n>10) {
    int t=n%10;
    println(t);
    face=faces[t-1];
  }
  return face+" of "+suit;
}
    
