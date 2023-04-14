class Player extends Actor{
    Hat h;
    Body b;

    PVector aim_vector;
    
    Player(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot){
        super(hitbox_radius,  pos,  vel,  accel,  scale,  rot);
        h = new Hat( hitbox_radius,  pos,  vel,  accel,  scale,  rot);
        b = new Body( hitbox_radius,  pos,  vel,  accel,  scale,  rot);
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
            
        }
    }

    void collisionReaction() {
        // overwrite this method with your object's reaction to collisions
    }

    void simulate() {
        checkInputs();
        super.simulate();
    }

}