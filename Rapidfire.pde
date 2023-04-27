class Rapidfire extends Powerup{

    Rapidfire(float hitbox_radius, PVector pos, int effect_time, Sprite displayImage, AudioPlayer collect_sound) {
        super(hitbox_radius, pos, effect_time, displayImage, collect_sound);
    }
    Rapidfire(float hitbox_radius, PVector pos, int effect_time) {
        this(hitbox_radius, pos, effect_time, GAME.assets.getSprite("media/sprites/powerups/rapidfire"), GAME.assets.getSound("media/sounds/powerup/rapidfire"));
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