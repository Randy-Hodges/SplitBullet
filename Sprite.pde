// Author: Daniel Ross

import java.util.Scanner;
import java.util.Collections;

class Sprite {
    // FIELDS

    // path from Sketch root to the directory that contains sprite frames
    // i.e. "media/sprites/other" or "media/sprites/player/body_idle"
    String src_dir;

    // The shared name between all frames
    String filename;
    
    // The shared filetype between all frames
    String filetype;

    // Number of digits in all frame's frame number
    // i.e. a file "spriteframe003" should be 3 or
    // a file sprite_frame_6 should be 1.
    int filenum_pad;
    
    // The frame value of the first frame in the sequence
    // Usually will either be 0 or 1
    int first_frame;
    
    // Number of frames in the sprite image sequence
    int num_frames;
    
    // length in ms the sprite animation should take to complete
    int anim_length;

    // timer used to determine which frame should be displayed
    Timer timer;

    // Array that stores the loaded PImages
    PImage[] image_buffer;

    // boolean for whether the image sequence should loop
    boolean loop;


    // CONSTRUCTORS

    // You will probably want to use the last constructor in most situations.
    // These are for manually loading a Sprite
    Sprite(String src_dir, String filename, int filename_framenum_leadingzeroes, String filetype, int anim_length_in_ms, boolean loops, int first_frame_num) {
        src_dir.trim();
        filename.trim();
        filetype.trim();

        if (!src_dir.endsWith("/")) {
            src_dir += "/";
        }

        if (!filetype.startsWith(".")) {
            filetype = "." + filetype;
        }

        this.src_dir = src_dir;
        this.filename = filename;
        this.filenum_pad = filename_framenum_leadingzeroes;
        this.filetype = filetype;

        this.first_frame = first_frame_num;
        this.anim_length = anim_length_in_ms;
        this.loop = loops;

        this.timer = new Timer(true, 0, anim_length_in_ms, false, loops);

        calcNumFrames();
        createArray();
    }
    Sprite(String src_dir, String filename, int filename_framenum_leadingzeroes, String filetype, int anim_length_in_ms, boolean loops) {
        this(src_dir, filename, filename_framenum_leadingzeroes, filetype, anim_length_in_ms, loops, 0);
    }
    Sprite(String src_dir, String filename, int filename_framenum_leadingzeroes, String filetype, int anim_length_in_ms) {
        this(src_dir, filename, filename_framenum_leadingzeroes, filetype, anim_length_in_ms, true, 0);
    }

    // You will probably want to use this constructor
    // Although, I would recommend grabbing the Sprite you want from
    // MyGame.assets instead, since it is already loaded.
    Sprite(String src_dir, int anim_length_in_ms, boolean loops) {
        src_dir.trim();

        if (!src_dir.endsWith("/")) {
            src_dir += "/";
        }

        this.src_dir = src_dir;
        this.anim_length = anim_length_in_ms;
        this.loop = loops;

        fillFields();
        createArray();

        this.timer = new Timer(true, 0, anim_length_in_ms, false, loops);
    }

    // METHODS

    // This is the only method you should really care about.
    // Used to pull the appropriate frame in the image sequence.
    // Common usage: image([your_sprite_var_name].getFrame(), 0, 0, 1, 1);
    PImage getFrame() {
        return image_buffer[constrain(timer.value() / int(ceil(float(anim_length) / num_frames)), 0, num_frames-1)];
    }
    
    void setAnimLength(int length) {
        anim_length = length;
        if (timer.countsDown()) {
            timer.setBaseTime(length);
        } else {
            timer.setEndTime(length);
        }
    }

    void setLoop(boolean loops) {
        loop = loops;
        timer.setLoop(loops);
    }

    // The following methods are used for building the Sprite object.
    // You probably will never need them.

    // Given that this instance already has its src_dir, anim_length, and loop
    // fields filled already, this method will automatically fill all other fields
    // with appropriate values.
    void fillFields() {
        File[] files = new File(sketchPath("") + "data\\" + src_dir).listFiles();

        ArrayList<String> file_names = new ArrayList<String>();
        for (File file : files) {
            if (file.isFile() && !file.isHidden()) {
                file_names.add(file.getName());
            }
        }
        
        ArrayList<String> trimmed_file_names = new ArrayList<String>();
        ArrayList<String> file_types = new ArrayList<String>();
        ArrayList<String> file_nums = new ArrayList<String>();

        for (String file_name : file_names) {
            String file_num = "";
            for (int i = file_name.length() - 1; i > 0; i--) {
                if (Character.isDigit(file_name.charAt(i))) {
                    file_num = file_name.charAt(i) + file_num;
                } else if (file_num.length() > 0) {
                    break;
                }
            }
            String file_type = file_name.substring(file_name.lastIndexOf('.'), file_name.length());
            String trimmed_name = file_name.replace(file_type, "").replace(file_num, "");

            trimmed_file_names.add(trimmed_name);
            file_types.add(file_type);
            file_nums.add(file_num);
        }

        Collections.sort(file_nums);
        this.first_frame = Integer.parseInt(file_nums.get(0));
        this.num_frames = file_nums.size();
        this.filenum_pad = file_nums.get(0).length();

        this.filename = trimmed_file_names.get(0);
        this.filetype = file_types.get(0);
    }

    // Calculates the number of frames (mostly deprecated by fillFields())
    int calcNumFrames() {
        num_frames = 0;

        File dir = new File(sketchPath("") + src_dir);
        File[] frame_list = dir.listFiles();

        for (File frame_file : frame_list) {
            if ((frame_file.isFile()) && (frame_file.getName().contains(filename))) {
                num_frames ++;
            }
        }

        return num_frames;
    }

    // Fills the image_buffer array with PImages of the frames in the specified
    // src_dir folder.
    PImage[] createArray() {
        image_buffer = new PImage[num_frames];

        for (int i = 0; i < num_frames; i++) {
            image_buffer[i] = requestImage(src_dir + filename + nf(i, filenum_pad) + filetype);
        }

        return image_buffer;
    }
}
