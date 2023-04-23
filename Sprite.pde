// Author: Daniel Ross

import java.util.Scanner;
import java.util.Collections;

class Sprite {
    // FIELDS
    String src_dir, filename, filetype;
    int filenum_pad, first_frame, num_frames, anim_length;

    Timer timer;

    PImage[] image_buffer;
    boolean loop;

    // CONSTRUCTORS
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

        this.timer = new Timer(true, true, true, loops, anim_length_in_ms);

        calcNumFrames();
        createArray();
    }
    Sprite(String src_dir, String filename, int filename_framenum_leadingzeroes, String filetype, int anim_length_in_ms, boolean loops) {
        this(src_dir, filename, filename_framenum_leadingzeroes, filetype, anim_length_in_ms, loops, 0);
    }
    Sprite(String src_dir, String filename, int filename_framenum_leadingzeroes, String filetype, int anim_length_in_ms) {
        this(src_dir, filename, filename_framenum_leadingzeroes, filetype, anim_length_in_ms, true, 0);
    }
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

        this.timer = new Timer(true, true, true, loops, anim_length_in_ms);
    }

    // METHODS
    void fillFields() {
        File[] files = new File(sketchPath("") + src_dir).listFiles();

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
            String trimmed_name = file_name.substring(0, file_name.lastIndexOf('.')).split("\\d(.*)")[0];
            String file_type = file_name.substring(file_name.lastIndexOf('.'), file_name.length());
            String file_num = "";
            for (int i = 0; i < file_name.length(); i++) {
                if (Character.isDigit(file_name.charAt(i))) {
                    file_num += file_name.charAt(i);
                } else if (file_num.length() > 0) {
                    break;
                }
            }

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

    PImage[] createArray() {
        image_buffer = new PImage[num_frames];

        for (int i = 0; i < num_frames; i++) {
            image_buffer[i] = loadImage(src_dir + filename + nf(i, filenum_pad) + filetype);
        }

        return image_buffer;
    }

    PImage getFrame() {
        return image_buffer[constrain(timer.getActiveTime() / int(ceil(float(anim_length) / num_frames)), 0, num_frames-1)];
    }
}