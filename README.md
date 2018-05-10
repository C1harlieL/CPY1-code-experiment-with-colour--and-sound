# Title : 

Code Experiment with Colours, Shape and Sound

# Synopsis : 

Interactive audio-visual program. Facial expression and movement tracking create images and sound.

# Build Description : 

The work consists of a computer and desktop monitor opposite a cushion (seating area). It is really for one user at a time if it is to be used effectively, though more than one could use it for example; the face of one person is tracked in the background while another person’s body makes movement for motion input. The software running consists of one [processing](https://processing.org/download/) sketch, the FaceOsc (pre-coded/compiled/built windows executable) , and Ableton Live 10 (30 day trial). These are connected through OSC (open sound control) messages. I ran all the software on one pc running windows 10 (in order to make use of the OpenKinect processing library). I had two inputs into computer; one webcam and one kinect v1. The camera feed from the webcam was the input for FaceOSC.exe and the kinect fed into the processing sketch.  In processing I used the oscP5 library which allowed me to create, receive, send osc messages. 
