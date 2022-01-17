class AI {
    // we could put health, takeDamage(), and drawCard() in a player class
    // and extend User and AI to different classes

    int health;
    int mana;
    Hand hand;
    int handLen;
    
    AI() {
        handLen = 4;
        health = 20;
        mana = 2;
        hand = new Hand();
    }
    
    void drawCard(Card c) {
        hand.drawCard(c);
        handLen++;
    }
    
    void placeCardToField(Card[] field) {
        for (int i = 0; i < handLen; i++) {
          if (hand.inHand[i].manaCost <= mana) {
            int runs = 0;
            int fieldSpots = (int)random(0,8);
            field[fieldSpots] = hand.inHand[i];
            field[fieldSpots].state = 1;
            hand.remove(i);
            handLen--;
          }
        }
    }
}
