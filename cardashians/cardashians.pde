import gab.opencv.*;
import processing.video.*;
/*
  Right now I'm just messing around with opencv 
  and trying to use the methods from the article online
*/

//:^)

OpenCV opencv;
PImage img,gray,blur,thresh; //to store each image to display after each opencv edit
ArrayList<Contour> cards; //stores contours of all four cards
Capture cam;

void setup(){
  //img = loadImage("test.png"); //test is the pic from the article
  int width = 1000;
  int height = 1000;
  size(width,height);
  cam = new Capture(this);
  cam.start();
  //image(img,0,0);
  //opencv = new OpenCV(this, img);
  // opencv.loadImage(gray); //by deafualt opencv images are grey
  //opencv.gray(); //these two methods seem kinda useless
  // opencv.blur(2); //also not really sure if blur is necessary either
  // blur = opencv.getSnapshot();
  // opencv.loadImage(blur);
  // opencv.threshold(80); //another threshold method, works for colors
  
}

void draw(){
 if(cam.available()){
    cam.read();
  }
 //image(cam,0,0);
  opencv = new OpenCV(this, cam);
  opencv.adaptiveThreshold(591,-50);
  thresh = opencv.getSnapshot();
  image(thresh,0,0);
  opencv.loadImage(thresh);
  
  ArrayList<Contour> cards =  biggestC(opencv.findContours(),4);
  outlineRects(cards);
  

}

/*
  finds numCard biggest contours in conts
  based on area and stores in arraylist
*/
ArrayList<Contour> biggestC(ArrayList<Contour> conts, int numCards){
  Contour max = conts.get(0);
  ArrayList<Contour> biggest = new ArrayList<Contour>();
  int n=0;
  for(int i=0; i <numCards;i++){
    for(int j = 0;j<conts.size();j++){
      Contour c = conts.get(j);
      if(c.area()>max.area()){
        max = c;
        n=j;
        }
    }
    biggest.add(conts.remove(n));
    max = conts.get(0);
  }
  return biggest; 
}

/*
  outlines the cards into a red rectangle
  need to find a way to store the rectangular image
  rather than just outline
*/
void outlineRects(ArrayList<Contour> conts){
  noFill();
  for(Contour c : conts){
    beginShape();
    stroke(255,0,0);
    for (PVector point : c.getPolygonApproximation().getPoints()) {
      vertex(point.x, point.y);
    }
    endShape(CLOSE);
  }  
}
