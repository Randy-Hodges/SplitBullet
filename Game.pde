// Initialize screen state variables. GUI class will manage interactions with screen_state.
final int MENU_SCREEN = 0;
final int GAME_SCREEN = 1;
final int PAUSE_SCREEN = 2;

class Game {
  
  // Initialize game variables
  int lives_count;
  int current_wave;
  int screen_state;
  
  // Initialize GUI object
  GUI game_gui;

  // Initialize objects
  // ArrayList<Actor> actors; // Can query check collision for all objects in this Game class
  
  Game() {
    // Set gameplay variables
    this.lives_count = 3;
    this.current_wave = 1;
    
    // Set screen state to MENU_SCREEN
    this.screen_state = MENU_SCREEN;
    
    // Initialize GUI object
    this.game_gui = new GUI(lives_count, current_wave, screen_state);
  }

  void update() {
    // Update game state
    switch(screen_state) {
      case MENU_SCREEN:
        // Handle menu logic
        break;
      case GAME_SCREEN:
        // Handle game logic
        // Check if wave is over, then begin the next spawn_wave(current_wave)
        break;
      case PAUSE_SCREEN:
        // Handle pause logic
        break;
        
    // Refresh the screen with the GUI object
    game_gui.refresh_screen();
    }
  }
  
  void spawn_wave(int wave_num) {
    // Spawn enemies based on the current wave
    populate_wave(wave_num);
  }
  
  void populate_wave(int current_wave) {
    // Handles the latest wave event after a wave is cleared. 
    // Difficulty scaled based on the value of current_wave
    // Add your enemy spawning logic here
  }

  void change_screen_state(int new_state) {
    // Change the screen state to the new state
    this.screen_state = new_state;
  }
}