// Author: Daniel Ross, Sean Thomas

class Projectile extends Actor {
    // FIELDS
    Sprite displayImage; // sprite
    int caliber; // damage that will be dealt

    // CONSTRUCTORS
    // Including base-class constructor is a good safety measure, but try not to use.
    Projectile(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot, int caliber, Sprite displayImage) {
        super(hitbox_radius, pos, vel, accel, scale, rot);
        this.caliber = caliber;
        this.displayImage = displayImage;
    }
    // Use one of below constructors
    // For class Player: Use this call to fire projectiles:
    // GAME.actors.add(new Projectile(pos.copy(), aim_vector.copy().setMag( [your projectile velocity here] )));
    Projectile(PVector origin, PVector direction, int caliber, float hitbox_radius, Sprite displayImage) {
        this(hitbox_radius, origin, direction, new PVector(), new PVector(1, 1), 0, caliber, displayImage);
    }
    Projectile(PVector origin, PVector direction, int caliber, float hitbox_radius) {
        this(hitbox_radius, origin, direction, new PVector(), new PVector(1, 1), 0, caliber, GAME.assets.getSprite("media/sprites/projectile/bullet"));
    }
    Projectile(PVector origin, PVector direction, int caliber, Sprite displayImage) {
        this(origin, direction, caliber, 10, displayImage);
    }
    Projectile(PVector origin, PVector direction, int caliber) {
        this(origin, direction, caliber, 10, GAME.assets.getSprite("media/sprites/projectile/bullet"));
    }
    Projectile(PVector origin, PVector direction, Sprite displayImage) {
        this(origin, direction, 1, 10, displayImage);
    }
    Projectile(PVector origin, PVector direction) {
        this(origin, direction, 1, 10, GAME.assets.getSprite("media/sprites/projectile/bullet"));
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
            (collisions.size() > 0) ||
            (pos.x < GAME.PLAYABLE_AREA_X) || 
            (pos.x > GAME.PLAYABLE_AREA_X + GAME.PLAYABLE_AREA_WIDTH) || 
            (pos.y < GAME.PLAYABLE_AREA_Y) || 
            (pos.y > GAME.PLAYABLE_AREA_Y + GAME.PLAYABLE_AREA_HEIGHT) ) {
                GAME.actor_despawns.add(this);
        }
    }

    void simulate() {
        rot = vel.heading();
        super.simulate();
    }

    void display() {
        image(displayImage.getFrame(), 0, 0, (2 * hitbox_radius), (2 * hitbox_radius));
    }
}
