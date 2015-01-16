import codeanticode.syphon.*;
import processing.video.*;
import VMap.*;

VMap vmap;
SuperSurface selectedSurface;
ArrayList<SyphonClientManager> s_clients;
PGraphics glos;
boolean preview;

PVector lastClicked;

void setup(){
  size(800,600, P3D);
  glos = createGraphics(width, height, P3D);
  vmap = new VMap(this,width,height);
  s_clients = new ArrayList<SyphonClientManager>();
  lastClicked = new PVector(width/2,height/2);
  guiSetup();
}

void draw(){
  background(0);
  glos.beginDraw();
  glos.clear();
  glos.hint(ENABLE_DEPTH_TEST);
  glos.endDraw();
  
  for(int i = 0; i<s_clients.size();i++){
   SyphonClientManager temp = s_clients.get(i);
   temp.update();
  }
  
  if(preview){
  vmap.render(glos);
  
  for(SuperSurface ss : vmap.getSurfaces()){
      //render this surface to GLOS, use TEX as texture
     if(ss.getTexture()!= null) ss.render(glos,ss.getTexture());
  }
    
  image(glos,0,0,width,height);
  }else{
    vmap.render();
    image(vmap,0,0,width,height);
  }
  
  if(vmap.getMode() == vmap.MODE_CALIBRATE){
    pushStyle();
    fill(255,0,0);
    ellipse(lastClicked.x,lastClicked.y,10,10);
    popStyle();
  }
 
}

void mousePressed()
{
  if(vmap.getSelectedSurfaces().size() > 0){
    selectedSurface = vmap.getSelectedSurfaces().get(0);
    println(selectedSurface.getSurfaceName());
  }
  
  lastClicked.x = mouseX;
  lastClicked.y = mouseY;
} 


void keyPressed(){
  if(key == ' ')vmap.toggleCalibration();
  if(key=='p') preview = ! preview;
}

void loadMovie(String thePath)
{
  Movie movie = new Movie(this, thePath);
  movie.loop();
  selectedSurface.setTexture(movie);
}

void movieEvent(Movie movie) {
  movie.read();
}


boolean checkFile(String theFile, String target)
{
   String extension = theFile.substring(theFile.lastIndexOf(".")+1, theFile.length());
   if(extension.equals(target)) return true;
   
   return false;
}
