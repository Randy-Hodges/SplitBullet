class HealthPowerup extends Powerup{

    HealthPowerup(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot)
    {
        super(hitbox_radius, pos, vel, accel, scale, rot);
        displayImage = loadImage("media/sprites/powerups/health.png");
    }
    
    void display()
    {
        image(displayImage, 0, 0, hitbox_radius, hitbox_radius);
    }
}