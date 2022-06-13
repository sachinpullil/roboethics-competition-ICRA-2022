import processing.core.PApplet;
import processing.core.PImage;


class Character extends Entity
{
  static final String DEFAULT_ROLE = "NOT_USER";
  
  String role;
  
  //Character class with operator role type
  Character(String name, String filepath, String role)
  {
    super(name, filepath);
    this.role = role;
  }
  
  Character(String name, String filepath){
    this(name, filepath, DEFAULT_ROLE);
  }
}
