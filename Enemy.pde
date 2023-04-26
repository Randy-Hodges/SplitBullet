class Enemy extends Actor{
    int health;
    Sprite sprite;
    // Taking damage
    boolean hurt = false;
    float hit_speed = 5;
    Timer hurt_timer = new Timer();
    int hurt_time = 300; // ms
    // Idle state occurs at begining of wave, spaces out enemies 
    Timer idle_timer = new Timer();
    int time_idle;
    boolean idle = true;
    
    Enemy(float hitbox_radius, PVector pos, PVector scale, int health, Sprite sprite) {
        super(hitbox_radius, pos, scale, 0);
        this.health = health;
        this.sprite = sprite;
    }
    
    void display() {
        if (checkInBounds()){
            imageMode(CENTER);
            hurtEffect();
            idleEffect();
            image(sprite.getFrame(), 0, 0);
            tint(255);
            // displayHitboxes();
        }
    }

    void calcCollision() {
        collisions.clear();
        
        for (Actor other : GAME.actors) {
            if (other instanceof Projectile && (pos.dist(other.pos) < hitbox_radius + other.hitbox_radius)) {
                collisions.add(other);
            }
        }
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
                if (hurt_timer.value() > hurt_time){
                    checkAlive();
                    this.hurt = false;
                }
            }
    }

    void idleEffect(){
        if (idle){
            tint(255*(time_idle - idle_timer.value())/float(time_idle));
        }
    }

    boolean checkInBounds(){
        return (pos.x > GAME.PLAYABLE_AREA_X && pos.x < GAME.PLAYABLE_AREA_X + GAME.PLAYABLE_AREA_WIDTH && 
            pos.y > GAME.PLAYABLE_AREA_Y && pos.y < GAME.PLAYABLE_AREA_Y + GAME.PLAYABLE_AREA_HEIGHT);
    }

    void displayHitboxes(){
            noFill();
            stroke(0);
            strokeWeight(3);
            rectMode(CENTER);
            rect(0, 0, hitbox_radius, hitbox_radius);
            rectMode(CORNER);
    }

    boolean checkIdle(){
        if (idle){
            if (idle_timer.value() > time_idle){
                idle = false;
            }
        }
        return idle;
    }

}

