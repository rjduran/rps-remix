// RPS 
// by Allison Speigel & RJ Duran

// TODO: Look at ReadASCIIString Arduino example for a way to send data from Processing to Arduino 
// to control the LEDs in each button. 

import processing.video.*;
import processing.serial.*;

boolean debug = false; // toggle to see debug messages

Serial myPort;  // Create object from Serial class
String inString;  // Input string from serial port
int lf = 10;      // ASCII linefeed

// VARIABLES
int gameScreen = 0; // this holds the current game screen in play

// Movies
Movie introMovie; 
Movie shootMovie;

// Images
PImage bgImg, img19, img20;

// Player Images
PImage  p1RockImg, p1PaperImg, p1ScissorImg, p1RockWinImg, p1PaperWinImg, p1ScissorWinImg, p1WinImg;
PImage  p2RockImg, p2PaperImg, p2ScissorImg, p2RockWinImg, p2PaperWinImg, p2ScissorWinImg, p2WinImg;

// Ready to Play Images
PImage readyToPlayBgImg, p1ReadyImg, p2ReadyImg;

// Round Images
PImage roundOneImg, roundTwoImg, roundThreeImg;
int roundNumber = 0; // This is the current round for the game


// Player variables
boolean player1Ready = false;
boolean player2Ready = false;

int player1Result = 0;
int player2Result = 1;

int player1Wins = 0;
int player2Wins = 0;

boolean player1Shoot = false;
boolean player2Shoot = false;

boolean isWinner = false;

boolean newGame = false;



int savedTime;
int totalTime;

/********* SETUP GAME *********/

void setup() {
  //size(960, 540);
  fullScreen();  //1440x900
  // 960x540

  introMovie =new Movie(this, "RPS_intro_working.mov");
  introMovie.loop(); // loop the movie

  shootMovie =new Movie(this, "RPS_shoot_working.mov");

  // define ready to play images
  readyToPlayBgImg = loadImage ("RPS_ready.png");
  p1ReadyImg = loadImage ("RPS_ready_p1.png");
  p2ReadyImg = loadImage ("RPS_ready_p2.png");

  // player 1 options
  p1RockImg = loadImage ("RPS_p1_rock_t.png");
  p1PaperImg = loadImage ("RPS_p1_paper_t.png");
  p1ScissorImg = loadImage ("RPS_p1_scissor_t.png");
  p1RockWinImg = loadImage ("RPS_p1_rock_win_t.png");
  p1PaperWinImg = loadImage ("RPS_p1_paper_win_t.png");
  p1ScissorWinImg = loadImage ("RPS_p1_scissor_win_t.png");
  p1WinImg = loadImage ("RPS_p1_overall_win.png");

  // player 2 options
  p2RockImg = loadImage ("RPS_p2_rock_t.png");
  p2PaperImg = loadImage ("RPS_p2_paper_t.png");
  p2ScissorImg = loadImage ("RPS_p2_scissor_t.png");
  p2RockWinImg = loadImage ("RPS_p2_rock_win_t.png");
  p2PaperWinImg = loadImage ("RPS_p2_paper_win_t.png");
  p2ScissorWinImg = loadImage ("RPS_p2_scissor_win_t.png");
  p2WinImg = loadImage ("RPS_p2_overall_win.png");

  // Cream Background Image
  bgImg = loadImage ("RPS_crm_bkgrd.png");

  // Round Images
  roundOneImg = loadImage ("RPS_round01.png");
  roundTwoImg = loadImage ("RPS_round02.png");
  roundThreeImg = loadImage ("RPS_round03.png");

  // Play again? images
  img19 = loadImage ("RPS_playagain_t.png");
  img20 = loadImage ("RPS_playagain_player.png");

  // Setup serial port
  println("Available serial ports:");  
  String portName = Serial.list()[1];
  println(portName);
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil(lf);
}

void movieEvent(Movie m) {
  m.read();
}

/********* DRAW LOOP aka GAME LOOP *********/

void draw() {  

  // Display the contents of the current screen
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    gameScreen();
  } else if (gameScreen == 2) {
    gameScreen2();
  } else if (gameScreen == 3) {
    gameScreen3();
  } else if (gameScreen == 4) {
    gameScreen4();
  } else if (gameScreen == 5) {
    gameOverScreen();
  }
}


