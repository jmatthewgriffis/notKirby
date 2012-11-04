//Please note - protagonist notKirby is also known as "Ball" throughout this code and commentary. Live free of perplexity!

//notKirby is a nested object made up of other objects, so originally his component parts had their own tabs. Once I integrated him into this game I decided to combine all the parts into one tab to keep character and the other game parts easily distinguishable.

class notKirby { //Make a class called "notKirby." This will create a nested object composed of various objects.
  float xPos, yPos, wide, tall; //These will be the default values for all other components of the face, to be modified in their cases for correct placement (code copied from the Face tab).
  color c; //Color of face.
  color c2 = (#2C27CB); //Color of pupil.
  float f = 90; //Blink frequency.
  float eyeDistance = 40 * resizer; //Distance from xPos of eye(s).
  float ang1 = 0;
  float ang2 = PI;
  float xVel = 3; //Modify horizontal position.
  float yVel = 0; //Modify vertical position.
  float speed_limit = 7.8; //Limit vertical speed.
  float rebound = -3; //How much bounce is there?
  float grav = .3; //Modify yVel to simulate gravity.
  float depth = 10; //Control how deep the ball can land on the platform (useful for collision detection).
  boolean jump = false; //Control when the ball can jump.
  boolean L, R = false; //Control when the ball can move.

  //Now we create variables to control a different type of movement for a separate game mode:
  boolean blastL, blastR, blastU, blastD = false; //Control when notKirby can rocket.
  float blastXvel, blastYvel = 0; //Use to modify position with rocketing.
  int blastSpeed = 20; //Speed of rocketing.
  float slow = .3; //Gradually slow rocketing speed.

  Eye eyes1;
  Face face1;
  Arm arm;

  notKirby(float _xPos, float _yPos, float _wide, float _tall, color _c) { //Uber-constructor in which we give the default parameters that will control almost everything.
    xPos = _xPos;
    yPos = _yPos;
    wide = _wide * resizer;
    tall = _tall * resizer;
    c = _c;
  }

  void prep() { //Originally I placed the following initializations in the constructor above. But I got a Null Pointer Exception. So I thought maybe the notKirby object wasn't getting created (with its parameters entered through the constructor) soon enough before loading the nested objects that pull from its parameters. So I placed them in their own function, which runs after initializing the notKirby object on the main tab, and it worked!
    face1 = new Face();
    eyes1 = new Eye();
    arm = new Arm();
    /* //No longer using the individual constructors to give parameters, basing things instead on the notKirby constructor.
     face1 = new Face(200, 200, 175, 200, color(#FF08F3));
     eyes1  = new Eye(200, 170, 60, color (#2C27CB), 90); //x,y,s,c,f
     arm = new Arm(190, 230, 50, 50, 0, PI); //x, y, w, h, ang1, ang2
     */
  }

  void display() {
    face1.display(xPos, yPos); //Thanks to Francisco for figuring out that I needed to pass the coordinates into the nested objects' display functions in order to update them with the changing positions.
    eyes1.display(xPos, yPos);
    arm.display(xPos, yPos);
  }

  void updateBall() {

    //Here are the regular game mode mechanics:

    if (jump == true) { //If jumping is allowed...
      yVel = -speed_limit; //...give the ball upward velocity. It's a jump!
      jump = false; //Immediately forbid jumping to prevent mid-air jumps.
    }
    if (R == true &&  xPos <= width-(wide / 2)) { //If rightward movement is allowed and the ball is not at the right edge of the screen...
      xPos += xVel; //...move the ball right based on the xVel.
    }
    if (L == true && xPos >= (wide / 2)) { //If leftward movement is allowed and the ball is not at the left edge of the screen...
      xPos -= xVel; //...move the ball left based on the xVel.
    }

    yPos += yVel; //Update yPos each frame with yVel.
    yVel += grav; //Update yVel each frame with grav.
    if (yVel > speed_limit) {
      yVel = speed_limit; //Impose terminal velocity to make collision detection easier.
    }

    if (yPos >= height - (tall / 2)) { //Did the ball hit the ground?
      if (yVel == speed_limit) { //If it was going fast enough...
        yVel = rebound; //...make it bounce a little.
      }
      else {
        yVel = 0; //Otherwise, bring it to rest (vertically).
      }
    }

    for (int i = 0; i < myLevels[currentLevel].myPlats.size(); i++) { //More collision detection. See the comments on the main tab for details. Same principles here.
      Platform myPlatform = myLevels[currentLevel].myPlats.get(i);
      if ((xPos + (wide / 2) >= myPlatform.xPos) && (xPos - (wide / 2) <= (myPlatform.xPos + myPlatform.platWidth))) { //At each value of i (aka ArrayList element in this case), is the ball's xPos within the width of the Platform at that element?
        if ((yPos + (tall / 2) >= myPlatform.yPos) && (yPos + (tall / 2) <= (myPlatform.yPos + depth))) { //Assuming we got a positive result above, is the ball's yPos within the upper part of the Platform at that element?
          if (yVel == speed_limit) { //The ball hit the platform, so change its velocity appropriately.
            yVel = rebound;
            if (myLevels[currentLevel].platColor[i] == false) {
              myLevels[currentLevel].platColor[i] = true;
              platRockd = true;
            }
          }
          else {
            yVel = 0; //All of this is the same deal as when the ball hits the ground (see comments above).
            if (myLevels[currentLevel].platColor[i] == false) {
              myLevels[currentLevel].platColor[i] = true;
              platRockd = true;
            }
          }
        }
        else if ((yPos - (tall / 2) >= (myPlatform.yPos + depth)) && (yPos - (tall / 2) <= (myPlatform.yPos + myPlatform.platHeight))) { //Ah, but what if the yPos is within the lower part of the Platform at that ArrayList element?
          yPos = (myPlatform.yPos + myPlatform.platHeight) + (tall / 2); //Set the yPos of the top of the ball (yPos - (tall / 2)) equal to the bottom of the platform (we must add (tall / 2) to the other side of the equation so yPos is isolated on the left). This prevents the ball from getting stuck within the platform when it reverses its velocity.
          yVel = (yVel - grav) * -1; //In that case the ball has hit the bottom of that Platform, so we reverse the direction (nullifying the gravity addition at this frame).
        }
      }

      //Changing the stroke color of the platform when notKirby rockets it is not working as desired. So we use an alternative solution. Instead of changing the color of the existing rectangle, we check to see if the appropriate boolean registers a collision, and if it does, we draw a new rectangle of a different color on top of the old one. Voila!
      if (myLevels[currentLevel].platColor[i] == true) {
        stroke(platFlipped);
        rectMode(CORNER);
        noFill();
        strokeWeight(4);
        rect(myPlatform.xPos, myPlatform.yPos, myPlatform.platWidth, myPlatform.platHeight);
      }

      //if (currentLevel == (myLevels.length - 1)) { //Make sure this is the last level.
      if (currentLevel == 11) {
        if (i == (myLevels[currentLevel].myPlats.size() - 1)) {
          if ((xPos + (wide / 2) >= myPlatform.xPos) && (xPos - (wide / 2) <= (myPlatform.xPos + myPlatform.platWidth))) { //Is the ball within the width of the last (and winning) Platform?
            if ((yPos + (tall / 2) >= myPlatform.yPos) && (yPos + (tall / 2) <= (myPlatform.yPos + depth))) { //If yes, is its vertical position within the upper part of that Platform?
              if (bounced == false) {
                bounced = true;
                msg = 6;
                next = true;
              }
            }
          }
        }
      }
      if (blastR == false && blastL == false && blastU == false && blastD == false) {
        if ((yPos + (tall / 2) >= (myPlatform.yPos + depth)) && (yPos - (tall / 2) <= (myPlatform.yPos + myPlatform.platHeight - depth))) { //Glitch control! Here we prevent the ball from getting inside a platform by coming from the side (rather than the bottom or top). Pseudo code was extremely helpful to figure out how to say this. If the bottom of the ball is above the top of the platform, the ball is definitely not in the platform. If the top of the ball is below the bottom of the platform, the ball is definitely not in the platform. So we check if the ball's bottom is below the platform's top, and if the ball's top is above the platform's bottom. We also include the depth variable for both the top and bottom of the platform as a sort of margin of error - that is to account for the imprecision of the collision detection. It's the same thing as we did when detecting landing on a platform, except that we're applying it to the underside of the platform too, because otherwise if you jump into the bottom of a platform (as opposed to coming from the side) it doesn't detect the collision quickly enough and loads the behavior as if you had come from the side, with the result that the ball warps to the side of the platform.
          if ((xPos + (wide / 2) >= (myPlatform.xPos + (myPlatform.platWidth / 2))) && (xPos - (wide / 2) <= (myPlatform.xPos + myPlatform.platWidth))) { //Assuming yes to the above, we test once again to see if the ball's horizontal position is within the width of the platform. But, in order to control how movement is affected, we want to check if the ball is to the left or right side of the platform. So we split the test up into two sections - this first one checks if the ball is within the right half of the platform.
            xPos = (myPlatform.xPos + myPlatform.platWidth) + (wide / 2); //If yes to the above (the ball is in the right half of the platform), it seems pretty certain that the ball was coming from the right, so we set the ball's xPos equal to the right edge of the platform and account for the ball's width.
          }
          else if (((xPos + (wide / 2)) >= myPlatform.xPos) && ((xPos - (wide / 2)) < myPlatform.xPos + (myPlatform.platWidth / 2))) { //Part two of the width test checks to see if the ball is in the left half of the platform.
            xPos = myPlatform.xPos - (wide / 2); //If yes to the above (the ball is in the left half of the platform), it seems pretty certain that the ball was coming from the left, so we set the ball's xPos equal to the left edge of the platform and account for the ball's width. (The advantage of doing it this way is that we don't have to mess with the xVel value or the movement booleans). The result is the ball presses up against the edge of the platform like a wall and does not get stuck inside it!
          }
        }
      }
    }


    //Here are the alternative game mode mechanics:
    if (blastR == true &&  xPos <= width-(wide / 2)) {
      blastXvel = blastSpeed;
      xPos += blastXvel;
    }
    if (blastL == true && xPos >= (wide / 2)) {
      blastXvel = blastSpeed;
      xPos -= blastXvel;
    }
    if (blastD == true &&  yPos <= height-(tall / 2)) {
      blastYvel = blastSpeed;
      yPos += blastYvel;
    }
    if (blastU == true && yPos >= (tall / 2)) {
      blastYvel = blastSpeed;
      yPos -= blastYvel;
    }

    if (blastXvel > 0) {
      blastXvel -= slow;
    }
    if (blastXvel <= 0) {
      blastXvel = 0;
    }
    if (blastYvel > 0) {
      blastYvel -= slow;
    }
    if (blastYvel <= 0) {
      blastYvel = 0;
    }
  }
}



//_________________________________________________________________________________________________________________________________________
//Arm class
//Please note - protagonist notKirby is also known as "Ball" throughout this code and commentary. Live free of perplexity!

class Arm { //Note I learned the hard way: any variables initialized here will only use the values from the first frame. If I need to update the variables, I must initialize them in a function into which I can pass the updated variables each frame.
  //xPos, yPos, width, height, start of arc (radians), end of arc (radians)
  float xPos;
  float yPos;
  //  float xPos = notKirby.xPos-(10 * resizer); //These two are no longer necessary (replaced with the two above) because they would pull only the first value of xPos and yPos from the notKirby object. We need to update each frame so the parts move together, so we update the display function below with the coordinates and initialize them there.
  //  float yPos = notKirby.yPos+(30 * resizer);
  float wide = notKirby.wide-(125 * resizer);
  float tall = notKirby.tall-(150 * resizer);
  float ang1 = notKirby.ang1;
  float ang2 = notKirby.ang2;

