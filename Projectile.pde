// Author: Daniel Ross, Sean Thomas

class Projectile extends Actor {
    // FIELDS
    Actor source; // Actor that fired the projectile

    Sprite displayImage; // sprite
    int caliber; // damage that will be dealt
    int durability; // number of enemies that can be penetrated before breaking

    ArrayList<Actor> hits; // Enemies the Projectile has hit

    // CONSTRUCTORS
    // Including base-class constructor is a good safety measure, but try not to use.
    Projectile(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot, int caliber, int durability, Sprite displayImage, Actor source) {
        super(hitbox_radius, pos, vel, accel, scale, rot);
        this.source = source;
        this.displayImage = displayImage;

        this.caliber = caliber;
        this.durability = durability;

        this.hits = new ArrayList<Actor>();
    }
    // Use one of below constructors
    // For class Player: Use this call to fire projectiles:
    // GAME.actors.add(new Projectile(pos.copy(), aim_vector.copy().setMag( [your projectile velocity here] )));
    Projectile(PVector origin, PVector direction, int caliber, int durability, float hitbox_radius, Sprite displayImage, Actor source) {
        this(hitbox_radius, origin, direction, new PVector(), new PVector(1, 1), 0, caliber, durability, displayImage, source);
    }
    Projectile(PVector origin, PVector direction, int caliber, int durability, float hitbox_radius, Actor source) {
        this(hitbox_radius, origin, direction, new PVector(), new PVector(1, 1), 0, caliber, durability, GAME.assets.getSprite("media/sprites/projectile/bullet"), source);
    }
    Projectile(PVector origin, PVector direction, int caliber, int durability, Sprite displayImage, Actor source) {
        this(origin, direction, caliber, durability, 10, displayImage, source);
    }
    Projectile(PVector origin, PVector direction, int caliber, int durability, Actor source) {
        this(origin, direction, caliber, durability, 10, GAME.assets.getSprite("media/sprites/projectile/bullet"), source);
    }
    Projectile(PVector origin, PVector direction, Sprite displayImage, Actor source) {
        this(origin, direction, 1, 1, 10, displayImage, source);
    }
    Projectile(PVector origin, PVector direction, Actor source) {
        this(origin, direction, 1, 1, 10, GAME.assets.getSprite("media/sprites/projectile/bullet"), source);
    }

    // METHODS
    void calcCollision() {
        collisions.clear();

        for (Actor other : GAME.actors) {
            // Projectiles only care about reacting to Enemies (despawning)
            if ((other instanceof Enemy) && (pos.dist(other.pos) < hitbox_radius + other.hitbox_radius)) {
                collisions.add(other);
            }
        }
    }

    void collisionReaction() {
        // Delete Proj if it has collided or left play area.
        if (
            (pos.x < GAME.PLAYABLE_AREA_X) || 
            (pos.x > GAME.PLAYABLE_AREA_X + GAME.PLAYABLE_AREA_WIDTH) || 
            (pos.y < GAME.PLAYABLE_AREA_Y) || 
            (pos.y > GAME.PLAYABLE_AREA_Y + GAME.PLAYABLE_AREA_HEIGHT) ) {
                GAME.actor_despawns.add(this);
                return;
        } else if (vel.mag() < 20) {
            GAME.actor_despawns.add(this);
            return;
        }

        PVector slow_down = vel.copy();
        for (Actor collision : collisions) {
            if (!hits.contains(collision)) {
                durability -= 1;
                caliber -= 1;

                next_accel.add(-slow_down.x * 0.2, -slow_down.y * 0.2);
                slow_down.add(next_accel);

                hits.add(collision);
            }
            if (durability <= 0 || caliber <= 0) {
                GAME.actor_despawns.add(this);
                return;
            }
        }
    }

    void applyDrag() {
        next_accel.add(-vel.x * 0.01, -vel.y * 0.01);
    }

    void simulate() {
        rot = vel.heading();
        applyDrag();
        super.simulate();
    }

    void display() {
        image(displayImage.getFrame(), 0, 0, (2 * hitbox_radius), (2 * hitbox_radius));
    }
}