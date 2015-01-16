import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;

private ControlP5 cp5;

ControlFrame cf;

void guiSetup(){
   cp5 = new ControlP5(this);
   
  // by calling function addControlFrame() a
  // new frame is created and an instance of class
  // ControlFrame is instanziated.
  cf = addControlFrame("controlls", 400,400,sketchPath(""), this);
}


ControlFrame addControlFrame(String theName, int theWidth, int theHeight, String thePath, PApplet context) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight, thePath + "/data/", context);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
 
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}

void guiUpdate(){
  
}


// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded
public class ControlFrame extends PApplet {

  int w, h;
  
  ListBox l;
  Toggle sourceButton;
  
  ArrayList <String> sources;
  
 // String[] sources = {"Syphon"}; 
  String dataPath;
  PApplet mainContext;
  
  private void processFiles(){
    sources = new ArrayList();
    sources.add("Syphon");
    
    File dir = new File(dataPath);
  
    java.io.FilenameFilter filter = new java.io.FilenameFilter() {
     public boolean accept(File dir, String name) {
       return name.toLowerCase().endsWith(".jpg") || name.toLowerCase().endsWith(".png") || name.toLowerCase().endsWith(".mp4");
     }
    };
  
    File [] files = dir.listFiles(filter);
    for(int i =0; i< files.length; i++){
      String lfname = files[i].toString();
      int lastIndex  = lfname.lastIndexOf("/");
      String sfname = lfname.substring(lastIndex+1);
      sources.add(sfname);
      //println(sfname);
    }
  }
  
  private void refreshFiles(){
    processFiles();
    l.clear();
    for (int i=0;i<sources.size();i++) {
      String tempName = sources.get(i);
      ListBoxItem lbi = l.addItem(tempName, i);
      lbi.setColorBackground(0xffff0000);
    }
  }
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
    processFiles();
   
    int locY = 50;
   
    cp5.addButton("mode").setPosition(20,locY);
    cp5.addButton("addQuad").setPosition(20,locY+=30);
    cp5.addButton("addBezier").setPosition(20,locY+=30);
    cp5.addButton("remove").setPosition(20,locY+=30);
    cp5.addTextlabel("resolution").setText("Resolution control").setPosition(20,locY+=30);
    cp5.addButton("res_minus").setLabel("-").setSize(20,20).setPosition(20,locY+=20);
    cp5.addButton("res_plus").setLabel("+").setSize(20,20).setPosition(45,locY);
    
    cp5.addTextlabel("Force").setText("Force control").setPosition(20,locY+=30);
    cp5.addButton("force_minus").setLabel("-").setSize(20,20).setPosition(20,locY+=20);
    cp5.addButton("force_plus").setLabel("+").setSize(20,20).setPosition(45,locY);
    
    cp5.addButton("refreshL").setLabel("Refresh List").setPosition(100, 50).setWidth(120);
    l = cp5.addListBox("myList")
           .setPosition(100, 100)
           .setSize(120, 120)
           .setItemHeight(15)
           .setBarHeight(15)
           .setColorBackground(color(255, 128))
           .setColorActive(color(0))
           .setColorForeground(color(255, 100,0))
           ;
  
    l.captionLabel().toUpperCase(true);
    l.captionLabel().set("Sources");
    l.captionLabel().setColor(0xffff0000);
    l.captionLabel().style().marginTop = 3;
    l.valueLabel().style().marginTop = 3;
    
    for (int i=0;i<sources.size();i++) {
      String tempName = sources.get(i);
      ListBoxItem lbi = l.addItem(tempName, i);
      lbi.setColorBackground(0xffff0000);
    }
   
  // sourceButton = cp5.addToggle("sourceControl").setLabel("Static").setPosition(100, 50).setMode(ControlP5.SWITCH);
  // sourceButton.setValue(true);

   cp5.setAutoDraw(false); 
  }

  public void draw() {
      background(0);
      
      cp5.draw();
  }
  
  public void keyPressed(){
    if(key == ' ')vmap.toggleCalibration();
    if(key=='p') preview = ! preview;
  }
  
  public void controlEvent(ControlEvent theEvent) {
    if(vmap != null){
      String theName = theEvent.name();
      
      if(theName.equals("mode")){
       vmap.toggleCalibration();
      }
      
      if(theName.equals("addBezier")){
       selectedSurface =  vmap.createBezierSurface(3,(int)lastClicked.x,(int)lastClicked.y);  
      }
      
      if(theName.equals("addQuad")){
        selectedSurface =  vmap.createQuadSurface(3,(int)lastClicked.x,(int)lastClicked.y);
      }
      
      if(theName.equals("remove")){
        vmap.removeSelectedSurfaces();
      }
      
     if(theName.equals("force_plus")){
       if(selectedSurface != null && selectedSurface instanceof BezierSurface){
          ((BezierSurface) selectedSurface ).increaseHorizontalForce();
          ((BezierSurface) selectedSurface ).increaseVerticalForce();
       }
      }
      
      if(theName.equals("force_minus")){
       if(selectedSurface != null && selectedSurface instanceof BezierSurface){
          ((BezierSurface) selectedSurface ).decreaseHorizontalForce();
          ((BezierSurface) selectedSurface ).decreaseVerticalForce();
       }
      }
      
      if(theName.equals("res_plus")){
       if(selectedSurface != null && selectedSurface instanceof BezierSurface){
          ((BezierSurface) selectedSurface ).increaseResolution();
       }
      }
      
      if(theName.equals("res_minus")){
       if(selectedSurface != null && selectedSurface instanceof BezierSurface){
          ((BezierSurface) selectedSurface ).decreaseResolution();
       }
      }
      
      
      
      if(theName.equals("refreshL")){
         refreshFiles();
      }

      if(theEvent.isGroup() && theName.equals("myList")){
        if(selectedSurface != null){
          int test = (int)theEvent.group().value();
          // empty if there's previous syphon client exist
          for(int i = 0; i<s_clients.size();i++){
             SyphonClientManager temp = s_clients.get(i);
             if(temp.surfId == selectedSurface.getId()) s_clients.remove(temp);
          }
          
          String selectedSource = sources.get(test);
          if(!checkFile(selectedSource, "mp4")){
            if(selectedSource.equals("Syphon")){
              if(selectedSurface != null){
                selectedSurface.setSurfaceName("Syphon");
                SyphonClientManager temp = new SyphonClientManager(mainContext,selectedSurface.getId());           
                s_clients.add(temp);
               }
            }else{
              
              PImage tempSource = loadImage(dataPath+selectedSource);
              selectedSurface.setSurfaceName(selectedSource);
              selectedSurface.setTexture(tempSource);
            }
            
          }else{
            println("loading..Video");
            selectedSurface.setSurfaceName(selectedSource);
            loadMovie(dataPath+selectedSource);
          }
          
        }
        
      }
    }
  } 
  private ControlFrame() {
  
  }
  public ControlFrame(Object theParent, int theWidth, int theHeight, String thePath, PApplet theContext) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
    dataPath = thePath;
    mainContext = theContext;
  }


  public ControlP5 control() {
    return cp5;
  }
  
  
  ControlP5 cp5;

  Object parent;

  
}


