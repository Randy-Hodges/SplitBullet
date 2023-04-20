// Author: Daniel Ross

class Timer {
    // FIELDS
    int init_time; // system time when the object was initialized
    int reset_time; // system time when Timer was last reset
    int elapsed_time; // time since object was initialized
    int active_time; // time since last reset when Timer was not paused
    int paused_time; // time since last reset when Timer was paused

    boolean active; // true if not paused
    boolean reset_forces_active; // resetting forces timer to be active if true

    // CONSTRUCTORS
    Timer(boolean active, boolean reset_forces_active) {
        this.init_time = millis();
        this.reset_time = init_time;
        this.active = active; 
        this.reset_forces_active = reset_forces_active;
    }
    Timer(boolean active) {
        this(active, false);
    }
    Timer() {
        this(true, false);
    }

    // METHODS
    void update() {
        if (active) {
            active_time = millis() - reset_time - paused_time;
        } else {
            paused_time = millis() - reset_time - active_time;
        }
        elapsed_time = millis() - init_time;
    }

    // Use these methods to manipulate the timer
    void toggle() {
        active = !active;
    }

    void resume() {
        active = true;
    }

    void pause() {
        active = false;
    }

    void reset() {
        active_time = paused_time = 0;
        reset_time = millis();

        if (reset_forces_active) {
            active = true;
        }
    }

    // Use these methods to access the Timer's time values
    int getActiveTime() {
        update();
        return active_time;
    }

    int getPausedTime() {
        update();
        return paused_time;
    }

    int getElapsedTime() {
        update();
        return elapsed_time;
    }
}