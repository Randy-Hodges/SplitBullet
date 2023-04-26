// Note: I would normally like to do one class per file, but because we can't get a file structure going with .pde files
//       I have put all enemies in one file to reduce overall clutter in the main directory

class Orc extends Enemy{
    // static variables that are applied with super()
    final static float hitbox_radius = 10;
    final static float scalex = 2;
    final static float scaley = 2;
    final static int health = 2;
    // Other variables specific to this class
    float decision_rate = 600; // how long (in ms) it takes between changing directions
    Timer decision_timer = new Timer();
    float speed = 70; // pixels/sec

    Orc(PVector initial_pos, int wave_time){
        // projectiles hit twice, I am doubling initial health to compensate
        super(hitbox_radius, initial_pos, new PVector(scalex, scaley), health, GAME.assets.getSprite("media/sprites/enemies/orcs/orc"));
        sprite.setAnimLength(750); //ms
        time_idle = int(random(wave_time));
    }

    void simulate(){
        // Don't move under these conditions
        if (checkIdle()){return;}
        if (hurt){return;}
        // Movement / other happenings
        // Change velocity towards player in NSWE direction
        orcMove();
        super.simulate();
    }

    void orcMove(){
        // Change velocity towards player in NSWE direction
        if (decision_timer.value() > decision_rate){
            decision_timer.reset();
            // get direction of player
            PVector player_dir = GAME.player.pos.copy().sub(pos);
            // Move in cardinal direction towards player
            if (abs(player_dir.x) > abs(player_dir.y)){ 
                // x direction
                if (player_dir.x < 0){
                    next_vel.set(-1, 0).mult(speed);
                    scale.x = -scalex;
                }
                else{
                    next_vel.set(1, 0).mult(speed);
                    scale.x = scalex;
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
    }
    
}

class OrcShaman extends Enemy{
    // static variables that are applied with super()
    final static float hitbox_radius = 20;
    final static float scalex = 2;
    final static float scaley = 2;
    final static int health = 3;
    // Other variables specific to this class
    float decision_rate = 1200; // how long (in ms) it takes between changing directions
    Timer decision_timer = new Timer();
    float speed = 60; // pixels/sec
    // Other
    EnergyProjectile energy;


    OrcShaman(PVector initial_pos, int wave_time){
        // projectiles hit twice, I am doubling initial health to compensate
        super(hitbox_radius, initial_pos, new PVector(scalex, scaley), health, GAME.assets.getSprite("media/sprites/enemies/orcs/shaman"));
        sprite.setAnimLength(750); //ms
        time_idle = int(random(wave_time));
        energy = new EnergyProjectile(pos, pos, time_idle);
        GAME.actor_spawns.add(energy);
    }

    void simulate(){
        // Don't move under these conditions
        if (checkIdle()){return;}
        if (hurt){return;}
        // Movement / other happenings
        orcMove();
        super.simulate();
    }
    
    void die(){
        super.die();
        energy.die();
    }

    void orcMove(){
        // Change velocity towards player in NSWE direction
        if (decision_timer.value() > decision_rate){
            decision_timer.reset();
            // get direction of player
            PVector player_dir = GAME.player.pos.copy().sub(pos);
            // Move in cardinal direction towards player
            if (abs(player_dir.x) > abs(player_dir.y)){ 
                // x direction
                if (player_dir.x < 0){
                    next_vel.set(-1, 0).mult(speed);
                    scale.x = -scalex;
                }
                else{
                    next_vel.set(1, 0).mult(speed);
                    scale.x = scalex;
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
    // Other
    float radius = 50;
    PVector host_pos;
    float host_rot = 0;

    EnergyProjectile(PVector initial_pos, PVector host_pos, int time_idle){
        super(hitbox_radius, initial_pos.copy(), new PVector(scalex, scaley), health, GAME.assets.getSprite("media/sprites/enemies/orcs/shaman_projectile/sword"));
        energy = GAME.assets.getSprite("media/sprites/enemies/orcs/shaman_projectile/energy");
        projectile = GAME.assets.getSprite("media/sprites/enemies/orcs/shaman_projectile/sword");
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
            if (idle_timer.value() > time_idle){
                idle = false;
            }
            return;
        }
        rot += 8.0 / GAME.tickrate; 
        host_rot += 2.5 / GAME.tickrate; 
        // rotate around host
        next_pos = host_pos.copy().add((new PVector(radius, 0)).rotate(host_rot));
    }

}


class Imp extends Enemy{
    // static variables that are applied with super()
    final static float hitbox_radius = 10;
    final static float scalex = 2;
    final static float scaley = 2;
    final static int health = 1;
    // Other
    float speed = 150; // pixels/sec

    Imp(PVector initial_pos, int wave_time){
        // projectiles hit twice, I am doubling initial health to compensate
        super(hitbox_radius, initial_pos, new PVector(scalex, scaley), health, GAME.assets.getSprite("media/sprites/enemies/imps/imp"));
        sprite.setAnimLength(500); //ms
        time_idle = int(random(wave_time));
    }

    void simulate(){
        // Don't move under these conditions
        if (checkIdle()){return;}
        if (hurt){return;}
        // Movement / other happenings
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

class ImpBoss extends Enemy{
    // static variables that are applied with super()
    final static float hitbox_radius = 20;
    final static float scalex = 2;
    final static float scaley = 2;
    final static int health = 8;
    
    // Other
    float speed = 50; // pixels/sec
    Timer spawn_timer = new Timer();
    int spawn_rate = 3000; // time (ms) to spawn a new small enemy
    int spawn_radius = 50; // pixels


    ImpBoss(PVector initial_pos, int wave_time){
        // projectiles hit twice, I am doubling initial health to compensate
        super(hitbox_radius, initial_pos, new PVector(scalex, scaley), health, GAME.assets.getSprite("media/sprites/enemies/imps/impBoss"));
        sprite.setAnimLength(500); //ms
        time_idle = int(random(wave_time));
        this.hurt_time = 100;
    }

    void simulate(){
        // Don't move under these conditions
        if (checkIdle()){return;}
        if (hurt){return;}
        // Spawning
        if (spawn_timer.value() > spawn_rate){
            spawn_timer.reset();
            spawn_small_enemy();
        }
        // Movement
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
    
    void spawn_small_enemy(){
        PVector randomRadius = PVector.random2D().mult(spawn_radius);
        ImpSpawn new_enem = new ImpSpawn(pos.copy().add(randomRadius));
        GAME.actor_spawns.add(new_enem);
        GAME.alive_enemies += 1;
    }
}

class ImpSpawn extends Enemy{
    // static variables that are applied with super()
    final static float hitbox_radius = 6;
    final static float scalex = 2;
    final static float scaley = 2;
    final static int health = 1;
    // Other
    float speed = 100; // pixels/sec
    int time_invulnerable = 2000; //ms
    

    ImpSpawn(PVector initial_pos){
        // projectiles hit twice, I am doubling initial health to compensate
        super(hitbox_radius, initial_pos, new PVector(scalex, scaley), health, GAME.assets.getSprite("media/sprites/enemies/imps/impSpawn"));
        sprite.setAnimLength(500); //ms
        time_idle = int(time_invulnerable);
    }

    void simulate(){
        // Don't move under these conditions
        if (checkIdle()){return;}
        if (hurt){return;}
        // Movement / other happenings
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

class OrcBoss extends Enemy{
    // static variables that are applied with super()
    final static float hitbox_radius = 20;
    final static float scalex = 2;
    final static float scaley = 2;
    final static int health = 8;
    // Movement
    float speed = 50; // pixels/sec
    float decision_rate = 2000; // how long (in ms) it takes between changing directions
    Timer decision_timer = new Timer();
    // Other
    Timer spawn_timer = new Timer();
    int spawn_rate = 3500; // time (ms) to spawn a new small enemy
    int spawn_radius = 50; // pixels


    OrcBoss(PVector initial_pos, int wave_time){
        // projectiles hit twice, I am doubling initial health to compensate
        super(hitbox_radius, initial_pos, new PVector(scalex, scaley), health, GAME.assets.getSprite("media/sprites/enemies/orcs/orcBoss"));
        sprite.setAnimLength(500); // ms
        time_idle = int(random(wave_time));
        this.hurt_time = 100;
    }

    void simulate(){
        // Don't move under these conditions
        if (checkIdle()){return;}
        if (hurt){return;}
        // Spawning
        if (spawn_timer.value() > spawn_rate){
            spawn_timer.reset();
            spawn_small_enemy();
        }
        // Movement
        orcMove();
        super.simulate();
    }
    
    void spawn_small_enemy(){
        PVector randomRadius = PVector.random2D().mult(spawn_radius);
        OrcSpawn new_enem = new OrcSpawn(pos.copy().add(randomRadius));
        GAME.actor_spawns.add(new_enem);
        GAME.alive_enemies += 1;
    }
    
    void orcMove(){
        // Change velocity towards player in NSWE direction
        if (decision_timer.value() > decision_rate){
            decision_timer.reset();
            // get direction of player
            PVector player_dir = GAME.player.pos.copy().sub(pos);
            // Move in cardinal direction towards player
            if (abs(player_dir.x) > abs(player_dir.y)){ 
                // x direction
                if (player_dir.x < 0){
                    next_vel.set(-1, 0).mult(speed);
                    scale.x = -scalex;
                }
                else{
                    next_vel.set(1, 0).mult(speed);
                    scale.x = scalex;
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
    }
}

class OrcSpawn extends Enemy{
    // static variables that are applied with super()
    final static float hitbox_radius = 6;
    final static float scalex = 2;
    final static float scaley = 2;
    final static int health = 2;
    // Other
    int time_invulnerable = 2000; //ms
    // Movement
    float speed = 80; // pixels/sec
    float decision_rate = 400; // how long (in ms) it takes between changing directions
    Timer decision_timer = new Timer();
    

    OrcSpawn(PVector initial_pos){
        // projectiles hit twice, I am doubling initial health to compensate
        super(hitbox_radius, initial_pos, new PVector(scalex, scaley), health, GAME.assets.getSprite("media/sprites/enemies/orcs/orcSpawn"));
        sprite.setAnimLength(500); //ms
        time_idle = int(time_invulnerable);
    }

    void simulate(){
        // Don't move under these conditions
        if (checkIdle()){return;}
        if (hurt){return;}
        // Movement / other happenings
        orcMove();
        super.simulate();
    }
    
    void orcMove(){
        // Change velocity towards player in NSWE direction
        if (decision_timer.value() > decision_rate){
            decision_timer.reset();
            // get direction of player
            PVector player_dir = GAME.player.pos.copy().sub(pos);
            // Move in cardinal direction towards player
            if (abs(player_dir.x) > abs(player_dir.y)){ 
                // x direction
                if (player_dir.x < 0){
                    next_vel.set(-1, 0).mult(speed);
                    scale.x = -scalex;
                }
                else{
                    next_vel.set(1, 0).mult(speed);
                    scale.x = scalex;
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
    }
}

