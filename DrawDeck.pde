class DrawDeck {
  Card[] deck;
  final int MAXCARDS = 15;
  int x, y;
  PImage img = loadImage("deck.png");
  
  DrawDeck(int x, int y) {
    deck = new Card[0];
    this.x = x;
    this.y = y;
  }

  void addCard(Card c) {
    if(deck.length < 15)
      append(deck, c);
  }

  void display() {
    image(img, x, y, 80, 150);
  }

  void removeCard() {
    if(deck.length > 0)
      deck = (Card[]) subset(deck, 1, deck.length-1);
  }
}