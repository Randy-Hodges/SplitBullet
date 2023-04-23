import com.jogamp.newt.opengl.GLWindow;
import java.util.ArrayList;

class MyGame {

  // Screen state variables
  final int MENU_SCREEN = 0;
  final int GAME_SCREEN = 1;
  final int PAUSE_SCREEN = 2;
  final int LOSE_SCREEN = 3;
  final int VICTORY_SCREEN = 4;
  final int HIGH_SCORE_SCREEN = 5;
  int screen_state;

  // Play area variables
  final int PLAYABLE_AREA_X = 50;
  final int PLAYABLE_AREA_Y = 100;
  final int PLAYABLE_AREA_WIDTH = 900;
  final int PLAYABLE_AREA_HEIGHT = 800;

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
  ArrayList<Actor> actors, actor_spawns, actor_despawns;

  // Game assets
  AssetPool assets;

  // Muted and paused flags
  boolean muted, paused;
  
  // Player object
  Player player;

  MyGame() {    
    // Set gameplay variables
    this.lives_count = 3;
    this.current_wave = 1;

    // Set screen state to MENU_SCREEN
    this.screen_state = MENU_SCREEN;

    // Initialize GUI object
    this.game_gui = new GUI(lives_count, current_wave);
    
    // Initialize the user inputted key and mouse array lists
    this.keys_pressed = new ArrayList<Integer>();
    this.keys_released = new ArrayList<Integer>();
    this.key_inputs = new ArrayList<Integer>();
    
    this.mouse_pressed = new ArrayList<Integer>();
    this.mouse_released = new ArrayList<Integer>();
    this.mouse_inputs = new ArrayList<Integer>();
    
    this.actors = new ArrayList<Actor>();
    this.actor_spawns = new ArrayList<Actor>();
    this.actor_despawns = new ArrayList<Actor>();

    // Initialize AssetPool
    this.assets = new AssetPool(true, "media/sprites");
    
    // Initialize Player
    //this.player = new Player(20, new PVector(width / 2, height / 2), new PVector(), new PVector(), new PVector(1, 1), 0, 3);


    window_properties = (GLWindow) surface.getNative();
    print("Finished Game initialization... \n");
  }


  void update() {
    // Update game state
    switch (screen_state) {
      case MENU_SCREEN:
        // Handle menu logic
        //print("got to MENU_SCREEN \n");

        window_properties.confinePointer(false);
        window_properties.setPointerVisible(true);

        game_gui.draw_main_menu();
        
        if (mouse_inputs.contains(LEFT)) { 
          change_screen_state(game_gui.handle_main_menu_click()); 
        }
        break;
        
      case GAME_SCREEN:
        // Handle game logic
        // Render, simulate, and move Actors
        //print("got to GAME_SCREEN \n");
        window_properties.confinePointer(true);
        window_properties.setPointerVisible(false);
        window_properties.warpPointer(width / 2, height / 2);

        game_gui.draw_game_screen();
        
        // Call initialize_player() and spawn_wave() only if the player object is null
        if (player == null) {
          initialize_player();
          spawn_wave(current_wave);
        }
  
        
        render();
        simulate();
        move();
        // Check if wave is over, then begin the next spawn_wave(current_wave)
        
        // Handle Pause 
        if (key_inputs.contains(int("P"))) {
          change_screen_state(PAUSE_SCREEN);    
        }
          


        break;
        
      case PAUSE_SCREEN:
        // Handle pause logic
        // print("got to PAUSE_SCREEN \n");

        window_properties.confinePointer(false);
        window_properties.setPointerVisible(true);

        game_gui.draw_pause_screen();
        
        
        // Handle Pause 
        if (key_inputs.contains(int("P"))) {
          change_screen_state(GAME_SCREEN);    
        }

        break;
        
      case LOSE_SCREEN:
        window_properties.confinePointer(false);
        window_properties.setPointerVisible(true);

        game_gui.draw_lose_screen();
        
        // Comment this out 
        if (key_inputs.contains((int) '1')) {
          change_screen_state(LOSE_SCREEN);
        } else if (key_inputs.contains((int) '2')) {
          change_screen_state(VICTORY_SCREEN);
        } else if (key_inputs.contains((int) '3')) {
          change_screen_state(PAUSE_SCREEN);    
        }

        break;
        
      case VICTORY_SCREEN:
        window_properties.confinePointer(false);
        window_properties.setPointerVisible(true);

        game_gui.draw_victory_screen();
        
        // Comment this out 
        if (key_inputs.contains((int) '1')) {
          change_screen_state(LOSE_SCREEN);
        } else if (key_inputs.contains((int) '2')) {
          change_screen_state(VICTORY_SCREEN);
        } else if (key_inputs.contains((int) '3')) {
          change_screen_state(PAUSE_SCREEN);    
        }

        break; 
     
      case HIGH_SCORE_SCREEN:
        //print("got to HIGH_SCORE_SCREEN \n");
        game_gui.draw_high_score_screen();
        
        // Go back to menu screen        
        if (mouse_inputs.contains(LEFT)) { 
          change_screen_state(game_gui.handle_high_score_click()); 
        }

    }
      // Clear input buffers
      clearInputBuffers();
      //print("end of update()");
  }
  
