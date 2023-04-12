class Hat extends Actor{
    String framefilename;
    PImage frame;
    int frameNum;

    Hat()
    {

    }

    void animate()
    {
        frameNum++;
        framefilename = "frame_" + nf(frameNum % 30, 2) + "_delay-0.03s.gif";
        frame = loadImage(framefilename)
    }

    void display()
    {
        displayImage(framefilename, pos.x, pos.y, 30, 30);
    }
}