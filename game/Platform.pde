//Please note - protagonist notKirby is also known as "Ball" throughout this code and commentary. Live free of perplexity!

class Platform { //Make a class called "Platform."
  float xPos; //Control horizontal position.
  float yPos; //Control vertical position.
  float platWidth; //Control width of object.
  float platHeight; //Control height of object.

  Platform(float x, float y, float w, float h) { //This is the constructor for the Platform object. See the note about constructors and local versus global variables on the Level tab.
    xPos = x;
    yPos = y;
    platWidth = w;
    platHeight = h;
  }

  void drawPlatform() {
    rectMode(CORNER);
    noFill();
    stroke(255); //Give a white outline to objects.
    strokeWeight(2); //Thicken the outline.
    rect(xPos, yPos, platWidth, platHeight); //Now we draw the rectangle using the values entered in the constructor (see note above).
  }
}

