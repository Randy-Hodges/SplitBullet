// Initialize screen state variables. GUI class will manage interactions with screen_state.
final int MENU_SCREEN = 0;
final int GAME_SCREEN = 1;
final int PAUSE_SCREEN = 2;

class GUI {
  // Initialize game variables
  int lives_count;
  int current_wave;
  int screen_state;

  GUI (int lives_count, int current_wave, int screen_state) {
    // Init GUI variables
    this.lives_count = lives_count;
    this.current_wave = current_wave;
    this.screen_state = screen_state;
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
        
      default:
        print("Fatal error: screen_state should never reach this");
        break;
    }
  }
  
  void draw_main_menu() {
    // Draw the main menu
    background(100, 150, 200);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("Main Menu", width/2, height/4);
    textSize(24);
    text("Press 'S' to Start", width/2, height/2);
  }
  
  void draw_game_screen() {
    // Draw the game screen
    background(50, 100, 150);
    // Draw game objects (player, enemies, projectiles) here
    // Draw game UI (score, lives) here
  }

  void draw_pause_screen() {
    // Draw the pause screen
    fill(0, 0, 0, 150);
    rect(0, 0, width, height);
    fill(255);
    textSize(32);
    text("Paused", width/2, height/4);
    textSize(24);
    text("Press 'P' to Resume", width/2, height/2);
  }
}
