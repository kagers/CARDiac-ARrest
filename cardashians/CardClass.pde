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
    String filename="../pics/c"+pindex+".png";
    photo=loadImage(filename);
  }

  Card (int p) {
    suit=p%4;
    value=(p/4);
    String filename="../pics/c"+p+".png";
    photo=loadImage(filename);
  }
  
  int compareTo(Card other) {
    /* for testing
       int suitSame=suit-other.suit; */
    int valueSame=value-other.value;
    return valueSame;
  }

  String toString() {
    String[] suits={"diamonds","clubs","hearts","spades"};
    String[] faces={"jack","queen","king","ace"}; //0,1,2,3
    String s=suits[suit];
    String v=""+value;
    if (value>5)
      v=faces[value-5];
    return v+" of "+s;
  }
}
