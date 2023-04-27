// Author: Daniel Ross

import java.util.Map;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

class AssetPool {
    // FIELDS
    Thread loading_thread;
    final ArrayList<Thread> subthreads, loading_files;

    // Object necessary for loading audio files
    // Used as audio_loader.loadFile(String path_to_file)
    // which returns a AudioPlayer object.
    private Minim audio_loader;

    // Lists of allowed sprite and audio file types
    // Limited by Processing's support
    private List<String> allowed_sprite_types, allowed_audio_types;

    // Dictionarys that store Sprite and AudioPlayer (sound file) Objects
    // If autofilled, access desired Sprite/Sound by their key, which defualts
    // to the path to that file, beginning at the Sketch root.
    // i.e. "media/sprites/player/player_running"
    HashMap<String,Sprite> sprites;
    HashMap<String,AudioPlayer> sounds;

    // CONSTRUCTORS
    // Can take an endless number of source directories. Will load Sprites
    // and Audio files from that directory and all subdirectories.
    AssetPool(boolean autofill, final String... src_dirs) {
        subthreads = new ArrayList<Thread>();
        loading_files = new ArrayList<Thread>();

        audio_loader = new Minim(SplitBullet.this);
        allowed_sprite_types = Arrays.asList(".gif", ".jpg", ".jpeg", ".tga", ".png");
        allowed_audio_types = Arrays.asList(".wav", ".aiff", ".aif", ".au", ".snd", ".mp3");

        sprites = new HashMap();
        sounds = new HashMap();

        if (autofill) {
            loading_thread = new Thread() {
                void run() {
                    for (final String dir : src_dirs) {
                        Thread loader = new Thread() {
                            void run() {
                                autoFill(dir);

                                for (final Thread loader : loading_files) {
                                    try {
                                        loader.join();
                                    } catch (Exception e) {

                                    }
                                }
                            }
                        };
                        loader.start();
                        subthreads.add(loader);
                    }

                    for (final Thread subthread : subthreads) {
                        try {
                            subthread.join();
                        } catch (Exception e) {
                            
                        }
                    }
                }
            };
            loading_thread.start();
        }
    }
    AssetPool() {
        this(false, null);
    }

    // METHODS

    // Add assets with String key, Object

    void addSprite(String label, Sprite sprite) {
        sprites.put(label, sprite);
    }

    void addSound(String label, AudioPlayer sound) {
        sounds.put(label, sound);
    }

    // Remove assets given String key 

    void removeSprite(String label) {
        sprites.remove(label);
    }

    void removeSound(String label) {
        sounds.remove(label);
    }

    // Get assets given String key

    Sprite getSprite(String key) {
        return sprites.get(key);
    }

    AudioPlayer getSound(String key) {
        return sounds.get(key);
    }

    // Finds all Sprites and audio files in a folder and its subfolders
    // and automatically adds them to the appropriate HashMap.
    void autoFill(String src_dir_name) {
        String root_path = sketchPath("");
        File src_dir = new File(root_path + src_dir_name);

        search_files(src_dir, root_path);
    }

    // Helper method for autoFill() that recursively dives into subfolders
    // searching for and adding Sprites and audio files
    private void search_files(File root, String src_dir_path) {
        for (File file : root.listFiles()) {
            if (!file.isHidden()) {
                if (file.isDirectory()) {
                    search_files(file, src_dir_path);
                } else if (file.isFile()) {
                    final String file_name = file.getName();
                    final String file_ext = file_name.substring(file_name.lastIndexOf('.'), file_name.length()).trim().toLowerCase();
                    final String label = file.getParent().replace(src_dir_path, "").replaceAll("\\\\", "/").trim();

                    if (allowed_sprite_types.contains(file_ext)) {
                        addSprite(label, new Sprite(label, 1000, true));
                    } else if (allowed_audio_types.contains(file_ext)) {
                        Thread thread = new Thread() {
                            @Override
                            public void run() {
                                addSound(label + "/" + file_name.substring(0, file_name.lastIndexOf('.')), audio_loader.loadFile(label + "/" + file_name));
                            }
                        };
                        thread.start();
                        loading_files.add(thread);
                    }
                }
            }
        }
    }

}