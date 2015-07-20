class Player {
  int cardCount;
  Card currentCard;
  ArrayList<Card> myCards;
  Player() {
    cardCount=18;
    myCards=new ArrayList<Card>();
  }
  void addToDeck(Card c){
    myCards.add(c);
    cardCount++;
  }
  Card withdraw() {
    cardCount--;
    return myCards.remove(0);
  }
  boolean isWinner() {
    return cardCount==36;
  }

}
