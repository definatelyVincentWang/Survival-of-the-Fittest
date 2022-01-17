int MANA_MAX = 6, CARD_AMOUNT = 9;
int currManaMax = 2, health = 20;
int mana = currManaMax;
int rows = 4, cols = 4;
Card[] field = new Card[rows * cols];
float WIDTH = 80, HEIGHT = 150;

Hand playerHand;
AI ai;
DrawDeck drawDeck;
DrawDeck ai_deck;
DrawDeck discardDeck;
boolean turnEnd = false;
PImage background;

boolean AITurnEnd = false;
boolean drawnCard = false;

boolean attacking = false;
boolean dying = false;

String[] cardNames = {"cat", "wolf", "bear", "lizard", "rat", "frog", "rock", "elk", "turtle"};
int[] manaCosts    = {    2, 4, 6, 1, 1, 3, 1, 3, 3};
int[] attacks      = {    1, 3, 3, 1, 0, 1, 0, 2, 1};
int[] healthValues = {    2, 2, 6, 1, 2, 1, 5, 5, 8};
int[] abilities    = {    2, 1, 0, 0, 3, 5, 0, 0, 0};

// abilities:
// 0 = nothign, 1 = wolf pack, +1 atk to wolves, 2 = nine lives aced, cat card returned to hand on death
// 3 = rat scavenger, return 1 card from dead zone to hand, 4 = buff (later) 5 = poison (insta kill card on death)

PImage[] cards = new PImage[cardNames.length];

void setup() {
  size(1000, 650);

  background = loadImage("wood.png");
  playerHand = new Hand();
  for (int i = 0; i < 4; i++) {
    int n = (int) random(CARD_AMOUNT);
    playerHand.drawCard(new Card((cardNames[n] + ".png"), manaCosts[n], attacks[n], healthValues[n], abilities[n]));
  }
  drawDeck = new DrawDeck(width - 100, height / 2 + 250);
  for (int i = 0; i < 15; i++) {
    int n = int(random(CARD_AMOUNT));
    drawDeck.addCard(new Card((cardNames[n] + ".png"), manaCosts[n], attacks[n], healthValues[n], abilities[n]));
  }
  ai = new AI();
  for (int i = 0; i < 4; i++) {
    int n = int(random(CARD_AMOUNT));
    ai.hand.drawCard(new Card((cardNames[n] + ".png"), manaCosts[n], attacks[n], healthValues[n], abilities[n]));
  }
  for (int i = 0; i < field.length; i++) {
    field[i] = new Card("data/blank.png", 0, 0, 0, 0);
    field[i].state = 1;
  }
  //ai.drawCard(ai_deck);
}
void draw() {
  if (health <= 0 || ai.health <= 0) {
    MANA_MAX = 6;
    CARD_AMOUNT = 9;
    currManaMax = 2;
    health = 20;
    mana = currManaMax;
    rows = 4;
    cols = 4;
    field = new Card[rows * cols];
    WIDTH = 80;
    HEIGHT = 150;

    turnEnd = false;

    AITurnEnd = false;
    drawnCard = false;

    attacking = false;
    dying = false;
    setup();
  }
  fill(255);
  textFont(createFont("Arial", 40));
  // field display
  image(background, 0, 0, width, height);
  fill(255);
  stroke(0);
  strokeWeight(1);
  for (int card = 0; card < field.length; card++) {
    if (!field[card].display(card)) {
      field[card] = new Card("data/blank.png", 0, 0, 0, 0);
      field[card].state = 1;
    }
    if (field[card].state == 2) {
      dying = true;
    }
    if (field[card].state == 3) {
      attacking = true;
    }
  }
  for (int card = 0; card < playerHand.inHand.length; card++) {
    if (playerHand.inHand[card] == null) {
      break;
    }
    playerHand.inHand[card].display(card);
  }

  textAlign(CENTER);
  //field.display();

  // set up the ai health
  fill(color(255, 50, 150));
  circle(width / 4, 50, 100);
  fill(255);
  image(loadImage("heart.png"), width / 4 - 40, 10, 80, 80);
  text(Integer.toString(ai.health), width / 4 - 40, 10, 80, 80);
  //player health
  circle(width - 100, height - 175, 150);
  image(loadImage("heart.png"), width - 150, height - 225, 120, 120);
  text(Integer.toString(health), width - 155, height - 200, 100, 70);
  //player mana
  image(loadImage("mana.png"), width - 100, 0, 100, 100);
  text(Integer.toString(mana), width - 110, 20, 100, 100);
  rect(0, 300, 100, 50);
  textAlign(LEFT);
  fill(0);
  textFont(createFont("Arial", 20));
  text("End Turn", 5, 300, 110, 50);
  textFont(createFont("Arial", 40));
  // discardDeck.display();
  drawDeck.display();
  playerHand.display();
  //if (!dying && !attacking) {
    if (!drawnCard) {
      int n = (int) random(CARD_AMOUNT);
      playerHand.drawCard(new Card((cardNames[n] + ".png"), manaCosts[n], attacks[n], healthValues[n], abilities[n]));
      drawnCard = true;
    }
    if (turnEnd) {
      int n = (int) random(CARD_AMOUNT);
      playerHand.drawCard(new Card((cardNames[n] + ".png"), manaCosts[n], attacks[n], healthValues[n], abilities[n]));
      ai.placeCardToField(field);
      drawnCard = false;
      AITurnEnd = true;
    }
    if (AITurnEnd) {
      mana += 2;
      ai.mana += 2;
      for (int i = 0; i < 4; i++) {
        if (field[i] == null) {
          continue;
        }
        if (field[i + 8].cardImage.equals("data/blank.png")) {
          if (field[i + 12].cardImage.equals("data/blank.png")) {
            health -= field[i].attack;
          } else {
            field[i + 12].health -= field[i].attack;
          }
        } else {
          field[i + 8].health -= field[i].attack;
        }
      }
      for (int i = 4; i < 8; i++) {
        if (field[i] == null) {
          continue;
        }
        if (field[i + 4].cardImage.equals("data/blank.png")) {
          if (field[i + 8].cardImage.equals("data/blank.png")) {
            health -= field[i].attack;
          } else {
            field[i + 8].health -= field[i].attack;
          }
        } else {
          field[i + 4].health -= field[i].attack;
        }
      }
      for (int i = 8; i < 12; i++) {
        if (field[i] == null) {
          continue;
        }
        if (field[i - 4].cardImage.equals("data/blank.png")) {
          if (field[i - 8].cardImage.equals("data/blank.png")) {
            ai.health -= field[i].attack;
          } else {
            field[i - 8].health -= field[i].attack;
          }
        } else {
          field[i - 4].health -= field[i].attack;
        }
      }
      for (int i = 12; i < 16; i++) {
        if (field[i] == null) {
          continue;
        }
        if (field[i - 8].cardImage.equals("data/blank.png")) {
          if (field[i - 12].cardImage.equals("data/blank.png")) {
            ai.health -= field[i].attack;
          } else {
            field[i - 12].health -= field[i].attack;
          }
        } else {
          field[i - 4].health -= field[i].attack;
        }
      }
      AITurnEnd = false;
      drawnCard = true;
      turnEnd = false;
    }
  //}
}
/*
void startRound() {
 playerHand.drawCard();
 drawDeck.remove();
 }*/


