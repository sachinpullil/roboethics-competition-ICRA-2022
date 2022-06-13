import uibooster.*;
import uibooster.components.*;
import uibooster.model.*;
import uibooster.model.formelements.*;
import uibooster.model.options.*;
import uibooster.utils.*;



import java.util.ArrayDeque;

class GUI {
    private static final int CONSOLE_HEIGHT = 200;
    private static final int BUTTON_HEIGHT = 100;
    private static final int BUTTON_WIDTH = 200;
    private static final int TEXT_SIZE = 30;
    private static final int MARGIN_LEFT = 10;
    private final int TEXTLINE_YPOS = height - (CONSOLE_HEIGHT/2) - (TEXT_SIZE/2);
    private final int CONSOLE_YBASE = height - 10;
    private final int BUTTONLINE_YPOS = height - (CONSOLE_HEIGHT/2) - (BUTTON_HEIGHT/2) - (TEXT_SIZE/2);
    private static final int MAX_CONSOLE_LINES = 6;

    private String currentRequester = "Amy Copper";
    private String currentTarget = "Credit Card";
    private String currentReceiver = "Jill Smith";

    private ArrayList<String> requesterOptions;
    private ArrayList<String> targetOptions;
    private ArrayList<String> receiverOptions;
    private ArrayList<String> userRoles;
    private ArrayList<String> itemClasses;
    private ArrayList<String> roomNames;

    private ArrayDeque<String> consoleLines;

    private UIState uiState; 
    
    private String record_data_setting = "ON";
    private String alternate_record_data_setting = "OFF";
    private String recorded_data;

    GUI(){

        this.requesterOptions = new ArrayList<String>(Scenario.instance().characters.keySet());
        this.targetOptions = new ArrayList<String>(Scenario.instance().items.keySet());
        this.receiverOptions = new ArrayList<String>();
        this.roomNames = new ArrayList<String>();
        this.consoleLines = new ArrayDeque<String>(6);

        this.uiState = UIState.INPUT;



        for (String characterName : Scenario.instance().characters.keySet()) {
            this.receiverOptions.add(characterName);
        }
        for (String roomName : Scenario.instance().rooms.keySet()) {
            this.receiverOptions.add(roomName);
            this.roomNames.add(roomName);
        }
        
        this.userRoles = new ArrayList<String>();
        userRoles.add("Administrator");
        userRoles.add("Full User");
        userRoles.add("Partial User");
        userRoles.add("Non-household Member");
        userRoles.add("Official");
        userRoles.add("NOT USER");
        
        this.itemClasses = new ArrayList<String>();
        itemClasses.add("Infeasible");
        itemClasses.add("Dangerous_R");
        itemClasses.add("Dangerous_P");
        itemClasses.add("General Ban");
        itemClasses.add("UD Ban");
        itemClasses.add("Emergency");
        itemClasses.add("Financial");
        itemClasses.add("Personal");
        itemClasses.add("General");
    }

    void update(Controller controller){
        fill(c_dark);
        rect(0, height-CONSOLE_HEIGHT, width, CONSOLE_HEIGHT);

        switch (uiState) {
            case INPUT:
                renderInputMenu();
                break;
            default:
                renderTerminalFeedback();
                break;
        }
    }

