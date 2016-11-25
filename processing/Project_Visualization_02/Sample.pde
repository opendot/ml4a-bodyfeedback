class Sample {
  PVector loc;
  boolean active = false;

  Sample(PVector _loc) {
    loc = _loc;
  }
  
  void run(){
    display();
  }


  void display() {
    if (!active) {
      stroke(255);
      strokeWeight(5);
      point(loc.x, loc.y, loc.z);

      stroke(255, 50);
      strokeWeight(15);
      point(loc.x, loc.y, loc.z);
    } else {
      stroke(255,0,0);
      strokeWeight(5);
      point(loc.x, loc.y, loc.z);

      stroke(255,0,0, 50);
      strokeWeight(15);
      point(loc.x, loc.y, loc.z);
    }
  }
}