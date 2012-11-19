class Level { // Are you ready to GET CRAZY????

  // This is not the crazy part. We use this variable to label each instance as a particular level:
  int thisLevel;

  int platCount; // Use to check interactions with platforms in the alternative game mode.

  // Time for an ArrayList of platforms! We declare and name it. The "<Platform>" is to tell the
  // ArrayList what kind of object it is storing, since it doesn't know otherwise:
  ArrayList<Platform> myPlats;

  // Use to check whether notKirby has rocketed this platform and display the color appropriately:
  boolean[] platColor;

  // Here is the constructor for the Level object. We use variable "_thisLevel" so that when we
  // create an instance of the Level object in the main tab, we can distinguish it from other Level
  // objects without giving it a different name. We use the variable below to draw different sets of
  // platforms:
  Level(int _thisLevel) {

    // Here we set "_thisLevel" (which exists only inside the constructor) equal to the variable we
    // created above. This way we can use the number we enter into the constructor in contexts outside
    // the constructor, like below:
    thisLevel = _thisLevel;
  }

  void prep() { // Aw yeah. Things are about to get to the CRAZY I mentioned earlier.

    // Here we initialize the ArrayList. ArrayLists don't have a fixed size, so we don't have to give
    // a number in brackets like in arrays. Hurray! The "<Platform>" serves the same purpose here as
    // it did above - identifying to the ArrayList what kind of object it's storing. I'm not sure why
    // we need to say this twice, but hey. As long as it works, amirite?
    myPlats = new ArrayList<Platform>(); 

    // Yeah, baby. Here's how we create different levels and tell them apart. We create all these
    // levels, identified by their thisLevel value. They're all ready to go from the get-go. But we
    // only draw one at a time:
    if (thisLevel == 0) { 
      myPlats.add(new Platform(165, 200, 80, 20));
      myPlats.add(new Platform((width/2)-40, 300, 80, 20));
      myPlats.add(new Platform(545, 200, 80, 20));
    }
    else if (thisLevel == 1) {
      myPlats.add(new Platform(100, 200, 80, 20));
      myPlats.add(new Platform(100, 400, 80, 20));
      myPlats.add(new Platform(width-180, 200, 80, 20));
      myPlats.add(new Platform(width-180, 400, 80, 20));
    }
    else if (thisLevel == 2) {
      myPlats.add(new Platform(165, 200, 80, 20));
      myPlats.add(new Platform((width/2)-40, 300, 80, 20));
      myPlats.add(new Platform(545, 400, 80, 20));
    }
    else if (thisLevel == 3) {
      myPlats.add(new Platform((width/2)-250, (height/2)-10, 500, 20));
    }
    else if (thisLevel == 4) {
      myPlats.add(new Platform(80, (height/2)-10, 80, 20));
      myPlats.add(new Platform(width-160, (height/2)-10, 80, 20));
      myPlats.add(new Platform((width/2)-40, 60, 80, 20));
      myPlats.add(new Platform((width/2)-40, height-80, 80, 20));
    }
    else if (thisLevel == 5) {
      myPlats.add(new Platform(200, (height/2)-100, 80, 20));
      myPlats.add(new Platform(520, (height/2)+100, 80, 20));
    }
    else if (thisLevel == 6) {
      myPlats.add(new Platform(200, height-100, 80, 20));
      myPlats.add(new Platform(400, (height/2)-100, 80, 20));
      myPlats.add(new Platform(600, (height/2)-10, 80, 20));
      myPlats.add(new Platform(400, (height/2)+100, 80, 20));
      myPlats.add(new Platform(200, 100, 80, 20));
    }
    else if (thisLevel == 7) {
      myPlats.add(new Platform(-10, (height/2)-200, 80, 20));
      myPlats.add(new Platform(-10, (height/2)+200, 80, 20));
      myPlats.add(new Platform(-10, (height/2)-10, 80, 20));
      myPlats.add(new Platform(width-70, (height/2)-10, 80, 20));
      myPlats.add(new Platform(width-70, (height/2)+200, 80, 20));
      myPlats.add(new Platform(width-70, (height/2)-200, 80, 20));
    }
    else if (thisLevel == 8) {
      myPlats.add(new Platform(150, 105, 80, 20));
      myPlats.add(new Platform(300, 50, 80, 20));
      myPlats.add(new Platform(450, -5, 80, 20));
    }
    else if (thisLevel == 9) {
      myPlats.add(new Platform(220, (height/2)+100, 120, 20));
      myPlats.add(new Platform(430, (height/2)+100, 120, 20));
    }
    else if (thisLevel == 10) {
      myPlats.add(new Platform(165, height-100, 200, 20));
    }
    else if (thisLevel == 11) {
      myPlats.add(new Platform(270, 530, 80, 20));
      myPlats.add(new Platform(420, 470, 60, 20));
      myPlats.add(new Platform(550, 410, 60, 20));
      myPlats.add(new Platform(680, 350, 60, 20));
      myPlats.add(new Platform(490, 250, 100, 20));
      myPlats.add(new Platform(0, 170, 60, 20));
      myPlats.add(new Platform(150, 250, 60, 20));
      myPlats.add(new Platform(300, 300, 60, 20));
      myPlats.add(new Platform(450, 150, 60, 20));
      myPlats.add(new Platform(75, 75, 200, 20));
    }
    else if (thisLevel == 12) {
      myPlats.add(new Platform((width/2)-120, height-70, 80, 20));
      myPlats.add(new Platform((width/2)-280, height-70, 80, 20));
      myPlats.add(new Platform((width/2)+40, height-70, 80, 20));
      myPlats.add(new Platform((width/2)+200, height-70, 80, 20));
      myPlats.add(new Platform((width/2)-120, height-205, 80, 20));
      myPlats.add(new Platform((width/2)-280, height-205, 80, 20));
      myPlats.add(new Platform((width/2)+40, height-205, 80, 20));
      myPlats.add(new Platform((width/2)+200, height-205, 80, 20));
      myPlats.add(new Platform((width/2)-120, height-340, 80, 20));
      myPlats.add(new Platform((width/2)-280, height-340, 80, 20));
      myPlats.add(new Platform((width/2)+40, height-340, 80, 20));
      myPlats.add(new Platform((width/2)+200, height-340, 80, 20));
      myPlats.add(new Platform((width/2)-120, height-470, 80, 20));
      myPlats.add(new Platform((width/2)-280, height-470, 80, 20));
      myPlats.add(new Platform((width/2)+40, height-470, 80, 20));
      myPlats.add(new Platform((width/2)+200, height-470, 80, 20));
    }
    else if (thisLevel == 13) {
      myPlats.add(new Platform((width/2)-40, (height/2)-210, 150, 20));
      myPlats.add(new Platform((width/2)-110, (height/2)-110, 20, 20));
      myPlats.add(new Platform((width/2)-40, (height/2)-10, 80, 20));
      myPlats.add(new Platform((width/2)+90, (height/2)+90, 20, 20));
      myPlats.add(new Platform((width/2)-110, (height/2)+190, 150, 20));
    }
    else if (thisLevel == 14) {
      myPlats.add(new Platform((width/2)-(150/2)-40, (height/2)-250, 150+40, 20));
      myPlats.add(new Platform((width/2)-(150/2)-80, (height/2)-220, 20, 20));
      myPlats.add(new Platform((width/2)+(150/2)+20, (height/2)-150, 20, 20));
      myPlats.add(new Platform((width/2)-(150/2)+40, (height/2)-50, (150-40), 20));
      myPlats.add(new Platform((width/2)-(150/2), (height/2)+50, 20, 20));
      myPlats.add(new Platform((width/2)-(150/2)-10, (height/2)+190, 40, 40));
    }
    else if (thisLevel == 15) {
      myPlats.add(new Platform((width/2)+100, (height/2)-20, 20, 20));
      myPlats.add(new Platform((width/2)+175, (height/2)-20, 20, 20));
      myPlats.add(new Platform((width/2)+250, (height/2)-20, 20, 20));
    }
    else if (thisLevel == 16) {
      myPlats.add(new Platform((width/2)+105, (height/2)-100, 185, 20));
      myPlats.add(new Platform((width/2)+345, (height/2)-100, 20, 20));
      myPlats.add(new Platform((width/2)+270, (height/2)-175, 20, 20));
      myPlats.add(new Platform((width/2)+270, (height/2)-25, 20, 20));
    }
    else if (thisLevel == 17) {
      myPlats.add(new Platform(width-150, 50, 80, 20));
    }
  }

  void display() {

    // Here we use a for loop to iterate through all the platforms in the ArrayList. We use i to
    // identify which element we are looking at. Note that we use "size()" instead of "length,"
    // because ArrayList has different syntax than array:
    for (int i = 0; i < myPlats.size(); i++) {

      // As on the main tab, we pull an object from the ArrayList so we can do something with it:
      Platform myPlatform = myPlats.get(i); 
      if ((thisLevel < 17) || (thisLevel == 17 && gameMode == 1 && noGoBack == true 
        && finalBattle == false)) {
        // Call the drawPlatform function from the Platform tab using the specific parameters for
        // this value of i (which is a specific element in the ArrayList):
        myPlatform.drawPlatform(); 
        fill(255); 

        // Debug - print the name of the element on the Platform drawn in that element, so we can
        // easily tell which Platform is which:
        // text(i, myPlatform.xPos + (myPlatform.platWidth / 2), myPlatform.yPos + 
        // (myPlatform.platHeight / 1.5));

        textAlign(CENTER);
        textFont(font, fontsize);
        text(platCount, width-fontsize, fontsize);
        textAlign(LEFT);
      }
    }
  }
}

