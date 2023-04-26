class HealthPowerup extends Powerup{

    HealthPowerup(float hitbox_radius, PVector pos, int effect_time, Sprite displayImage) {
        super(hitbox_radius, pos, effect_time, displayImage);
    }
    HealthPowerup(float hitbox_radius, PVector pos, int effect_time) {
        this(hitbox_radius, pos, effect_time, GAME.assets.getSprite("media/sprites/powerups/health"));
    }
    HealthPowerup(PVector pos, int effect_time) {
        this(30, pos, effect_time);
    }
    HealthPowerup(PVector pos) {
        this(30, pos, 0);
    }

    void applyEffect() {
        collector.health++;
    }
}