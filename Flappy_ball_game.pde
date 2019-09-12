float ballX;
float ballY;
int ballSize = 50;
float vyDown = 1.0;
float vyUp = 8;
float acceleration = 0.2;
boolean up = false;
float tempY;
boolean gameOver = false;
int leftL = 0;
float vxL = 7.0;
boolean newLine = true;

float vxLeft = 2;// value for triangle
int widT = 150;// value for triangle
int heiT = 70;// value for triangle
float left;// value for triangle
float midPointT;// value for triangle
boolean newBlock = true;

float vxR = 4;
int widR = 180;
int heiR = 120;
float leftR;
float midPointR;
boolean newRocket = true;
boolean closeRocket = false;

String[] colors = new String[7];
int colorNumB;
int colorNumT;
int colorNumR;
int colorNumI;
boolean newColorB = true;
boolean newColorT = true;
boolean newColorR = true;
boolean newColorI = true;

float vxI = 1;
float leftI;
int sizeItem = 30;
float midPointI;
boolean newItem = true;
float angle = 0.0;

int CurrentScore = 0;
boolean newHills = true;
PImage bg;
void setup() {
  size(500, 600);
  frameRate(70);
  ballX = 150;
  ballY = 200;
  colors[0] = "red";
  colors[1] = "orange";
  colors[2] = "yellow";
  colors[3] = "green";
  colors[4] = "blue";
  colors[5] = "indigo";
  colors[6] = "violet";
  bg = loadImage("background.png");
}

void draw() {
  background(bg);
  stroke(255);
  triangles();
  rockets();
  drawBall();// draw the flappy ball that can control by mouse pressed.
  changeColorItem();
  drawScore();
  if (gameOver) {
    stroke(0);
    fill(230);
    strokeWeight(2);
    rect(width/4, height/4, width/2, height/2);
    strokeWeight(1);
    drawGameOver();
  }
}

void mousePressed() {// cpntrolling the ball by using mouse
  if (!gameOver) {
    up = true;
    tempY = ballY - 70;
    if (closeRocket) {
      if (tempY-ballSize/2 <= midPointR+heiR/2) {
        tempY = midPointR+heiR/2+ballSize/2;
      }
    }
    vyDown = 1.0;// reset the vyDown value
  }
}

/*this method is for drawing moving ball*/
void drawBall() {
  if (newColorB) {
    colorNumB = (int)random(7);
    newColorB = false;
  }
  color c = getColor(colors[colorNumB]);
  fill(c);
  if (!up) {// for going down
    ballY += vyDown;
    vyDown += acceleration;
    ellipse(ballX, ballY, ballSize, ballSize);
    if (ballY >=height - ballSize/2) {
      vyDown = 0;
      acceleration = 0;
      ballY = height - ballSize/2;
      gameOver = true;
    }
  } else {// for going up
    ballY -= vyUp;
    ellipse(ballX, ballY, ballSize, ballSize);
    if (ballY <= tempY) {
      up = false;
    }
  }
}

/* this method is for resetting the values for triangles*/
void triangles() {
  if (newBlock) {// reset the values of the triangle
    midPointT = random(height/4, height*3/4);
    left = width+widT;// the initial position of the blocks
    newBlock = false;
    newHills = true;
  } else {
    drawTriangleBlocks();
  }
}

