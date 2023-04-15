class Projectile extends Actor{
    boolean hasCollided;
    PImage displayImage;

    Projectile(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot)
    {
        super(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot);
        displayImage = loadImage("projectile.png");
    }

    Actor collisionReaction(){//update later
        for (Actor other : GAME.actors) {
            if (other instanceof Enemy && !hasCollided) {
                if (pos.dist(other.pos) <= hitbox_radius + other.hitbox_radius) {
                    collisions.add(other);
                    hasCollided = true;
                    return other;
                }
            }
        }
        return null;
    }

    void render(){
        if(!hasCollided){
            pushMatrix();
            translate(draw_pos.x, draw_pos.y);
            image(displayImage, 0, 0, 2 * hitbox_radius, 2 * hitbox_radius)
            popMatrix();
        }
    }
}