import ddf.minim.*;
import com.jogamp.newt.opengl.GLWindow;
import java.util.ArrayList;

class MyGame {

  // Screen state variables
  final int MENU_SCREEN = 0;
  final int GAME_SCREEN = 1;
  final int PAUSE_SCREEN = 2;
  final int LOSE_SCREEN = 3;
  final int LOSE_SCREEN_SAVE = 4;
  final int SAVE_SCORE = 41;
  final int SKIP_SCORE = 42;
  final int VICTORY_SCREEN = 5;
  final int HIGH_SCORE_SCREEN = 6;
  final int INFO_SCREEN = 7;
  int screen_state;

  // Play area variables
  final int PLAYABLE_AREA_X = 50;
  final int PLAYABLE_AREA_Y = 100;
  final int PLAYABLE_AREA_WIDTH = 900;
  final int PLAYABLE_AREA_HEIGHT = 800;

  // Game variables
  Timer spawn_delay_timer;
  int lives_count;
  int current_wave;
  int spawned_enemies;
  int alive_enemies = 0;
  int wave_time;

  // GUI object
  GUI game_gui;
  
  // TextInput object
  TextInputField player_name_input;

  // Window properties
  GLWindow window_properties;

  // Game simulation variables
  Timer game_time;
  int tickrate;
  
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

  MyGame(int tickrate) {
    // Set gameplay variables
    this.lives_count = 3;
    this.current_wave = 1;

    // Set screen state to MENU_SCREEN
    this.screen_state = MENU_SCREEN;

    // Initialize GUI object
    this.game_gui = new GUI();
    
    // Initialize TextInputField object
    this.player_name_input = new TextInputField(new PVector(width / 2 - 150, height / 2 - 25), new PVector(300, 50), 5);

    
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
    this.assets = new AssetPool(true, "media/sprites", "media/sounds");
    
    // Initialize timers
    this.game_time = new Timer();
    this.spawn_delay_timer = new Timer();
    this.tickrate = tickrate;
    
    // muted and pause flags
    this.muted = false;
    this.paused = false;

    // Window properties
    window_properties = (GLWindow) surface.getNative();
    print("Finished Game initialization... \n");
  }
  MyGame() {
    this(60);
  }

