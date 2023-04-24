// Note: I would normally like to do one class per file, but because we can't get a file structure going with .pde files
//       I have put all enemies in one file to reduce overall clutter in the main directory

class Orc extends Enemy{
    // static variables that are applied with super()
    final static float orc_hitbox_radius = 10;
    final static float orc_scalex = 2;
    final static float orc_scaley = 2;
    // Other variables specific to this class
    float decision_rate = 750; // how long (in ms) it takes between changing directions
    float speed = 50; // pixels/sec
    Timer decision_timer = new Timer();
    // Idle state occurs at begining of wave, spaces out enemies 
    Timer idle_timer = new Timer();
    float time_idle;
    boolean idle = true;

    
    // Orc(PVector initial_pos, int health){
    //     // super(orc_hitbox_radius, initial_pos, new PVector(orc_scalex, orc_scaley), health, orc_total_frames, orc_frame_rate);
    //     // this.hitbox_radius = hitbox_radius;
    // }

    Orc(PVector initial_pos, int wave_time){
        // projectiles hit twice, I am doubling initial health to compensate
        super(orc_hitbox_radius, initial_pos, new PVector(orc_scalex, orc_scaley), 2*2, GAME.assets.getSprite("media/sprites/enemies/orc"));
        sprite.anim_length = 750; //ms
        time_idle = int(random(wave_time));
    }

    void simulate(){
        if (idle){
            if (idle_timer.getActiveTime() > time_idle){
                idle = false;
                // println("changing from idle");
            }
            return;
        }
        // next_vel = GAME.player.pos.copy().sub(pos).normalize().mult(speed);
        if (decision_timer.getActiveTime() > decision_rate && !this.hurt && !this.idle){
            decision_timer.reset();
            // get direction of player
            PVector player_dir = GAME.player.pos.copy().sub(pos);
            // Move in cardinal direction towards player
            if (abs(player_dir.x) > abs(player_dir.y)){ 
                // x direction
                if (player_dir.x < 0){
                    next_vel.set(-1, 0).mult(speed);
                    scale.x = -orc_scalex;
                }
                else{
                    next_vel.set(1, 0).mult(speed);
                    scale.x = orc_scalex;
                }
            }
            else { 
                // y direction
                if (player_dir.y < 0){
                    next_vel.set(0, -1).mult(speed);
                }
                else{
                    next_vel.set(0, 1).mult(speed);
                }
            }
        }
        super.simulate();
    }
    // GAME.player.pos
    /* */
}

// class Ogre extends Enemy{
//     final static float ogre_hitbox_radius = 10;
//     final static float ogre_scalex = 2;
//     final static float ogre_scaley = 2;
//     final static int ogre_total_frames =  4;
//     final static int ogre_frame_rate = 6; // frames shown / sec
//     float decision_rate = 1; // how long (in sec) it takes between changing directions
//     int decision_frames = int(target_frame_rate/decision_rate);
    
//     Ogre(PVector initial_pos, int health){
//         super(ogre_hitbox_radius, initial_pos, new PVector(ogre_scalex, ogre_scaley), health, ogre_total_frames, ogre_frame_rate);
//     }

//     Ogre(PVector initial_pos){
//         super(ogre_hitbox_radius, initial_pos, new PVector(ogre_scalex, ogre_scaley), 1, ogre_total_frames, ogre_frame_rate);
//     }

//     Ogre(float x, float y){
//         super(ogre_hitbox_radius, new PVector(x, y), new PVector(ogre_scalex, ogre_scaley), 1, ogre_total_frames, ogre_frame_rate);
//     }

//     void loadSprites(){
//         // puts all frames for a character in the (Enemy attr) frames obj
//         frames = new PImage[ogre_total_frames];
//         for (int i = 0; i < ogre_total_frames; i++) {
//             String image_name = "media/sprites/enemies/orc_shaman/orc_shaman_run_anim_f" + nf(i, 1) + ".png";
//             frames[i] = loadImage(image_name);
//         }
//     }
// }