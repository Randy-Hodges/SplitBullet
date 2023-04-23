class Powerup extends Actor
{
    float lifetime;
    Sprite displayImage;

    Powerup(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot)
    {
        super(hitbox_radius, pos, vel, accel, scale, rot);
    }
    
    Powerup(float hitbox_radius, PVector pos)
    {
        super(hitbox_radius, pos, new PVector(), new PVector(), new PVector(1,1), 0);
    }
    void calcCollision() {
        collisions.clear();

        for (Actor other : GAME.actors) {
            if ((other instanceof Player) && (pos.dist(other.pos) < hitbox_radius + other.hitbox_radius)) {
                collisions.add(other);
            }
        }
    }

    void collisionReaction() {
        if(collisions.size() > 0) 
        {
            GAME.actor_despawns.add(this);   
        }
        
    }

    void display()
    {
        image(displayImage.getFrame(), 0, 0, hitbox_radius, hitbox_radius);
    }
}
