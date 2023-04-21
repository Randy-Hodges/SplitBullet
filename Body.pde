class Body extends Actor
{

    String framefilename;
    PImage frame;
    int frameNum;

    Body(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot)
    {
        super(hitbox_radius,  pos,  vel,  accel,  scale,  rot);
    }

    void animate()
    {
        frameNum++;
        if(vel.mag() == 0)
            framefilename = "media/sprites/player/body_idle/idle_" + nf(frameNum % 17, 2) + "_delay-0.03s.gif";
        else
            framefilename = "media/sprites/player/body_running/run_" + nf(frameNum % 17, 2) + "_delay-0.03s.gif";

        frame = loadImage(framefilename);
    }

    void display()
    {
        animate();
        imageMode(CENTER);
        image(frame, 0, 0, 2 * hitbox_radius, 1.656* hitbox_radius);
    }
}