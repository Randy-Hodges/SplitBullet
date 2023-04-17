import com.jogamp.newt.opengl.GLWindow;
import java.util.ArrayList;

class MyGame {

  // Screen state variables
  final int MENU_SCREEN = 0;
  final int GAME_SCREEN = 1;
  final int PAUSE_SCREEN = 2;
  int screen_state;

  // Game variables
  int lives_count;
  int current_wave;

  // GUI object
  GUI game_gui;

  // Window properties
  GLWindow window_properties;

  // Arrays of buttons pressed on current frame only
  ArrayList<Integer> keys_pressed, mouse_pressed;

  // Arrays of buttons released on current frame only
  ArrayList<Integer> keys_released, mouse_released;

  // Arrays of buttons currently held
  ArrayList<Integer> key_inputs, mouse_inputs;

  // List of actors
  ArrayList<Actor> actors;

  // Muted and paused flags
  boolean muted, paused;

  MyGame() {
    // Set gameplay variables
    this.lives_count = 3;
    this.current_wave = 1;

    // Set screen state to MENU_SCREEN
    this.screen_state = MENU_SCREEN;

    // Initialize GUI object
    this.game_gui = new GUI(lives_count, current_wave, screen_state);

    window_properties = (GLWindow) surface.getNative();
  }

  void clearInputBuffers() {
    keys_pressed.clear();
    keys_released.clear();
    mouse_pressed.clear();
    mouse_released.clear();
  }

  void simulate() {
    for (Actor actor : actors) {
      actor.simulate();
    }
  }

  void move() {
    for (Actor actor : actors) {
      actor.move();
    }
  }

  void render() {
    for (Actor actor : actors) {
      actor.render();
    }
  }

/* See update() method
  void run() {
    render();

    if (!paused) {
      simulate();
      move();
    } else {
      // draw pause UI
    }

    clearInputBuffers();
  }
*/

  void update() {
    // Update game state
    switch (screen_state) {
      case MENU_SCREEN:
        // Handle menu logic
        break;
        
      case GAME_SCREEN:
        // Handle game logic
        // Render, simulate, and move Actors
        render();
        simulate();
        move();
        // Check if wave is over, then begin the next spawn_wave(current_wave)
        break;
      case PAUSE_SCREEN:
        // Handle pause logic
        break;
    }
      // Refresh the screen with the GUI object
      game_gui.refresh_screen();
      
      // Clear input buffers
      clearInputBuffers();
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
