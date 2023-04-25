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
            t = new Timer(true, 0, 5000, false, true);
        }
        Hat(PVector pos, float rot, PVector scale) {
            this(GAME.assets.getSprite("media/sprites/player/hat"), pos, rot, scale);
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
            anim_rot = cos(t.value() / (t.endTime() / TWO_PI));
        }

        void render() {
            // updateSprite();

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
            
            this.run.setAnimLength(500);
        }
        Body() {
            this(GAME.assets.getSprite("media/sprites/player/idle"), GAME.assets.getSprite("media/sprites/player/run"));
        }

        void updateSprite() {
            if (Player.this.vel.mag() > 2) {
                draw_sprite = run;
            } else {
                draw_sprite = idle;
            }

            if ((Player.this.aim_vector.x < 0 && Player.this.vel.x > 0) || (Player.this.aim_vector.x > 0 && Player.this.vel.x < 0)) {
                run.timer.countDown();
            } else {
                run.timer.countUp();
            }
        }

        void render() {
            updateSprite();

            pushMatrix();

            image(draw_sprite.getFrame(), 0, 0, (2 * Player.this.hitbox_radius), (2 * Player.this.hitbox_radius));

            popMatrix();
        }
    }
    class Arm {
        Gun gun;

        Sprite arm;
        PVector pos, scale;
        float rot;

        Arm(Sprite arm, Gun gun, PVector pos, float rot, PVector scale) {
            this.arm = arm;
            this.gun = gun;

            this.pos = pos;
            this.rot = rot;
            this.scale = scale;
        }
        Arm(PVector pos, float rot, PVector scale) {
            this(GAME.assets.getSprite("media/sprites/player/arm"), new Gun(), pos, rot, scale);
        }
        Arm(PVector pos, float rot) {
            this(pos, rot, new PVector(1, 1));
        }
        Arm(PVector pos, PVector scale) {
            this(pos, 0, scale);
        }
        Arm(PVector pos) {
            this(pos, 0, new PVector(0.5, 0.5));
        }
        Arm() {
            this(new PVector(12, 14));
        }

        void updateSprite() {
            rot = Player.this.aim_vector.y * HALF_PI;
        }

        void render() {
            updateSprite();

            pushMatrix();

            translate(pos.x, pos.y);
            scale(scale.x, scale.y);

            rotate(rot);

            gun.render();
            image(arm.getFrame(), 0, 0, (2 * Player.this.hitbox_radius), (2 * Player.this.hitbox_radius));

            popMatrix();
        }
    }
    class Gun {
        Sprite gun;
        PVector pos, scale;
        float rot;

        Gun(Sprite gun, PVector pos, float rot, PVector scale) {
            this.gun = gun;

            this.pos = pos;
            this.rot = rot;
            this.scale = scale;
        }
        Gun(PVector pos, float rot, PVector scale) {
            this(GAME.assets.getSprite("media/sprites/player/gun"), pos, rot, scale);
        }
        Gun(PVector pos, float rot) {
            this(pos, rot, new PVector(1, 1));
        }
        Gun(PVector pos, PVector scale) {
            this(pos, 0, scale);
        }
        Gun(PVector pos) {
            this(pos, 0, new PVector(1, 1));
        }
        Gun() {
            this(new PVector(20, 0));
        }

        void render() {
            pushMatrix();

            translate(pos.x, pos.y);
            scale(scale.x, scale.y);

            rotate(rot);

            image(gun.getFrame(), 0, 0, (2 * Player.this.hitbox_radius), (2 * Player.this.hitbox_radius));

            popMatrix();
        }
    }

    Hat h;
    Body b;
    Arm a;

    PVector aim_vector, flip;
    int health;
    boolean hurt;

    Timer fireTimer;
    Timer invincibilityTimer;

    Player(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot, int health) {
        super(hitbox_radius,  pos,  vel,  accel,  scale,  rot);

        h = new Hat(new PVector(0, -0.7 * hitbox_radius), new PVector(0.7, 0.7));
        b = new Body();
        a = new Arm();

        this.health = health;

        fireTimer = new Timer();
        invincibilityTimer = new Timer(false, false, true, 0, 0, true);

        aim_vector = new PVector(1, 0);

        flip = scale.copy();
    }
    Player(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot) {
        this(hitbox_radius,  pos,  vel,  accel,  scale,  rot, 10);
    }

    void checkInputs() {
        // aim_vector.add((mouseX - (width / 2)) / 100.0,(mouseY - (height / 2)) / 100.0).limit(1);
        aim_vector.set(mouseX - (pos.x + (a.pos.x * a.scale.x)), mouseY - (pos.y + a.pos.y)).normalize();

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
        if (fireTimer.value() >= 300)
        {
            GAME.actor_spawns.add(new Projectile(new PVector(pos.x + (flip.x * a.pos.x), pos.y + a.pos.y).add(PVector.fromAngle(flip.x * a.rot).mult(flip.x  * a.gun.pos.x)), aim_vector.copy().setMag(1000)));
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
                if (invincibilityTimer.value() <= 0 && !((Enemy)collision).hurt && ((Enemy)collision).health > 0) {
                    health--;
                    hurt = true;
                    invincibilityTimer.setBaseTime(1000);
                    invincibilityTimer.reset();
                    invincibilityTimer.resume();
                }
            } else if (collision instanceof Powerup) {
                //apply powerup effects
                if (collision instanceof HealthPowerup)
                    health++;
            
                else if (collision instanceof Superstar) {
                    invincibilityTimer.setBaseTime(8000);
                    invincibilityTimer.reset();
                    invincibilityTimer.resume();
                }
            }
        }
    }

    void damageCooldown() {
        if (hurt && invincibilityTimer.value() <= 0) {
            hurt = false;
        }
    }

    void simulate() {
        checkInputs();
        damageCooldown();
        super.simulate();
    }
    
    void move() {
        next_pos.set(
            constrain(next_pos.x, GAME.PLAYABLE_AREA_X, GAME.PLAYABLE_AREA_X + GAME.PLAYABLE_AREA_WIDTH), 
            constrain(next_pos.y, GAME.PLAYABLE_AREA_Y, GAME.PLAYABLE_AREA_Y + GAME.PLAYABLE_AREA_HEIGHT)
        );
        super.move();
        vel.limit(1000);
    }

    void drawAimVector() {
        stroke(#FF0000);

        pushMatrix();
        rotate(aim_vector.heading());
        line(0, 0, (2 * hitbox_radius), 0);
        popMatrix();
    }

    void checkDirection() {
         if (aim_vector.x < 0) {
            flip.set(-scale.x, scale.y);
        } else {
            flip.set(scale.x, scale.y);
        }
    }

    void render() {
        checkDirection();
        imageMode(CENTER);

        draw_pos.set(lerp(pos.x, next_pos.x, (GAME.game_time.value() / (1000.0 / GAME.tickrate))), lerp(pos.y, next_pos.y, (GAME.game_time.value() / (1000.0 / GAME.tickrate))));

        pushMatrix();

        translate(draw_pos.x, draw_pos.y);
        scale(flip.x, flip.y);

        rotate(rot);

        if (hurt) 
            tint(255, 150, 150);
        b.render();
        tint(255);

        h.render();
        a.render();

        popMatrix();
    }
}
