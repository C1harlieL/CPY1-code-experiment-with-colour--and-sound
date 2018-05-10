// CPY1 - march april may 2018 //
// Code Experiment with shape colour and sound //
// Interactive audio-visual program. Facial expression and movement tracking create images and soun //
// Louis James / ljame002@gold.ac.uk //


import netP5.*;
import oscP5.*;


import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// kinect stuff //
KinectTracker tracker;
Kinect kinect;

OscP5 oscP5;
NetAddress myLocation;

float[] rawArray;
int highlighted;

boolean overCount = false;
boolean count0;

PVector posePosition;
boolean found;
float eyeLeftHeight;
float eyeRightHeight;
float mouthHeight;
float mouthWidth;
float nostrilHeight;
float leftEyebrowHeight;
float rightEyebrowHeight;

float poseScale;

float mapX, mapY, hue;


// graphics buffer to draw to //
PGraphics db;

OscP5 oscP50;

void setup() {
  //size(1900, 1000);
  fullScreen();
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  //colorMode(HSB);
  
  // Set initial properties of the graphics  //
  db = createGraphics(1920, 1080);
  db.beginDraw();
  db.background(200);
  db.colorMode(HSB);
  db.endDraw();

  rawArray = new float[132]; 

  // initialise osc communications //
  oscP5 = new OscP5(this, 8338);
  // Set NetAddress //
  myLocation = new NetAddress("127.0.0.1", 8001);
  
  
  //--- Plugs for automatically forwarding gesture data to objects ---///
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "rawData", "/raw");
  oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
  oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
  oscP5.plug(this, "eyebrowLeftReceived", "/gesture/eyebrow/left");
  oscP5.plug(this, "eyebrowRightReceived", "/gesture/eyebrow/right");
  oscP5.plug(this, "eyeLeftReceived", "/gesture/eye/left");
  oscP5.plug(this, "eyeRightReceived", "/gesture/eye/right");
  oscP5.plug(this, "jawReceived", "/gesture/jaw");
  oscP5.plug(this, "nostrilsReceived", "/gesture/nostrils");
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");
  oscP5.plug(this, "posePosition", "/pose/position");
  oscP5.plug(this, "poseScale", "/pose/scale");
  //-------------------------------------------------------------------//
  
}

void draw() {
  background(200);
  textSize(20);

  // Run the tracking analysis
  tracker.track();
  // Show the image
  tracker.display();
  
  
  //// Let's draw the raw location
  PVector v1 = tracker.getPos();
  ////fill(50, 100, 250, 200);
  ////noStroke();
  ////ellipse(v1.x, v1.y, 20, 20);

  //// Let's draw the "lerped" location
  PVector v2 = tracker.getLerpedPos();
  ////fill(100, 250, 50, 200);
  ////noStroke();
  ////ellipse(v2.x, v2.y, 20, 20);

  //// Display some info
  //int t = tracker.getThreshold();



  // draw to graphics buffer and draw image //
  db.beginDraw();
  
  //mapX = map(v2.x, 0, 640, 0, 960);
  //mapY = map(v2.y, 0, 480, 0, 720);
  hue = map(leftEyebrowHeight, 6.0, 9.0, 0, 360);
  db.fill(hue, 200, 200, 120);
  float circleSize = 20*mouthHeight;
  db.ellipse(v2.x*3, v2.y*2.25, circleSize, circleSize);
  //db.ellipse(mouseX, mouseY, 20*mouthHeight, 20*mouthHeight);
  
  OscMessage myMessage4 = new OscMessage("/mouthHeight");
  float amt4 = map(circleSize, 0, 200, 0, 0.3);
  myMessage4.add(amt4);
  
  // //
  
  
  if(mousePressed){
    db.background(200);
  }
  
  // clear drawing if too count of kinect tracker is over certain level //
  if(overCount) {
    db.background(200);
  }
  
  db.fill(255);
  db.stroke(0);
  db.textSize(35);
  db.text("Sit on the cushion and put your hand out in front of you, open your mouth, raise your eyebrows and smile ...", 40, 100);
 
  db.endDraw();
  image(db, 0, 0);
  
  //if(found){
  //  text("FACE IS DETECTED", 160, 30);
  //} else {
  //  text("NO FACE DETECTED", 160, 30);
  //}
  
  OscMessage myMessage1 = new OscMessage("/xpos");
  float amt=map(v1.x, 0, 640, -0.7, 1.2);
  //println(amt);
  myMessage1.add(amt);
  
  
  
  OscMessage myMessage0 = new OscMessage("/ypos");
  float amt1=map(v1.y, 0, 480, 0, 0.8);
  myMessage0.add(amt1);
  
  if(count0){
    v1.x = 320;
    v1.y = 240;
  }
  
  
  
  
  // Send osc messages to port 8001 (set in NetAddress myLocation) //
  oscP5.send(myMessage1, myLocation);
  oscP5.send(myMessage0, myLocation);
  oscP5.send(myMessage4, myLocation);

   // Display Threshold
   //text("threshold: " + t + "    " +  "framerate: " + int(frameRate) + "    " + 
   //"UP increase threshold, DOWN decrease threshold", 160, 1040);


}

