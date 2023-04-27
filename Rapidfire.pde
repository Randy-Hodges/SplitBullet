class Rapidfire extends Powerup{

    Rapidfire(float hitbox_radius, PVector pos, int effect_time, Sprite displayImage) {
        super(hitbox_radius, pos, effect_time, displayImage);
    }
    Rapidfire(float hitbox_radius, PVector pos, int effect_time) {
        this(hitbox_radius, pos, effect_time, GAME.assets.getSprite("media/sprites/powerups/rapidfire"));
    }
    Rapidfire(PVector pos, int effect_time) {
        this(30, pos, effect_time);
    }
    Rapidfire(PVector pos) {
        this(30, pos, 0);
    }

    void applyEffect() {
        collector.rapidfire = true;
    }
}