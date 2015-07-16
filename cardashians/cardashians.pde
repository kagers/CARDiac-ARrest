import gab.opencv.*;
import org.opencv.core.*;
import org.opencv.imgproc.*;
import processing.video.*;

OpenCV opencv;
PImage img,gray,blur,thresh; //to store each image to display after each opencv edit
ArrayList<Contour> cards; //stores contours of all four cards
Capture cam;
int ch,cw,threshold;
PImage fin;
int n=0;
ArrayList<PImage> Parray;

void setup(){
  //img = loadImage("test.png"); //test is the pic from the article
  int width = 1500;
  int height = 1500;
  size(width,height);
  cam = new Capture(this);
  cam.start();
  cw=210;
  ch=cw+100;
 
  threshold=-50;
  Parray = new ArrayList<PImage>();
}

void draw(){
  if(cam.available()){
    cam.read();
    opencv = new OpenCV(this, cam);
    opencv.adaptiveThreshold(591,threshold);
    thresh = opencv.getSnapshot();
    image(thresh,0,0);
    opencv.loadImage(thresh);

     cards =  biggestC(opencv.findContours(),16);
     outlineRects(cards);
 
    //PImage fin2=createImage(cw,ch,ARGB);
    //opencv.toPImage(warpPerspective(testContour.getPoints(),cw,ch), fin);
    //opencv.toPImage(warpPerspective(testContour2.getPoints(),cw,ch), fin2);
    //fin.save("test1.jpg");
    
    //image(fin2, cw+200,ch+400);
     for(int i=0;i<cards.size();i++){
       Parray.add(createImage(cw,ch, ARGB));
        opencv.toPImage(warpPerspective(cards.get(i).getPoints(),cw,ch),Parray.get(i));
    }
     try{
       image( Parray.get(n), cw+400,ch+400);
     } catch (ArrayIndexOutOfBoundsException e){}
  }
}

void keyPressed(){
  if(key==CODED){
    if (keyCode==RIGHT) {
      n++;
    } else if (keyCode==LEFT){
      n--;
      
      
      //Contour testContour=cards.get(0);
      //Contour testContour2=cards.get(1).getPolygonApproximation();
      println("elephant");
      
    }
    if (keyCode == UP){
      threshold++;
    } else if (keyCode == DOWN){
      threshold--;
    } if (keyCode == ENTER){
      Parray.get(n).save("cards/c"+n+".png");
    }
    
  }
}

/*
  finds numCard biggest contours in conts
  based on area and stores in arraylist
*/
ArrayList<Contour> biggestC(ArrayList<Contour> conts, int numCards){
  Contour max = conts.get(0);   // 
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
    biggest.add(conts.remove(n).getPolygonApproximation());
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

Mat getPerspectiveTransformation(ArrayList<PVector> inputPoints, int w, int h) {
  //sets up the temporary location for the warped image
  Point[] canons=new Point[4];
  canons[0]=new Point(w,h);
  canons[1]=new Point(w,0);
  canons[2]=new Point(0,0);
  canons[3]=new Point(0,h);
  // canons[0] = new Point(w, 0);
  // canons[1] = new Point(0, 0);
  // canons[2] = new Point(0, h);
  // canons[3] = new Point(w, h);
  
  //makes matrix of those points
  MatOfPoint2f canonMarker=new MatOfPoint2f();
  canonMarker.fromArray(canons);
  
  //makes array of the actual coordinates of the original image
  Point[] reals=new Point[4];
  for (int i=0;i<4;i++) {
    reals[i]=new Point(inputPoints.get(i).x, inputPoints.get(i).y);
  }
  MatOfPoint2f realMarker=new MatOfPoint2f(reals);

  //calculates diff in perspective b/w straight temp image and original skewed image
  return Imgproc.getPerspectiveTransform(realMarker,canonMarker);
}

Mat warpPerspective(ArrayList<PVector> inputPoints, int w, int h) {
  //gets the perspective transform diff b/w original and straight temp
  Mat transform=getPerspectiveTransformation(inputPoints,w,h);
  
  //makes location for final processed image
  Mat endMarker=new Mat(w,h,CvType.CV_8UC1);
  //applies perspective difference to create final image 
  Imgproc.warpPerspective(opencv.getColor(), endMarker, transform, new Size(w,h));
  return endMarker;
}
  

