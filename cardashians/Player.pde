class Player {
  int cardCount;
  Card currentCard;
  Boolean isWar;
  int numWar;
  ArrayList<Card> myCards;
 
  Player() {
    cardCount=18;
    myCards=new ArrayList<Card>();
    isWar = false;
  }

  void wonHand(){
    cardCount++;
    if(isWar){
      cardCount+=numWar*3;
      isWar = false;
      numWar=0;
    }
  }

  void lostHand() {
    cardCount--;
    if(isWar){
      cardCount-=numWar*3;
      isWar = false;
      numWar=0;
    }
  }

  void war(){
    isWar=true;
    numWar+=1;
  }

  boolean isWinner() {
    return cardCount==36;
  }

}
