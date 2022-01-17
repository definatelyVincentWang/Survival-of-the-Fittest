class Card {
  float WIDTH = 80, HEIGHT = 150;
  int manaCost, attack, health, ability;
  String cardImage;
  PImage img;

  int totFade = 0;

  int state = 0;
  float curY = 0;
  float prevY = 0;
  float subtract = 2;
  boolean firstTime = true;
  boolean goingback = false;

  public Card(String cardImage, int manaCost, int attack, int health, int ability) {
    this.cardImage = cardImage;
    this.manaCost = manaCost;
    this.attack = attack;
    this.health = health;
    this.ability = ability;
    img = loadImage(cardImage);
  }

  boolean display(int pos) {
    // do this if its still in your deck
    if (state == 0) {
      return true;
    } else if (state == 1) {
      
      int y = pos / 4;
      int x = pos % 4;
      
      if (y >= 2) {
        image(img, width / 2 - WIDTH + x * WIDTH / 1.3, height / 2 - HEIGHT * 2 + y * HEIGHT / 1.3 + 10, WIDTH / 1.3, HEIGHT / 1.3);
      } else {
        image(img, width / 2 - WIDTH + x * WIDTH / 1.3, height / 2 - HEIGHT * 2 + y * HEIGHT / 1.3, WIDTH / 1.3, HEIGHT / 1.3);
      }
      if (y == 2) {
        strokeWeight(10);
        line(width / 2 - WIDTH + x * WIDTH / 1.3, height / 2 - HEIGHT * 2 + y * HEIGHT / 1.3 + 5, width / 2 - WIDTH + x * WIDTH / 1.3 + WIDTH / 1.3, height / 2 - HEIGHT * 2 + y * HEIGHT / 1.3 + 5);
      }
      //   do this if its currently dying
    } else if (state == 2) {
      fade();
      int y = pos / 4;
      int x = pos % 4;
      if (y >= 2) {
        image(img, width / 2 - WIDTH + x * WIDTH / 1.3, height / 2 - HEIGHT * 2 + y * HEIGHT / 1.3 + 10, WIDTH / 1.3, HEIGHT / 1.3);
      } else {
        image(img, width / 2 - WIDTH + x * WIDTH / 1.3, height / 2 - HEIGHT * 2 + y * HEIGHT / 1.3, WIDTH / 1.3, HEIGHT / 1.3);
      }
      if (y == 2) {
        strokeWeight(10);
        line(width / 2 - WIDTH + x * WIDTH / 1.3, height / 2 - HEIGHT * 2 + y * HEIGHT / 1.3 + 5, width / 2 - WIDTH + x * WIDTH / 1.3 + WIDTH / 1.3, height / 2 - HEIGHT * 2 + y * HEIGHT / 1.3 + 5);
      }
      if (totFade > 255) {
        state = 4;
      }
      // do this if its attacking
    } else if (state == 3) {
      int y = pos / 4;
      int x = pos % 4;
      if (firstTime) {
        prevY = height / 2 - HEIGHT * 2 + y * HEIGHT / 1.3 + 10;
        curY = prevY;
        if (y >= 2) {
          subtract  = -subtract;
        }
        firstTime = false;
      }
      curY += subtract;
      if (abs(prevY - curY) == 40 && !goingback) {
        subtract = -subtract;
        goingback = true;
      }
      if (goingback && abs(prevY - curY) == 0) {
        state = 1;
      }
      if (y >= 2) {
        image(img, width / 2 - WIDTH + x * WIDTH / 1.3, curY + 10, WIDTH / 1.3, HEIGHT / 1.3);
      } else {
        image(img, width / 2 - WIDTH + x * WIDTH / 1.3, curY, WIDTH / 1.3, HEIGHT / 1.3);
      }
      // do this if its dead
    } else {
      return false;
    }
    return true;
  }

  void fade() {
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      img.pixels[i] = color(red(img.pixels[i]) - 5, green(img.pixels[i]) - 5, blue(img.pixels[i]) - 5);
    }
    totFade += 5;
    img.updatePixels();
  }

  boolean attack(Card fighting) {
    fighting.health -= attack;
    if (fighting.health <= 0) {
      return true;
    }
    return false;
  }

  boolean placed(int totMana) {
    if (totMana < manaCost) {
      return false;
    }
    return true;
  }

  boolean mouseIn(int pos) {
    int y = pos / 4;
    int x = pos % 4;
    if (y >= 2) {
      boolean isX = mouseX > width / 2 - WIDTH + x * WIDTH / 1.3 && mouseX < width / 2 - WIDTH + x * WIDTH / 1.3 + WIDTH / 1.3;
      boolean isY = mouseY > height / 2 - HEIGHT * 2 + y * HEIGHT / 1.3 + 10 && mouseY < height / 2 - HEIGHT * 2 + y * HEIGHT / 1.3 + 10 + HEIGHT / 1.3;
      return isX && isY;
    } else {
      boolean isX = mouseX > width / 2 - WIDTH + x * WIDTH / 1.3 && mouseX < width / 2 - WIDTH + x * WIDTH / 1.3 + WIDTH / 1.3;
      boolean isY = mouseY > height / 2 - HEIGHT * 2 + y * HEIGHT / 1.3 && mouseY < height / 2 - HEIGHT * 2 + y * HEIGHT / 1.3 + HEIGHT / 1.3;
      return isX && isY;
    }
  }
}
