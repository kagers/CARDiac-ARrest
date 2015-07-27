
import gab.opencv.*;
import org.opencv.core.*;
import org.opencv.imgproc.*;

class imgProcess {

  /*--------------------------Variables-----------------------------------*/
  OpenCV opencv;
  PImage threshed; //image after adaptive threshold
  ArrayList<Contour> cards; //stores contours of all the cards
  int ch, cw; //unwarped card demensions
  int numCs; //number of cards
  ArrayList<PVector> benters;

  /*-------------------------Constructors--------------------------------*/

  imgProcess(OpenCV op, int numCards, int th) {
    opencv = op;
    cw = 310;
    ch = 210;
    numCs = numCards;
    thresh(th);
    cards =  biggestC(opencv.findContours(), numCs);
  }

  imgProcess(OpenCV op, int numCards) {
    this(op, numCards, -50);
  }

  imgProcess(OpenCV op) {
    this(op, 2, -50);
  }

  /*-------------------------------Methods--------------------------------*/

  /*
    sets dimensions for unwarped card
   */
  void setCardD(int newCh, int newCw) {
    ch = newCh;
    cw = newCw;
  }


  /*
    runs adaptive threshold
   */
  void thresh(int threshold) {
    opencv.adaptiveThreshold(591, threshold);
    threshed = opencv.getSnapshot();    
    opencv.loadImage(threshed);
  }


  /*-----------------------------Contour Methods----------------------------*/

  /*
    finds numCard biggest contours in conts
   based on area and stores in arraylist
   */
  ArrayList<Contour> biggestC(ArrayList<Contour> conts, int numCards) {
    Contour max = conts.get(0);   // 
    ArrayList<Contour> biggest = new ArrayList<Contour>();
    int n=0;
    for (int i=0; i <numCards; i++) {
      for (int j = 0; j<conts.size (); j++) {
        Contour c = conts.get(j);
        if (c.area()>max.area()) {
          max = c;
          n=j;
        }
      }
      biggest.add(conts.remove(n).getPolygonApproximation());
      if (conts.size() > 0) {
        max = conts.get(0);
      } else {
        break;
      }
    }
    return biggest;
  }

  /*
    outlines the cards into a green rectangle
   must be run after image is displayed in main
   */
  void outlineRects(ArrayList<Contour> conts) {
    noFill();
    for (Contour c : conts) {
      beginShape();
      strokeWeight(4);
      stroke(0, 255, 0);
      for (PVector point : realign(c)) {
        vertex(point.x, point.y);
      }
      endShape(CLOSE);
    }
  }

  void outlineCards() {
    outlineRects(cards);
  }

  PVector findBenter(Contour c) {
    if (c.numPoints()==4) {
      //gets points of the contour of a card
      ArrayList<PVector> points = c.getPoints();
      for (PVector p : points) {
        p.z=1.0;
      }

      //initialize array of all distances from first point??
      ArrayList<Float> dists = new ArrayList<Float>();
      for (int i=0; i<points.size (); i++) {
        dists.add(points.get(0).dist(points.get(i)));
      }

      //find point index with greatest distance from first point. to find diagonal?
      int max = 0;
      for (int i=0; i<dists.size (); i++) {
        if (dists.get(i)>dists.get(max)) {
          max = i;
        }
      }

      //orders the point indexes so that diagonals are next to each other?
      int[] order = new int[4];
      order[0] = 0;
      order[1] = max;
      if (max==1) {
        order[2] = 2;
        order[3] = 3;
      } else if (max==2) {
        order[2] = 1;
        order[3] = 3;
      } else if (max==3) {
        order[2] = 1;
        order[3] = 2;
      }

      //finds cross product of diagonal points
      PVector l1 = points.get(order[0]).cross(points.get(order[1]));

      PVector l2 = points.get(order[2]).cross(points.get(order[3]));

      //finds intersection of the two diagonals
      PVector intersex = l1.cross(l2);

      PVector result=new PVector(intersex.x/intersex.z, intersex.y/intersex.z);

      return result;
    } else {
      return null;
    }
  }

  ArrayList<PVector> getBenters() {
    ArrayList<PVector> result=new ArrayList<PVector>();
    PVector max=findBenter(cards.get(0));
    result.add(max);
    for (int i=0; i<cards.size (); i++) {
      if (findBenter(cards.get(i)).x<max.x) {
        PVector tmp=findBenter(cards.get(i));
        result.set(0, tmp);
        result.set(1, max);
      } else {
        result.add(findBenter(cards.get(i)));
      }
    }
    return result;
  }

  ArrayList<Contour> getSortedCards() {
    ArrayList<Contour> tmp=new ArrayList<Contour>();
    if (findBenter(cards.get(0)).x<findBenter(cards.get(1)).x) {
      tmp.add(cards.get(0));
      tmp.add(cards.get(1));
    } else {
      tmp.add(cards.get(1));
      tmp.add(cards.get(0));
    }
    cards=tmp;
    return cards;
  }  


  /* ----------------------Warp Persepective Methods-----------------------------*/

  /*
    unwarps a single contour
   */
  PImage unwarpC(Contour c) {    
    PImage newImg =createImage(ch, cw, ARGB);
    ArrayList<PVector> pv = realign(c);
    if(pv == null){
      return null;
    }
    opencv.toPImage(warpPerspective(pv, ch, cw), newImg);
    return newImg;
  }

