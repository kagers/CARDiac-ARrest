class Sprite {

  int numFrames;
  int xCor, yCor;
  ArrayList<PImage> frames;
  ArrayList<PImage> sexFrames;
  int[] delay = new int[5];
  int frame, sframe;
  String prefix;
  

  Sprite( int x, int y, String pre, int n ) {
    
    xCor = x;
    yCor = y;
    
    prefix = pre;
    numFrames = 0;
    frames = new ArrayList<PImage>();
    sexFrames=new ArrayList<PImage>();
    delay[0] = 3;
    delay[1] = 2;
    delay[2] = 1;
    delay[3] = 1;
    delay[4] = 1;
    for ( int i = 0; i < n; i++ ) {
      for ( int j = 0; j < delay[i]; j++ ) {
        frames.add(loadImage( prefix + i + ".png" ));
        //println("k");
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

  void moveToCenter(int cx, int cy) {
    while (xCor>cx) {
      xCor--;
      image(frames.get(0),xCor,yCor);
    }
    while (xCor<cx) {
      xCor++;
      image(frames.get(0),xCor,yCor);
    }
    while (yCor>cy) {
      yCor--;
      image(frames.get(0),xCor,yCor);
    }
    while (yCor<cy) {
      yCor++;
      image(frames.get(0),xCor,yCor);
    }
  }

  void displayAttack() {
    imageMode(CENTER);
    for (int i=0; i<frames.size();i++) {
      image(frames.get(i),xCor,yCor);
    }
  }

  void displayExplosion() {
    imageMode(CENTER);
    for (int i=0;i<sexFrames.size();i++) {
      image(sexFrames.get(i),xCor,yCor);
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

