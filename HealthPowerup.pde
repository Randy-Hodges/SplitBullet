class HealthPowerup extends Powerup{

    HealthPowerup(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot)
    {
        super(hitbox_radius, pos, vel, accel, scale, rot);
        displayImage = loadImage("health.png");
    }
    
    void display()
    {
        image(displayImage, pos.x, pos.y, hitbox_radius, hitbox_radius);
    }
}