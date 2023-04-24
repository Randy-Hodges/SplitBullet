// Author: Daniel Ross

class Timer {
    // FIELDS
    int init_time; // system time when the object was initialized
    int reset_time; // system time when Timer was last reset
    int elapsed_time; // time since object was initialized
    int active_time; // time since last reset when Timer was not paused
    int paused_time; // time since last reset when Timer was paused
    int loop_time; // time when Timer should loop (reset) if >=

    boolean active; // true if not paused

    // Timer's state when initialized OR when reset IF reset_uses_default is true.
    boolean default_state;

    // true if Timer's active state should be set to default_state when the Timer is reset.
    boolean reset_uses_default;

    boolean loop;

    // CONSTRUCTORS
    Timer(boolean init_state, boolean default_state, boolean reset_uses_default, boolean loops, int loop_time) {
        this.active = init_state;
        this.default_state = default_state;
        this.reset_uses_default = reset_uses_default;

        this.loop = loops;
        this.loop_time = loop_time;

        this.init_time = millis();
        this.reset_time = init_time;
    }
    Timer(boolean init_state, boolean default_state, boolean reset_uses_default) {
        this(init_state, default_state, reset_uses_default, false, 0);
    }
    Timer(boolean default_state) {
        this(default_state, default_state, false, false, 0);
    }
    Timer() {
        this(true, true, false, false, 0);
    }

    // METHODS
    void update() {
        if (active) {
            active_time = millis() - reset_time - paused_time;
        } else {
            paused_time = millis() - reset_time - active_time;
        }
        elapsed_time = millis() - init_time;

        if (loop) {
            loop();
        }
    }

    // Use these methods to manipulate the timer
    void setDefaultState(boolean default_state) {
        this.default_state = default_state;
    }

    void setResetBehavior(boolean reset_uses_default) {
        this.reset_uses_default = reset_uses_default;
    }

    void setResetDefaults(boolean default_state, boolean reset_uses_default) {
        setDefaultState(default_state);
        setResetBehavior(reset_uses_default);
    }

    void toggle() {
        update();
        active = !active;
    }

    void resume() {
        update();
        active = true;
    }

    void pause() {
        update();
        active = false;
    }

    void reset() {
        active_time = paused_time = 0;
        reset_time = millis();

        if (reset_uses_default) {
            active = default_state;
        }
    }

    void loop() {
        if (active_time >= loop_time) {
            int loop_spill = active_time - loop_time;
            reset();
            active_time = loop_spill;
        }
    }

    // Alternate reset method if you want to manually specify the Timer's
    // active state; bypasses default_state and reset_uses_default
    void reset(boolean new_active_state) {
        active_time = paused_time = 0;
        reset_time = millis();

        active = new_active_state;
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