  void update() {
    // Update game state
    switch (screen_state) {
      case MENU_SCREEN:
        // Handle menu logic
        //print("got to MENU_SCREEN \n");

        window_properties.confinePointer(false);

        game_gui.draw_main_menu();
        
        if (mouse_pressed.contains(LEFT)) { 
          change_screen_state(game_gui.handle_main_menu_click()); 
        }
        
        // Comment this out
        if (key_inputs.contains((int) '1')) {
          change_screen_state(LOSE_SCREEN);
        }
        
        break;
        
      case GAME_SCREEN:
        // Handle game logic
        // Render, simulate, and move Actors
        //print("got to GAME_SCREEN \n");

        window_properties.confinePointer(true);
        
        // Call initialize_player() and spawn_wave() only if the player object is null. This is Wave 1.
        if (player == null) {
          //print("Initializing player and populating wave\n");
          alive_enemies = 0;
          initialize_player();
          populate_wave(current_wave);
        }
        
        // Check if player health has reached 0. Saves high score and changes to Lose screen
        if (player.health <= 0) {
          // reset_game() is inside LOSE_SCREEN_SAVE. This is to preserve the current_wave value to submit to the highscore.csv before resetting.
          change_screen_state(LOSE_SCREEN); 
        }

        // Go to new wave if needed
        if (alive_enemies == 0){
          current_wave += 1; 
          populate_wave(current_wave);
        }
        
        // simulate & move on tick; always render
        if (game_time.value() >= (1000.0 / tickrate)) {
          for (int sim = 1; sim < (game_time.value() / (1000.0 / tickrate)); sim++) {
            move();
            simulate();
          }
          game_time.reset();
        }

        game_gui.draw_game_screen();
        render();

        // Check if wave is over, then begin the next spawn_wave(current_wave)
        // Handle Pause 
        if (keys_pressed.contains( (int)'P' )) {
          game_time.pause();

          paused = true;
          change_screen_state(PAUSE_SCREEN);

          window_properties.confinePointer(false);
        }
        
        break;
        
      case PAUSE_SCREEN:
        // Handle pause logic
        // print("got to PAUSE_SCREEN \n");

        window_properties.confinePointer(false);

        game_gui.draw_pause_screen();
        
        // Handle Pause 
        if (keys_pressed.contains( (int)'P' )) {
          paused = false;
          change_screen_state(GAME_SCREEN);

          game_time.resume();
          break;
        }

        // Handle Mute
        if (keys_pressed.contains( (int)'M')) {
          muted = !muted;
        }
        
        // Handle Quit
        if (keys_pressed.contains( (int)'Q' )) {
          game_time.resume();
          change_screen_state(LOSE_SCREEN_SAVE);
        }

        break;
        
      case LOSE_SCREEN:
        window_properties.confinePointer(false);

        game_gui.draw_lose_screen();
        
        if (mouse_pressed.contains(LEFT)) { 
          change_screen_state(game_gui.handle_lose_screen_click()); 
        }

        break;

      case LOSE_SCREEN_SAVE:
        window_properties.confinePointer(false);

        game_gui.draw_lose_save_screen();
                
        // Draws text box
        player_name_input.draw();
                
        if (keys_pressed.size() > 0 && !keys_pressed.contains( (int) BACKSPACE )) {
          // Only registers the first key pressed.
          char[] keyChar = Character.toChars(keys_pressed.get(0));
          player_name_input.add_char(keyChar[0]); 
        }
        
        if (keys_pressed.contains( (int) BACKSPACE )) {
          player_name_input.remove_char();
        }
        
        if (mouse_pressed.contains(LEFT)) {
          int clicked_button = game_gui.handle_lose_save_click();
          
          // If clicked to return to submit and return to menu, save highscore info, reset game
          if (clicked_button == 41) {
             // Submits high score
             submit_high_score(player_name_input.text, current_wave);
             player_name_input.text = "";
             
             // reset_game() is here instead of in GAME_SCREEN b/c we want to save the current_wave value to the high score before resetting.
             reset_game();
             
             // Change screen back to MENU
             change_screen_state(MENU_SCREEN);
          
          // If clicked to skip submit
          } else if (clicked_button == 42) {
            player_name_input.text = "";
            reset_game();
            change_screen_state(MENU_SCREEN);
            
          // Else stay on the same screen
          } else {
            change_screen_state(clicked_button);
          }
        }
        
        break;


      case VICTORY_SCREEN:
        window_properties.confinePointer(false);
        window_properties.setPointerVisible(true);

        game_gui.draw_victory_screen();
        
        
        if (mouse_pressed.contains(LEFT)) { 
          change_screen_state(game_gui.handle_victory_screen_click()); 
        }


        break; 
     
      case HIGH_SCORE_SCREEN:
        //print("got to HIGH_SCORE_SCREEN \n");
        game_gui.draw_high_score_screen();
        
        // Go back to menu screen        
        if (mouse_pressed.contains(LEFT)) { 
          change_screen_state(game_gui.handle_high_score_click()); 
        }
      
        break;

      case INFO_SCREEN:
        game_gui.draw_info_screen();
        
        // Go back to menu screen
        if (mouse_pressed.contains(LEFT)) {
          change_screen_state(game_gui.handle_info_click()); 
        }
      
        break;
  
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
    despawn_actors();
    spawn_actors();
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

  void populate_wave(int current_wave) {
    // Handles the latest wave event after a wave is cleared.
    // Difficulty scaled based on the value of current_wave
    // Add your enemy spawning logic here
      
    // Update MyGame() field
    spawned_enemies = 0;
    final int STANDARD = 0;
    final int FAST = 1;
    final int HEAVY = 2;
    // int standard_rate = 60;
    int wave_mode = 0; // int(random(3))
    switch (wave_mode){
      case STANDARD:
        // 5 seconds of extra wave time every 3 waves, max 30 sec
        wave_time = (int(current_wave/3) + 1)*5000;
        wave_time = constrain(wave_time, 5000, 30000);
        // Spawn orcs
        int num_orcs = 4 + current_wave;
        for(int i = 0; i < num_orcs; i++){
          Orc new_orc = new Orc(get_random_spawn_point(), wave_time);
          actor_spawns.add(new_orc);
          alive_enemies += 1;
        }
        // Spawn Shamans
        int num_shamans = 1 + int(current_wave / 3);
        for(int i = 0; i < num_shamans; i++){
          OrcBoss new_orc = new OrcBoss(get_random_spawn_point(), wave_time);
          actor_spawns.add(new_orc);
          alive_enemies += 1;
        }
        // Spawn Imps
        int num_imps = 1 + int(current_wave / 3);
        for(int i = 0; i < num_imps; i++){
          ImpBoss new_enem = new ImpBoss(get_random_spawn_point(), wave_time);
          actor_spawns.add(new_enem);
          alive_enemies += 1;
        }
        break;
      default:
        println("Wave mode incorrect");
        break;
    }
    spawned_enemies = 0;
    spawn_delay_timer.reset();
  }

  void change_screen_state(int new_state) {
    // Change the screen state to the new state
    //print("Changing screen state from " + screen_state + " to " + new_state + "\n");
    game_gui.screen_state = new_state;
    this.screen_state = new_state;
  }
  
  PVector get_random_spawn_point() {
    float radius = (PLAYABLE_AREA_WIDTH/2);
    // float radius = 200;
    PVector spawn_point = new PVector(width/2, height/2).add(PVector.random2D().mult(radius*sqrt(2)));
    return spawn_point;  
  }
  
  void initialize_player() {
    actor_despawns.add(player);
    this.player = new Player(30, new PVector(width / 2, height / 2), new PVector(), new PVector(), new PVector(1, 1), 0, 3);
    actor_spawns.add(player);
  }

  void clear_all_actors() {
    actor_despawns.addAll(actors);
    despawn_actors();
  }

  void reset_game() {
    //print("resetting game...\n");
    clear_all_actors();
    player = null;
    lives_count = 3;
    current_wave = 1;
    //print(player + "\n");
  }

  void submit_high_score(String player_name, int current_wave) {
    
    if (player_name == "") {
      player_name = "PLAYR";
    }
    
    String[] lines = loadStrings("highscore.csv");
    String new_entry = player_name + "," + current_wave;
    String[] updated_lines = append(lines, new_entry);
    saveStrings("highscore.csv", updated_lines);
  }

}