/********* SCREEN CONTENTS *********/

// Code for initial screen
void initScreen() {  

  image(introMovie, 0, 0); // show movie

  // TODO: if either button is pressed, move to gameScreen() to confirm
  // display leds with music here - some kind of pattern  
  if (player1Ready || player2Ready) {
    gameScreen=1;

    // reset player ready modes
    player1Ready = false;
    player2Ready = false;

    introMovie.stop(); // STOP INTRO MOVIE
  }
}

// PLAYER READY? SCREEN
void gameScreen() {

  // DRAW BG IMG
  //readyToPlayBgImg.resize(960, 540); // comment out for fullscreen HD
  image(readyToPlayBgImg, 0, 0);

  // IS PLAYER 1 READY?
  // Show left hand for yes
  if (player1Ready) {    
    //p1ReadyImg.resize(960, 540); // comment out for fullscreen HD
    image(p1ReadyImg, 0, 0);
  }
  // IS PLAYER 2 READY?
  // Show right hand for yes
  if (player2Ready) {
    //p2ReadyImg.resize(960, 540); // comment out for fullscreen HD
    image(p2ReadyImg, 0, 0);
  }

  // if both players are ready, move to next screen
  // put in short delay here to transition between screens? - fade to black effect? this could be done in draw loop
  if (player1Ready && player2Ready) {
    gameScreen = 2;

    player1Ready = false;
    player2Ready = false;

    player1Wins = 0;
    player2Wins = 0;

    savedTime = millis(); // set start time for next screen
    totalTime = 3000; // set timer duration in ms
  }

  //textSize(32);
  //fill(255);
  //text("PLAYER READY?", 10, 30);
}

// ROUND NUMBER SCREEN
void gameScreen2() {

  //bgImg.resize(960, 540);
  image(bgImg, 0, 0);

  // logic for which round screen
  if (roundNumber == 0) {          // ROUND 1
    // show round 1 image
    //roundOneImg.resize(960, 540);
    image(roundOneImg, 0, 0);
  } else if (roundNumber == 1) {   // ROUND 2
    // show round 2 image
    //roundTwoImg.resize(960, 540);
    image(roundTwoImg, 0, 0);
  } else if (roundNumber == 2) {   // ROUND 3
    // round 3 (last round)
    //roundThreeImg.resize(960, 540);
    image(roundThreeImg, 0, 0);
  }

  // display above images for a time then automatically advance to next gamescreen, which plays shoot movie 

  // Calculate how much time has passed
  int passedTime = millis() - savedTime;
  // Has t seconds passed?
  if (passedTime > totalTime) {
    // perform some action
    //println(totalTime/1000 + " seconds have passed");

    gameScreen = 3;
    shootMovie.play(); // START SHOOT MOVIE
  }

  //textSize(32);
  //fill(255);
  //text("ROUND NUMBER", 10, 30);
}

// SHOOT SCREEN
void gameScreen3() {

  // play movie and wait for players to press buttons
  image(shootMovie, 0, 0); // show movie

  // if both players shoot then goto next game screen and show results
  if (player1Shoot && player2Shoot) {

    // get results for each player and display winner in next gamescreen
    getPlayerResults();

    // reset shoot variables
    player1Shoot = false;
    player2Shoot = false;    
    isWinner = false;

    // stop shoot movie        
    shootMovie.stop();
    // advance to next screen
    gameScreen = 4;

    savedTime = millis(); // set start time for next screen   
    totalTime = 5000; // set timer duration in ms
  }

  //textSize(32);
  //fill(255);
  //text("BOTH PLAYERS READY. SHOW VIDEO - RPS SHOOT", 10, 30);
}

