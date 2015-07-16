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
    return myCards.remove(0);
    cardCount--;
  }
  boolean isWinner() {
    return cardCount==36;
  }

}