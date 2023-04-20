class Powerup extends Actor
{
    float lifetime;
    PImage displayImage;

    Powerup(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot)
    {
        super(hitbox_radius, pos, vel, accel, scale, rot);
    }

    
}