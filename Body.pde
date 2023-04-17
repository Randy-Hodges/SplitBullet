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
            framefilename = "idle_" + nf(frameNum % 17, 2) + "_delay-0.03s.gif";
        else
            framefilename = "run_" + nf(frameNum % 17, 2) + "_delay-0.03s.gif";

        frame = loadImage(framefilename);
    }

    void display()
    {
        image(frame, pos.x, pos.y, 30, 30);
    }
}