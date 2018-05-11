# Title : 

Code Experiment with Colours, Shape and Sound

# Synopsis : 

Interactive audio-visual program. Facial expression and movement tracking create images and sound.

# Build Description and tech details: 

The work consists of a computer and desktop monitor opposite a cushion (seating area). It is really for one user at a time if it is to be used effectively, though more than one could use it for example; the face of one person is tracked in the background while another person’s body makes movement for motion input. The software running consists of one [processing](https://processing.org/download/) sketch, the [FaceOsc](https://github.com/kylemcdonald/ofxFaceTracker/releases) (pre-coded/compiled/built windows executable) , and [Ableton Live 10](https://www.ableton.com/en/live/) (30 day trial). These are connected through [OSC (open sound control)](http://opensoundcontrol.org/) messages. I ran all the software on one pc running windows 10 (in order to make use of the [OpenKinect](https://github.com/shiffman/OpenKinect-for-Processing) processing library). I had two inputs into computer; one webcam and one kinect v1. The camera feed from the webcam was the input for FaceOSC.exe and the kinect fed into the processing sketch.  In processing I used the [oscP5](http://www.sojamo.de/libraries/oscP5/) library which allowed me to create, receive, send osc messages. 

![Image of setup](https://github.com/C1harlieL/CPY1-code-experiment-with-colour--and-sound/blob/master/meg-sis.jpg)

## OSC receive

I will first focus on OSC to demonstrate my understanding of OSC and the oscP5 library which connects the various applications into one communicating system. I initialised OSC communications with the two lines of processing code:

```java
oscP5 = new OscP5(this, 8338);
myRemoteLocation = new NetAddress("127.0.0.1", 8001);
```
In the first line an instance of the oscP5 object is initialised to the oscP5 variable. This starts oscP5, listening for incoming messages at port 8338. In the second line a NetAddress is created which is used as a parameter in oscP5.send(); when sending osc packets. An ‘osc plug service’ is used which automatically forwards a specific method to an object. In my program plugs were used for each of the various pre-programmed OSC data packets received from the running executable FaceOSC.exe :

```java
oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
```
Which was then automatically sent to the method of an object:
```java
public void mouthHeightReceived(float h) {
  //println("mouth height: " + h);
  mouthHeight = h;
}
```
## Graphics and kinect input

The variable `mouthHeight` was then used to the vary the size of an `ellipse();` which was being drawn to a graphics object:

```java
PGraphics db; // global variable for PGraphics object
…

db = createGraphics(400, 200); // createGraphics function initialised to variable db inside void setup() {}
…

// inside draw

db.ellipse(v1.x, v1.y, mouthHeight*200, mouthHeigh*200);
```
The use of a `PGraphics` object was unnecessary for the final program but was useful for troubleshooting with the kinect, which I will run over now. For example by displaying the `kinect.getDepthImage();` as well as the visualisation drawn to the `PGraphics`, it was helpful for tweaking the blob tracking algorithm for the  gallery space. I used the `int threshold = 625;` variable which was changed while the program was running to alter the depth threshold of the algorithm. I used the object class `KinectTracker {...}`([from kinectTracker example](https://github.com/shiffman/OpenKinect-for-Processing/blob/master/OpenKinect-Processing/examples/Kinect_v2/AveragePointTracking2/AveragePointTracking2.pde)) to contain the blob tracking algorithm which was carried out on the raw depth pixel data stored in the array: rawDepth[]; from the `kinect.getRawDepth();` array. Nested for loops cycle over the array and check if each element is less than the threshold. An average location is calculated and then stored and returned in `PVecto`r method of KinectTracker. This is then accessed in the main draw loop and determines position of the circles drawn to the `PGraphics`. A global variable for hue was also created and  determined by the plugging of the /eyeBrowHeight  OSC message, which was then mapped between 0 and 360. This colour and size of the circles forms the basis of the visual aspect of the piece. A simple pattern of circles are drawn to the graphics buffer as no background is drawn. I also added logic so that if the count of blob / depth data goes over a certain threshold a global boolean is set to true which then clears all the previously drawn circles. This allowed the user to [clear the screen by quickly swiping body](https://youtu.be/9tNx4LXjuPM?t=1m47s).

![troubleshootImage](https://github.com/C1harlieL/CPY1-code-experiment-with-colour--and-sound/blob/master/early%20troubleshooting.jpg)

![exampleImage1](https://github.com/C1harlieL/CPY1-code-experiment-with-colour--and-sound/blob/master/iolodrawing.JPG)
![exampleimage2](https://github.com/C1harlieL/CPY1-code-experiment-with-colour--and-sound/blob/master/ed_drawing.JPG)

## OSC Send 

The audio element of the work was done by having looping midi clips and an audio sample in Ableton with which parameters were controlled by OSC messages sent from processing and received by the Max for Live patch [TouchOSC (from the Max for Live Connection Kit)](https://github.com/Ableton/m4l-connection-kit). This patch allowed me to link the OSC messages to parameters of various affects parameters on the midi and audio tracks. 

![abletonimage](https://github.com/C1harlieL/CPY1-code-experiment-with-colour--and-sound/blob/master/touchosc.JPG)

In Ableton OSC messages are received and linked to in this case a frequency shifter which affects a midi clip playing repeating bell notes.

Below is a demonstration of OSC messages being initialised, mapped and sent in processing script. Mapping the messages was important for them to be interpreted in a dynamic and effective way by Ableton and Max. In this case the y position from the kinect tracker is used:

```java
OscMessage myMessage1 = new OscMessage("/y");
float amt=map(v1.y, 0, width, 0, 1);
//println(amt);
myMessage1.add(amt);
oscP5.send(myMessage1, myLocation);
```
## 
This is a quick brush over some technical elements of the processing sketch but it shows the essential use of OSC, and the oscP5 and OpenKinect processing libraries, in order to transform movement / body position / facial gestures into visuals and the sound. In short:

1. Movement and position of mass in the correct depth threshold is detected by the kinect and defines the position of the circles on the screen.
1. Eyebrow height and mouth height from the webcam via FaceOSC defines the hue and size of the circles 
1. The x and y position of the circles; the hue of the circles and the size of the circles all control various frequency shifting and flanger effects on the three midi and one audio tracks in Ableton.

# [Video Documentation of work](https://www.youtube.com/watch?v=9tNx4LXjuPM&t=0s)

# Creative process review and outcome analysis

## Research

## Audience and Outcomes

The intended audience was varied. Potential future collaborators (performers, sound artists, programmers, artists) were an important section of this. The potential performance possibilities working in the medium of interactive and audio-visual are pretty endless, and this area excites me. Having responsive and dynamic visuals to accompany musical performers and the inverse, having image and novel input informing sound are two big areas to explore, especially with those with specialised skills. For these potential collaborators a demonstration of the computional literacy and technicalility was important. A questioning and mixed audience, *fine-art-engaged* or anyone else, was also desired for unexpected and aptypical responses which could progress my work in new directions.

The original intention for it to be an interactive audio-visual installation was kept through but it was more the concept that developed. The original idea for it to be a 

hypnotic
sound visualisation








