class AI {
    // we could put health, takeDamage(), and drawCard() in a player class
    // and extend User and AI to different classes

    int health;
    int mana;
    Hand hand;
    int handLen;
    
    AI() {
        int handLen = 4;
        health = 20;
        mana = 2;
        hand = new Hand();
    }
    
    void drawCard(Card c) {
        hand.drawCard(c);
        handLen++;
    }
    
    void placeCardToField(Card[] field) {
        for (int i = 0; i < handLen; i++) { //<>//
          if (hand.inHand[i].manaCost <= mana) {
            int runs = 0;
            int fieldSpots = (int)random(8);
            field[fieldSpots] = new Card(playerHand.inHand[playerHand.selected].cardImage, playerHand.inHand[playerHand.selected].manaCost, playerHand.inHand[playerHand.selected].attack, playerHand.inHand[playerHand.selected].health, playerHand.inHand[playerHand.selected].ability);
            field[fieldSpots].state = 1;
            hand.remove(i);
            handLen--;
          }
        }
    }
}
