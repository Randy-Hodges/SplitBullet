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

        next_pos = new PVector();
        next_vel = new PVector();
        next_accel = new PVector();

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
    void calcCollision() {
        // collisions.clear();

        // for (Actor other : Game.actors) {
        //     if ((other != this) && (pos.dist(other.pos) < hitbox_radius + other.hitbox_radius)) {
        //         collisions.add(other);
        //     }
        // }
    }

    void collisionReaction() {
        // overwrite this method with your object's reaction to collisions
    }

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

    void display() {
        // image(PImage, 0, 0, 1, 1) or
        // ellipse(0, 0, 1, 1) or
        // rect(0, 0, 1, 1) or
        // etc.
    }
}