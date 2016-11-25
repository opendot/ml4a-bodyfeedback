void draw_gui_labels(){
  
  
}

void gui() {
  cp5 = new ControlP5(this);
  
  cp5.addToggle("use_bpm")
    .setPosition(100, 100)
    .setSize(100, 60)
    .setLabel("BPM");
  ;
  
  
  cp5.addToggle("use_myo")
    .setPosition(300, 100)
    .setSize(100, 60)
    .setLabel("MYO");
  ;

  cp5.addToggle("use_leap")
    .setPosition(500, 100)
    .setSize(100, 60)
    .setLabel("LEAP");
  ;

  cp5.addToggle("send")
    .setPosition(700, 100)
    .setSize(100, 60)
    ;
  
  /*
  cp5.addMatrix("INPUT_OUTPUT_MAPPING")
    .setPosition(100, 200)
    .setSize(320, 320)
    .setGrid(values_num, values_num)
    .setGap(5, 5)
    .setBackground(color(75))
    .setMode(ControlP5.SINGLE_ROW)
    .pause()
    ;
    */
}