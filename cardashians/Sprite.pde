class Sprite {

  int numFrames;
  int xCor, yCor;
  ArrayList<PImage> frames;
  ArrayList<PImage> sexFrames;
  int[] delay = new int[5];
  int frame, sframe;
  String prefix;
  

  Sprite( int x, int y, int n ) {
    
    xCor = x;
    yCor = y;
    numFrames = 0;
    frames = new ArrayList<PImage>();
    sexFrames=new ArrayList<PImage>();
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

  boolean moveToCenter(int cx, int cy) {
    if (xCor==cx && yCor==cy) return true;
    
    if (xCor>cx) {
      xCor--;
      image(frames.get(0),xCor,yCor);
    }
    if (xCor<cx) {
      xCor++;
      image(frames.get(0),xCor,yCor);
    }
    if (yCor>cy) {
      yCor--;
      image(frames.get(0),xCor,yCor);
    }
    if (yCor<cy) {
      yCor++;
      image(frames.get(0),xCor,yCor);
    }

    return false;
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
      
  void loadSequence(int picNum) {
    ArrayList<PImage> newFrames=new ArrayList<PImage>();
    numFrames=0;
    for (int i=0; i<picNum;i++) {
      for (int j=0;j<delay[i];j++) {
        newFrames.add(loadImage(prefix+i+".png"));
        numFrames++;
      }
    }
    frames=newFrames;
    loadSexplosion(picNum);
  }

  void loadSexplosion(int n) {
    //sexFrames.add(loadImage("../pics/sprites/sexplosion/e"+(n%4)*2+".png"));
    sexFrames.add(loadImage("../pics/sprites/sexplosion/e0.png"));
    sexFrames.add(loadImage("../pics/sprites/sexplosion/e"+(((n%4)*2)+1)+".png"));
    for (int e=8;e<13;e++) {
      sexFrames.add(loadImage("../pics/sprites/sexplosion/e"+e+".png"));
    }
  }
  
}

