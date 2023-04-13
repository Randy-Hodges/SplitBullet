class Player extends Actor{
    Hat h;
    Body b;
    
    Player(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot){
        super(hitbox_radius,  pos,  vel,  accel,  scale,  rot);
        h = new Hat( hitbox_radius,  pos,  vel,  accel,  scale,  rot);
        b = new Body( hitbox_radius,  pos,  vel,  accel,  scale,  rot);
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

     
}