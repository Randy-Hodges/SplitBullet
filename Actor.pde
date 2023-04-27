// Author: Daniel Ross

class Actor {
    // FIELDS

    // Represents the Actor's current position and motion vectors
    // on the current simulation
    PVector pos, vel, accel;

    // Represents the Actor's position and motion vectors beginning
    // at the next simulation cycle. (will become pos, vel, accel
    // at the beginning of that next cycle.)
    // Designed to be filled out in simulate()
    PVector next_pos, next_vel, next_accel;
    
    // Size of Actor's hitbox in px. Also functions as the drawn
    // image's base scale.
    float hitbox_radius;

    // Array that contains all collisions between this Actor and
    // all Actors in GAME.actors. Filled by calcCollision() method.
    ArrayList<Actor> collisions;

    // The position where the Actor is drawn.
    // Represents a linearly interpolated position between
    // pos and next_pos. Will not differ from pos unless
    // frameRate is greater than GAME.tickrate.
    PVector draw_pos;

    // Multiplier that scales the drawn image
    PVector scale;

    // Rotation in radians of the drawn image
    float rot;

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

        draw_pos = pos.copy();

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

    // Used to fill in the next_pos, next_vel, next_accel fields
    // Overwrite if, for example, you want to add AI or any other
    // simulated functionality to your Actor.
    // You must retain the existing functionality of the method.
    /* For example, your override would ideally look something like this:
        void simulate() {
            runAI();
            calcGravity();
            super.simulate(); <-- retains the functionality of the original method
        }
    */
    void simulate() {
        calcCollision();

        collisionReaction();

        updateVectors();
    }

    // Applies movement calculations for the next simulation cycle
    void updateVectors() {
        next_vel.add(next_accel);
        next_pos.add(next_vel.x / GAME.tickrate, next_vel.y / GAME.tickrate);
    }

    // Set all current fields to next_ fields
    void applySimulation() {
        move();
    }

    // Sets the current movement vectors to their next_ counterparts
    void move() {
        accel.set(next_accel);
        vel.set(next_vel);
        pos.set(next_pos);

        next_accel.set(0, 0);
        next_vel.set(vel);
        next_pos.set(pos);
    }

    // Draws the Actor to the screen using translation matrices.
    // In most scenarios, you will simply want to override the display() method.
    void render() {
        draw_pos.set(lerp(pos.x, next_pos.x, (GAME.tick_time.value() / (1000.0 / GAME.tickrate))), lerp(pos.y, next_pos.y, (GAME.tick_time.value() / (1000.0 / GAME.tickrate))));
        
        pushMatrix();

        translate(draw_pos.x, draw_pos.y);
        scale(scale.x, scale.y);
        rotate(rot);

        display();

        popMatrix();
    }
}