  /*
  Arm(float _xPos, float _yPos, float _wide, float _tall, float _ang1, float _ang2) { //Constructor - no longer needed because we are controlling all the variables through the main object, 'notKirby.'
   xPos = _xPos;
   yPos = _yPos;
   wide = _wide;
   tall = _tall;
   ang1 = _ang1;
   ang2 = _ang2;
   }
   */

  void display(float _xPos, float _yPos) {
    xPos = _xPos-(10 * resizer);
    yPos = _yPos+(30 * resizer);
    noFill();
    stroke(0); //Color
    strokeWeight(2 * resizer); //Thickness of arc
    if (direction==true) { //Character is facing to the right.
      if (notKirby.yVel == 0) { //Character is on a surface.
        arc(xPos, yPos, wide, tall, ang1, ang2);  // Draw arm down and to the left.
      }
      else { //Character is in the air.
        arc(xPos, yPos, wide, tall, -ang2, ang1);  // Draw arm up and to the left.
      }
    }
    else { //Character is facing to the left.
      if (notKirby.yVel == 0) { //Character is on a surface.
        arc(xPos+(20 * resizer), yPos, wide, tall, ang1, ang2);  // Draw arm down and to the right.
      }
      else { //Character is in the air.
        arc(xPos+(20 * resizer), yPos, wide, tall, -ang2, ang1);  // Draw arm up and to the right.
      }
    }
  }
}



//_________________________________________________________________________________________________________________________________________
//Eye class
//Please note - protagonist notKirby is also known as "Ball" throughout this code and commentary. Live free of perplexity!

//Initial character code for separate parts Face, Eye and Mouth provided in class by Francisco, then modified by me.

class Eye { //Note I learned the hard way: any variables initialized here will only use the values from the first frame. If I need to update the variables, I must initialize them in a function into which I can pass the updated variables each frame.
  //posx, posy, size, blink frequency, color, distance from center of face
  float xPos;
  float yPos;
  //  float xPos = notKirby.xPos; //These two are no longer necessary (replaced with the two above) because they would pull only the first value of xPos and yPos from the notKirby object. We need to update each frame so the parts move together, so we update the display function below with the coordinates and initialize them there.
  //  float yPos = notKirby.yPos - (30  * resizer);
  float wide = notKirby.wide - (115 * resizer);
  float f = notKirby.f;
  color c = notKirby.c2;
  float eyeDistance = notKirby.eyeDistance;

