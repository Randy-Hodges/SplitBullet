class HealthPowerup extends Powerup{

    HealthPowerup(float hitbox_radius, PVector pos, int effect_time, Sprite displayImage, AudioPlayer collect_sound) {
        super(hitbox_radius, pos, effect_time, displayImage, collect_sound);
    }
    HealthPowerup(float hitbox_radius, PVector pos, int effect_time) {
        this(hitbox_radius, pos, effect_time, GAME.assets.getSprite("media/sprites/powerups/health"), GAME.assets.getSound("media/sounds/powerup/health"));
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

class Superstar extends Powerup
{
    Timer color_timer;
    color tint_color;

    Superstar(float hitbox_radius, PVector pos, int effect_time, Sprite displayImage, AudioPlayer collect_sound) {
        super(hitbox_radius, pos, effect_time, displayImage, collect_sound);
        color_timer = new Timer(true, 0, 250);
    }
    Superstar(float hitbox_radius, PVector pos, int effect_time) {
        this(hitbox_radius, pos, effect_time, GAME.assets.getSprite("media/sprites/powerups/superstar"), GAME.assets.getSound("media/sounds/powerup/superstar"));
    }
    Superstar(PVector pos, int effect_time) {
        this(30, pos, effect_time);
    }
    Superstar(PVector pos) {
        this(30, pos, 8000);
    }

    void applyEffect() {
        collector.invulnerable = true;

        if (color_timer.value() >= color_timer.endTime()) {
            color_timer.reset();

            colorMode(HSB, 360, 100, 100);
            tint_color = color(360 - random(360), 100, 100);
            colorMode(RGB, 255, 255, 255);
        }

        collector.tint_color = tint_color;
    }
}

class Rapidfire extends Powerup{

    Rapidfire(float hitbox_radius, PVector pos, int effect_time, Sprite displayImage, AudioPlayer collect_sound) {
        super(hitbox_radius, pos, effect_time, displayImage, collect_sound);
    }
    Rapidfire(float hitbox_radius, PVector pos, int effect_time) {
        this(hitbox_radius, pos, effect_time, GAME.assets.getSprite("media/sprites/powerups/rapidfire"), GAME.assets.getSound("media/sounds/powerup/superstar"));
    }
    Rapidfire(PVector pos, int effect_time) {
        this(30, pos, effect_time);
    }
    Rapidfire(PVector pos) {
        this(30, pos, 10000);
    }

    void applyEffect() {
        collector.fireTimer.setBaseTime(collector.fireTimer.baseTime() / 2);
    }
}

class Penetrator extends Powerup {

    Penetrator(float hitbox_radius, PVector pos, int effect_time, Sprite displayImage, AudioPlayer collect_sound) {
        super(hitbox_radius, pos, effect_time, displayImage, collect_sound);
    }
    Penetrator(float hitbox_radius, PVector pos, int effect_time) {
        this(hitbox_radius, pos, effect_time, GAME.assets.getSprite("media/sprites/powerups/penetrator"), GAME.assets.getSound("media/sounds/powerup/superstar"));
    }
    Penetrator(PVector pos, int effect_time) {
        this(30, pos, effect_time);
    }
    Penetrator(PVector pos) {
        this(30, pos, 8000);
    }

    void applyEffect() {
        collector.a.gun.bullet_durability *= 2;
    }
}