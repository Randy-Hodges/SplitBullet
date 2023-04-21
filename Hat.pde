class Hat extends Actor{
    String framefilename;
    PImage frame;
    int frameNum;

    Hat(float hitbox_radius, PVector pos, PVector vel, PVector accel, PVector scale, float rot)
    {
        super(hitbox_radius,  pos,  vel,  accel,  scale,  rot);

    }

    void animate()
    {
        frameNum++;
        framefilename = "media/sprites/player/hat_frames/frame_" + nf(frameNum % 30, 2) + "_delay-0.03s.gif";
        frame = loadImage(framefilename);
    }

    void display()
    {
        animate();
        imageMode(CENTER);
        image(frame, 0, 0,  hitbox_radius, 0.5* hitbox_radius);
    }
}