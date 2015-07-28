class Sprite {

  int xCor, yCor;
  int picNum;
  int frame,sframe;
  ArrayList<PImage> frames;
  ArrayList<PImage> sexFrames;
  String prefix;
  Boolean centered;

  Sprite( int x, int y, int n ) {
    prefix = "../pics/sprites/reggae/";
    xCor = x;
    yCor = y;
    picNum = n;
    frames = new ArrayList<PImage>();
    sexFrames=new ArrayList<PImage>();
    centered = false;
    /*
    delay[0] = 3;
    delay[1] = 2;
    delay[2] = 1;
    delay[3] = 1;
    delay[4] = 1;
   
    String fixed=""+n;
    if (fixed.length()==1) 
      fixed="0"+n;
    for (int i=0;i<5;i++) {
      for (int j=0;j<delay[i];j++) {
        frames.add(loadImage("../pics/sprites/reggae/"+fixed+"/"+i+".png"));
        numFrames++;
      }
    }
    loadSequence(n);
    loadSexplosion(n);
    frame=0;
    */
    loadSequence();
    loadSexplosion();
  }

  /*void display() {    
    frame = (frame+1) % numFrames;
    imageMode(CENTER);
    image( frames.get(frame), xCor, yCor );
  }

  void displaySexplosion() {
    sframe=(sframe
    }*/

  void display() {
    imageMode(CENTER);
    image(frames.get(0),xCor,yCor);
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

  void displayAttack() {
    imageMode(CENTER);
    if (frame<frames.size()) {
      image(frames.get(frame),xCor,yCor);
      frame++;
    }
  }

  void displayExplosion() {
    imageMode(CENTER);
    if (sframe<sexFrames.size()) {
      image(sexFrames.get(sframe),xCor,yCor);
      sframe++;
    }
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
    sexFrames.add(frames.get(0));
    sexFrames.add(frames.get(0));
    sexFrames.add(loadImage("../pics/sprites/sexplosion/e"+(picNum%4)*2+".png"));
    //sexFrames.add(loadImage("../pics/sprites/sexplosion/e0.png"));
    sexFrames.add(loadImage("../pics/sprites/sexplosion/e"+(((picNum%4)*2)+1)+".png"));
    for (int e=8;e<13;e++) {
      sexFrames.add(loadImage("../pics/sprites/sexplosion/e"+e+".png"));
    }
  }
  
}

