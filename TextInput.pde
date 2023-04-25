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
    // Convert to ASCII value and don't include special characters
    int ascii_value = (int) character;
    
    if (ascii_value >= 32 && ascii_value <= 126) {
      if (text.length() < max_characters) {
        text += Character.toUpperCase(character);
      }
    }
  }

  void remove_char() {
    if (text.length() > 0) {
      text = text.substring(0, text.length() - 1);
      //print(text);
      //print("\n");
    }
  }
}
