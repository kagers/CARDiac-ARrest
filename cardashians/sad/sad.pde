ArrayList<PImage> pics = new ArrayList<PImage>();

void setup(){
  size(100,100);
  for (int i=0; i<36; i++){
     pics.add(loadImage("../capturer/cards/c"+i+".png")); 
  }
}

void draw(){
  
}
