// Split Bullet
// Final Project: Your Own Graphics Project

// By Randy Hodges, Long Vu, Sean Thomas, Daniel Ross


MyGame GAME;
Game GAME;
int target_frame_rate = 20;
// The variables below are for testing purposes and will be removed in final product
Orc orc1;
PVector player_pos;

void setup() {
    size(1000, 1000, P2D);

    GAME = new MyGame();
    
    // Comment this out
    // GAME.screen_state = 2;
    frameRate(target_frame_rate);
    GAME = new Game();
    // Testing
    orc1 = new Orc(3*width/4, height/4);
    player_pos = new PVector(width/2, height/2);
}

void draw() {
    // GAME.run()
    GAME.update();
    background(#45c8fb);
    // GAME.run();
    // Testing
    fill(0);
    ellipse(player_pos.x, player_pos.y, 20, 20);
    orc1.move();
    orc1.render();
}

// INPUT HANDLING
void keyPressed() {
    if (!GAME.key_inputs.contains(keyCode)) {
        GAME.key_inputs.add(Integer.valueOf(keyCode));
    }
    if (!GAME.keys_pressed.contains(keyCode)) {
        GAME.keys_pressed.add(Integer.valueOf(keyCode));
    }
}

void keyReleased() {
    if (GAME.key_inputs.contains(keyCode)) {
        GAME.key_inputs.remove(Integer.valueOf(keyCode));
    }
    if (!GAME.keys_released.contains(keyCode)) {
        GAME.keys_released.add(Integer.valueOf(keyCode));
    }
}

void mousePressed() {
    if (!GAME.mouse_inputs.contains(mouseButton)) {
        GAME.mouse_inputs.add(Integer.valueOf(mouseButton));
    }
    if (!GAME.mouse_pressed.contains(mouseButton)) {
        GAME.mouse_pressed.add(Integer.valueOf(mouseButton));
    }
}

void mouseReleased() {
    if (GAME.mouse_inputs.contains(mouseButton)) {
        GAME.mouse_inputs.remove(Integer.valueOf(mouseButton));
    }
    if (!GAME.mouse_released.contains(mouseButton)) {
        GAME.mouse_released.add(Integer.valueOf(mouseButton));
    }
}

void mouseWheel(MouseEvent scroll) {
    Integer.valueOf(scroll.getCount());
}