// SHOW RESULTS SCREEN
void gameScreen4() {

  //bgImg.resize(960, 540);
  image(bgImg, 0, 0);

  // GOAL OF THIS SCREEN
  // assign rand number for each player
  // and based on rand numer, show rock, paper, or scissor images for each player and determine winner
  // display winner image on the winner for the current round
  // goto next round or game over


  // Rules of the game

  // possible rand numbers
  //rock = 0;
  //paper = 1;
  //scissor = 2;

  // 1. No ties, which means no two players will have the same random result.
  // 2. rock beats scissor, when is this true?  
  // 3. paper beats rock, when is this true?
  // 4. scissor beats paper, when is this true?

  // who will win?

  // 01 - if player1Result is 0 and player2Result is 2, then player1 wins Y
  // 02 - if player1Result is 0 and player2Result is 1, then player2 wins Z
  // 03 - if player1Result is 1 and player2Result is 2, then player2 wins U
  // 04 - if player1Result is 1 and player2Result is 0, then player1 wins W
  // 05 - if player1Result is 2 and player2Result is 0, then player2 wins X
  // 06 - if player1Result is 2 and player2Result is 1, then player1 wins V

  // 07 - if player2Result is 0 and player1Result is 2, then player2 wins X
  // 08 - if player2Result is 0 and player1Result is 1, then player1 wins W
  // 09 - if player2Result is 1 and player1Result is 2, then player1 wins V
  // 10 - if player2Result is 1 and player1Result is 0, then player2 wins Z
  // 11 - if player2Result is 2 and player1Result is 0, then player1 wins Y
  // 12 - if player2Result is 2 and player1Result is 1, then player2 wins U


  // display random result images for each player 
  // determine winner
  // decide to goto next round or end game



  // 01 - PLAYER 1 WINS - ROCK BEATS SCISSORS
  if ((player1Result == 0) && (player2Result == 2)) {
    //println("player 1 wins");

    //p1RockImg.resize(960, 540);
    image(p1RockImg, 0, 0);
    //p2ScissorImg.resize(960, 540);
    image(p2ScissorImg, 0, 0);

    // Winner
    //p1RockWinImg.resize(960, 540);
    image(p1RockWinImg, 0, 0);

    if (!isWinner) {
      player1Wins++;
      isWinner = true;
    }
  }

  // 02 - PLAYER 2 WINS - PAPER BEATS ROCK
  if ((player1Result == 0) && (player2Result == 1)) {      
    //println("player 2 wins");

    //p1RockImg.resize(960, 540);
    image(p1RockImg, 0, 0);
    //p2PaperImg.resize(960, 540);
    image(p2PaperImg, 0, 0);

    // Winner
    //p2PaperWinImg.resize(960, 540);
    image(p2PaperWinImg, 0, 0);

    if (!isWinner) {
      player2Wins++;
      isWinner = true;
    }
  }

  // 03 - PLAYER 2 WINS - SCISSOR BEATS PAPER
  if ((player1Result == 1) && (player2Result == 2)) {
    //println("player 2 wins");

    //p1PaperImg.resize(960, 540);
    image(p1PaperImg, 0, 0);
    //p2ScissorImg.resize(960, 540);
    image(p2ScissorImg, 0, 0);

    // Winner
    //p2ScissorWinImg.resize(960, 540);
    image(p2ScissorWinImg, 0, 0);

    if (!isWinner) {
      player2Wins++;
      isWinner = true;
    }
  }

  // 04 - PLAYER 1 WINS - PAPER BEATS ROCK
  if ((player1Result == 1) && (player2Result == 0)) {      
    //println("player 1 wins");

    //p1PaperImg.resize(960, 540);
    image(p1PaperImg, 0, 0);
    //p2RockImg.resize(960, 540);
    image(p2RockImg, 0, 0);

    // Winner
    //p1PaperWinImg.resize(960, 540);
    image(p1PaperWinImg, 0, 0);

    if (!isWinner) {
      player1Wins++;
      isWinner = true;
    }
  }

  // 05 - PLAYER 2 WINS - ROCK BEATS SCISSOR
  if ((player1Result == 2) && (player2Result == 0)) {      
    //println("player 2 wins");

    //p1ScissorImg.resize(960, 540);
    image(p1ScissorImg, 0, 0);
    //p2RockImg.resize(960, 540);
    image(p2RockImg, 0, 0);

    // Winner
    //p2RockWinImg.resize(960, 540);
    image(p2RockWinImg, 0, 0);

    if (!isWinner) {
      player2Wins++;
      isWinner = true;
    }
  }

  // 06 - PLAYER 1 WINS - SCISSOR BEATS PAPER
  if ((player1Result == 2) && (player2Result == 1)) {      
    //println("player 1 wins");

    //p1ScissorImg.resize(960, 540);
    image(p1ScissorImg, 0, 0);
    //p2PaperImg.resize(960, 540);
    image(p2PaperImg, 0, 0);

    // Winner
    //p1ScissorWinImg.resize(960, 540);
    image(p1ScissorWinImg, 0, 0);

    if (!isWinner) {
      player1Wins++;
      isWinner = true;
    }
  }

  // print summary
  //println("player 1 wins:" + player1Wins + ", player 2 wins: " + player2Wins);


  // game over? or go to next round?

  // display above images for a time then automatically advance to next gamescreen, which plays shoot movie 

  // Calculate how much time has passed
  int passedTime = millis() - savedTime;
  // Has t seconds passed?
  if (passedTime > totalTime) {
    // perform some action
    //println(totalTime/1000 + " seconds have passed");


    if (roundNumber < 2) {
      // go another round
      roundNumber++;
      gameScreen = 2;
      totalTime = 3000; // set timer duration in ms
    } else {
      //game over
      roundNumber = 0;
      gameScreen = 5;
      totalTime = 30000; // set timer duration in ms
    }

    savedTime = millis(); // set start time for next screen
    //totalTime = 3000; // set timer duration in ms
  }


  //textSize(32);
  //fill(255);
  //text("DISPLAY WINNER. GOTO NEXT ROUND", 10, 30);
}


