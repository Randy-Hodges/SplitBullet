class Powerup extends Actor
{
    Player collector;
    Timer effect_time;
    Sprite displayImage;

    Powerup(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot, int effect_time, Sprite displayImage)
    {
        super(hitbox_radius, pos, vel, accel, scale, rot);
        this.displayImage = displayImage;
        this.collector = null;
        this.effect_time = new Timer(false, true, true, effect_time, 0, true);
    }
    Powerup(float hitbox_radius, PVector pos, int effect_time, Sprite displayImage)
    {
        this(hitbox_radius, pos, new PVector(), new PVector(), new PVector(1, 1), 0, effect_time, displayImage);
    }
    Powerup(PVector pos, int effect_time, Sprite displayImage)
    {
        this(30, pos, new PVector(), new PVector(), new PVector(1, 1), 0, effect_time, displayImage);
    }


    boolean simulateEffects() {
        if (effect_time.value() <= 0) {
            collector.powerups.remove(this);
            return false;
        }
        return true;
    }

    void applyEffect() {}

    void calcCollision() {
        collisions.clear();

        for (Actor other : GAME.actors) {
            if ((other instanceof Player) && (pos.dist(other.pos) < hitbox_radius + other.hitbox_radius)) {
                collisions.add(other);
            }
        }
    }

    void collisionReaction() {
        if(collisions.size() > 0) 
        {
            collector = (Player)collisions.get(0);
            GAME.actor_despawns.add(this);
            effect_time.reset(); 
        }
        
    }

    void display()
    {
        image(displayImage.getFrame(), 0, 0, hitbox_radius, hitbox_radius);
    }
}
