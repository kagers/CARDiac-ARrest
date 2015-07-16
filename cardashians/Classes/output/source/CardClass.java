import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class CardClass extends PApplet {

class Card {
  PImage photo;
  
  //0->3, diamond->spade respectively
  int suit;
  
  //0->8, six->ace respectively 
  int value;
  
  //something for animation
  String animationType; //to be changed
  
  Card(int s, int v) {
    suit=s;
    value=v;
    int pindex=(4*v)+s;
    String filename="../../pics/c"+pindex+".png";
    photo=loadImage(filename);
  }

  public int compareTo(Card other) {
    /* for testing
       int suitSame=suit-other.suit; */
    int valueSame=value-other.value;
    return valueSame;
  }
}
class NumCard extends Card {
  NumCard(int s, int v) {
    super(s,v);
    animationType="number";
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "CardClass" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