// Code for game over screen
void gameOverScreen() {

  //bgImg.resize(960, 540);
  //image(bgImg, 0, 0);

  // display overall winner here based on win count
  if (player1Wins > player2Wins) {
    // display player 1 wins
    //p1WinImg.resize(960, 540);
    image(p1WinImg, 0, 0);
  } else {
    // display player 2 wins
    //p2WinImg.resize(960, 540);
    image(p2WinImg, 0, 0);
  }


  // play again?
  if (player1Ready || player2Ready) {
    gameScreen=1;

    // reset player ready modes
    player1Ready = false;
    player2Ready = false;
  }


  // start over after 30 seconds if either button is not pressed
  int passedTime = millis() - savedTime;  
  if (passedTime > totalTime) {

    // go back to init screen loop to start again
    gameScreen = 0;
    introMovie.loop(); // START INTRO MOVIE
  }


  //textSize(32);
  //fill(255);
  //text("game over", 10, 30);
}

void getPlayerResults () {

  // generate random numbers
  int r1 = int(random(3));
  int r2 = int(random(3));

  // rand results
  player1Result = r1;  
  player2Result = r2;

  //println("r1: " + r1 + ", r2: " + r2);

  // if they are same, just add one to player 2
  if (player1Result == player2Result) {
    player2Result = (r2+1) % 2;
  }

  // this should show results that are always different and never equal (by design)
  if (debug) println("player1Result: " + player1Result + ", player2Result: " + player2Result);
}


/********* INPUTS *********/

// This function handles button presses. The functionality would be 
// replaced by the incoming button presses from an arduino hooked up to the big buttons.
void keyPressed() {
  if (key == '1') {
    if (debug) println("player 1 ready!");    
    player1Ready = true;
  } 

  if (key == '2') {
    if (debug) println("player 2 ready!");
    player2Ready = true;
  }

  if (key == 'a') {
    if (debug) println("player 1 shoot!");    
    player1Shoot = true;
  } 

  if (key == 'b') {
    if (debug) println("player 2 shoot!");
    player2Shoot = true;
  }
}


// Read from serial port and trigger events if the 
// gameplay is in one of these screens: 0,1,2, or 5 

void serialEvent(Serial p) {
  inString = (p.readString());
  if (inString.contains("1,1")) {
    // trigger your action
    if (debug) println("1,1");
    if ( (gameScreen == 0) || (gameScreen == 1) || (gameScreen == 2) || (gameScreen == 5) ) {      
      if (debug) println("player 1 ready!");    
      player1Ready = true;
    }

    if ( (gameScreen == 3) ) {
      if (debug) println("player 1 shoot!");    
      player1Shoot = true;
    }
  }
  if (inString.contains("2,1")) {
    // trigger your action
    if (debug) println("2,1");

    if ( (gameScreen == 0) || (gameScreen == 1) || (gameScreen == 2) || (gameScreen == 5) ) {      
      if (debug) println("player 2 ready!");    
      player2Ready = true;
    }

    if ( (gameScreen == 3) ) {
      if (debug) println("player 2 shoot!");    
      player2Shoot = true;
    }
  }
}
