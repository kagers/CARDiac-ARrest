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

  int compareTo(Card other) {
    /* for testing
       int suitSame=suit-other.suit; */
    int valueSame=value-other.value;
    return valueSame;
  }
}
