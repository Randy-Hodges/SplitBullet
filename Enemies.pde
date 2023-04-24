// Note: I would normally like to do one class per file, but because we can't get a file structure going with .pde files
//       I have put all enemies in one file to reduce overall clutter in the main directory

class Orc extends Enemy{
    // static variables that are applied with super()
    final static float orc_hitbox_radius = 10;
    final static float orc_scalex = 2;
    final static float orc_scaley = 2;
    final static int health = 2;
    // Other variables specific to this class
    float decision_rate = 600; // how long (in ms) it takes between changing directions
    Timer decision_timer = new Timer();
    float speed = 60; // pixels/sec
    // Idle state occurs at begining of wave, spaces out enemies 
    Timer idle_timer = new Timer();
    int time_idle;
    boolean idle = true;

    Orc(PVector initial_pos, int wave_time){
        // projectiles hit twice, I am doubling initial health to compensate
        super(orc_hitbox_radius, initial_pos, new PVector(orc_scalex, orc_scaley), health, GAME.assets.getSprite("media/sprites/enemies/orc"));
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
        if (hurt){
            return;
        }
        // next_vel = GAME.player.pos.copy().sub(pos).normalize().mult(speed);
        // Change velocity towards player in NSWE direction
        if (decision_timer.getActiveTime() > decision_rate){
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
    /* */
}

class OrcShaman extends Enemy{
    // static variables that are applied with super()
    final static float orc_hitbox_radius = 10;
    final static float orc_scalex = 2;
    final static float orc_scaley = 2;
    final static int health = 2;
    // Other variables specific to this class
    float decision_rate = 750; // how long (in ms) it takes between changing directions
    Timer decision_timer = new Timer();
    float speed = 40; // pixels/sec
    // Idle state occurs at begining of wave, spaces out enemies 
    Timer idle_timer = new Timer();
    int time_idle;
    boolean idle = true;
    // Other
    EnergyProjectile energy;


    OrcShaman(PVector initial_pos, int wave_time){
        // projectiles hit twice, I am doubling initial health to compensate
        super(orc_hitbox_radius, initial_pos, new PVector(orc_scalex, orc_scaley), health, GAME.assets.getSprite("media/sprites/enemies/orc_shaman"));
        sprite.anim_length = 750; //ms
        time_idle = int(random(wave_time));
        energy = new EnergyProjectile(pos, pos, time_idle);
        GAME.actor_spawns.add(energy);
    }

    void simulate(){
        if (idle){
            if (idle_timer.getActiveTime() > time_idle){
                idle = false;
                // println("changing from idle");
            }
            return;
        }
        if (hurt){
            return;
        }
        // Change velocity towards player in NSWE direction
        if (decision_timer.getActiveTime() > decision_rate){
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
    
    void die(){
        super.die();
        energy.die();
    }
}

class EnergyProjectile extends Enemy{
    Sprite energy;
    Sprite projectile;
    // static variables that are applied with super()
    final static float hitbox_radius = 10;
    final static float scalex = 1.5;
    final static float scaley = 1.5;
    final static int health = 1;
    // Idle state occurs at begining of wave, spaces out enemies 
    Timer idle_timer = new Timer();
    int time_idle;
    boolean idle = true;
    // Other
    float radius = 40;
    PVector host_pos;
    float host_rot = 0;

    EnergyProjectile(PVector initial_pos, PVector host_pos, int time_idle){
        super(hitbox_radius, initial_pos.copy(), new PVector(scalex, scaley), health, GAME.assets.getSprite("media/sprites/enemies/orc_shaman_projectile/sword"));
        energy = GAME.assets.getSprite("media/sprites/enemies/orc_shaman_projectile/energy");
        projectile = GAME.assets.getSprite("media/sprites/enemies/orc_shaman_projectile/sword");
        this.host_pos = host_pos;
        this.time_idle = time_idle;
    }
    

    void collisionReaction() {
        if (!checkInBounds()){return;}
        // only remove projectile
        for (Actor projectile : collisions) {
            GAME.actor_despawns.add(projectile);
        }
    }

    void die(){
        GAME.actor_despawns.add(this);
    }

    void simulate(){
        if (idle){
            if (idle_timer.getActiveTime() > time_idle){
                idle = false;
            }
            return;
        }
        rot += .05; // need to convert to a ticking thing
        host_rot += .02; // need to convert to a ticking thing
        next_pos = host_pos.copy().add((new PVector(radius, 0)).rotate(host_rot));
    }

}


class Imp extends Enemy{
    // static variables that are applied with super()
    final static float hitbox_radius = 10;
    final static float scalex = 2;
    final static float scaley = 2;
    final static int health = 1;
    // Idle state occurs at begining of wave, spaces out enemies 
    Timer idle_timer = new Timer();
    int time_idle;
    boolean idle = true;
    // Other
    float speed = 120; // pixels/sec

    Imp(PVector initial_pos, int wave_time){
        // projectiles hit twice, I am doubling initial health to compensate
        super(hitbox_radius, initial_pos, new PVector(scalex, scaley), health, GAME.assets.getSprite("media/sprites/enemies/imp"));
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
        if (hurt){
            return;
        }
        // Change velocity towards player
        next_vel = GAME.player.pos.copy().sub(pos).normalize().mult(speed);
        // Change sprite direction appropriately
        if (next_vel.x < 0){
            scale.x = -scalex;
        }
        else{
            scale.x = scalex;
        }
        super.simulate();
    }
    /* */
}

