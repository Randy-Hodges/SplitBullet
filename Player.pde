class Player extends Actor {
    class Hat {
        Sprite sprite;
        PVector pos, scale;
        float rot;
        float hitbox_radius;
        Timer t;
        Hat(Sprite sprite, PVector pos, PVector scale, float rot, float hitbox_radius) {
            this.sprite = sprite;
            this.pos = pos;
            this.scale = scale;
            this.rot = rot;
            this.hitbox_radius = hitbox_radius;
            t = new Timer(true, true, true, true, 5000);
        }
        Hat(PVector pos, PVector scale, float hitbox_radius) {
            this(GAME.assets.getSprite("media/sprites/player/hat_frames"), pos, scale, 0,  hitbox_radius);
        }

        void render() {
            pushMatrix();
            rot = cos(t.getActiveTime() / (t.loop_time/ TWO_PI));
            translate(pos.x, pos.y);
            //scale(scale.x, scale.y);
            scale(hitbox_radius);
            rotate(PI/16 * rot);

            image(sprite.getFrame(), 0, 0, 1, 0.5);

            popMatrix();
        }
    }
    class Body {
        Sprite idle, run, draw_sprite;
        PVector vel, scale;
        float hitbox_radius;
        Body(Sprite idle, Sprite run, PVector vel, float hitbox_radius) {
           this.idle = idle;
           this.run = run;
           this.vel = vel;
           this.scale = new PVector(1, 1);
           this.hitbox_radius = hitbox_radius;
        }
        Body(PVector vel, float hitbox_radius) {
            this(GAME.assets.getSprite("media/sprites/player/body_idle"), GAME.assets.getSprite("media/sprites/player/body_running"), vel, hitbox_radius);
        }

        void updateSprite() {
            if (vel.mag() > 0.5) {
                draw_sprite = run;
            } else {
                draw_sprite = idle;
            }

            //if (vel.x >= 0) {
            //    scale.x = 1;
            //} else {
            //    scale.x = -1;
            //}
            
            
        }

        void render() {
            updateSprite();

            pushMatrix();
            
            if(vel.x >= 0)
              scale(2 * hitbox_radius);
            else 
              scale(-2 * hitbox_radius, 2 * hitbox_radius);
              
            
            
            image(draw_sprite.getFrame() , 0, 0, 1, 0.828);

            popMatrix();
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

        h = new Hat(new PVector(0, -0.60 * hitbox_radius), scale, hitbox_radius);
        b = new Body(vel, hitbox_radius);

        this.health = health;

        fireTimer = new Timer();
        invincibilityTimer = new Timer(false);

        aim_vector = new PVector(1, 0);
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
        //GAME.actor_spawns.add(new Projectile(pos.copy(), aim_vector.copy().setMag(50)));
        if(fireTimer.getActiveTime() >= 300)
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
        stroke(#FF0000);
        line(0, 0, 50*aim_vector.x, 50*aim_vector.y);
        imageMode(CENTER);
        b.render();
        // pushMatrix();
        // translate(-0.17 * hitbox_radius, -0.50 * hitbox_radius);
        h.render();
        // popMatrix();
        
    }
}
