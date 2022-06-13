import processing.core.PApplet;
import processing.core.PImage;

class Entity extends PApplet {
  String name;
  protected PImage img; 
  String imagePath; 
  
  
  Entity(String name, String imagePath){
    this.name = name;
    this.imagePath = imagePath;
    if(name.equals("Amy Copper"))
      println(imagePath);
  }

  public void init(PApplet papplet){
    this.img = papplet.loadImage(this.imagePath);
  }

  public void getImage(PApplet papplet, float x, float y, int width, int height){
    papplet.image(this.img, x, y, width, height);
  }

  public void update(PApplet papplet){};
}
