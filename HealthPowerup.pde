class HealthPowerup extends Powerup{

    HealthPowerup(float hitbox_radius, PVector pos)
    {
        super(hitbox_radius, pos);
        displayImage = GAME.assets.getSprite("media/sprites/powerups/health");
    }
    

}
