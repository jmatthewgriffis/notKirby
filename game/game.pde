//Please note - protagonist notKirby is also known as "Ball" throughout this code and commentary. Live free of perplexity!

int gameMode = 0; //Control which play style applies. Set to zero for the initial instruction set. This needs to be initialized outside the setup function to enable restarting the game with a new mode.

int msg; //Control the display of messages and how they affect game play. Set to zero to enable action.
int currentLevel; //Control the current level (game screen).

PFont font;
boolean bounced; //Detect whether player has achieved the winning condition.
boolean direction; //Control which direction notKirby faces.
float resizer = 0.25; //Use to scale notKirby's size as needed.
boolean next; //Control transition between messages and game play.
int fontsize = 24;
color textBackground = #9FA1FA; //Background color of text boxes.
color textColor = 0;
boolean promptJump; //Prompt jumping at one point.
boolean noAdvance; //Prevent moving through messages at one point.
int jumpCounter; //Tally jumps at one point.
boolean pressedV; //Check if V has been pressed.
boolean pressedVlevel; //Check if this is the level to press V.
float msgXpos; //Use this to position a specific message.
int moveMsg = 2; //Use this to move the message.
float msgYpos; //Use this to posiition a specific message.

notKirby notKirby; //Declare an instance of the protagonist object ("notKirby").
Level [] myLevels; //Declare an array of "Level" objects (which are themselves ArrayLists, "Inception"-style.)
boolean[] levelNew;

//_____________________________________________________________________________________________________________