/* this method is for drawing triangles*/
void drawTriangleBlocks() {
  if (gameOver) {
    vxLeft = 0;
  }
  if (newColorT) {
    colorNumT = (int)random(7);
    newColorT = false;
  }
  color col = getColor(colors[colorNumT]);
  fill(col);
  left -= vxLeft;
  triangle(left, 0, left+widT, 0, left+widT/2, midPointT-heiT);
  triangle(left, height, left+widT, height, left+widT/2, midPointT+heiT);
  if (left+widT <= 0) {
    newBlock = true;
    newColorT = true;
  }
  if (colorNumB != colorNumT) {// when ball has the same property(color) with triangles, ball can directly get through this block
    if (ballY-ballSize/2 <= midPointT-heiT && ballX <= left+widT/2) {// for left side of top triangle
      float a = (midPointT-heiT)/((left+widT/2)-left);
      float b = -1.0;
      float c = ((midPointT-heiT) - a*(left+widT/2+left))/2;
      if (abs((a*ballX+b*ballY+c)/sqrt(a*a+b*b)) <= ballSize/2) {
        vxLeft = 0;
        gameOver = true;
      }
    } else if (ballY-ballSize/2 <= midPointT-heiT && ballX >= left+widT/2) {// for right side of top triangle
      float a = (midPointT-heiT)/((left+widT/2)-(left+widT));
      float b = -1.0;
      float c = ((midPointT-heiT) - a*(left+widT/2+left+widT))/2;
      if (abs((a*ballX+b*ballY+c)/sqrt(a*a+b*b)) <= ballSize/4) {
        vxLeft = 0;
        gameOver = true;
      }
    } else if (ballY+ballSize/2 >= midPointT+heiT && ballX <= left+widT/2) {// for left side of bottom triangle
      float a = ((midPointT+heiT)- height)/(left+widT/2-left);
      float b = -1.0;
      float c = ((midPointT+heiT)+height - a*(left+widT/2+left))/2;
      if (abs((a*ballX+b*ballY+c)/sqrt(a*a+b*b)) <= ballSize/2) {
        vxLeft = 0;
        gameOver = true;
      }
    } else if (ballY+ballSize/2 >= midPointT+heiT && ballX >= left+widT/2) {// for right side of bottom triangle
      float a = ((midPointT+heiT)- height)/(left+widT/2-(left+widT));
      float b = -1.0;
      float c = ((midPointT+heiT)+height - a*(left+widT/2+left+widT))/2;
      if (abs((a*ballX+b*ballY+c)/sqrt(a*a+b*b)) <= ballSize/4) {
        vxLeft = 0;
        gameOver = true;
      }
    }
    if (sqrt(pow(ballX-(left+widT/2), 2)+pow(ballY-(midPointT-heiT), 2)) <= ballSize/2 || sqrt(pow(ballX-(left+widT/2), 2)+pow(ballY-(midPointT+heiT), 2)) <= ballSize/2) {// for two vertex at the top of triangle
      gameOver = true;
    }
  }
  if (ballX >= left + widT/2 && !gameOver && newHills) {
    CurrentScore += 1;
    newHills = false;
  }
}

/* this method is for drawing rockets */
void rockets() {
  if (newRocket) {
    midPointR = random(height/4, height*3/4);
    leftR = width+widT;
    newRocket = false;
  } else {
    drawRockets();
  }
}

void drawRockets() {
  closeRocket = false;
  if (gameOver) {
    vxR = 0;
  }
  if (newColorR) {
    colorNumR = (int)random(7);
    newColorR = false;
  }
  color c = getColor(colors[colorNumR]);
  fill(c);
  leftR -= vxR;
  rectMode(CORNER);
  rect(leftR, midPointR-heiR/2, widR, heiR/3);
  rect(leftR, midPointR-heiR/2+heiR/3, widR, heiR/3);
  rect(leftR, midPointR-heiR/2+heiR*2/3, widR, heiR/3);
  triangle(leftR, midPointR-heiR/2, leftR, midPointR-heiR/2+heiR/3, leftR-widR/5, midPointR-heiR/2+heiR/6);
  triangle(leftR, midPointR-heiR/2+heiR/3, leftR, midPointR-heiR/2+heiR*2/3, leftR-widR/5, midPointR-heiR/2+heiR/3+heiR/6);
  triangle(leftR, midPointR-heiR/2+heiR*2/3, leftR, midPointR+heiR/2, leftR-widR/5, midPointR-heiR/2+heiR*2/3+heiR/6);
  if (leftR+widR <= 0) {
    newRocket = true;
    newColorR = true;
  }
  if (colorNumB != colorNumR) {
    if (ballX < leftR && ballY > midPointR-heiR/2 && ballY < midPointR+heiR/2) {// for ball at the left of the rocket
      if (abs(ballX-(leftR-widR/5)) <= ballSize/2) {
        gameOver = true;
      }
    } else if (ballX >= leftR-widR/5 && ballX <= leftR + widR && ballY >= midPointR+heiR/2) {// for the ball under the rocket
      closeRocket = true;
      if (abs(ballY- midPointR) < ballSize/2+heiR/2) {
        gameOver = true;
      }
    } else if (ballX >= leftR-widR/5 && ballX <= leftR + widR && ballY <= midPointR-heiR/2) {// for the ball higher than the rocket
      if (abs(ballY- midPointR) < ballSize/2+heiR/2) {
        gameOver = true;
      }
    }
  }
}

