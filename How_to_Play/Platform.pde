// Please note: protagonist notKirby is also known as "Ball" throughout. Live free of perplexity!

class Platform { // Make a class called "Platform."
  float xPos; // Control horizontal position.
  float yPos; // Control vertical position.
  float platWidth; // Control width of object.
  float platHeight; // Control height of object.

  // This is the constructor for the Platform object. See the note about constructors and local
  // versus global variables on the Level tab:
  Platform(float x, float y, float w, float h) { 
    xPos = x;
    yPos = y;
    platWidth = w;
    platHeight = h;
  }

  void drawPlatform() {
    stroke(255); // Give a white outline to objects.
    rectMode(CORNER);
    noFill();
    strokeWeight(2); // Thicken the outline.

    // Now we draw the rectangle using the values entered in the constructor (see note above):
    rect(xPos, yPos, platWidth, platHeight);
  }
}