void setup() {
  size(800, 600);

  //It's necessary to initialize the following variables within setup so that when we switch game modes and reload setup, everything reverts properly.
  currentLevel = 0;
  msg = 0;
  bounced = true;
  direction = true;
  next = true;
  promptJump = false;
  noAdvance = false;
  jumpCounter = 0;
  pressedV = false;
  pressedVlevel = false;

  msgXpos = width/2;
  msgYpos = height/2;
  smooth();
  font = loadFont("font.vlw");

  myLevels = new Level[18]; //Initialize the number of levels in the brackets.
  myLevels[0] = new Level(0); //We initialize each element in the array, labeling each with the level number it represents and making it a level object. See the Level tab regarding the constructor.
  myLevels[1] = new Level(1);
  myLevels[2] = new Level(2);
  myLevels[3] = new Level(3);
  myLevels[4] = new Level(4);
  myLevels[5] = new Level(5);
  myLevels[6] = new Level(6);
  myLevels[7] = new Level(7);
  myLevels[8] = new Level(8);
  myLevels[9] = new Level(9);
  myLevels[10] = new Level(10);
  myLevels[11] = new Level(11);
  myLevels[12] = new Level(12);
  myLevels[13] = new Level(13);
  myLevels[14] = new Level(14);
  myLevels[15] = new Level(15);
  myLevels[16] = new Level(16);
  myLevels[17] = new Level(17);

  levelNew = new boolean[18]; //Use these booleans to test whether or not we are visiting a room for the first time.
  levelNew[0] = false;
  levelNew[1] = false;
  levelNew[2] = false;
  levelNew[3] = false;
  levelNew[4] = false;
  levelNew[5] = false;
  levelNew[6] = false;
  levelNew[7] = false;
  levelNew[8] = false;
  levelNew[9] = false;
  levelNew[10] = false;
  levelNew[11] = false;
  levelNew[12] = false;
  levelNew[13] = false;
  levelNew[14] = false;
  levelNew[15] = false;
  levelNew[16] = false;
  levelNew[17] = false;

  for (int i = 0; i < myLevels.length; i++) { //Use a for loop to iterate through each level in the array.
    myLevels[i].prep(); //Prepare every level to be drawn. We won't draw them all at once. Sorry.
  }
  notKirby = new notKirby(50, 600 - ((175 * resizer) / 2), 175, 200, color(#FF08F3)); //Create an instance of notKirby object using parameters entered in the constructor (see notKirby tab).
  notKirby.prep(); //Load notKirby's components.
}

//_____________________________________________________________________________________________________________

void draw() {
  background(150);

  myLevels[currentLevel].display(); //Here's where things get awesome. We draw only the level in the array whose element label matches the value of the variable indicating the current level. If the current level is set at 2, we don't draw level 1 or level 3. Look, Ma, no for loop!

  if (gameMode == 0) {

    if (currentLevel == 11) {
      if (bounced == true) { //Did the player win?
        fill(255);
        textFont(font, fontsize*0.5);
        text("Winner! You jumped this.", 115, 70); //Display winning text.
      }
      else if (bounced != true) { //The player hasn't won yet?
        fill(255);
        textFont(font, fontsize*0.5);
        text("Can't jump this.", 135, 70); //Display other text.
      }
    }



    if (currentLevel < (myLevels.length - 1)) { //If the next level exists...
      if (bounced == true) { //If we are not on the 'winning' level, needing to win...
        stroke(255);
        strokeWeight(2);
        line((width - 50), (height - 25), (width - 25), (height - 25)); //With these three lines we draw an arrow pointing to the next screen.
        line((width - 25), (height - 25), (width - 35), (height - 35));
        line((width - 25), (height - 25), (width - 35), (height - 15));

        if (notKirby.xPos >= width-(notKirby.wide / 2)) { //Here we will transition between levels. If notKirby crosses the right edge of the screen...
          currentLevel++; //...switch to the next level...
          notKirby.xPos = (notKirby.wide / 2); //...and move notKirby to the other side of the screen so it looks like he really moved between screens.
          if (levelNew[currentLevel] == false) { //If we haven't visited this level before...
            next = true; //...prepare for new messages.
            msg = 1; //Ditto.
          }
        }
      }
    }

    if (currentLevel > 0) { //If the previous level exists...
      if (bounced == true) { //If we are not on the 'winning' level, needing to win...
        stroke(255);
        strokeWeight(2);
        line(50, (height - 25), 25, (height - 25)); //With these three lines we draw an arrow pointing to the next screen.
        line(25, (height - 25), 35, (height - 35));
        line(25, (height - 25), 35, (height - 15));

        if (notKirby.xPos < (notKirby.wide / 2)) { //Do the above going the other way. If notKirby crosses the left edge of the screen...
          currentLevel--; //...switch to the previous level...
          notKirby.xPos = width - (notKirby.wide / 2); //...and move notKirby to the other side of the screen so it looks like he really moved between screens.
        }
      }
    }
  }

  notKirby.display(); //Draw notKirby! (by calling the function from the tab)
  notKirby.updateBall(); //Call the updateBall function from the notKirby tab.

  println(currentLevel); //Debug.

  //A debugging problem arises. An onscreen message prevents the arrow keys from enabling movement, but what if movement is already enabled via the previous screen and the player keeps holding the key down? We address that here.
  if (msg >= 1) { //If there's a message on screen...
    if (notKirby.R == true) { //and rightward movement is enabled...
      notKirby.R = false; //...disable it.
    }
    if (notKirby.L == true) { //Just so, if leftward movement is enabled...
      notKirby.L = false; //...disable it.
      //This is necessary for debugging; otherwise the player could move right through screens without going through the text boxes as long as he never stopped holding a directional key.
    }
  }

  //Start of instructions___________________________________________________________________________//

  if (gameMode == 0) {

    //Let's display some instructions. We'll draw text at different points on screen and colored backgrounds behind the text, and instruct the player to press ENTER to progress through the messages.
    textFont(font, fontsize);
    //textAlign(CENTER);

    if (currentLevel == 0) { //First level.
      rectMode(CORNER);
      if (msg == 0 && levelNew[currentLevel] == false) { //If there's no message but this is the first time on this level and it's the original game mode...
        msg = 1; //...display the first message.
      }
      if (msg == 1) {
        noStroke(); 
        fill(textBackground); 
        rect(width/2-100, height/2-fontsize*5, 190, 75);
        fill(textColor); 
        text("Ah, there you are.", width/2-100, height/2-fontsize*4);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2-100, height/2-fontsize*2);
      }
      else if (msg == 2) {
        noStroke(); 
        fill(textBackground); 
        rect(width/4-100, height/2+fontsize*2, 180, 100);
        fill(textColor); 
        textFont(font, fontsize/1.25); 
        text("Oh, good. You know\nhow to follow orders.", width/4-100, height/2+fontsize*3);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/4-100, height/2+fontsize*6);
      }
      else if (msg == 3) {
        noStroke(); 
        fill(textBackground); 
        rect(width/1.25-115, height-(height/5)-fontsize*2, 205, 100);
        textFont(font, fontsize*2); 
        fill(textColor); 
        text("I like that.", width/1.25-115, height-(height/5));
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/1.25-115, height-(height/5)+fontsize*2);
      }
      else if (msg == 4) {
        noStroke(); 
        fill(textBackground); 
        rect(85, height-100, 155, 50+fontsize);
        textFont(font, fontsize*1.25); 
        fill(textColor); 
        text("Let's begin.", 85, height-100+fontsize);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", 85, height-100+fontsize*3);
      }
      else if (msg == 5) { //In this case we are not moving between screens by controlling notKirby so we handle the transition here.
        levelNew[currentLevel] = true; //We have now read the messages here so we set the variable to true so the messages don't repeat if we return to this screen.
        currentLevel++;
        msg = 1;
      }
    }

    if (currentLevel == 1) { //Second level.
      //rectMode(CENTER);
      if (msg == 1) {
        pushMatrix();
        translate(-(215/2), 0);
        noStroke(); 
        fill(textBackground); 
        rect(width/2, height/7-fontsize, 215, 50+fontsize*1.5);
        textFont(font, fontsize*1.25); 
        fill(textColor); 
        text("This is a 'game.'", width/2, height/7);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/7+fontsize*2);
        popMatrix();
      }
      else if (msg == 2) {
        pushMatrix();
        translate(-130, 0);
        noStroke(); 
        fill(textBackground); 
        rect(width/2, height/3-fontsize, 260, fontsize*5-10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("The purpose of a 'game'\nis to have 'fun.'", width/2, height/3);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/3+fontsize*3);
        popMatrix();
      }
      else if (msg == 3) {
        pushMatrix();
        translate(-130, 0);
        noStroke(); 
        fill(textBackground); 
        rect(width/2, height/2, 260, fontsize*4+10);
        textFont(font, fontsize*0.75); 
        fill(textColor); 
        text("'Fun' is what you have\nwhen you're being 'useless.'", width/2, height/2+fontsize);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*4);
        popMatrix();
      }
      else if (msg == 4) {
        pushMatrix();
        translate(-(315/2), 0);
        noStroke(); 
        fill(textBackground); 
        rect(width/2, height-fontsize*7, 315, fontsize*6+10);
        textFont(font, fontsize*2); 
        fill(textColor); 
        text("Who's ready\nfor some fun!?", width/2, height-fontsize*5);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height-fontsize);
        popMatrix();
      }
      else if (msg == 5) {
        levelNew[currentLevel] = true; //We have now read the messages here so we set the variable to true so the messages don't repeat if we return to this screen.
        currentLevel++;
        msg = 1;
      }
    }

    if (currentLevel == 2) {
      if (msg == 1) {
        pushMatrix(); 
        translate(-390, 50);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 225, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("This is your 'avatar.'", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        strokeWeight(10);
        stroke(0);
        line(width/2+40, height/2+fontsize*4, width/2+40, height/2+fontsize*7);
        line(width/2+30, height/2+fontsize*6.5, width/2+40, height/2+fontsize*7);
        line(width/2+50, height/2+fontsize*6.5, width/2+40, height/2+fontsize*7);
        noStroke();
        popMatrix();
      }
      if (msg == 2) {
        pushMatrix(); 
        translate(-350, 100);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 300, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("You are not the same as it.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 3) {
        pushMatrix(); 
        translate(-310, 150);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 225, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("But it does represent\nyou in the game.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 4) {
        pushMatrix(); 
        translate(-270, 200);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 225, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("With a 90% increase\nin adorableness.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 5) {
        levelNew[currentLevel] = true;
        currentLevel++;
        msg = 1;
      }
    }
    if (currentLevel == 3) {
      if (msg == 1) {
        pushMatrix(); 
        translate(200, -250);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 180, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("This world is flat.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        //draw arrow
        popMatrix();
      }
      if (msg == 2) {
        pushMatrix(); 
        translate(-390, -250);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 230, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Not like your outdated\ngeographic theories.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 3) {
        pushMatrix(); 
        translate(200, 225);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 180, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("But vertically flat.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 4) {
        levelNew[currentLevel] = true;
        currentLevel++;
        msg = 1;
      }
    }
    if (currentLevel == 4) {
      if (msg == 1) {
        pushMatrix(); 
        translate(250, 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 130, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("There is left.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 2) {
        pushMatrix(); 
        translate(-390, 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 200, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("And there is right.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 3) {
        pushMatrix(); 
        translate(-(130/2), 230);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 130, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("There is up.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 4) {
        pushMatrix(); 
        translate(-100, -260);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 200, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("And there is down.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 5) {
        pushMatrix();
        translate(0, 0);
        rotate(25);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 175, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Two dimensions.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 6) {
        pushMatrix();
        rotate(-25);
        translate(0, 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 185, fontsize*5+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("There is no depth\n\nin this game.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*4);
        popMatrix();
      }
      if (msg == 7) {
        levelNew[currentLevel] = true;
        currentLevel++;
        msg = 1;
      }
    }
    if (currentLevel == 5) {
      if (msg == 1) {
        msgXpos += moveMsg;
        if (msgXpos >= (width-300) || msgXpos <= 0) {
          moveMsg *= -1;
        }
        pushMatrix(); 
        translate(0, 0);
        noStroke();
        fill(textBackground); 
        rect(msgXpos, height/2-fontsize, 300, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("You can move your avatar\nif you know the secret.", msgXpos, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", msgXpos, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 2) {
        pushMatrix(); 
        translate(0, 0);
        scale(0.5);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 200, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Here is the secret.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 3) {
        pushMatrix(); 
        translate(0, 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 230, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Find the key with\na right-pointing arrow.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 4) {
        pushMatrix(); 
        translate(-200, 100);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 185, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("I call it the\n'right arrow key.'", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 5) {
        pushMatrix(); 
        translate(100, 230);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 230, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Press it to move right.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 6) {
        next = false;
        levelNew[currentLevel] = true;
        msg = 0;
      }
    }
    if (currentLevel == 6) {
      if (msg == 1) {
        pushMatrix(); 
        translate(-390, -260);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 185, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("There is a 'left-\narrow key,' too.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 2) {
        pushMatrix(); 
        translate(130, 230);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 250, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Maybe you knew this?", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 3) {
        pushMatrix(); 
        translate(-(235/2), 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 235, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("I'll bet you can guess\nwhat that does.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 4) {
        next = false;
        levelNew[currentLevel] = true;
        msg = 0;
      }
    }
    if (currentLevel == 7) {
      if (msg == 1) {
        msgYpos += moveMsg;
        if ((msgYpos-fontsize) >= (height-(fontsize*4+10)) || (msgYpos-fontsize) <= 0) {
          moveMsg *= -1;
        }
        pushMatrix(); 
        translate(-120, 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, msgYpos-fontsize, 240, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("The 'up-' and 'down-\narrow keys,' however", width/2, msgYpos);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, msgYpos+fontsize*3);
        popMatrix();
      }
      if (msg == 2) {
        pushMatrix(); 
        translate(0, 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 300, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("do not do what you expect.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 3) {
        pushMatrix();
        scale(2.5);
        translate(-300, -150);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 115, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Ha ha.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 4) {
        pushMatrix(); 
        translate(-300, 200);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 145, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("You still need\nthe secret.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 5) {
        next = false;
        levelNew[currentLevel] = true;
        msg = 0;
      }
    }
    if (currentLevel == 8) {
      if (msg == 1) {
        pushMatrix();
        scale(0.5);
        translate(0, 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 200, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Here is the secret.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 2) {
        pushMatrix(); 
        translate(0, 200);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 205, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Press the 'SPACE\nBAR' to 'jump.'", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 3) {
        pushMatrix(); 
        translate(200, -150);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 180, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("I hope you know\nwhat that is.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 4) {
        pushMatrix(); 
        translate(-390, -75);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 315, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("('SPACE BAR' and 'jumping,'\nI mean.)", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 5) {
        pushMatrix(); 
        translate(-300, 175);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 115, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Try it now.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press SPACE]", width/2, height/2+fontsize*2);
        promptJump = true; //Enable jumping.
        noAdvance = true;
        popMatrix();
        if (jumpCounter >= 3) {
          msg++;
        }
      }
      if (msg == 6) {
        noAdvance = false;
        pushMatrix(); 
        translate(0, 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 305, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Ha ha! Look at your avatar's\nlittle arm flip up and down!", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 7) {
        jumpCounter = 0;
        pushMatrix(); 
        translate(-390, 235 );
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 115, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("SO CUTE.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 8) {
        promptJump = false;
        next = false;
        levelNew[currentLevel] = true;
        msg = 0;
      }
    }
    if (currentLevel == 9) {
      if (msg == 1) {
        pressedVlevel = true;
        pushMatrix();
        translate(-600, -300);
        scale(2);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 185, fontsize*2+15);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Whatever you do,\ndon't press 'v'!", width/2, height/2);
        noAdvance = true;
        popMatrix();
      }
      if (msg == 2) {
        noAdvance = false;
        pressedVlevel = false;
        pushMatrix(); 
        translate(-(185/2), 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 185, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Just kidding.\nJust testing you.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 3) {
        pushMatrix(); 
        translate(-(115/2), 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 115, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("You failed.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 4) {
        pushMatrix(); 
        translate(-60, 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 120, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("LOL ha ha.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 5) {
        pushMatrix(); 
        translate(-100, 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 200, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Alright, let's get\ndown to business.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 6) {
        next = false;
        levelNew[currentLevel] = true;
        msg = 0;
      }
    }
    if (currentLevel == 10) {
      if (msg == 1) {
        pushMatrix(); 
        translate(0, 185);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 210, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("This is a 'platform.'", width/2, height/2);
        textFont(font, fontsize/1.5);
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        //draw arrow
        popMatrix();
      }
      if (msg == 2) {
        pushMatrix(); 
        translate(-250, 100);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 225, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Your avatar can\njump on the platform.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 3) {
        pushMatrix(); 
        translate(-235, -250);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 180, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("If you are lucky it\nwill hold weight.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 4) {
        pushMatrix(); 
        translate(-240, 240);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 210, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Ha ha, just kidding.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 5) {
        pushMatrix(); 
        translate(-390, 100);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 180, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("All platforms are\n100% reliable.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 6) {
        next = false;
        levelNew[currentLevel] = true;
        msg = 0;
      }
    }
    if (currentLevel == 11) {
      if (msg == 1) {
        bounced = false;
        pushMatrix(); 
        translate(-200, 75);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 315, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("There are multiple platforms.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 2) {
        pushMatrix(); 
        translate(50, 10);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 200, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Make your way to\nthe top platform.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 3) {
        pushMatrix(); 
        translate(-275, -150);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 260, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("See how it mocks you?", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 4) {
        pushMatrix(); 
        translate(-390, 235);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 285, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Don't put up with mockery!", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 5) {
        next = false;
        levelNew[currentLevel] = true;
        msg = 0;
      }
      if (msg == 6) {
        next = true;
        pushMatrix(); 
        translate(-100, -240);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 115, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Well done.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 7) {
        next = false;
        msg = 0;
      }
    }
    if (currentLevel == 12) {
      if (msg == 1) {
        pushMatrix(); 
        translate(-(285/2), 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 285, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Wait…what's that number\ndoing up there?", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 2) {
        next = false;
        levelNew[currentLevel] = true;
        msg = 0;
      }
    }
    if (currentLevel == 13) {
      if (msg == 1) {
        pushMatrix(); 
        translate(-110, 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 220, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("It looks like a score.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 2) {
        next = false;
        levelNew[currentLevel] = true;
        msg = 0;
      }
    }
    if (currentLevel == 14) {
      if (msg == 1) {
        pushMatrix(); 
        translate(-(215/2), 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 215, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("I don't remember\nany scoring system.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 2) {
        next = false;
        levelNew[currentLevel] = true;
        msg = 0;
      }
    }
    if (currentLevel == 15) {
      if (msg == 1) {
        pushMatrix(); 
        translate(-(175/2), 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 175, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Wait a minute...", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 2) {
        next = false;
        levelNew[currentLevel] = true;
        msg = 0;
      }
    }
    if (currentLevel == 16) {
      if (msg == 1) {
        pushMatrix(); 
        translate(-(225/2), 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 225, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Are these the right...", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 2) {
        next = false;
        levelNew[currentLevel] = true;
        msg = 0;
      }
    }
    if (currentLevel == 17) {
      if (msg == 1) {
        pushMatrix();
        scale(0.75);
        translate(0, 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 200, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("These are the\nwrong instructions.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 2) {
        pushMatrix(); 
        translate(0, 0);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 200, fontsize*4+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("I think they're\nfor another game.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*3);
        popMatrix();
      }
      if (msg == 3) {
        pushMatrix();
        scale(4);
        translate(-350, -250);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 115, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("LOL", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 4) {
        pushMatrix(); 
        translate(-390, 130);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 215, fontsize*5+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Alright,\n\nyou're on your own.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*4);
        popMatrix();
      }
      if (msg == 5) {
        pushMatrix(); 
        translate(275, 225);
        noStroke();
        fill(textBackground); 
        rect(width/2, height/2-fontsize, 115, fontsize*3+10);
        textFont(font, fontsize); 
        fill(textColor); 
        text("Later.", width/2, height/2);
        textFont(font, fontsize/1.5); 
        text("[Press ENTER]", width/2, height/2+fontsize*2);
        popMatrix();
      }
      if (msg == 6) {
        next = false;
        levelNew[currentLevel] = true;
        msg = 0;
      }
    }

    if (currentLevel > 17) {
      /*
    if (msg == 1) {
       noStroke();
       fill(textBackground); 
       rect(width/2, height/2, 315, fontsize*3+10);
       textFont(font, fontsize); 
       fill(textColor); 
       text("", width/2, height/2);
       textFont(font, fontsize/1.5); 
       text("[Press ENTER]", width/2, height/2+fontsize*2);
       }
       */
      next = false;
      levelNew[currentLevel] = true;
      msg = 0;
    }
  }

  //End of instructions___________________________________________________________________________//
}

//_____________________________________________________________________________________________________________

void keyPressed() {
  if (key=='1') { //Debug.
    if (currentLevel > 0) { //If previous level exists...
      currentLevel--; //...switch to previous level.
    }
  }

  if (key=='2') { //Debug.
    if (currentLevel < (myLevels.length - 1)) { //If next level exists...
      currentLevel++; //...switch to next level.
    }
  }

  if (key=='0') { //Debug.
    msg--;
  }

  if (key=='v' || key=='V') { //Debug.
    if (pressedVlevel == true) {
      msg++;
    }
  }
  if (keyCode==SHIFT) {
    if (gameMode == 0) {
      gameMode = 1;
      setup();
    }
    else {
      gameMode = 0;
      setup();
    }
  }

  if (keyCode==ENTER || keyCode==RETURN) { //Let's advance the text boxes.
    if (noAdvance == false) { //Assuming it is permitted.
      if (msg >= 1) { //If there's a message on screen...
        if (next == true) { //...and if there are more messages to come...
          msg++; //...advance to the next message.
        }
        else {
          msg = 0; //Turn off messages (thereby enabling movement).
        }
      }
    }
  }

  //Let's control the ball. Many, MANY thanks to Ramiro Corbetta and his Dorkshop on Intro to Game Programming for this method of controlling movement through booleans (resulting in much more fluid control and recognition of multiple buttons at once).

  if (promptJump == true) { //Special jump instructions for if jumping is prompted.
    if (key==' ') { //If the player presses the Space Bar...
      if (notKirby.yPos >= height - (notKirby.tall / 2)) { //...and if the ball is on the ground...
        notKirby.jump = true; //...enable jumping.
        jumpCounter ++;
      }
      else for (int i = 0; i < myLevels[currentLevel].myPlats.size(); i++) { //OK, this is where things get really awesome (and really complicated). It's time for collision detection - super cool and super important! Each level is an ArrayList composed of varying numbers of Platform objects. We use a for loop to count how many platforms there are in the ArrayList for the current level, then iterate through those platforms. We are going to check the ball's position relative to each Platform in the ArrayList.
        Platform myPlatform = myLevels[currentLevel].myPlats.get(i); //ArrayLists are weird (and cool). They don't necessarily know what kind of information they hold in their elements. In order to use if statements to check notKirby's position relative to each platform, we have to give each platform an identity, which we do by naming it as a platform ("myPlatform" in this case) and assigning it the current value of i. In other words, this statement allows us to pull one of the objects in the ArrayList so we can refer to it in the following statements.
        if ((notKirby.xPos + (notKirby.wide / 2) >= myPlatform.xPos) && (notKirby.xPos - (notKirby.wide / 2) <= (myPlatform.xPos + myPlatform.platWidth))) { //At each value of i (aka ArrayList element in this case), is the ball's xPos within the width of the platform at that element?
          if ((notKirby.yPos + (notKirby.tall / 2) >= myPlatform.yPos) && (notKirby.yPos + (notKirby.tall / 2) <= (myPlatform.yPos + notKirby.depth))) { //Assuming we got a positive result above, is the ball's yPos within the upper part of the platform at that element?
            notKirby.jump = true; //If yes to all the above, enable jumping.
            jumpCounter ++;
          }
        }
      }
    }
  }

  if (msg <= 0) { //If there are no messages on screen, proceed.
    if (keyCode==RIGHT) { //If the player presses the right-directional arrow key...
      notKirby.R = true; //...enable movement right...
      direction=true; //...and face right.
    }
    if (keyCode==LEFT) { //If the player presses the left-directional arrow key...
      notKirby.L = true; //...enable movement left...
      direction=false; //...and face left.
    }
    if (key==' ') { //If the player presses the Space Bar...
      if (notKirby.yPos >= height - (notKirby.tall / 2)) { //...and if the ball is on the ground...
        notKirby.jump = true; //...enable jumping.
      }
      else for (int i = 0; i < myLevels[currentLevel].myPlats.size(); i++) { //OK, this is where things get really awesome (and really complicated). It's time for collision detection - super cool and super important! Each level is an ArrayList composed of varying numbers of Platform objects. We use a for loop to count how many platforms there are in the ArrayList for the current level, then iterate through those platforms. We are going to check the ball's position relative to each Platform in the ArrayList.
        Platform myPlatform = myLevels[currentLevel].myPlats.get(i); //ArrayLists are weird (and cool). They don't necessarily know what kind of information they hold in their elements. In order to use if statements to check notKirby's position relative to each platform, we have to give each platform an identity, which we do by naming it as a platform ("myPlatform" in this case) and assigning it the current value of i. In other words, this statement allows us to pull one of the objects in the ArrayList so we can refer to it in the following statements.
        if ((notKirby.xPos + (notKirby.wide / 2) >= myPlatform.xPos) && (notKirby.xPos - (notKirby.wide / 2) <= (myPlatform.xPos + myPlatform.platWidth))) { //At each value of i (aka ArrayList element in this case), is the ball's xPos within the width of the platform at that element?
          if ((notKirby.yPos + (notKirby.tall / 2) >= myPlatform.yPos) && (notKirby.yPos + (notKirby.tall / 2) <= (myPlatform.yPos + notKirby.depth))) { //Assuming we got a positive result above, is the ball's yPos within the upper part of the platform at that element?
            notKirby.jump = true; //If yes to all the above, enable jumping.
          }
        }
      }
    }
  }
  
  //Alternative movement mechanics:
  if (key=='w' || key=='W') {
    notKirby.blastU = true;
  }
  if (key=='a' || key=='A') {
    notKirby.blastL = true;
    direction = false;
  }
  if (key=='s' || key=='S') {
    notKirby.blastD = true;
  }
  if (key=='d' || key=='D') {
    notKirby.blastR = true;
    direction = true;
  }
  
}

//_____________________________________________________________________________________________________________

void keyReleased() { //We use these statements to stop movement when the player releases the key. Otherwise notKirby would just keep groovin' in the same direction until he runs into a wall. You jerk.
  if (keyCode==RIGHT) {
    notKirby.R = false;
  }
  if (keyCode==LEFT) {
    notKirby.L = false;
  }
  
  //Alternative movement mechanics:
  if (key=='w' || key=='W') {
    notKirby.blastU = false;
  }
  if (key=='a' || key=='A') {
    notKirby.blastL = false;
  }
  if (key=='s' || key=='S') {
    notKirby.blastD = false;
  }
  if (key=='d' || key=='D') {
    notKirby.blastR = false;
  }
}

//_____________________________________________________________________________________________________________

/*
The following code is a hack of sorts from the Processing website, for
 which I'm very grateful. I use pushMatrix and popMatrix to position
 the text instructions above more easily, but I discovered that Processing has a
 built-in limit of 32 uses of the push function, which was insufficient.
 Fortunately I found this solution, which overrides the default limit. Everything
 below the end of this comment is copied and pasted from the page cited below in
 the next comment. I don't totally understand what it's doing, but I'm grateful for it!
 */

/**
 deepmatrixstack taken from http://wiki.processing.org/index.php/Matrix_stack
 to override the default stack just copy & paste the following code
 to your sketch
 @author steve
 */

// adjust this value to whatever depth is actually necessary
public final int STACK_DEPTH = 512;
public float[][] matrixStack = new float[STACK_DEPTH][6];
public int matrixStackDepth;

// this version will override the built-in version pushMatrix function
public void pushMatrix() {
  if (matrixStackDepth == 512) {
    throw new RuntimeException("too many calls to pushMatrix()");
  }
  this.g.getMatrix().get(matrixStack[matrixStackDepth]);
  matrixStackDepth++;
}

// this version will override the built-in version popMatrix function
public void popMatrix() {
  if (matrixStackDepth == 0) {
    throw new RuntimeException("too many calls to popMatrix()" +
      "(or too few to pushMatrix)");
  }
  matrixStackDepth--;
  PMatrix2D m = new PMatrix2D();
  m.set(matrixStack[matrixStackDepth]);
  this.g.setMatrix(m);
}

