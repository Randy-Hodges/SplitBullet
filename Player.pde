class Player extends Actor{
    Hat h;
    Body b;

    PVector aim_vector;
    int health;
    Game GAME;
    Player(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot, int health){
        super(hitbox_radius,  pos,  vel,  accel,  scale,  rot);
        h = new Hat( hitbox_radius,  pos,  vel,  accel,  scale,  rot);
        b = new Body( hitbox_radius,  pos,  vel,  accel,  scale,  rot);
        this.health = health;
    }
    Player(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot){
        this(hitbox_radius,  pos,  vel,  accel,  scale,  rot, 10);
    }

    void checkInputs() {
        aim_vector.add((mouseX - (width / 2)) / 100.0, (mouseY - (height / 2)) / 100.0).limit(1);

        if (GAME.mouse_inputs.contains(LEFT)) {
            fire();
        }

        if (GAME.key_inputs.contains(int('W'))) {
            next_accel.add(0, -1);
        }
        if (GAME.key_inputs.contains(int('A'))) {
            next_accel.add(-1, 0);
        }
        if (GAME.key_inputs.contains(int('S'))) {
            next_accel.add(0, 1);
        }
        if (GAME.key_inputs.contains(int('D'))) {
            next_accel.add(1, 0);
        }
    }

    void fire()
    {
        if(GAME.key_inputs.contains(int(' ')));
        {
            //add new projectile at player's location moving in the direction that the player is facing
        }
    }

    void collisionReaction() {
        // overwrite this method with your object's reaction to collisions
        for (Actor other : GAME.actors) {
            boolean isColliding = pos.dist(other.pos) <= hitbox_radius + other.hitbox_radius;
            if (other instanceof Projectile && isColliding/* change to Enemy once class is created*/) {

                collisions.add(other);
                health--;

            }

            else if(other instanceof Powerup && isColliding)
            {
                //apply powerup effects
                collisions.add(other);
            }
        }
    }

    void simulate() {
        checkInputs();
        super.simulate();
    }

}