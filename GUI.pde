import java.io.*;

class GUI {

  // Screen state variables
  final int MENU_SCREEN = 0;
  final int GAME_SCREEN = 1;
  final int PAUSE_SCREEN = 2;
  final int LOSE_SCREEN = 3;
  final int VICTORY_SCREEN = 4;
  final int HIGH_SCORE_SCREEN = 5;

  // Initialize game variables
  int lives_count;
  int current_wave;
  int screen_state;
  
  // Initilize state elements
  PImage menu_image;
  PImage victory_image;
  PImage lose_image;
  
  
  // Initialize font
  PFont customFont;

  GUI (int lives_count, int current_wave) {    
    // Init GUI variables
    this.lives_count = lives_count;
    this.current_wave = current_wave;
    
    // Set state elements
    this.menu_image = loadImage("media/gui/Menu_Screen.png");
    this.victory_image = loadImage("media/gui/Victory_Screen.png");
    this.lose_image = loadImage("media/gui/Game_Over.png");
    this.screen_state = MENU_SCREEN;

    // Load the custom font from the "data" folder and set the size to 32
    this.customFont = createFont("media/fonts/goudy_bookletter/GoudyBookletter1911.otf", 32);
    textFont(customFont);
  }
  
  void refresh_screen() {
  /* Draws the GUI to the screen */
    
    switch (screen_state) {
      case MENU_SCREEN:
        // draw main menu
        draw_main_menu();
        break;
        
      case GAME_SCREEN:
        // draw game
        draw_game_screen();
        break;
       
      case PAUSE_SCREEN:
        // pause screen
        draw_pause_screen();
        break;
        
    }
  }
  
  void drawBush(float x, float y, float size) {
    color bushColor = color(0, 128, 0); // Define a green color for the bush
    fill(bushColor);
    noStroke();
    ellipse(x, y, size, size);
  }

  void draw_main_menu() {
    // Draw the main menu
    pushMatrix();
    image(menu_image, 0, 0, width, height);
    textAlign(CENTER, CENTER);
    textSize(40);
    text("Play", width/2, height/2 + 270); // Draw "Play" button
    text("High Score", width/2, height/2 + 320); // Draw "High Score" button
    
    // Draw clickable area rectangles
    //stroke(255, 0, 0); // Set the stroke color to red for visibility
    //noFill(); // Make the rectangle transparent
    //rect(width/2 - 50, height/2 + 250, 100, 40); // "Play" button clickable area
    //rect(width/2 - 100, height/2 + 300, 200, 40); // "High Score" button clickable area

    popMatrix();
  }
  
  void draw_game_screen() {
    // Draw the black background screen
    pushMatrix();
    background(26);
        
    // Draw game UI (score, lives) here
    fill(255);
    textSize(24);
    text("Lives:", 50, 25);
    text("Current Wave:", 300, 25);
    
    // Draw playable area
    color sandColor = color(194, 178, 128); // Define a sandy color
    fill(sandColor);
    float playableAreaX = 50;
    float playableAreaY = 100;
    float playableAreaWidth = 900;
    float playableAreaHeight = 800;
    rect(playableAreaX, playableAreaY, playableAreaWidth, playableAreaHeight);

    // Draw bushes on the edges of the playable area
    float bushSize = 49;
    int numOfBushes = 20;
  
    // Draw bushes along the top edge
    for (int i = 0; i < numOfBushes; i++) {
      drawBush(playableAreaX + i * (playableAreaWidth / numOfBushes), playableAreaY, bushSize);
    }
  
    // Draw bushes along the bottom edge
    for (int i = 0; i < numOfBushes + 1; i++) {
      drawBush(playableAreaX + i * (playableAreaWidth / numOfBushes), playableAreaY + playableAreaHeight, bushSize);
    }
  
    // Draw bushes along the left edge
    for (int i = 0; i < numOfBushes; i++) {
      drawBush(playableAreaX, playableAreaY + i * (playableAreaHeight / numOfBushes), bushSize);
    }
  
    // Draw bushes along the right edge
    for (int i = 0; i < numOfBushes; i++) {
      drawBush(playableAreaX + playableAreaWidth, playableAreaY + i * (playableAreaHeight / numOfBushes), bushSize);
    }
  
    popMatrix();
  }

  void draw_lose_screen() {
    image(lose_image, 0, 0, width, height);
  }

  void draw_pause_screen() {
    // Draw the pause screen
    pushMatrix();
    fill(0, 0, 0, 150);
    rect(0, 0, width, height);
    fill(255);
    textSize(32);
    text("Paused", width/2, height/4);
    textSize(24);
    text("Press 'P' to Resume", width/2, height/2);
    popMatrix();
  }
  
  void draw_victory_screen() {
     image(victory_image, 0, 0, width, height); 
  }
  
void draw_high_score_screen() {
    background(26);
    
    // Load high score data from the CSV file
    String[] lines = loadStrings("highscore.csv");
    
    textAlign(LEFT, CENTER);
    textSize(24);
    
    
    // Display Back button
    text("Go Back", 50, 50);
    
    // Display column headers
    text("Name", width/4, height/4);
    text("Rounds Survived:", width/2, height/4);
    
    // Loop through the CSV lines and display the names and scores
    for (int i = 0; i < lines.length; i++) {
      String[] columns = split(lines[i], ',');
      String name = columns[0].trim();
      String roundsSurvived = columns[1].trim();
    
      // Cap the name at 5 letters
      if (name.length() > 5) {
        name = name.substring(0, 5);
      }
    
      float y = height/4 + 30 * (i + 1); // Calculate the y position for the current line
      text(name, width/4, y);
      text(roundsSurvived, width/2, y);
    }
  }

  int handle_main_menu_click() {
    // Check if the click is within the "Play" button's area
    if (mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 250 && mouseY < height/2 + 290) {
       // Switch to the game screen
       screen_state = GAME_SCREEN;
       return GAME_SCREEN;
    }
    // Check if the click is within the "High Score" button's area
    else if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && mouseY > height/2 + 300 && mouseY < height/2 + 340) {
       // Display the high score screen
       // I'll need to create a new method to handle the high score screen
       screen_state = HIGH_SCORE_SCREEN;
       return HIGH_SCORE_SCREEN;
    }
    
    return screen_state;
  }
  
  int handle_high_score_click() {
    // Check if the click is within the "Go Back" button's area
    if (mouseX > 50 && mouseX < 50 + textWidth("Go Back") && mouseY > 50 - textAscent() && mouseY < 50 + textDescent()) {
      // Switch to the main menu screen
      screen_state = MENU_SCREEN;
      return MENU_SCREEN;
    }
    
    return screen_state;
  }
}
