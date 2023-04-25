// Author: Daniel Ross

class Timer {
    // FIELDS
    protected int init_time; // millis() value when the object was initialized
    protected int reset_time; // millis() value when Timer was last reset

    protected int elapsed_time; // ms since object was initialized
    protected int active_time; // ms since last reset when Timer was not paused
    protected int paused_time; // ms since last reset when Timer was paused
    
    protected int base_time; // ms the Timer should start with and reset to, and/or loop to

    // ms when Timer should end (or loop back to base_time if loop == true)
    // set to null to have endless Timer
    protected Integer end_time; 

    // ms, represents base_time + active_time if counting up,
    // or base_time - active_time if counting down
    // This is the value you usually want to query.
    protected int value; 

    protected boolean active; // true if not paused

    // Timer's state when initialized OR when reset IF reset_uses_default is true.
    protected boolean default_state;

    // true if Timer's active state should be set to default_state when the Timer is reset.
    protected boolean reset_uses_default;

    protected boolean loop; // should the timer loop to base_time when value exceeds end_time
    protected boolean counts_down; // should the timer count down from base_time rather than up

    // CONSTRUCTORS
    // All other constructors pass to this one
    Timer(boolean init_state, boolean default_state, boolean reset_uses_default, int base_time, Integer end_time, boolean counts_down, boolean loops) {
        this.active = init_state;

        set(default_state, reset_uses_default, base_time, end_time, counts_down, loops);

        this.init_time = millis();
        this.reset_time = init_time;
    }
    Timer(boolean init_state, boolean default_state, boolean reset_uses_default, int base_time, Integer end_time, boolean counts_down) {
        // boolean init_state, boolean default_state, boolean reset_uses_default, int base_time, Integer end_time, boolean counts_down, boolean loops
        this(      init_state,         default_state,         reset_uses_default,     base_time,         end_time,         counts_down,         false);
    }
    Timer(boolean init_state, int base_time, Integer end_time, boolean counts_down, boolean loops) {
        // boolean init_state, boolean default_state, boolean reset_uses_default, int base_time, Integer end_time, boolean counts_down, boolean loops
        this(      init_state,         init_state,            false,                  base_time,         end_time,         counts_down,         loops);
    }
    Timer(boolean init_state, int base_time, Integer end_time, boolean counts_down) {
        // boolean init_state, boolean default_state, boolean reset_uses_default, int base_time, Integer end_time, boolean counts_down, boolean loops
        this(      init_state,         init_state,            false,                  base_time,         end_time,         counts_down,         false);
    }
    Timer(boolean init_state, int base_time, Integer end_time) {
        // boolean init_state, boolean default_state, boolean reset_uses_default, int base_time, Integer end_time, boolean counts_down, boolean loops
        this(      init_state,         init_state,            false,                  base_time,         end_time,         false,               false);
    }
    Timer(boolean init_state, boolean default_state, boolean reset_uses_default) {
        // boolean init_state, boolean default_state, boolean reset_uses_default, int base_time, Integer end_time, boolean counts_down, boolean loops
        this(      init_state,         default_state,         reset_uses_default,     0,                 null,             false,               false);
    }
    Timer(boolean default_state) {
        // boolean init_state, boolean default_state, boolean reset_uses_default, int base_time, Integer end_time, boolean counts_down, boolean loops
        this(      default_state,      default_state,         false,                  0,                 null,             false,               false);
    }
    Timer() {
        // boolean init_state, boolean default_state, boolean reset_uses_default, int base_time, Integer end_time, boolean counts_down, boolean loops
        this(      true,               true,                  false,                  0,                 null,             false,               false);
    }

    // METHODS

    // Use the following methods to access the Timer's time values
    
    // ms = start_time + active_time if counting up,
    // or end_time - active_time if counting down
    // This is the value you usually want to query.
    int value() {
        update();
        return value;
    }

    int endTime() {
        return end_time;
    }

    int baseTime() {
        return base_time;
    }

    int activeTime() {
        update();
        return active_time;
    }

    int pausedTime() {
        update();
        return paused_time;
    }

    int elapsedTime() {
        update();
        return elapsed_time;
    }

