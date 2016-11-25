void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.addrPattern().equals("/wek/outputs")){
    float weight = theOscMessage.get(3).floatValue();
    weight = map(weight, 0, 1, 0, 2);
    float x = theOscMessage.get(0).floatValue();
    float y = theOscMessage.get(1).floatValue();
    float z = theOscMessage.get(2).floatValue();
    
    /*
    x = map(x, 0, 1, 0, 5);
    y = map(y, 0, 1, 0, 5);
    z = map(z, 0, 1, 0, 5);
    */
    
    point_vel = new PVector(x*weight,y*weight,z*weight);
    println(point_vel);
  }
}


void sendOscOfx() {
  // /test 
  OscMessage myMessage = new OscMessage("/NavigatorPosition");
  String message = "";
  
  float x_val = map(point_loc.x, -world_size/2,world_size/2, -0.5,0.5);
  float y_val = map(point_loc.y, -world_size/2,world_size/2, -0.5,0.5);
  float z_val = map(point_loc.z, -world_size/2,world_size/2, -0.5,0.5);
  
  myMessage.add(x_val);
  myMessage.add(y_val);
  myMessage.add(z_val);
  
  oscP5.send(myMessage, myRemoteLocation);
  println(message);
}