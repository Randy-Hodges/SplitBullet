import com.jogamp.newt.opengl.GLWindow;

class Game {
    GLWindow window_properties;
    Timer TIME;

    // Arrays of buttons pressed on current frame only
    ArrayList<Integer> keys_pressed, mouse_pressed;

    // Arrays of buttons released on current frame only
    ArrayList<Integer> keys_released, mouse_released;

    // Arrays of buttons currently held
    ArrayList<Integer> key_inputs, mouse_inputs;

    ArrayList<Actor> actors;
    boolean muted, paused;

    Game() {
        window_properties = (GLWindow)surface.getNative();
    }

    void clearInputBuffers() {
        keys_pressed.clear();
        keys_released.clear();
        mouse_pressed.clear();
        mouse_released.clear();
    }

    void simulate() {
        for (Actor actor : actors) {
            actor.simulate();
        }
    }

    void move() {
        for (Actor actor : actors) {
            actor.move();
        }
    }

    void render() {
        for (Actor actor : actors) {
            actor.render();
        }
    }

    void run() {
        render();

        if (!paused) {
            simulate();
            move();
        } else {
            // draw pause UI
        }

        clearInputBuffers();
    }
}