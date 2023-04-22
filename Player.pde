class Player extends Actor {
    class Hat {
        Sprite sprite;
        PVector pos, scale;
        float rot;

        Hat(Sprite sprite, PVector pos, PVector scale, float rot) {
            this.sprite = sprite;
            this.pos = pos;
            this.scale = scale;
            this.rot = rot;
        }
        Hat(PVector pos, PVector scale) {
            this(GAME.assets.getSprite("media/sprites/player/hat_frames"), pos, scale, 0);
        }

        void render() {
            pushMatrix();

            translate(pos.x, pos.y);
            scale(scale.x, scale.y);
            rotate(rot);

            image(sprite.getFrame(), 0, 0);

            popMatrix();
        }
    }
    class Body {
        Sprite idle, run, draw_sprite;
        PVector vel, scale;

        Body(Sprite idle, Sprite run, PVector vel) {
           this.idle = idle;
           this.run = run;
           this.vel = vel;
           this.scale = new PVector(1, 1);
        }
        Body(PVector vel) {
            this(GAME.assets.getSprite("media/sprites/player/body_idle"), GAME.assets.getSprite("media/sprites/player/body_running"), vel);
        }

        void updateSprite() {
            if (vel.mag() > 0.5) {
                draw_sprite = run;
            } else {
                draw_sprite = idle;
            }

            if (vel.x >= 0) {
                scale.x = 1;
            } else {
                scale.x = -1;
            }
        }

        void render() {
            updateSprite();

            // pushMatrix();

            scale(scale.x, scale.y);

            image(draw_sprite.getFrame(), 0, 0);

            // popMatrix();
        }
    }

    Hat h;
    Body b;
    boolean invincible;

    PVector aim_vector;
    int health;

    Timer fireTimer;
    Timer invincibilityTimer;

    Player(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot, int health){
        super(hitbox_radius,  pos,  vel,  accel,  scale,  rot);

        h = new Hat(new PVector(), scale);
        b = new Body(vel);

        this.health = health;

        fireTimer = new Timer();
        invincibilityTimer = new Timer(false);

        aim_vector = new PVector(0, 0);
    }
    Player(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot){
        this(hitbox_radius,  pos,  vel,  accel,  scale,  rot, 10);
    }

    void checkInputs() {
        aim_vector.add((mouseX - (width / 2)) / 100.0, (mouseY - (height / 2)) / 100.0).limit(1);

        if (GAME.mouse_inputs.contains(LEFT)) {
            fire();
        }

        if (GAME.key_inputs.contains( (int)'W') ) {
            next_accel.add(0, -3);
        }
        if (GAME.key_inputs.contains( (int)'A') ) {
            next_accel.add(-3, 0);
        }
        if (GAME.key_inputs.contains( (int)'S') ) {
            next_accel.add(0, 3);
        }
        if (GAME.key_inputs.contains( (int)'D') ) {
            next_accel.add(3, 0);
        }
    }

    void fire()
    {
        //add new projectile at player's location moving in the direction of aim_vector
        GAME.actor_spawns.add(new Projectile(pos.copy(), aim_vector.copy().setMag(50)));
        if(fireTimer.getActiveTime() >=  500)
        {
            GAME.actor_spawns.add(new Projectile(pos.copy(), aim_vector.copy().setMag(50)));
            fireTimer.reset();
        }
    }

    void calcCollision() {
        collisions.clear();

        for (Actor other : GAME.actors) {
            if (((other instanceof Enemy) || (other instanceof Powerup)) && (pos.dist(other.pos) < hitbox_radius + other.hitbox_radius)) {
                collisions.add(other);
            }
        }
    }

    void collisionReaction() {
        for (Actor collision : collisions) {
            if (collision instanceof Enemy) {
                if(!invincible)
                    health--;
            } else if (collision instanceof Powerup) {
                //apply powerup effects
                if (collision instanceof HealthPowerup)
                    health++;
                else if (collision instanceof Superstar)
                {
                    invincible = true;
                    invincibilityTimer.resume();
                }
            }
        }
    }

    void simulate() {
        next_vel.setMag(vel.mag() * 0.75);
        checkInputs();
        super.simulate();
        fireTimer.update();
        invincibilityTimer.update();
    }
    
    void move() {
        super.move();
        vel.limit(10);
    }
    
    void toggleInvincibility()
    {
        if(invincible && invincibilityTimer.getActiveTime() >= 8000)
        {
            invincible = false;
            invincibilityTimer.pause();
            invincibilityTimer.reset();
        }
    }
    
    void display(){
        ellipse(0, 0, 10, 10);
        imageMode(CENTER);
        b.render();
        // pushMatrix();
        // translate(-0.17 * hitbox_radius, -0.50 * hitbox_radius);
        // h.render();
        // popMatrix();
    }
}