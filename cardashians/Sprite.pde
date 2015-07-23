class Sprite {

  int numFrames;
  int xCor, yCor;
  ArrayList<PImage> frames;
  int[] delay = new int[5];
  int frame;
  String path;

  Sprite( int x, int y, int index, int n ) {

    xCor = x;
    yCor = y;

    path = "../pics/sprites/frame"+index+".png";
    numFrames = 0;
    frames = new ArrayList<PImage>();
    delay[0] = 30;
    delay[1] = 12;
    delay[2] = 6;
    delay[3] = 6;
    delay[4] = 6;
    for ( int i = 0; i < n; i++ ) {
      for ( int j = 0; j < delay[i]; j++ ) {
        frames.add(loadImage(path));
        //println("k");
        numFrames++;
      }
    }
    display();
  }

  void display() {
    try { 
      frame = (frame+1) % numFrames;
      imageMode(CENTER);
      image( frames.get(frame), xCor, yCor );
    } 
    catch (ArithmeticException e) {
      //println((frame+1), numFrames);
    }
  }
}

