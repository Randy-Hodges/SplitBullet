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
<<<<<<< HEAD
            translate(pos.x, pos.y);
=======
            translate(draw_pos.x, draw_pos.y);
>>>>>>> 19697bef3137ed4e9b0f0f62be7f8f75e786524c
            image(displayImage, 0, 0, 2 * hitbox_radius, 2 * hitbox_radius);
            popMatrix();
        }
    }
}
