class Superstar extends Powerup
{
    Superstar(float hitbox_radius, PVector pos, int effect_time, Sprite displayImage) {
        super(hitbox_radius, pos, effect_time, displayImage);
    }
    Superstar(float hitbox_radius, PVector pos, int effect_time) {
        this(hitbox_radius, pos, effect_time, GAME.assets.getSprite("media/sprites/powerups/superstar"));
    }
    Superstar(PVector pos, int effect_time) {
        this(30, pos, effect_time);
    }
    Superstar(PVector pos) {
        this(30, pos, 8000);
    }
    
    void applyEffect() {
        collector.invulnerable = true;
        colorMode(HSB, 360, 100, 100);
        collector.tint_color -= color(360 - random(360), 100, 100);
        colorMode(RGB, 255, 255, 255);
    }
}
