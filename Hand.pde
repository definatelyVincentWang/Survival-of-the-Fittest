class Hand {
  int n, selected;
  Card[] inHand = new Card[10];

  Hand() {
    n = 0;
    selected = -1;
  }

  boolean drawCard(Card c) {
    if (n >= 10)
      return false;
    
    inHand[n] = c;
    n++;

    return true;
  }

  int select() {
    for(int i = 0; i < n; i++){ 
      // x value of each card will be 
      // wdith / 2 - (# card * 0.5  * card.width)
      // y value is: height - 150
      if ((mouseX > width / 2 - (n * 0.5 * inHand[i].WIDTH) + i * inHand[i].WIDTH && mouseX < width / 2 - (n * 0.5 * inHand[i].WIDTH) + (i + 1) * inHand[i].WIDTH) && (mouseY > height - 150 && mouseY < height)) {
        if(selected != i){ //new card selected
            selected = i;
            return i;
        } else {
            selected = -1;
            return i;
        }
      }
    }
    return -1;
  }

  void remove(int i) {
    for (int pos = i + 1; pos < n; pos++) {
      inHand[pos - 1] = inHand[pos];
    }
    n--;
    inHand[n] = null;
  }
  
  void display() {
    // draw
    for(int i = 0; i < n; i++) {
        strokeWeight(10);
        stroke(0);
        int offset = 0;
        if(selected == i){
          offset = 50;
          stroke(255, 255, 0);
        } 
        rect(width / 2 - (n * 0.5 * inHand[i].WIDTH) + i * inHand[i].WIDTH, height-150-offset, inHand[i].WIDTH, inHand[i].HEIGHT);
        image(loadImage(inHand[i].cardImage), width / 2 - (n * 0.5 * inHand[i].WIDTH) + i * inHand[i].WIDTH, height-150-offset, inHand[i].WIDTH, inHand[i].HEIGHT);
    }
    strokeWeight(1);
  }
  
}
