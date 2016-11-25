void initialize_bpm() {
  values = new ArrayList<Float>();
  
  printArray(Serial.list());
  if (Serial.list().length > 0){
    String portName = Serial.list()[1];
    myPort = new Serial(this, portName, 115200);
    curVal = 0;
  }
}

static final float arrayAverage(ArrayList<Float> arr) {
  float sum = 0;
  for (float f : arr)  sum += f;
  return sum/arr.size();
}