  void clearInputBuffers() {
    keys_pressed.clear();
    keys_released.clear();
    mouse_pressed.clear();
    mouse_released.clear();
  }

  void spawn_actors() {
    actors.addAll(actor_spawns);
    actor_spawns.clear();
  }

  void despawn_actors() {
    actors.removeAll(actor_despawns);
    actor_despawns.clear();
  }

  void update_actors() {
    spawn_actors();
    despawn_actors();
  }

  void simulate() {
    for (Actor actor : actors) {
      actor.simulate();
    }
    
    update_actors();
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


  void spawn_wave(int wave_num) {
    // Spawn player
    //actor_spawns.add(player);
  
    // Spawn enemies based on the current wave
    populate_wave(wave_num);
  }

  void populate_wave(int current_wave) {
    // Handles the latest wave event after a wave is cleared.
    // Difficulty scaled based on the value of current_wave
    // Add your enemy spawning logic here
    
    int num_orcs = 5 + current_wave;
    int num_ogres = int(current_wave / 3);
  
    // Spawn Orcs
    for (int i = 0; i < num_orcs; i++) {
      PVector random_pos = get_random_spawn_point();
      Orc new_orc = new Orc(random_pos);
      new_orc.loadSprites();
      actor_spawns.add(new_orc);
    }
  
    // Spawn Ogres
    for (int i = 0; i < num_ogres; i++) {
      PVector random_pos = get_random_spawn_point();
      Ogre new_ogre = new Ogre(random_pos);
      new_ogre.loadSprites();
      actor_spawns.add(new_ogre);
    }


  }

  void change_screen_state(int new_state) {
    // Change the screen state to the new state
    this.screen_state = new_state;
  }
  
  PVector get_random_spawn_point() {
    int edge = int(random(4));
    PVector spawn_point;
    
    switch (edge) {
      case 0: // Top edge
        spawn_point = new PVector(( PLAYABLE_AREA_X + PLAYABLE_AREA_WIDTH) / 2, PLAYABLE_AREA_Y );
        break;
      case 1: // Right edge
        spawn_point = new PVector(PLAYABLE_AREA_X + PLAYABLE_AREA_WIDTH, (PLAYABLE_AREA_Y + PLAYABLE_AREA_HEIGHT) / 2 );
        break;
      case 2: // Bottom edge
        spawn_point = new PVector(( PLAYABLE_AREA_X + PLAYABLE_AREA_WIDTH) / 2, PLAYABLE_AREA_Y + PLAYABLE_AREA_HEIGHT);
        break;
      default: // Left edge
        spawn_point = new PVector(PLAYABLE_AREA_X, (PLAYABLE_AREA_Y + PLAYABLE_AREA_HEIGHT) / 2);
        break;
    }
  
    return spawn_point;
  }
  
  void initialize_player() {
    this.player = new Player(20, new PVector(width / 2, height / 2), new PVector(), new PVector(), new PVector(1, 1), 0, 3);
  }

}
