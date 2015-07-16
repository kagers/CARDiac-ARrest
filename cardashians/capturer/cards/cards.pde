import gab.opencv.*;
import org.opencv.imgproc.*;

ArrayList<PImage> pics = new ArrayList<PImage>();

PImage src, img, dest;
OpenCV cv2;

float threshold; // FOR FUTURE USE IN DETERMINING WHAT IS GOOD CARD Vs BAD CARD

String srcFile = "c0.png";
String imgFile = "c4.png";

color black = color(255);
color white = color(0);

void setup(){
  
  for (int i=0; i<36; i++) {
    pics.add(loadImage("c"+i+".png"));
  }
  
  size( 630, 310 );

  src = loadImage(srcFile);
  img = loadImage(imgFile);
  cv2 = new OpenCV(this,src);
  //cv2.useGray();
  cv2.diff(img);
  dest = cv2.getSnapshot();
  
//  src.filter(GRAY); // negates the color
//  img.filter(GRAY);
//  dest.filter(GRAY);
  
  src.filter(INVERT); // inverts the color
  img.filter(INVERT);
  dest.filter(INVERT);
  
  src.filter(THRESHOLD); // 0.5 thresh for black / white
  img.filter(THRESHOLD);
  dest.filter(THRESHOLD);
  
  image(src, 0,0 );
  image(img, 210, 0);
  image(dest, 420,0);

  loadPixels(); 
  
//  textSize(32);
//  fill(166,30,30);
//  text( intensity(src) + "", 30, 100 );
//  text( intensity(img) + "", 230, 150 );
//  text( intensity(dest) + "", 440, 200 );
  
  println( intensity(src) );
  println( intensity(img) );
  println( intensity(dest));
  
//  for

  
}

void draw(){
  //cv2.adaptiveThreshold(31,threshold );
  //loadPixels();
  //lol don't ask about threshold stuff pls
  
}

float intensity( PImage p ){ //percentage of image that is black
  float sumDiff = 0;
  p.loadPixels();
  for ( int i = 0; i < p.pixels.length; i++ ){
    if ( brightness(p.pixels[i]) == 0 ){ //pixel is black pretty much
      sumDiff++;
    }
  }
  return sumDiff / (p.width*p.height);
}

PImage mostSimilar(PImage p) {
  float dif = intensity(a);
  int ret = 0;
  for (int i=0; i<pics.size(); i++) {
    long b = absDif(a, L.get(i));
    //dif = min(b, dif);
    if (b<dif) {
      dif=b;
      ret=i;
    }
  }
  println(dif);
  return L.get(ret);
}



    
  
