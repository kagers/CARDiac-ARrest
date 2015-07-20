class Player {
  int cardCount;
  Card currentCard;
  ArrayList<Card> myCards;
  Player() {
    cardCount=18;
    myCards=new ArrayList<Card>();
  }
  void wonHand(){
    cardCount++;
  }
  void lostHand() {
    cardCount--;
  }
  boolean isWinner() {
    return cardCount==36;
  }

}