    private void renderInputMenu(){
            if(Button(currentRequester, MARGIN_LEFT, BUTTONLINE_YPOS, BUTTON_WIDTH, BUTTON_HEIGHT)){
                String selection = new UiBooster().showSelectionDialog(
                                                                        "Select requester:",
                                                                        "Requester Character",
                                                                        this.requesterOptions
                                                                        );
                if(selection != null) currentRequester = selection;                
            };

            text("requests: bring", 
                MARGIN_LEFT + 330, 
                TEXTLINE_YPOS);

            if(Button(currentTarget, MARGIN_LEFT + 460, BUTTONLINE_YPOS, BUTTON_WIDTH, BUTTON_HEIGHT)){
                String selection = new UiBooster().showSelectionDialog(
                                                                        "Select item:",
                                                                        "Item to Bring",
                                                                        this.targetOptions
                                                                        );
                if(selection != null) currentTarget = selection;
            };

            text("to: ", 
                MARGIN_LEFT + 710, 
                TEXTLINE_YPOS);

            if(Button(currentReceiver, 
                    MARGIN_LEFT + 740, 
                    BUTTONLINE_YPOS, 
                    BUTTON_WIDTH, 
                    BUTTON_HEIGHT)){
                        String selection = new UiBooster().showSelectionDialog(
                                                                        "Select receiver:",
                                                                        "Destination",
                                                                        this.receiverOptions
                                                                        );
                if(selection != null) currentReceiver = selection;
            };

            if(Button("> Execute", 
                    width - BUTTON_WIDTH - MARGIN_LEFT, 
                    BUTTONLINE_YPOS, 
                    BUTTON_WIDTH, 
                    BUTTON_HEIGHT)){

                println("current requester: "+this.currentRequester);
                println("current target: "+this.currentTarget);
                println("current rec: "+this.currentReceiver);

                println("current receiver:");

                Entity destination = Scenario.instance().characters.get(this.currentReceiver);
                if(destination == null){
                    destination = Scenario.instance().rooms.get(this.currentReceiver);
                }

                controller.command(Scenario.instance().characters.get(this.currentRequester), 
                                Scenario.instance().items.get(this.currentTarget), 
                                destination);
                toggleState();
            };
            
            if(Button("Privacy Settings", 
                    width - 2*BUTTON_WIDTH - 2*MARGIN_LEFT, 
                    BUTTONLINE_YPOS, 
                    BUTTON_WIDTH, 
                    BUTTON_HEIGHT)){

                UiBooster booster = new UiBooster();
                Form form = booster.createForm("Privacy Settings")
                .addSelection("Record data",
                              Arrays.asList(record_data_setting, alternate_record_data_setting)).setID("data")
                .addButton("Show recorded data", () -> booster.showInfoDialog(this.recorded_data))
                .setChangeListener((element, value, this_form) -> {
                  if (element.getId().equals("data"))
                  {
                    String data_setting = this_form.getById("data").asString();
                    if(!data_setting.equals(record_data_setting))
                    {
                      updateTerminal("Data recording turned "+data_setting);
                      alternate_record_data_setting = record_data_setting;
                      record_data_setting = data_setting;
                    }
                  }                    
                })
                .show();
             };
             
             if(Button("Change User Roles", 
                    width - 3*BUTTON_WIDTH - 3*MARGIN_LEFT, 
                    BUTTONLINE_YPOS, 
                    BUTTON_WIDTH, 
                    BUTTON_HEIGHT)){

                UiBooster booster = new UiBooster();
                Form form = booster.createForm("User Roles")
                .addSelection(
                    "User",
                    this.requesterOptions).setID("user")
                .addSelection(
                    "Role",
                    this.userRoles).setID("role")
                .setCloseListener((this_form) -> {
                  String user = this_form.getById("user").asString();
                  String role = this_form.getById("role").asString();
                  new UiBooster().showConfirmDialog(
                      "Do you really want to change "+user+" to "+role+"?",
                      "Are you sure?",
                      () -> {
                        Character character = Scenario.instance().characters.get(user);
                        Character updated_character = new Character(character.name, character.imagePath, role);
                        
                        Scenario.instance().characters.remove(user);
                        Scenario.instance().characters.put(user, updated_character);
                        InitializeCharacters(Scenario.instance());
                        
                        for(Room room : Scenario.instance().rooms.values()) {
                          if(room.characters.contains(character)){
                            room.removeCharacter(character);
                            room.addCharacter(updated_character);
                            break;
                          }
                        }
                       
                      },
                      () -> {}); 
                })
                .show();
             };
             
             if(Button("Add New User/Item", 
                    width - 4*BUTTON_WIDTH - 4*MARGIN_LEFT, 
                    BUTTONLINE_YPOS, 
                    BUTTON_WIDTH, 
                    BUTTON_HEIGHT)){
                
                UiBooster booster = new UiBooster();
                Form form = booster.createForm("Add New User/Item")
                .addSelection("Select Item or User",
                              Arrays.asList("User", "Item")).setID("type")
                .addText("Name").setID("name")                
                .addSelection("If user, enter role. Otherwise, ignore.",
                              this.userRoles).setID("role")
                .addSelection("If item, enter class. Otherwise, ignore.",
                              this.itemClasses).setID("class")
                .addSelection("Room",
                              this.roomNames).setID("room")             
                .addText("Image path (optional)").setID("imgpath")
                .setCloseListener((this_form) -> {
                  String type = this_form.getById("type").asString();
                  String name = this_form.getById("name").asString();
                  String role = this_form.getById("role").asString();
                  String item_class = this_form.getById("class").asString();
                  String imgpath = this_form.getById("imgpath").asString();
                  String room = this_form.getById("room").asString();
                  
                  if(type.equals("User"))
                  {
                    if(imgpath.isEmpty())
                        imgpath = "assets/characters/person.png";                    
                    
                    Character new_character = new Character(name, imgpath, role);
                    Scenario.instance().characters.put(name, new_character);
                    this.receiverOptions.add(name);
                    this.requesterOptions.add(name);
                    
                    InitializeCharacters(Scenario.instance());
                    Room char_room = Scenario.instance().rooms.get(room);
                    char_room.addCharacter(new_character);              
                  }
                  else
                  {
                    if(imgpath.isEmpty())
                        imgpath = "assets/items/thing.png";
                    
                    Item new_item = new Item(name, imgpath, item_class);
                    Scenario.instance().items.put(name, new_item);
                    this.targetOptions.add(name);
                    
                    InitializeItems(Scenario.instance());
                    Room item_room = Scenario.instance().rooms.get(room);
                    item_room.addItem(new_item);
                  }             
                })
                .show();
                      
                      
            };
            
            if(Button("View Access Rules", 
                    width - BUTTON_WIDTH - MARGIN_LEFT, 
                    BUTTONLINE_YPOS - BUTTON_HEIGHT - MARGIN_LEFT, 
                    BUTTON_WIDTH, 
                    BUTTON_HEIGHT)){
                      
               new UiBooster().showPictures(
              "Access Rule Table",
              Arrays.asList(
                  new File(sketchPath()+"/assets/access_rule_table.jpg"))
              );
                      
            };
    }

    public void renderTerminalFeedback(){
        fill(255,255,255);
        textAlign(LEFT);

        int i = 0;
        for (String msg : this.consoleLines) {
            if(msg != null){
                text(msg, MARGIN_LEFT, CONSOLE_YBASE - (i * TEXT_SIZE));
            }
            i++;
        }
    }

    public void updateTerminal(String msg){
        if(this.consoleLines.size() >= 6){
            this.consoleLines.removeLast();
        }
        this.consoleLines.push(msg);
        
        if(record_data_setting.equals("ON"))
          this.recorded_data += msg + "\n";
    }

    public void toggleState(){
        if (this.uiState == UIState.INPUT) this.uiState = UIState.FEEDBACK;
        else this.uiState = UIState.INPUT;
    }
}
