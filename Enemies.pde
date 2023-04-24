// Note: I would normally like to do one class per file, but because we can't get a file structure going with .pde files
//       I have put all enemies in one file to reduce overall clutter in the main directory

class Orc extends Enemy{
    // static variables that are applied with super()
    final static float orc_hitbox_radius = 10;
    final static float orc_scalex = 2;
    final static float orc_scaley = 2;
    final static int orc_total_frames =  4;
    final static int orc_frame_rate = 8; // frames shown / sec
    // Other variables specific to this class
    float decision_rate = 1.5; // how long (in sec) it takes between changing directions
    int decision_frames = int(target_frame_rate*decision_rate);
    float speed = 2;

    
    Orc(PVector initial_pos, int health){
        super(orc_hitbox_radius, initial_pos, new PVector(orc_scalex, orc_scaley), health, orc_total_frames, orc_frame_rate);
    }

    Orc(PVector initial_pos){
        super(orc_hitbox_radius, initial_pos, new PVector(orc_scalex, orc_scaley), 1, orc_total_frames, orc_frame_rate);
    }

    Orc(float x, float y){
        super(orc_hitbox_radius, new PVector(x, y), new PVector(orc_scalex, orc_scaley), 1, orc_total_frames, orc_frame_rate);
    }

    void loadSprites(){
        // puts all frames for a character in the (Enemy attr) frames obj
        frames = new PImage[orc_total_frames];
        for (int i = 0; i < orc_total_frames; i++) {
            String image_name = "media/sprites/enemies/orc/orc_warrior_run_anim_f" + nf(i, 1) + ".png";
            frames[i] = loadImage(image_name);
        }
    }

    void move(){
        pos.add(vel);
        // change direction every decision_frames
        if (frameCount % decision_frames == 0){
            // get direction of player
            PVector player_dir = player_pos.copy().sub(pos);
            // Move in cardinal direction towards player
            if (abs(player_dir.x) > abs(player_dir.y)){ 
                // x direction
                if (player_dir.x < 0){
                    vel.set(-1, 0).mult(speed);
                    scale.x = -orc_scalex;
                }
                else{
                    vel.set(1, 0).mult(speed);
                    scale.x = orc_scalex;
                }
            }
            else { 
                // y direction
                if (player_dir.y < 0){
                    vel.set(0, -1).mult(speed);
                }
                else{
                    vel.set(0, 1).mult(speed);
                }
            }
        }
    }

}

class Ogre extends Enemy{
    final static float ogre_hitbox_radius = 10;
    final static float ogre_scalex = 2;
    final static float ogre_scaley = 2;
    final static int ogre_total_frames =  4;
    final static int ogre_frame_rate = 6; // frames shown / sec
    float decision_rate = 1; // how long (in sec) it takes between changing directions
    int decision_frames = int(target_frame_rate/decision_rate);
    
    Ogre(PVector initial_pos, int health){
        super(ogre_hitbox_radius, initial_pos, new PVector(ogre_scalex, ogre_scaley), health, ogre_total_frames, ogre_frame_rate);
    }

    Ogre(PVector initial_pos){
        super(ogre_hitbox_radius, initial_pos, new PVector(ogre_scalex, ogre_scaley), 1, ogre_total_frames, ogre_frame_rate);
    }

    Ogre(float x, float y){
        super(ogre_hitbox_radius, new PVector(x, y), new PVector(ogre_scalex, ogre_scaley), 1, ogre_total_frames, ogre_frame_rate);
    }

    void loadSprites(){
        // puts all frames for a character in the (Enemy attr) frames obj
        frames = new PImage[ogre_total_frames];
        for (int i = 0; i < ogre_total_frames; i++) {
            String image_name = "media/sprites/enemies/ogre/orc_shaman_run_anim_f" + nf(i, 1) + ".png";
            frames[i] = loadImage(image_name);
        }
    }
}
