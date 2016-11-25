void initialize_myo() {
  myo = new Myo(this, true); // true, with EMG data

  emg_sensors = new ArrayList<ArrayList<Integer>>();
  for (int i=0; i<8; i++) {
    emg_sensors.add(new ArrayList<Integer>());
  }

  emg_sensors_buffer = new ArrayList<ArrayList<Integer>>();
  for (int i=0; i<8; i++) {
    emg_sensors_buffer.add(new ArrayList<Integer>());
  }
  
  accelerometer_buffer = new ArrayList<PVector>();
  for (int i = 0; i < 10; i++){
    accelerometer_buffer.add(new PVector());
  }
}
/*
void myoOn(Myo.Event event, de.voidplus.myo.Device myo, long timestamp) {  
  switch(event) {
  case POSE:
    switch (myo.getPose().getType()) {
    case FIST:
      // println("Pose: FIST");
      break;
    }
    // println("Sketch: myoOn() of type 'POSE' has been called");
    break;
  case ORIENTATION_DATA:
    // println("Sketch: myoOn() of type 'ORIENTATION_DATA' has been called");
    break;
  case ACCELEROMETER_DATA:
    // println("Sketch: myoOn() of type 'ACCELEROMETER_DATA' has been called");
    accelerometer = myo.getAccelerometer();
    break;
  case GYROSCOPE_DATA:
    // println("Sketch: myoOn() of type 'GYROSCOPE_DATA' has been called");
    break;
  case EMG_DATA:
    // println("Sketch: myoOn() of type 'EMG_DATA' has been called");
    int[] data = myo.getEmg();
    // println("Sketch: myoOnEmgData, device: " + myo.getId());
    // int[] data <- 8 values from -128 to 127
    for (int i = 0; i<data.length; i++) {
      emg_sensors.get(i).add((int) map(data[i], -128, 127, 0, 50)); // [-128 - 127]
      emg_sensors_buffer.get(i).add((int) abs(data[i]));
    }
    while (emg_sensors.get(0).size() > width) {
      for (ArrayList<Integer> sensor : emg_sensors) {
        sensor.remove(0);
      }
    }
    while (emg_sensors_buffer.get(0).size() > buffer_size) {
      for (ArrayList<Integer> sensor : emg_sensors_buffer) {
        sensor.remove(0);
      }
    }

    break;
  }
}
  */