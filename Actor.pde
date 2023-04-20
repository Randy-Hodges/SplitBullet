// Author: Daniel Ross

class Actor {
    // FIELDS
    PVector pos, vel, accel, scale, next_pos, next_vel, next_accel;
    float rot, hitbox_radius;
    ArrayList<Actor> collisions;

    // CONSTRUCTORS
    Actor(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot) {
        this.hitbox_radius = hitbox_radius;
        this.pos = pos;
        this.vel = vel;
        this.accel = accel;
        this.scale = scale;
        this.rot = rot;

        next_pos = pos.copy();
        next_vel = vel.copy();
        next_accel = accel.copy();

        collisions = new ArrayList();
    }
    Actor(float hitbox_radius, PVector pos, PVector scale, float rot) {
        this(hitbox_radius, pos, new PVector(), new PVector(), scale, rot);
    }
    Actor(float hitbox_radius, PVector pos) {
        this(hitbox_radius, pos, new PVector(), new PVector(), new PVector(), 0);
    }
    Actor(float hitbox_radius) {
        this(hitbox_radius, new PVector(), new PVector(), new PVector(), new PVector(), 0);
    }
    Actor(PVector pos) {
        this(1, pos, new PVector(), new PVector(), new PVector(), 0);
    }
    Actor() {
        this(1, new PVector(), new PVector(), new PVector(), new PVector(), 0);
    }

    // METHODS

    // Overwrite this method with how your object REACTS to collisions.
    // ACTING upon a colliding object may be less flexible.
    void collisionReaction() {    
        // Your method will likely will look something like this:

        /*
        for (collision : collisions) {
            // Reaction
        } 
        */
    }

    // OVERWRITE THIS METHOD with the function that draws your object.
    void display() {
        // image(PImage, 0, 0, 1, 1) or
        // ellipse(0, 0, 1, 1) or
        // rect(0, 0, 1, 1) or
        // etc.
    }

    // Fills "collisions" ArrayList. Adds any GAME.Actor by default. Overwrite 
    // if you only want certain class types to be considered/added to the array.
    // RECOMMEND COPYING THIS METHOD and only replacing the block comment in the "if" statement.
    void calcCollision() {
        collisions.clear();

        for (Actor other : GAME.actors) {
            if ((other != this) /* && (other instanceof ClassType) */ && (pos.dist(other.pos) < hitbox_radius + other.hitbox_radius)) {
                collisions.add(other);
            }
        }
    }

    // The following methods should only be overwritten in special circumstances.

    void updateVectors() {
        next_vel.add(next_accel);
        next_pos.add(next_vel);
    }

    void simulate() {
        calcCollision();

        collisionReaction();

        updateVectors();
    }

    void move() {
        accel.set(next_accel);
        vel.set(next_vel);
        pos.set(next_pos);

        next_accel.set(0, 0);
        next_vel.set(vel);
        next_pos.set(pos);
    }

    void render() {
        pushMatrix();

        translate(pos.x, pos.y);
        scale(scale.x, scale.y);
        rotate(rot);

        display();

        popMatrix();
    }
}