// Adjust the threshold with key presses
void keyPressed() {
  int t = tracker.getThreshold();
  //int len = rawArray.length; 
  
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
    } else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
    }

    //if (keyCode == RIGHT) {
    //  highlighted = (highlighted + 2) % len;
    //}
    //if (keyCode == LEFT) {
    //  highlighted = (highlighted - 2 + len) % len;
    //}
  }
}

////--------------------------------------------
//void drawFacePoints() {
//  int nData = rawArray.length;
//  for (int val=0; val<nData; val+=2) {
//    if (val == highlighted) { 
//      fill(255, 0, 0);
//      ellipse(rawArray[val], rawArray[val+1], 11, 11);
//    } else {
//      fill(100);
//      ellipse(rawArray[val], rawArray[val+1], 8, 8);
//    }
//  }
//}

////--------------------------------------------
//void drawFacePolygons() {
//  noFill(); 
//  stroke(100); 

//  // Face outline
//  beginShape();
//  for (int i=0; i<34; i+=2) {
//    vertex(rawArray[i], rawArray[i+1]);
//  }
//  for (int i=52; i>32; i-=2) {
//    vertex(rawArray[i], rawArray[i+1]);
//  }
//  endShape(CLOSE);

//  // Eyes
//  beginShape();
//  for (int i=72; i<84; i+=2) {
//    vertex(rawArray[i], rawArray[i+1]);
//  }
//  endShape(CLOSE);
//  beginShape();
//  for (int i=84; i<96; i+=2) {
//    vertex(rawArray[i], rawArray[i+1]);
//  }
//  endShape(CLOSE);

//  // Upper lip
//  beginShape();
//  for (int i=96; i<110; i+=2) {
//    vertex(rawArray[i], rawArray[i+1]);
//  }
//  for (int i=124; i>118; i-=2) {
//    vertex(rawArray[i], rawArray[i+1]);
//  }
//  endShape(CLOSE);

//  // Lower lip
//  beginShape();
//  for (int i=108; i<120; i+=2) {
//    vertex(rawArray[i], rawArray[i+1]);
//  }
//  vertex(rawArray[96], rawArray[97]);
//  for (int i=130; i>124; i-=2) {
//    vertex(rawArray[i], rawArray[i+1]);
//  }
//  endShape(CLOSE);

//  // Nose bridge
//  beginShape();
//  for (int i=54; i<62; i+=2) {
//    vertex(rawArray[i], rawArray[i+1]);
//  }
//  endShape();

//  // Nose bottom
//  beginShape();
//  for (int i=62; i<72; i+=2) {
//    vertex(rawArray[i], rawArray[i+1]);
//  }
//  endShape();
//}


//-----------------------------------------------//
//--- Objects for receiving data from FaceOsc ---//

public void found(int i) {
  found = i == 1;
}
public void rawData(float[] raw) {
  rawArray = raw; // stash data in array
}
public void mouthWidthReceived(float w) {
  //println("mouth Width: " + w);
  mouthWidth = w;
}

public void mouthHeightReceived(float h) {
  //println("mouth height: " + h);
  mouthHeight = h;
}

public void eyebrowLeftReceived(float h) {
  //println("eyebrow left: " + h);
  leftEyebrowHeight = h;
}

public void eyebrowRightReceived(float h) {
  //println("eyebrow right: " + h);
  rightEyebrowHeight = h;
}

public void eyeLeftReceived(float h) {
  //println("eye left: " + h);
  eyeLeftHeight = h;
}

public void eyeRightReceived(float h) {
  //println("eye right: " + h);
  eyeRightHeight = h;
}

public void jawReceived(float h) {
  //println("jaw: " + h);
}

public void nostrilsReceived(float h) {
  //println("nostrils: " + h);
  nostrilHeight = h;
}

public void posePosition(float x, float y) {
  //println("pose position\tX: " + x + " Y: " + y );
  posePosition = new PVector(x, y);
}

public void poseScale(float s) {
  //println("scale: " + s);
  poseScale = s;
}

public void poseOrientation(float x, float y, float z) {
  //println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
}


void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.isPlugged()==false) {
    //println("UNPLUGGED: " + theOscMessage);
  }
}