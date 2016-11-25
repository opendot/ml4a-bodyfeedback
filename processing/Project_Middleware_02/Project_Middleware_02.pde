//// LIBRARIES
// SENSORS
import de.voidplus.myo.*;
import de.voidplus.leapmotion.*;

// COMMUNICATION
import processing.serial.*;
import oscP5.*;
import netP5.*;

// GUI
import controlP5.*;


ControlP5 cp5;
OscP5 oscP5;
NetAddress myRemoteLocation;
int listening_port = 12001;
boolean send;
OscMessage myMessage;


//// ARDUINO BPM
Serial myPort = null;  // Create object from Serial class
float val;      // Data received from the serial port
int lf = 10;    // Linefeed in ASCII

int xPos = 1;
int lastxPos = 1;
int lastheight = 0;
int curVal;
float meanval;
ArrayList <Float> values;

//// MYO
Myo myo;

// EMG
ArrayList<ArrayList<Integer>> emg_sensors;
ArrayList<ArrayList<Integer>> emg_sensors_buffer;
int buffer_size = 30;

// ACC
PVector accelerometer;
ArrayList<PVector> accelerometer_buffer;

//// LEAP
LeapMotion leap;

// DATA
PVector handPosition;
PVector prevHandPosition;
PVector handStabilized;
PVector handDirection;
PVector handDynamics;
float   handRoll;
float   handPitch;
float   handYaw;
boolean handIsLeft;
boolean handIsRight;
float   handGrab;
float   handPinch;
float   handTime;
PVector spherePosition;
float   sphereRadius;

// ACTIVATION
boolean use_bpm = true;
boolean use_myo = true;
boolean use_leap = true;

int values_num = 17;
int starting_bpm = 0;
int starting_myo = 1;
int starting_leap = 12;
float[] send_values;


void setup() {
  size(900, 300);
  background(255);
  frameRate(30);

  oscP5 = new OscP5(this, listening_port);
  myRemoteLocation = new NetAddress("127.0.0.1", 6448);

  initialize_myo();
  initialize_leap();
  initialize_bpm();

  prevHandPosition = new PVector();
  send_values = new float[values_num];

  gui();
}


void draw() {
  background(75);

  clear_data();

  if (use_bpm) {
    if (myPort != null) {
      if ( myPort.available() > 0) {  // If data is available,
        String s = myPort.readStringUntil(lf);

        if (s != null) {
          val = float(s);  // Converts and prints float
          if (val != 0) {
            values.add(val);
            println(val);
          }
        }
      }
    }

    if (val != 0) {
      curVal++;
      if (curVal > 10) {
        meanval = arrayAverage(values);
        println(meanval);
        send_values[starting_bpm] = meanval;

        if (values.size() > 10) {
          values.remove(0);
        }

        /*float inByte = map(meanval, 0, 1023, 0, height);
         
         stroke(127,34,255);
         strokeWeight(4);
         line(lastxPos, lastheight, xPos, height-inByte);
         lastxPos = xPos;
         lastheight = int(height-inByte);
         
         if (xPos >= width) {
         xPos = 0;
         lastxPos = 0;
         background(255);
         } else {
         xPos++;
         }      */
      }
    }
  }

  if (use_myo) {

    // GET DATA
    int[] data = myo.getEmg();
    if (data != null) {
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

      accelerometer = myo.getGyroscope();
      PVector accelerometer_abs = new PVector(abs(accelerometer.x), abs(accelerometer.y), abs(accelerometer.z));
      accelerometer_buffer.add(accelerometer_abs);
      if(accelerometer_buffer.size() > 10){
        accelerometer_buffer.remove(0);
      }

      // SEND DATA
      for (int i=0; i<8; i++) {
        if (!emg_sensors_buffer.get(i).isEmpty()) {
          float emg_sensor_average = 0;
          for (int j = 0; j < emg_sensors_buffer.get(i).size(); j++) {
            emg_sensor_average += map(emg_sensors_buffer.get(i).get(j), 0, 127, 0, 1);
          }
          emg_sensor_average /= emg_sensors_buffer.get(i).size();
          send_values[i+starting_myo] = emg_sensor_average;
        }
      }
      
      ArrayList<Float> acc_x = new ArrayList<Float>();
      ArrayList<Float> acc_y = new ArrayList<Float>();
      ArrayList<Float> acc_z = new ArrayList<Float>();
      for(PVector v : accelerometer_buffer){
        acc_x.add(v.x);
        acc_y.add(v.y);
        acc_z.add(v.z);
      }
      
      send_values[starting_myo + 8] = arrayAverage(acc_x);
      send_values[starting_myo + 9] = arrayAverage(acc_y);
      send_values[starting_myo + 10] = arrayAverage(acc_z);
    }
  }

  if (use_leap) {
    for (Hand hand : leap.getHands ()) {
      // ==================================================
      // 2. Hand


      handPosition       = hand.getPosition();
      if (prevHandPosition.mag() > 0) {
        float hand_x = abs(handPosition.x - prevHandPosition.x);
        float hand_y = abs(handPosition.y - prevHandPosition.y);
        float hand_z = abs(handPosition.z - prevHandPosition.z);
        send_values[starting_leap] = hand_x;
        send_values[starting_leap+1] = hand_y;
        send_values[starting_leap+2] = hand_z;
      }
      prevHandPosition = new PVector(handPosition.x, handPosition.y, handPosition.z);
      /*
       handStabilized     = hand.getStabilizedPosition();
       handDirection      = hand.getDirection();
       handDynamics       = hand.getDynamics();
       handRoll           = hand.getRoll();
       handPitch          = hand.getPitch();
       handYaw            = hand.getYaw();
       handIsLeft         = hand.isLeft();
       handIsRight        = hand.isRight();
       */
      handGrab           = hand.getGrabStrength();
      handPinch          = hand.getPinchStrength();
      /*
      handTime           = hand.getTimeVisible();
       spherePosition     = hand.getSpherePosition();
       sphereRadius       = hand.getSphereRadius();
       */

      // --------------------------------------------------
      // Drawing
      hand.draw();

      send_values[starting_leap+3] = handGrab;
      send_values[starting_leap+4] = handPinch;
    }
  }
  if (send) {
    send_data();
  }
}

void send_data() {
  myMessage = new OscMessage("/wek/inputs");
  String message = "";

  for (int i = 0; i < send_values.length; i++) {
    myMessage.add(send_values[i]);
    message = message + str(send_values[i]) + ";";
  }

  oscP5.send(myMessage, myRemoteLocation);
  println(message);
}

void clear_data() {
  for (int i = 0; i < send_values.length; i++) {
    send_values[i] = 0;
  }
}