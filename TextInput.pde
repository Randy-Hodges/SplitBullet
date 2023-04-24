class TextInputField {
  PVector position;
  PVector size;
  String text;
  boolean active;
  int max_characters;

  TextInputField(PVector position, PVector size, int max_characters) {
    this.position = position;
    this.size = size;
    this.max_characters = max_characters;
    this.text = "";
    //this.active = false;
  }

  void draw() {
    pushMatrix();
    fill(200); // Set the default fill color for the rectangle
    rect(position.x, position.y, size.x, size.y);
    fill(0); // Set the default fill color for the text
    textAlign(LEFT, CENTER);
    textSize(24);
    text(text, position.x + 10, position.y + size.y / 2);
    popMatrix();
  }

  void add_char(char character) {
    if (text.length() < max_characters) {
      text += character;
    }
  }

  void remove_char() {
    if (text.length() > 0) {
      text = text.substring(0, text.length() - 1);
    }
  }
}
//  void set_active(boolean active) {
//    this.active = active;
//  }

//  boolean is_active() {
//    return active;
//  }
//}
