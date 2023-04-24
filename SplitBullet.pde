// Split Bullet
// Final Project: Your Own Graphics Project

// By Randy Hodges, Long Vu, Sean Thomas, Daniel Ross

import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;
import java.awt.DisplayMode;

MyGame GAME;
// The variables below are for testing purposes and will be removed in final product
Player p1;
float target_frame_rate = 20;

void setup() {
    int FR = GraphicsEnvironment.getLocalGraphicsEnvironment().getScreenDevices()[0].getDisplayMode().getRefreshRate();

    size(1000, 1000, P2D);
    frameRate(target_frame_rate);

    GAME = new MyGame(100);

    // Testing
    // GAME.actor_spawns.add(new OrcShaman(new PVector(width/4, 3*height/4), 5000));
}

void draw() {
    // background(#45c8fb);
    GAME.update();
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
