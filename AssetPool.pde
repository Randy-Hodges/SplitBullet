// Author: Daniel Ross

import java.util.Map;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

class AssetPool {
    // FIELDS
    Minim audio_loader;

    private List<String> allowed_sprite_types, allowed_audio_types;
    HashMap<String,Sprite> sprites;
    HashMap<String,AudioPlayer> sounds;

    // CONSTRUCTORS
    AssetPool(boolean autofill, String... src_dirs) {
        audio_loader = new Minim(SplitBullet.this);
        allowed_sprite_types = Arrays.asList(".gif", ".jpg", ".jpeg", ".tga", ".png");
        allowed_audio_types = Arrays.asList(".wav", ".aiff", ".aif", ".au", ".snd", ".mp3");

        sprites = new HashMap();
        sounds = new HashMap();

        if (autofill) {
            for (String dir : src_dirs) {
                autoFill(dir);
            }
        }
    }
    AssetPool() {
        this(false, null);
    }

    // METHODS
    void addSprite(String label, Sprite sprite) {
        sprites.put(label, sprite);
    }

    void removeSprite(String label) {
        sprites.remove(label);
    }

    Sprite getSprite(String key) {
        return sprites.get(key);
    }

    void addSound(String label, AudioPlayer sound) {
        sounds.put(label, sound);
    }

    void removeSound(String label) {
        sounds.remove(label);
    }

    AudioPlayer getSound(String key) {
        return sounds.get(key);
    }

    private void search_files(File root, String src_dir_path) {
        for (File file : root.listFiles()) {
            if (!file.isHidden()) {
                if (file.isDirectory()) {
                    search_files(file, src_dir_path);
                } else if (file.isFile()) {
                    String file_name = file.getName();
                    String file_ext = file_name.substring(file_name.lastIndexOf('.'), file_name.length()).trim().toLowerCase();
                    String label = file.getParent().replace(src_dir_path, "").replaceAll("\\\\", "/").trim();

                    if (allowed_sprite_types.contains(file_ext)) {
                        addSprite(label, new Sprite(label, 1000, true));
                    } else if (allowed_audio_types.contains(file_ext)) {
                        new Thread() {
                            @Override
                            void run() {
                                addSound(label, audio_loader.loadFile(label + "/" + file_name));
                            }
                        }.start();
                    }
                }
            }
        }
    }

    void autoFill(String src_dir_name) {
        String root_path = sketchPath("");
        File src_dir = new File(root_path + src_dir_name);

        search_files(src_dir, root_path);
    }
}