  /*
    unwarps a list of contours
   */
  ArrayList<PImage> unwarpCards(ArrayList<Contour> contours) {
    ArrayList<PImage> p = new ArrayList<PImage>();
    for (Contour c : contours) {
      p.add(unwarpC(c));
    }
    return p;
  }

  ArrayList<PImage> unwarpCards() {
    return unwarpCards(cards);
  }
  
  ArrayList<PVector> fixCorners( ArrayList<PVector> points ){
    PVector upleft, upright, downleft, downright;
    upleft = new PVector();
    upright = new PVector();
    downleft = new PVector();
    downright = new PVector();
    
    ArrayList<PVector> newPoints = new ArrayList<PVector>();
    float middleX = (abs( points.get(0).x - points.get(2).x ) / 2) + min( points.get(0).x, points.get(2).x);
    float middleY = (abs( points.get(0).y - points.get(2).y ) / 2) + min( points.get(0).y, points.get(2).y);
    for ( int i = 0; i < points.size(); i++ ){
      PVector temp = points.get(i);
      if ( temp.x < middleX && temp.y < middleY ){
        upleft = points.get(i);
      }
      else if ( temp.x > middleX && temp.y < middleY ){
        upright = points.get(i);
      }
      else if ( temp.x < middleX && temp.y > middleY ){
        downleft = points.get(i);
      }
      else if ( temp.x > middleX && temp.y > middleY ){
        downright = points.get(i);
      }
    }
      
      newPoints.add(upleft);
      newPoints.add(downleft);
      newPoints.add(downright);
      newPoints.add(upright);
      
      return newPoints;
    
  }
  ArrayList<PVector> realign( Contour c ){
    if (c.numPoints()==4) {    
    ArrayList<PVector> points;
    
    points = c.getPolygonApproximation().getPoints();
    

    
    if ( points.get(0).x  > points.get(1).x ){ // if the first point is upper right not upper left
      points = fixCorners(points);
    }
    
    /* fill(255,0,0);
    ellipse( points.get(0).x, points.get(0).y, 20, 20);
    fill(0,255,0);
    ellipse( points.get(1).x, points.get(1).y, 20, 20);*/
    
    return points;
    } else { 
      return null;
    }
  }

  Mat getPerspectiveTransformation(ArrayList<PVector> inputPoints, int w, int h) {
    //sets up the temporary location for the warped image
    Point[] canons=new Point[4];
    canons[0]=new Point(w, h);
    canons[1]=new Point(w, 0);
    canons[2]=new Point(0, 0);
    canons[3]=new Point(0, h);
    // canons[0] = new Point(w, 0);
    // canons[1] = new Point(0, 0);
    // canons[2] = new Point(0, h);
    // canons[3] = new Point(w, h);

    //makes matrix of those points
    MatOfPoint2f canonMarker=new MatOfPoint2f();
    canonMarker.fromArray(canons);

    //makes array of the actual coordinates of the original image
    Point[] reals=new Point[4];
    for (int i=0; i<4; i++) {
      reals[i]=new Point(inputPoints.get(i).x, inputPoints.get(i).y);
    }
    MatOfPoint2f realMarker=new MatOfPoint2f(reals);

    //calculates diff in perspective b/w straight temp image and original skewed image
    return Imgproc.getPerspectiveTransform(realMarker, canonMarker);
  }

  Mat warpPerspective(ArrayList<PVector> inputPoints, int w, int h) {
    //gets the perspective transform diff b/w original and straight temp
    Mat transform=getPerspectiveTransformation(inputPoints, w, h);

    //makes location for final processed image
    Mat endMarker=new Mat(w, h, CvType.CV_8UC1);
    //applies perspective difference to create final image 
    Imgproc.warpPerspective(opencv.getColor(), endMarker, transform, new Size(w, h));
    return endMarker;
  }




  /*-------------------------COMPARING------------------*/


  long absDif(PImage a, PImage b, boolean reverse) {
    a.loadPixels();
    int[] aa = a.pixels;
    b.loadPixels();
    int[] bb = b.pixels;
    int[] cc = new int[aa.length];
    for (int i=0; i<aa.length; i++) {
      if (reverse) {
        cc[i] = abs(aa[i]-bb[bb.length-i-1]);
      } else {
        cc[i] = abs(aa[i]-bb[i]);
      }
    }
    long ret = 0L;
    for (int i=0; i<aa.length; i++) {
      ret += cc[i];
    }
    /*loadPixels();
     for (int i=0; i<aa.length; i++) {
     pixels[i] = color((int)cc[i]);
     }
     updatePixels();*/
    return ret;
  }

  int minDif(PImage a) {
    ArrayList<PImage> L=new ArrayList<PImage>();
    for (int i=0; i<36; i++) {
      PImage newCard=loadImage("../pics/cards/c"+i+".png");
      L.add(newCard);
    }
    long dif = absDif(a, L.get(0), true);
    int ret = 0;
    long b;
    for (int i=0; i<L.size (); i++) {
      b = absDif(a, L.get(i), true);
      if (b<dif) {
        dif=b;
        ret=i;
        
      }
      b = absDif(a, L.get(i), false);
      if (b<dif) {
        dif=b;
        ret=i;
        
      }
    }
   
    
    return ret;
  }
}

