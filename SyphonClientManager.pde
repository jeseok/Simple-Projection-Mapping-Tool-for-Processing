class SyphonClientManager
{
  PImage img;
  SyphonClient client;
  int surfId;
  
  SyphonClientManager(PApplet theContext, int tempId){
    client = new SyphonClient(theContext);
    surfId = tempId;
    println(surfId);
  }
  
  void update(){
   if(client.available()){
    img = client.getImage(img);
    vmap.getSurfaceById(surfId).setTexture(img);
   }
  }
  
  void stopSyphon()
  {
    client.stop();
  }
}
