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
    sframe = -2;
    loadSequence();
    loadSexplosion();
  }

  void moveToCenter(int cx, int cy) {
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

   void display() {
    imageMode(CENTER);
    PImage current=frames.get(0);
    if (faceleft) {
      pushMatrix();
      scale(-1.0,1.0);
      image(current,-xCor,yCor);
      popMatrix();
    } else {
      image(current,xCor,yCor);
    }
  }
  
  boolean displayAttack() {
    imageMode(CENTER);
    if (frame<frames.size()) {
      PImage current=frames.get(frame);
      if (faceleft) {
        pushMatrix();
        scale(-1.0,1.0);
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

  boolean displayExplosion() {
    imageMode(CENTER);
    if(sframe< 0){
      display();
      sframe++;
    }else if (sframe<sexFrames.size()) {
      PImage current=sexFrames.get(sframe);
      if(sframe < 2){
        display();
      }
      if (faceleft) {
        image(current,xCor+40,yCor);
        sframe++;
      } else {
        image(current,xCor,yCor);
        sframe++;
      }
    } else if (sframe==sexFrames.size()) {
      return true;
    }
    return false;
  }
      
  void loadSequence() {
    ArrayList<PImage> newFrames=new ArrayList<PImage>();
    for (int i=0; i<10;i++) {
      if(i<5){  
        newFrames.add(loadImage(prefix+picNum+ "/" +i +".png"));
      } else if (i==5){
        newFrames.add(newFrames.get(4));
      } else {
        newFrames.add(newFrames.get(0));
      }
        
    }
    
    frames=newFrames;
  }

  void loadSexplosion() {
    for (int e=0;e<7;e++) {
      sexFrames.add(loadImage("../pics/sprites/sexplosion/e"+e+".png"));
    }
  }
  
}

