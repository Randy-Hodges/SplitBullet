class Enemy extends Actor{
    int health;
    Sprite sprite;
    // Taking damage
    boolean hurt = false;
    float hit_speed = 5;
    Timer hurt_timer = new Timer();
    int hurt_time = 300; // ms
    
    Enemy(float hitbox_radius, PVector pos, PVector scale, int health, Sprite sprite) {
        super(hitbox_radius, pos, scale, 0);
        this.health = health;
        this.sprite = sprite;
    }
    
    void display() {
        if (checkInBounds()){
            imageMode(CENTER);
            hurtEffect();
            image(sprite.getFrame(), 0, 0);
            tint(255);
        }
    }

    void calcCollision() {
        collisions.clear();
        
        for (Actor other : GAME.actors) {
            if (other instanceof Projectile && (pos.dist(other.pos) < hitbox_radius + other.hitbox_radius)) {
                collisions.add(other);
            }
        }
        
        // collisionReaction(); <-- this gets called by Actor.simulate()
    }

    void collisionReaction() {
        if (!checkInBounds()){return;}
        // Change hurt to true and take damage
        for (Actor projectile : collisions) {
            hurt = true;
            this.health -= ((Projectile)projectile).caliber; // <-- We can cast the Actor as a Projectile to access its caliber field
            // move in opposite direction of projectile hit
            // next_vel = (projectile.pos.copy().sub(pos).normalize().mult(-1).mult(hit_speed));
            hurt_timer.reset();
            // GAME.actor_despawns.add(projectile); <-- The projectile despawns itself
        }
    }
    
    void checkAlive(){
        if (health <= 0){
            die();
        }
    }

    void die(){
        GAME.actor_despawns.add(this);
        GAME.alive_enemies -= 1;
    }

    void hurtEffect(){
        if (hurt) {
                tint(80);
                // might not be the right place for this, works fine though
                if (hurt_timer.getActiveTime() > hurt_time){
                    checkAlive();
                    this.hurt = false;
                }
            }
    }

    boolean checkInBounds(){
        return (pos.x > GAME.PLAYABLE_AREA_X && pos.x < GAME.PLAYABLE_AREA_X + GAME.PLAYABLE_AREA_WIDTH && 
            pos.y > GAME.PLAYABLE_AREA_Y && pos.y < GAME.PLAYABLE_AREA_Y + GAME.PLAYABLE_AREA_HEIGHT);
    }
}

