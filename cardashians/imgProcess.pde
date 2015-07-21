
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


  /*-------------------------Constructors--------------------------------*/

  imgProcess(OpenCV op, int numCards, int th) {
    opencv = op;
    cw = 310;
    ch = 210;
    numCs = numCards;
    thresh(th);
    cards =  biggestC(opencv.findContours().getPolygonApproximation(), numCs);
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
      biggest.add(conts.remove(n));
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
      for (PVector point : c.getPolygonApproximation ().getPoints()) {
        vertex(point.x, point.y);
      }
      endShape(CLOSE);
    }
  }

  void outlineCards() {
    outlineRects(cards);
  }

  /* ----------------------Warp Persepective Methods-----------------------------*/

  /*
    unwarps a single contour
   */
  PImage unwarpC(Contour c) {    
    PImage newImg =createImage(ch, cw, ARGB);
    opencv.toPImage(warpPerspective(c.getPolygonApproximation().getPoints(), ch, cw), newImg);
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

  PVector findBenter(Contour c) {
    if (c.numPoints()==4) {
      ArrayList<PVector> points = c.getPoints();
      ArrayList<PVector> dists = new ArrayList<Float>();
      for (int i=0; i<points.size (); i++) {
        dists.add(points.get(0).dist(points.get(i)));
      }
      int max = 0;
      for (int i=0; i<dists.size (); i++) {
        if (dists.get(i)>dists.get(max)) {
          max = i;
        }
      }
      int[] order = new int[4];
      order[0] = 0;
      order[1] = i;
      if (i==1) {
        order[2] = 2;
        order[3] = 3;
      } else if (i==2) {
        order[2] = 1;
        order[3] = 3;
      } else if (i==3) {
        order[2] = 1;
        order[3] = 2;
      } 
      PVector l1 = points.get(order[0]).cross(points.get(order[1]));
      PVector l2 = points.get(order[2]).cross(points.get(order[3]));
      PVector intersex = li.cross(l2);
      return new PVector(intersex.x/intersex.z,intersex.y,intersex.z);
    } else {
      return null;
    }
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
    loadPixels();
    for (int i=0; i<aa.length; i++) {
      pixels[i] = color((int)cc[i]);
    }
    updatePixels();
    return ret;
  }

  int minDif(PImage a) {
    ArrayList<PImage> L=new ArrayList<PImage>();
    for (int i=0; i<36; i++) {
      PImage newCard=loadImage("../pics/c"+i+".png");
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
        println(i);
      }
      b = absDif(a, L.get(i), false);
      if (b<dif) {
        dif=b;
        ret=i;
        println(i);
      }
    }
    println(dif);
    println(ret);
    return ret;
  }
}

