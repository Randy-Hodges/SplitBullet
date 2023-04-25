import java.io.*;

class GUI {

  // Screen state variables
  final int MENU_SCREEN = 0;
  final int GAME_SCREEN = 1;
  final int PAUSE_SCREEN = 2;
  final int LOSE_SCREEN = 3;
  final int LOSE_SCREEN_SAVE = 4;
  final int VICTORY_SCREEN = 5;
  final int HIGH_SCORE_SCREEN = 6;

  // Initialize game variables
  int screen_state;
  
  // Initilize state elements
  PImage menu_image;
  PImage victory_image;
  PImage lose_image;
  
  
  // Initialize font
  PFont customFont;
  float fontSize;
  float textDescent;
  

  GUI () {    
    // Init GUI variables
    //this.lives_count = lives_count;
    //this.current_wave = current_wave;
    
    // Set state elements
    this.menu_image = loadImage("media/gui/Menu_Screen.png");
    this.victory_image = loadImage("media/gui/Victory_Screen.png");
    this.lose_image = loadImage("media/gui/Game_Over.png");
    this.screen_state = MENU_SCREEN;

    // Load the custom font from the "data" folder and set the size to 32
    this.fontSize = 32;
    this.customFont = createFont("media/fonts/goudy_bookletter/GoudyBookletter1911.otf", 32);
    textFont(customFont);
    this.textDescent = 13.0;  // Processing 3 gives different textDescent() values than Processing 4
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
    imageMode(CORNER);
    image(menu_image, 0, 0, width, height);
    textAlign(CENTER, CENTER);
    textSize(40);
    fill(255);
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
    imageMode(CORNER);
    background(26);
        
    // Draw game UI (score, lives) here
    fill(255);
    textSize(24);
    text("Lives: " + str(GAME.player.health), 50, 25);
    text("Current Wave: " + str(GAME.current_wave), 300, 25);
    
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
    pushMatrix();
    imageMode(CORNER);
    image(lose_image, 0, 0, width, height);
    fill(255);
    textSize(40);
    text("It's all over...", width/4, height/2 - 80);
    text("Back to Menu", width/2, height - height/4);
    popMatrix();
    //pushMatrix();
    //fill(0, 255, 0, 100); // Set fill color to green with some transparency
    //rect(width/2 - (textWidth("Back to Menu") / 2), height - height/4 - 10, textWidth("Back to Menu"), 2*textDescent() + 10); // Draw a rectangle around the "Back to Menu" text
    //popMatrix();

  }
  
  void draw_lose_save_screen() {
    pushMatrix();
    imageMode(CORNER);
    background(26);
    fill(255);
    textSize(32);
    text("Submit", width / 2 - 100, height / 2 + 100);
    popMatrix();
  }

  void draw_pause_screen() {
    // Draw the pause screen
    pushMatrix();
    imageMode(CORNER);
    fill(0, 0, 0, 150);
    rect(0, 0, width, height);
    fill(255);
    textSize(32);
    text("Paused", width/2, height/4);
    textSize(24);
    text("Press 'P' to Resume", width/2, height/2);
    text("Press 'M' to Mute", width/2, height/2 + 50);
    text("Press 'Q' to Quit", width/2, height/2 + 100);
    popMatrix();
  }
  
  void draw_victory_screen() {
     pushMatrix();
     imageMode(CORNER);
     image(victory_image, 0, 0, width, height); 
     fill(255);
     textSize(40);
     text("You won...", width/2, height/5);
     text("Back to Menu", width/2, height - height/4);
     popMatrix();
  }
  
  void draw_high_score_screen() {
    pushMatrix();
    imageMode(CORNER);
    background(26);
  
    // Check if the highscore.csv file exists, if not, create it
    File highscore_file = new File(savePath("highscore.csv"));
  
    if (!highscore_file.exists()) {
      // Create new file
      try {
        highscore_file.createNewFile();
  
        // Lest some unexpected error occurs, e.g., not enough disk space
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  
    // Load high score data from the CSV file
    String[] lines = loadStrings("highscore.csv");
  
    // Parse CSV lines into an ArrayList of PlayerScore objects
    ArrayList<PlayerScore> scores = new ArrayList<PlayerScore>();
    for (String line : lines) {
      String[] columns = split(line, ',');
      if (columns.length >= 2) {
        String name = columns[0].trim();
        int score = int(columns[1].trim());
        scores.add(new PlayerScore(name, score));
      }
    }
  
    // Sort the ArrayList by score in descending order
    // scores.sort((a, b) -> b.score - a.score);
  
    textAlign(LEFT, CENTER);
    textSize(24);
    fill(255);
  
    // Display Back button
    text("Go Back", 50, 50);
  
    // Display column headers
    text("Name", width / 4, height / 4);
    text("Rounds Survived:", width / 2, height / 4);
  
    // Loop through the sorted ArrayList and display the top 10 names and scores
    int num_scores_to_display = min(15, scores.size());
    for (int i = 0; i < num_scores_to_display; i++) {
      PlayerScore playerScore = scores.get(i);
      float y = height / 4 + 30 * (i + 1); // Calculate the y position for the current line
      text(playerScore.name, width / 4, y);
      text(str(playerScore.score), width / 2, y);
    }
  
    popMatrix();
  }

  int handle_lose_screen_click() {
    // Check if click is within "Back to Menu" area
      if (mouseX > width/2 - (textWidth("Back to Menu") / 2) && mouseX < width/2 + (textWidth("Back to Menu") / 2) && mouseY > (height - height/4) - 10 && mouseY < (height - height/4) + 2*textDescent) {
      // Switch to lose save screen
      screen_state = LOSE_SCREEN_SAVE;
      return LOSE_SCREEN_SAVE;
    }
    
    return screen_state;
  }

  int handle_lose_save_click() {
    // Check if click is within "Submit" : width / 2 - 100, height / 2 + 100
    if (mouseX > (width / 2 - 100) && mouseX < (width / 2 - 100) + textWidth("Submit") && mouseY > (height / 2 + 100) - textDescent && mouseY < (height / 2 + 100) + 2*textDescent) {
      // Switch to main menu
      screen_state = MENU_SCREEN;
      return MENU_SCREEN;
    }
    
    return screen_state;
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
    if (mouseX > 50 && mouseX < 50 + textWidth("Go Back") && mouseY > 50 - textAscent() && mouseY < 50 + 2*textDescent) {
      // Switch to the main menu screen
      screen_state = MENU_SCREEN;
      return MENU_SCREEN;
    }
    
    return screen_state;
  }
  
  int handle_victory_screen_click() {
    // Check if click is within "Back to Menu" area
    if (mouseX > width/2 && mouseX < 50 + textWidth("Back to Menu") && mouseY > (height - height/4) && mouseY < (height - height/4) + 2*textDescent) {
      // Switch to main menu screen
      screen_state = MENU_SCREEN;
      return MENU_SCREEN;
    }
    
    return screen_state;
  }

}


// Class to sort top 10 highscores by descending values in HIGH_SCORE_SCREEN
class PlayerScore {
  String name;
  int score;

  PlayerScore(String name, int score) {
    this.name = name;
    this.score = score;
  }
}
