class Sprite{
  
  int numFrames;
  int xCor, yCor;
  PImage[] frames = new PImage[numFrames];
  PImage frame;
  
  String prefix;
  
  public Sprite( int x, int y, String pre, int n ){
    
    xCor = x;
    yCor = y;
    
    prefix = pre;
    numFrames = n;
    
    for( int i = 0; i < numFrames; i++ ){
      PImage[i] = loadImage( prefix + i + ".png" );
    }
    
  }
  
  public display(){ 
    frame = (frame+1) % numFrames;
    image( image[frame], xCor, yCor );
  }
