import processing.video.*;

imgProcess ip;
Capture cam;
ArrayList<PImage> Parray;
int n=0;
OpenCV opencv;

void setup(){
  int width = 800;
  int height = 800;
  size(width,height);
  cam = new Capture(this);
  cam.start();
}

void draw(){
  if(cam.available()){
    cam.read();
    opencv = new OpenCV(this, cam);
    ip = new imgProcess(opencv);
    //ip.outlineCards();// outlines don't work yet
    Parray = ip.processCards(2);//does countours+warp takes numCards
    //image(ip.threshed,0,0); //depicts image in black'n'white
    image(cam,0,0);
    try{
      image(Parray.get(n),0,0);
    } catch(IndexOutOfBoundsException e){
    }
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
    Parray.get(n).save("cards/c"+n+".png");
  }
}