    int initTime() {
        return init_time;
    }

    int resetTime() {
        update();
        return resetTime();
    }

    boolean active() {
        return active;
    }

    boolean loops() {
        return loop;
    }

    boolean countsDown() {
        return counts_down;
    }

    boolean defaultState() {
        return default_state;
    }

    boolean resetUsesDefault() {
        return reset_uses_default;
    }

    // Use the following methods to manipulate the timer
    void pause() {
        update();
        active = false;
    }

    void resume() {
        update();
        active = true;
    }

    void toggle() {
        update();
        active = !active;
    }

    void reverse() {
        setCountDown(!counts_down, end_time, base_time);
    }

    void countDown() {
        if (!counts_down) {
            reverse();
        }
    }

    void countUp() {
        if (counts_down) {
            reverse();
        }
    }

    void reset() {
        active_time = paused_time = 0;
        reset_time = millis();

        if (reset_uses_default) {
            active = default_state;
        }
    }

    // Alternate reset method if you want to manually specify the Timer's
    // active state; bypasses default_state and reset_uses_default
    void reset(boolean new_active_state) {
        active_time = paused_time = 0;
        reset_time = millis();

        active = new_active_state;
    }

    // Use these methods to change the timer's behavior
    void set(boolean default_state, boolean reset_uses_default, int base_time, Integer end_time, boolean counts_down, boolean loops) {
        setResetDefaults(default_state, reset_uses_default);
        setLoop(loops, base_time, end_time, counts_down);
    }

    void setCountDown(boolean counts_down, int base_time, Integer end_time) {
        setStartEnd(base_time, end_time);
        setCountDown(counts_down);
    }

    void setCountDown(boolean counts_down, int base_time) {
        setBaseTime(base_time);
        setCountDown(counts_down);
    }

    void setCountDown(boolean counts_down) {
        if ((counts_down == true) && (end_time!= null) && (end_time > base_time)) {
            throw new RuntimeException("end_time cannot be greater than base_time if counts_down is true.");
        } else {
            this.counts_down = counts_down;
        }
    }

    void setStartEnd(int base_time, Integer end_time) {
        setBaseTime(base_time);
        setEndTime(end_time);
    }

    void setBaseTime(int start_time) {
        this.base_time = start_time;
    }

    void setEndTime(Integer end_time) {
        this.end_time = end_time;
    }

    void setLoop(boolean loops, int base_time, Integer end_time, boolean counts_down) {
        setCountDown(counts_down, base_time, end_time);
        setLoop(loops);
    }

    void setLoop(boolean loops, int base_time, Integer end_time) {
        setStartEnd(base_time, end_time);
        setLoop(loops);
    }

    void setLoop(boolean loops, Integer end_time) {
        setEndTime(end_time);
        setLoop(loops);
    }

    void setLoop(boolean loops) {
        if (loops && end_time == null) {
            throw new RuntimeException("Timer cannot be asked to loop when end_time is null.");
        } else {
            this.loop = loops;
        }
    }

    void setResetDefaults(boolean default_state, boolean reset_uses_default) {
        setDefaultState(default_state);
        setResetBehavior(reset_uses_default);
    }

    void setDefaultState(boolean default_state) {
        this.default_state = default_state;
    }

    void setResetBehavior(boolean reset_uses_default) {
        this.reset_uses_default = reset_uses_default;
    }

    // This following methods are not designed to be called outside the class
    protected void update() {
        elapsed_time = millis() - init_time;

        if (active) {
            active_time = millis() - reset_time - paused_time;
        } else {
            paused_time = millis() - reset_time - active_time;
        }

        if (counts_down) {
            if (end_time == null) {
                value = base_time - active_time;
            } else {
                value = base_time - (active_time + end_time);
                
                if (value < end_time) {
                    if (loop) {
                        reset();
                        active_time = value - end_time;
                        update();
                    } else {
                        value = end_time;
                    }
                }
            }
        } else {
            value = base_time + active_time;

            if (!(end_time == null)) {
                if (value > end_time) {
                    if (loop) {
                        reset();
                        active_time = value - end_time;
                        update();
                    } else {
                        value = end_time;
                    }
                }
            }
        }
    }

}