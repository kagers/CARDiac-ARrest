import processing.video.*;

imgProcess ip;
Capture cam;
ArrayList<PImage> Parray;
int n=0;
OpenCV opencv;

void setup(){
  int width = 1500;
  int height = 1500;
  size(width,height);
  cam = new Capture(this);
  cam.start();
}

void draw(){
  if(cam.available()){
    cam.read();
    opencv = new OpenCV(this, cam);
    ip = new imgProcess(opencv, 4, -50);
    ip.outlineCards();
    Parray = ip.processCards(4);

  }
  image(cam,0,0);
  image(Parray.get(n),0,0);
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

