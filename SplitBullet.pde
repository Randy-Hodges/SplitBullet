// Split Bullet
// Final Project: Your Own Graphics Project

// By Randy Hodges, Long Vu, Sean Thomas, Daniel Ross


// Game GAME;

void setup() {
    size(1000, 1000, P2D);

    // GAME = new Game();
}

void draw() {
    // GAME.run();
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