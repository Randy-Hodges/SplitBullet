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
    int tint_color;

    Superstar(float hitbox_radius, PVector pos, int effect_time, Sprite displayImage, AudioPlayer collect_sound) {
        super(hitbox_radius, pos, effect_time, displayImage, collect_sound);
        color_timer = new Timer(true, 0, 250);
        tint_color = 0;
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

        if (effect_time.value <= 2000) {
            color_timer.setEndTime(50);
        }

        if (color_timer.value() >= color_timer.endTime()) {
            color_timer.reset();
            tint_color = (tint_color + 60) % 360;
        }

        colorMode(HSB, 360, 100, 100);
        collector.tint_color = color(tint_color, 100, 100);
        colorMode(RGB, 255, 255, 255);
    }
}

class Rapidfire extends Powerup{

    Rapidfire(float hitbox_radius, PVector pos, int effect_time, Sprite displayImage, AudioPlayer collect_sound) {
        super(hitbox_radius, pos, effect_time, displayImage, collect_sound);
    }
    Rapidfire(float hitbox_radius, PVector pos, int effect_time) {
        this(hitbox_radius, pos, effect_time, GAME.assets.getSprite("media/sprites/powerups/rapidfire"), GAME.assets.getSound("media/sounds/gun/reload"));
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
        this(hitbox_radius, pos, effect_time, GAME.assets.getSprite("media/sprites/powerups/penetrator"), GAME.assets.getSound("media/sounds/gun/reload"));
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