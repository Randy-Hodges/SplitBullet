// Author: Daniel Ross, Sean Thomas

class Projectile extends Actor {
    // FIELDS
    PImage displayImage; // sprite
    int caliber; // damage that will be dealt

    // CONSTRUCTORS
    // Including base-class constructor is a good safety measure, but try not to use.
    Projectile(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot, int caliber) {
        super(hitbox_radius, pos, vel, accel, scale, rot);
        this.caliber = caliber;
        displayImage = loadImage("media/sprites/projectile.png");
    }
    // Use one of below constructors
    // For class Player: Use this call to fire projectiles:
    // GAME.actors.add(new Projectile(pos.copy(), aim_vector.copy().setMag( [your projectile velocity here] )));
    Projectile(PVector origin, PVector direction, int caliber, float hitbox_radius) {
        this(hitbox_radius, origin, direction, new PVector(), new PVector(1, 1), 0, caliber);
    }
    Projectile(PVector origin, PVector direction, int caliber) {
        this(origin, direction, caliber, 20);
    }
    Projectile(PVector origin, PVector direction) {
        this(origin, direction, 1, 20);
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
        // Move Proj offscreen IN THE NEXT SIM CYCLE if it has collided.
        if (collisions.size() > 0) {
            next_pos.set(-100, -100);
        }

        // delete the projectile if it is CURRENTLY offscreen
        if ((pos.x < 0) || (pos.x > 1000) || (pos.y < 0) || (pos.y > 1000)) {
            GAME.actor_despawns.add(this);
        }
    }

    void display() {
        image(displayImage, 0, 0, (2 * hitbox_radius), (2 * hitbox_radius));
    }
}