color getColor(String name) {
  color c = color(0, 0, 0);
  if (name.equals("red")) {
    c = color(255, 51, 51);
  } else if (name.equals("blue")) {
    c = color(51, 153, 255);
  } else if (name.equals("yellow")) {
    c = color(255, 255, 51);
  } else if (name.equals("green")) {
    c = color(51, 255, 51);
  } else if (name.equals("orange")) {
    c = color(255, 153, 51);
  } else if (name.equals("violet")) {
    c = color(153, 51, 255);
  } else if (name.equals("indigo")) {
    c = color(0, 255, 255);
  }
  return c;
}

void changeColorItem() {
  if (newItem) {
    midPointI = 50+random(height-50);
    newItem = false;
    leftI = width+sizeItem;
  } else {
    drawItem();
  }
}

void drawItem() {
  if (gameOver) {
    vxI = 0;
  }
  if (newColorI) {
    colorNumI = (int)random(7);
    newColorI = false;
  }
  color c = getColor(colors[colorNumI]);
  fill(c);
  leftI -= vxI;
  pushMatrix();
  translate(leftI, midPointI-sizeItem/2);
  rotate(angle);
  rectMode(CORNER);
  rect(-sizeItem/2, -sizeItem/2, sizeItem, sizeItem);
  popMatrix();
  angle += 0.05;
  if (leftI+sizeItem <= 0) {
    newItem = true;
    newColorI = true;
  }
  if (sqrt(pow(ballX-(leftI+ballSize/2), 2) + pow(ballY-midPointI, 2)) <= ballSize/2+sizeItem/2 + 15) {
    newItem = true;
    newColorI = true;
    colorNumB = colorNumI;
    CurrentScore += 1;
  }
}

void drawScore() {
  int s = CurrentScore;
  fill(255);
  textSize(32);
  text(String.valueOf(s), 20, 50);
}

void drawGameOver() {
  fill(255, 0, 0);
  textSize(30);
  text("Game Over", width/4+40, height/4+40);
  textSize(20);
  text("Your Scors: " + String.valueOf(CurrentScore), width/4+50, height/4+120);
  noFill();
  rect(width/4+40, height/4+200, width/3, height/12);
  text("reStart", width/4+90, height/4+230);
  if (mouseX > width/4+40 && mouseX < width/4+40+width/3 && mouseY > height/4+200 && mouseY < height/4+200+height/12) {
    if (mousePressed == true) {
      gameOver = false;
      reSetAll();
    }
  }
}

void reSetAll() {
  ballX = 150;
  ballY = 200;
  ballSize = 50;
  vyDown = 1.0;
  vyUp = 8;
  acceleration = 0.2;
  up = false;
  gameOver = false;
  leftL = 0;
  vxL = 7.0;
  newLine = true;
  vxLeft = 2;// value for triangle
  widT = 150;// value for triangle
  heiT = 70;// value for triangle
  newBlock = true;
  vxR = 4;
  widR = 180;
  heiR = 120;
  newRocket = true;
  closeRocket = false;
  newColorB = true;
  newColorT = true;
  newColorR = true;
  newColorI = true;
  vxI = 1;
  sizeItem = 30;
  newItem = true;
  angle = 0.0;
  CurrentScore = 0;
  newHills = true;
}
