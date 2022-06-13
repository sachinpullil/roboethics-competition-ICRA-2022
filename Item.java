class Item extends Entity 
{
  
  static final String DEFAULT_CLASS = "General";
  
  String item_class;
  
  //Item class with object class type
  Item(String name, String filepath, String item_class){
    super(name, filepath);
    this.item_class = item_class;
    println(item_class);
  }
  
  Item(String name, String filepath){
    this(name, filepath, DEFAULT_CLASS);
  }
}
