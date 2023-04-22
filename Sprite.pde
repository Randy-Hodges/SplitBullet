// Author: Daniel Ross

class Sprite {
    // FIELDS
    String src_dir, filename, filetype;
    int filenum_pad, first_frame, num_frames, anim_length;

    Timer time;

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

        this.time = new Timer();

        createArray();
    }
    Sprite(String src_dir, String filename, int filename_framenum_leadingzeroes, String filetype, int anim_length_in_ms, boolean loops) {
        this(src_dir, filename, filename_framenum_leadingzeroes, filetype, anim_length_in_ms, loops, 0);
    }
    Sprite(String src_dir, String filename, int filename_framenum_leadingzeroes, String filetype, int anim_length_in_ms) {
        this(src_dir, filename, filename_framenum_leadingzeroes, filetype, anim_length_in_ms, true, 0);
    }

    // METHODS
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
        calcNumFrames();

        image_buffer = new PImage[num_frames];

        for (int i = 0; i < num_frames; i++) {
            image_buffer[i] = loadImage(src_dir + filename + nf(i, filenum_pad) + filetype);
        }

        return image_buffer;
    }
}