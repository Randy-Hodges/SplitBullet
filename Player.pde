class Player extends Actor {
    class Hat {
        Sprite sprite;
        PVector pos, scale;
        float rot, anim_rot;
        Timer t;

        Hat(Sprite sprite, PVector pos, float rot, PVector scale) {
            this.sprite = sprite;
            this.pos = pos;
            this.rot = rot;
            this.scale = scale;

            this.anim_rot = 0;
            t = new Timer(true, true, true, true, 5000);
        }
        Hat(PVector pos, float rot, PVector scale) {
            this(GAME.assets.getSprite("media/sprites/player/hat_frames"), pos, rot, scale);
        }
        Hat(PVector pos, float rot) {
            this(pos, rot, new PVector(1, 1));
        }
        Hat(PVector pos, PVector scale) {
            this(pos, 0, scale);
        }
        Hat(PVector pos) {
            this(pos, 0, new PVector(1, 1));
        }

        void updateSprite() {
            anim_rot = cos(t.getActiveTime() / (t.loop_time / TWO_PI));
        }

        void render() {
            updateSprite();

            pushMatrix();

            translate(pos.x, pos.y);
            scale(scale.x, scale.y);
            rotate(rot);

            rotate((QUARTER_PI / 2) * anim_rot);

            image(sprite.getFrame(), 0, 0, (2 * Player.this.hitbox_radius), (2 * Player.this.hitbox_radius));

            popMatrix();
        }
    }
    class Body {
        Sprite idle, run, draw_sprite;

        Body(Sprite idle, Sprite run) {
            this.idle = idle;
            this.run = run;
            this.draw_sprite = idle;
        }
        Body() {
            this(GAME.assets.getSprite("media/sprites/player/body_idle"), GAME.assets.getSprite("media/sprites/player/body_running"));
        }

        void updateSprite() {
            if (Player.this.vel.mag() > 2) {
                draw_sprite = run;
            } else {
                draw_sprite = idle;
            }
        }

        void render() {
            updateSprite();

            pushMatrix();

            image(draw_sprite.getFrame(), 0, 0, (2 * Player.this.hitbox_radius), (2 * Player.this.hitbox_radius));

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

    Player(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot, int health) {
        super(hitbox_radius,  pos,  vel,  accel,  scale,  rot);

        h = new Hat(new PVector(0, -0.8 * hitbox_radius), new PVector(0.5, 0.5));
        b = new Body();

        this.health = health;

        fireTimer = new Timer();
        invincibilityTimer = new Timer(false);

        aim_vector = new PVector(1, 0);
    }
    Player(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot) {
        this(hitbox_radius,  pos,  vel,  accel,  scale,  rot, 10);
    }

    void checkInputs() {
        aim_vector.add((mouseX - (width / 2)) / 100.0,(mouseY - (height / 2)) / 100.0).limit(1);

        if (GAME.mouse_inputs.contains(LEFT)) {
            fire();
        }

        next_accel.add(-vel.x * 0.5, -vel.y * 0.5);

        if (GAME.key_inputs.contains((int)'W')) {
            next_accel.add(0, -100);
        }
        if (GAME.key_inputs.contains((int)'A')) {
            next_accel.add(-100, 0);
        }
        if (GAME.key_inputs.contains((int)'S')) {
            next_accel.add(0, 100);
        }
        if (GAME.key_inputs.contains((int)'D')) {
            next_accel.add(100, 0);
        }
    }

    void fire()
    {
        //add new projectile at player's location moving in the direction of aim_vector
        if (fireTimer.getActiveTime() >= 300)
        {
            GAME.actor_spawns.add(new Projectile(pos.copy(), aim_vector.copy().setMag(1000)));
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
                if (!invincible)
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
        checkInputs();
        super.simulate();
        fireTimer.update();
        invincibilityTimer.update();
    }
    
    void move() {
        next_pos.set(
            constrain(next_pos.x, GAME.PLAYABLE_AREA_X, GAME.PLAYABLE_AREA_X + GAME.PLAYABLE_AREA_WIDTH), 
            constrain(next_pos.y, GAME.PLAYABLE_AREA_Y, GAME.PLAYABLE_AREA_Y + GAME.PLAYABLE_AREA_HEIGHT)
        );
        super.move();
        vel.limit(1000);
    }
    
    void toggleInvincibility()
    {
        if (invincible && invincibilityTimer.getActiveTime() >= 8000)
        {
            invincible = false;
            invincibilityTimer.pause();
            invincibilityTimer.reset();
        }
    }

    void drawAimVector() {
        stroke(#FF0000);

        pushMatrix();
        rotate(aim_vector.heading());
        line(0, 0, (2 * hitbox_radius), 0);
        popMatrix();
    }

    void render() {
        imageMode(CENTER);

        draw_pos.set(lerp(pos.x, next_pos.x, (GAME.game_time.getActiveTime() / (1000.0 / GAME.tickrate))), lerp(pos.y, next_pos.y, (GAME.game_time.getActiveTime() / (1000.0 / GAME.tickrate))));

        pushMatrix();

        translate(draw_pos.x, draw_pos.y);
        scale(scale.x, scale.y);
        
        drawAimVector();

        if (aim_vector.x < 0) {
            scale(-1, 1);
        } else {
            scale(1, 1);
        }

        rotate(rot);

        b.render();
        h.render();

        popMatrix();
    }
}
