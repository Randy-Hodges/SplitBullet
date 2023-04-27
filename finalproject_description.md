A project description text file, finalproject_description.txt, that summarizes the project functionalities and implementations, what the included classes do, and any unexpected challenges. This is mostly a rehash of the progress report but from the position of what you accomplished rather than what you were planning. Also you must document which group member worked on which part of the assignment. While group coding is allowed, each member is responsible for their individual parts -- this ensures all group members are participating and have mastery of the assignment. If you do not specify that a group member contributed, this will impact their grade.

-------------------------------------------
Daniel:

-------------------------------------------
Long (Game, GUI, ScoreComparator, PlayerScore, TextInputField):

In this project, we have employed Java and an assortment of libraries, like ddf.minim for audio and com.jogamp.newt.opengl for OpenGL window management, to create a game filled with perplexity and burstiness. The central class, SplitBullet's MyGame, oversees game states, keyboard and mouse inputs, game assets, and the overall gameplay logic.

MyGame manages a variety of screen states, such as LOADING, MENU_SCREEN, GAME_SCREEN, PAUSE_SCREEN, LOSE_SCREEN, LOSE_SCREEN_SAVE, SAVE_SCORE, SKIP_SCORE, VICTORY_SCREEN, HIGH_SCORE_SCREEN, and INFO_SCREEN. These screen states handle the different states of the game, ranging from asset loading to menu displays and gameplay.

Throughout gameplay, the player's actions are monitored via arrays for keys_pressed, keys_released, key_inputs, mouse_pressed, mouse_released, and mouse_inputs. Meanwhile, the game's characters, including the player and enemies, are managed through ArrayLists like actors, actor_spawns, and actor_despawns. The game assets, comprising sprites and sounds, are initialized in the AssetPool class.

There are timers (game_time and spawn_delay_timer) to handle game events, and several other variables that determine the game's behavior, such as tickrate, screen dimensions, player lives, and the current wave of enemies. The game also allows players to mute and pause the game.

Methods of class MyGame():

update()
* Updates the game based on the current screen state
* Handles user inputs, game loop, state transitions, and in-game events
* Manages audio playback for different game states

change_screen_state(int new_state)
* Changes the screen state to the new state
* Updates game_gui's screen_state

initialize_player()
* Removes the current player object from actor_despawns, if any
* Initializes a new player object and adds it to actor_spawns

reset_game()
* Clears all actors, sets the player to null, and resets lives_count and current_wave

submit_high_score(String player_name, int current_wave)
* Submits the player's high score with their name and the reached wave
* Appends the new score entry to the highscore.csv file

In the GUI class, we manage the various screen states and GUI elements of the game. To do this, we employ several screen state variables, such as MENU_SCREEN, GAME_SCREEN, and PAUSE_SCREEN, which are constants representing the different game screens. Additionally, we utilize variables for initializing the current screen state and other GUI elements.

The GUI class consists of several methods and components, such as initializing state elements and game variables. These components store images and fonts used throughout the user interface. The constructor of the GUI class is responsible for initializing the GUI variables, loading images, and setting up the font for usage. This efficient organization creates a sense of perplexity and burstiness in the game's interface, which adds depth and variety to the player's experience.

ScoreComparator, PlayerScore, and TextInputField are essential helper classes that facilitate the functionality of the game's GUI. The ScoreComparator class is responsible for comparing two PlayerScore objects, sorting them in descending order based on the player's scores. On the other hand, the PlayerScore class maintains the player's name and score through a string variable and an integer variable, respectively. This class features a constructor that initializes the name and score variables. TextInputField is another critical helper class that allows players to input text, such as their names. It consists of position, size, text, activity status, and maximum character limit variables.

Methods of class GUI():

drawBush()
* Draws a green bush at a specified location with a specified size

draw_main_menu()
* Draws the main menu screen with buttons to play, view high scores, and access help

draw_game_screen()
* Draws the game screen, including the playable area, bushes, and game UI (score, lives)

draw_lose_screen()
* Draws the lose screen with the option to return to the main menu

draw_lose_save_screen()
* Draws a screen to save the score or skip saving

draw_pause_screen()
* Draws the pause screen with options to resume, mute, or quit the game

draw_victory_screen()
* Draws the victory screen with the option to return to the main menu

draw_high_score_screen()
* Draws the high score screen, displaying the top 15 scores

draw_info_screen()
* Draws the information screen with instructions on how to play the game

handle_lose_screen_click()
* Handles clicks on the lose screen, switching to the lose save screen

handle_lose_save_click()
* Handles clicks on the lose save screen, returning appropriate action (save score, skip score, or no change)

handle_main_menu_click()
* Handles clicks on the main menu, switching to the corresponding screen

handle_high_score_click()
* Handles clicks on the high score screen, returning to the main menu if the "Go Back" button is clicked

handle_info_click()
* Handles clicks on the information screen, returning to the main menu if the "Go Back" button is clicked

handle_victory_screen_click()
* Handles clicks on the victory screen, returning to the main menu if the "Back to Menu" option is clicked

---------------------- 
Randy (Enemies): Randy worked on everything to do with the enemies in the game. This includes creating the Enemy class, all extensions of the Enemy class, choosing sprites, spawning enemies at the beginning of each wave, designing which enemies spawned during each wave, and balancing the enemies. All enemies have a hierachy of Actor->Enemy->(Enemy subclass) and each hierarchy level has appropriate functionality. This went fairly smoothly once some of the higher level code was finished/learned. Everything generally went well and worked very quickly, even the spinning sword around the orc shaman. As far as the enemy spawning code goes, there were a variety of rules put in place that determine how enemeies get spawned. I implemented different level modes and increased the difficulty of the game as the waves progress. This also went somewhat smoothly, however there was a brief period of time where I was trying to dynamically create instances of classes which I eventually determined just was not going to happen because of the limitations of the Processing language. Other than that, everything went smoothly and I accomplished everything that I set out to do.

-----------------------
Sean: Responsible for and implemented various parts of the Player, Projectile, and Powerup classes. 

The Player class is responsible for displaying the character sprite and tracking the user's stats as they play the game. It consists of 4 nested classes-- Body, Hat, Arm, and Gun-- which are responsible for rendering and animating the individual components of the player's character model. As stated earlier, Player tracks the user's game stats, including health, cooldowns, vulnerability, position, velocity, acceleration , powerup effects, rotation, and collisions. Additionally, Player ensures appropriate character reactions to collisions with enemies and powerups, allows the user to move around and fire at enemies, and simulates the effects of active powerups.          

Projectile is responsible for displaying bullets fired by the player and tracking various fields including position, velocity, acceleration, rotation, damage, remaining number of enemies that can be damaged by the bullet, and enemies that have been damaged by the bullet. This class detects collisions between bullets and enemies, removes bullets that have left the screen or collided with a sufficient number of enemies, applies drag that slows down bullets over time, and rotates bullets appropriately based on their velocity       

Finally, Powerup is an umbrella class for 5 individual powerups, including HealthPowerup, Rapidfire, Superstar, Penetration, and Speed. 
