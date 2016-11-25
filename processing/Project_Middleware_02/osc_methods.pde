void sendOscWek() {
  // /test 
  OscMessage myMessage = new OscMessage("/wek/inputs");
  String message = "";
  
  myMessage.add("test");
  
  oscP5.send(myMessage, myRemoteLocation);
  println(message);
}

void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.addrPattern().equals("/wek/outputs")){
    println("receiving...");
  }
}