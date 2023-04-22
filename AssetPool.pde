// Author: Daniel Ross

import java.util.Map;

class AssetPool {
    // FIELDS
    private String[] allowed_sprite_types;
    HashMap<String,Sprite> sprites;

    // CONSTRUCTORS
    AssetPool(boolean autofill, String src_dir) {
        sprites = new HashMap();
        allowed_sprite_types = new String[] {".gif", ".jpg", ".tga", ".png"};

        if (autofill) {
            autoFill(src_dir);
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

    private void search_files(File root, String src_dir_path) {
        for (File file : root.listFiles()) {
            if (file.isDirectory()) {
                search_files(file, src_dir_path);
            } else if (file.isFile()) {
                for (String file_type : allowed_sprite_types) {
                    if (file.getName().contains(file_type)) {
                        String label = file.getParent().replace(src_dir_path, "").replaceAll("\\\\", "/").trim();
                        addSprite(label, new Sprite(label, 1000, true));
                    }
                }
            }
        }
    }

    void autoFill(String src_dir_name) {
        String root_path = sketchPath("");
        File root = new File(root_path);
        File src_dir = new File(root_path + src_dir_name);

        search_files(src_dir, root_path);
    }
}