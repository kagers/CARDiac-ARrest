
import gab.opencv.*;
import org.opencv.core.*;
import org.opencv.imgproc.*;

class imgProcess{

  /*--------------------------Variables-----------------------------------*/
  OpenCV opencv;
  PImage threshed; //image after adaptive threshold
  ArrayList<Contour> cards; //stores contours of all four cards
  int ch, cw; //unwarped card demensions
  int threshold; 
  int numCs; //number of cards


  /*-------------------------Constructors--------------------------------*/

  imgProcess(OpenCV op, int numCards, int th){
    opencv = op;
    threshold = th;
    cw = 210;
    ch = 310;
    numCs = numCards;
    thresh(th);
  }
  
  imgProcess(OpenCV op, int numCardss){
    this(op, numCards, -50);
  }
  
  imgProcess(OpenCV op){
    this(op, 2, -50);
  }
  
  /*-------------------------------Methods--------------------------------*/
  
  /*
    sets dimensions for unwarped card
  */
  void setCardD(int newCh,int newCw){
    ch = newCh;
    cw = newCw;
  }
  
  
  /*
    runs adaptive threshold
  */
  void thresh(int th){
    opencv.adaptiveThreshold(591,th);
    threshed = opencv.getSnapshot();    
    opencv.loadImage(threshed);
  }

  /*
    unwarps numCards cards in img
  */
  ArrayList<PImage> processCards(int numCards){
    ArrayList<Contour> cards =  biggestC(opencv.findContours(),numCards);
    return unwarpCards(cards);
  }

  ArrayList<PImage> processCards(){
    processCards(numCs);
  }
  
  /*-----------------------------Contour Methods----------------------------*/
                   
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
     
      biggest.add(conts.remove(n));
      if(conts.size() > 0){
        max = conts.get(0);
      } else {
        break;
      }
    }
    return biggest; 
  }

  /*
    outlines the cards into a red rectangle
    doesn't work because rect is drawn on wrong image
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

  void outlineCards(){
    ArrayList<Contour> cards =  biggestC(opencv.findContours(),numCs);
    outlineRects(cards);
  }

  /* ----------------------Warp Persepective Methods-----------------------------*/

  /*
    unwarps a single contour
  */
  PImage unwarpC(Contour c){    
    PImage newImg =createImage(ch,cw, ARGB);
    opencv.toPImage(warpPerspective(c.getPolygonApproximation().getPoints(),ch,cw), newImg);
    return newImg;
  }

  /*
    unwarps a list of contours
  */
  ArrayList<PImage> unwarpCards(ArrayList<Contour> contours){
    ArrayList<PImage> p = new ArrayList<PImage>();
    for(Contour c: contours){
      p.add(unwarpC(c));
    }
    return p;
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
  
}
