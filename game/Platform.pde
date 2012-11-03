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
    //for (int i = 0; i < myLevels[currentLevel].myPlats.size(); i++) {
      //Platform myPlatform = myLevels[currentLevel].myPlats.get(i);


      //if (myLevels[currentLevel].platColor[i] == true) {
        //stroke(0); //Give a black outline to objects.
      //}
      //else {
        stroke(255); //Give a white outline to objects.
      //}

      rectMode(CORNER);
      noFill();
      strokeWeight(2); //Thicken the outline.
      rect(xPos, yPos, platWidth, platHeight); //Now we draw the rectangle using the values entered in the constructor (see note above).
    //}
  }
}

