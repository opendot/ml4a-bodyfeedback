import peasy.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
boolean send = false;


float world_size = 1000;
int num_samples = 1000;
ArrayList <Sample> samples;

PeasyCam cam;

PVector point_loc = new PVector();
PVector point_vel = new PVector(1, 1, 1);
float sound_volume = 10;
float max_dist = 75;
float movement_amount = 0.0;

//// FUNCTION TYPES:
//   - noise
//   - sincos

String function_type = "noise";

void setup() {
  size(600, 600, OPENGL);
  smooth(8);

  cam = new PeasyCam(this, world_size);
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("localhost", 2345);

  samples = new ArrayList<Sample>();
  for (int i = 0; i < num_samples; i++) {
    PVector sample_loc = new PVector(random(-world_size/2, world_size/2), random(-world_size/2, world_size/2), random(-world_size/2, world_size/2));
    Sample s = new Sample(sample_loc);
    samples.add(s);
  }
}

void draw() {
  background(0);

  PVector vel = new PVector();
  if (function_type.equals("noise")) {
    // update the location
    float noise_scale = 10;
    float noise_map = 5;
    noiseSeed(0);
    float x_vel = map(noise(frameCount/10), 0, 1, -noise_map, noise_map);
    noiseSeed(1);
    float y_vel = map(noise(frameCount/10), 0, 1, -noise_map, noise_map);
    noiseSeed(2);
    float z_vel = map(noise(frameCount/10), 0, 1, -noise_map, noise_map);

    x_vel *= point_vel.x;
    y_vel *= point_vel.y;
    z_vel *= point_vel.z;

    vel = new PVector(x_vel, y_vel, z_vel);
  }
  else if(function_type.equals("sincos")){
    float scale_x = 50;
    float scale_y = 43;
    float scale_z = 72;
    float sincos_map = 5;
   
    float x_vel = map(sin(frameCount/scale_x), -1,1, -sincos_map, sincos_map);
    float y_vel = map(cos(frameCount/scale_y), -1,1, -sincos_map, sincos_map);
    float z_vel = map(cos(frameCount/scale_z), -1,1, -sincos_map, sincos_map);
    
    x_vel *= point_vel.x;
    y_vel *= point_vel.y;
    z_vel *= point_vel.z;
    
    vel = new PVector(x_vel, y_vel, z_vel);
  }
  point_loc.add(vel);

  if (point_loc.x < -world_size/2) {
    point_loc.x = world_size/2;
  }
  if (point_loc.x > world_size/2) {
    point_loc.x = -world_size/2;
  }
  if (point_loc.y < -world_size/2) {
    point_loc.y = world_size/2;
  }
  if (point_loc.y > world_size/2) {
    point_loc.y = -world_size/2;
  }
  if (point_loc.z < -world_size/2) {
    point_loc.z = world_size/2;
  }
  if (point_loc.z > world_size/2) {
    point_loc.z = -world_size/2;
  }


  stroke(255, 0, 0);
  strokeWeight(20);
  point(point_loc.x, point_loc.y, point_loc.z);

  for (Sample s : samples) {

    s.run();

    float distance = s.loc.dist(point_loc);
    if (distance < max_dist) {
      s.active = true;
      stroke(255, 0, 0, 100);

      strokeWeight(map(distance, 0, max_dist, 4, 0.1));
      line(s.loc.x, s.loc.y, s.loc.z, point_loc.x, point_loc.y, point_loc.z);
    } else {
      s.active = false;
    }
  }

  if (send) {
    sendOscOfx();
  }
}


void keyPressed() {
  if (key == ' ') {
    send = !send;
  }
}