/*
 * check if click is on a card
 * check if next click is on a valid field
 * if click somewhere else, unselect
 */
void mouseClicked() {
  int a;
  if (playerHand.selected == -1 && playerHand.n > 0) { //if no card selected, check if card selected;
    a = playerHand.select();
  } else { //if card was already selected, see if the click is on a EMPTY field tile
    /*for (int i = 0; i < field.length; i++) {
     if ((mouseX > field[i].x && mouseX < field[i].x + width) && (mouseY > field[i].y && mouseY < field[i].y + height)) {
     //if tile was clicked on, set field[i] = playerHand.inHand[selected];
     playerHand.selected = -1;
     break;
     }
     }*/
    if (playerHand.selected == playerHand.select()) { //if the selected card was clikced on, deselected
      playerHand.selected = -1;
    }
    //if mouse clicks on "END TURN" button, end turn
  }
  if (mouseX > 0 && mouseX < 100 && mouseY > 300 && mouseY < 350) {
    turnEnd = true;
  }
  if (playerHand.selected != -1) {
    for (int i = 8; i < field.length; i++) {
      if (field[i].mouseIn(i) && field[i].cardImage.equals("data/blank.png") && playerHand.inHand[playerHand.selected].manaCost <= mana) {
        field[i] = playerHand.inHand[playerHand.selected];
        //println("In field pos " + i % 4 + ", " + i / 4);
        playerHand.remove(playerHand.selected);
        field[i].state = 1;
        playerHand.selected = -1;
        mana -= field[i].manaCost;
      }
    }
  }
}

// new Card(playerHand.inHand[playerHand.selected].cardImage, playerHand.inHand[playerHand.selected].manaCost, playerHand.inHand[playerHand.selected].attack, playerHand.inHand[playerHand.selected].health, playerHand.inHand[playerHand.selected].ability);
