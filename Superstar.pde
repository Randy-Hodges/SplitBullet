class Superstar extends Powerup
{
    Superstar(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot)
    {
        super(hitbox_radius, pos, vel, accel, scale, rot);
        displayImage = loadImage("media/sprites/powerups/superstar.png");
    }
    
    void display()
    {
        image(displayImage, 0, 0, hitbox_radius, hitbox_radius);
    }
}