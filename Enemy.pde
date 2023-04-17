class Enemy extends Actor{
    int health;
    int frame_num, max_frames, frame_rate, sprite_time; // frame_rate is num frames/sec, sprite_time is time one frame is shown.
    PImage[] frames;

    Enemy(float hitbox_radius, PVector pos, PVector scale, int health, int max_frames, int frame_rate){
        super(hitbox_radius, pos, scale, 0);
        this.health = health;
        this.max_frames = max_frames;
        this.frame_rate = frame_rate;
        sprite_time = int(target_frame_rate/frame_rate);
        loadSprites();
    }

    void display(){
        imageMode(CENTER);
        image(frames[frame_num], 0, 0);
        cycleNextFrame();
    }

    void loadSprites(){
        println("loadSprites() not implemented yet");
    }

    void cycleNextFrame(){
        if (frameCount % sprite_time == 0){
            frame_num += 1;
            if (frame_num >= max_frames){
                frame_num = 0;
            }
        }
    }
}