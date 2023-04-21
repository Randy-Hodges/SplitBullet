class Player extends Actor{
    Hat h;
    Body b;
    boolean invincible;

    PVector aim_vector;
    int health;

    Timer fireTimer;
    Timer invincibilityTimer;

    Player(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot, int health){
        super(hitbox_radius,  pos,  vel,  accel,  scale,  rot);
        // DO NOT UNCOMMENT UNTIL HAT AND BODY HAVE CONSTRUCTORS
        h = new Hat( hitbox_radius,  pos,  vel,  accel,  scale,  rot);
        b = new Body( hitbox_radius,  pos,  vel,  accel,  scale,  rot);
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
            // println("fire");
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

    void collisionReaction() {
        // overwrite this method with your object's reaction to collisions
        for (Actor other : GAME.actors) {
            boolean isColliding = pos.dist(other.pos) <= hitbox_radius + other.hitbox_radius;
            if (other instanceof Enemy && isColliding) {

                collisions.add(other);

                if(!invincible)
                    health--;

            }

            else if(other instanceof Powerup && isColliding)
            {
                //apply powerup effects
                collisions.add(other);
                if(other instanceof HealthPowerup)
                    health++;
                else if(other instanceof Superstar)
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
      b.display();
      pushMatrix();
      translate(-0.17 * hitbox_radius, -0.50 * hitbox_radius);
      h.display();
      popMatrix();
    }
}