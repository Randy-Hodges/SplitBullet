class Projectile extends Actor{
    boolean hasCollided;
    PImage displayImage;
    Game GAME;
    Projectile(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot)
    {
        super( hitbox_radius,  pos,  vel,  accel,  scale,  rot);
        displayImage = loadImage("projectile.png");
    }

    void collisionReaction(){//update later
        for (Actor other : GAME.actors) {
            if (true/*other instanceof Enemy && !hasCollided*/) {
                if (pos.dist(other.pos) <= hitbox_radius + other.hitbox_radius) {
                    collisions.add(other);
                    hasCollided = true;
                    //return other;
                }
            }
        }
        //return null;
    }

    void render(){
        if(!hasCollided){
            pushMatrix();
            translate(pos.x, pos.y);
            image(displayImage, 0, 0, 2 * hitbox_radius, 2 * hitbox_radius);
            popMatrix();
        }
    }
}