  /*
  //constructor. It receives values from outside the class - no longer needed because we are controlling all the variables through the main object, 'notKirby.'
   Eye(float _xPos, float _yPos, float _wide, color _c, float _f) {
   //we copy the values coming from outside to our global variables
   xPos = _xPos;
   yPos = _yPos;
   wide = _wide;
   c = _c;
   f = _f;
   }
   */

  void display(float _xPos, float _yPos) {
    xPos = _xPos;
    yPos = _yPos - (30  * resizer);
    //a small modulo trick to cycle and make the eyes blink
    if (frameCount % f < 8 ) {
      fill(0);
      if (direction==true) { //Character is facing to the right.
        ellipse (xPos+eyeDistance, yPos, wide, 2); //Draw the right eye blinking.
      }
      else { //Character is facing to the left.
        ellipse (xPos-eyeDistance, yPos, wide, 2); //Draw the left eye blinking.
      }
    }

    else {
      if (direction==true) { //Character is facing to the right.      
        //Draw right eye open.
        fill(255);
        ellipse (xPos+eyeDistance, yPos, wide, wide/2); //white of eye

        fill(c);
        noStroke();
        ellipse (xPos+(eyeDistance*1.4), yPos, wide/3, wide/3);//iris

        fill(0);
        ellipse (xPos+(eyeDistance*1.5), yPos, wide/5, wide/5);//pupil
      }
      else { //Character is facing to the left.
        //Draw left eye open.
        fill(255);
        ellipse (xPos-eyeDistance, yPos, wide, wide/2); //white

        fill(c);
        noStroke();
        ellipse (xPos-(eyeDistance*1.4), yPos, wide/3, wide/3); //iris

        fill(0);
        ellipse (xPos-(eyeDistance*1.5), yPos, wide/5, wide/5); //pupil
      }
    }
  }
}



//_________________________________________________________________________________________________________________________________________
//Face class
//Please note - protagonist notKirby is also known as "Ball" throughout this code and commentary. Live free of perplexity!

//Initial character code for separate parts Face, Eye and Mouth provided in class by Francisco, then modified by me.

class Face { //Note I learned the hard way: any variables initialized here will only use the values from the first frame. If I need to update the variables, I must initialize them in a function into which I can pass the updated variables each frame.
  //These will be the default values for all other components of the face, to be modified in their cases for correct placement.
  float xPos;
  float yPos;
  //  float xPos = notKirby.xPos; //These two are no longer necessary (replaced with the two above) because they would pull only the first value of xPos and yPos from the notKirby object. We need to update each frame so the parts move together, so we update the display function below with the coordinates and initialize them there.
  //  float yPos = notKirby.yPos;
  float wide = notKirby.wide;
  float tall = notKirby.tall;
  color c = notKirby.c;

  /*
  //constructor - no longer needed because we are controlling all the variables through the main object, 'notKirby.'
   Face(float _xPos, float _yPos, float _wide, float _tall, color _c) {
   xPos = _xPos;
   yPos = _yPos;
   wide = _wide;
   tall = _tall;
   c = _c;
   }
   */

  //draw
  void display(float _xPos, float _yPos) {
    xPos = _xPos;
    yPos = _yPos;
    fill(c);
    noStroke();
    ellipse(xPos, yPos, wide, tall);
  }
}

