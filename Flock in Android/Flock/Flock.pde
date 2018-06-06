import frames.core.Frame;
import frames.primitives.Vector;
import frames.processing.Scene;
import processing.core.PApplet;
import processing.event.MouseEvent;
import android.view.MotionEvent; 
import ketai.ui.*;   
import java.util.ArrayList;

/**
 * Flock is a work in progress still. Known issues:
 * 1. Need to click twice to pick a boid
 * 2. Fires weird setting reference warnings (see TODOs)
 */
KetaiGesture gesture;   
  Scene scene;
  //flock bounding box
  static int flockWidth = 1280;
  static int flockHeight = 720;
  static int flockDepth = 600;
  static boolean avoidWalls = true;

  int initBoidNum = 20; // amount of boids to start the program with
  static ArrayList<Boid> flock;
  static Frame avatar;
  static boolean animate = true;

   void settings() {
    //size(1000, 800, P3D);
    fullScreen(P3D,1);
  }

  void setup() {
    gesture = new KetaiGesture(this); 
    scene = new Scene(this);
    scene.setBoundingBox(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
    scene.setAnchor(scene.center());
    scene.setFieldOfView(PI / 3);
    scene.fitBall();
    // create and fill the list of boids
    flock = new ArrayList();
    for (int i = 0; i < initBoidNum; i++)
      flock.add(new Boid(scene, new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2)));
      print("Pinte 1 boid");
  }

   void draw() {
    background(0);
    ambientLight(128, 128, 128);
    directionalLight(255, 255, 255, 0, 1, -100);
    walls();
    // draw + mouse click picking
    scene.castOnMouseClick();
  }
  
public boolean surfaceTouchEvent(MotionEvent event) {  //  13
  //call to keep mouseX and mouseY constants updated
  super.surfaceTouchEvent(event);
  //forward events
  return gesture.surfaceTouchEvent(event);
}
  // interaction in 'first-person'
   void mouseDragged() {
    if (scene.eye().reference() == null)
      
        scene.mouseSpin(scene.eye());
        //scene.zoom(mouseX - pmouseX, scene.eye());
    //scene.scale(mouseX - pmouseX);
  }

  // interaction in 'third-person'
   void mouseMoved(MouseEvent event) {
    if (scene.eye().reference() != null)
      // press shift to move the mouse without looking around
      if (!event.isShiftDown())
        scene.mouseLookAround();
  }

   void onPinch(float x, float y, float d)                 // 18
  {
     scene.scale(d * 12);
  }

  // Behaviour: tapping over a boid will select the frame as
  // the eye reference and perform an eye interpolation to it.
   void mousePressed(MouseEvent event) {
    if (scene.trackedFrame() != null)
      if (avatar != scene.trackedFrame() && scene.eye().reference() != scene.trackedFrame()) {
        avatar = scene.trackedFrame();
        scene.interpolateTo(scene.trackedFrame());
        scene.eye().setReference(scene.trackedFrame());
        // TODO
        // Interpolation after setting the reference fires the following warning:
        // 'Both frame and its reference should be detached, or attached to the same graph.'
        //scene.interpolateTo(scene.trackedFrame());
      }
  }

   void walls() {
    pushStyle();
    noFill();
    stroke(255);

    line(0, 0, 0, 0, flockHeight, 0);
    line(0, 0, flockDepth, 0, flockHeight, flockDepth);
    line(0, 0, 0, flockWidth, 0, 0);
    line(0, 0, flockDepth, flockWidth, 0, flockDepth);

    line(flockWidth, 0, 0, flockWidth, flockHeight, 0);
    line(flockWidth, 0, flockDepth, flockWidth, flockHeight, flockDepth);
    line(0, flockHeight, 0, flockWidth, flockHeight, 0);
    line(0, flockHeight, flockDepth, flockWidth, flockHeight, flockDepth);

    line(0, 0, 0, 0, 0, flockDepth);
    line(0, flockHeight, 0, 0, flockHeight, flockDepth);
    line(flockWidth, 0, 0, flockWidth, 0, flockDepth);
    line(flockWidth, flockHeight, 0, flockWidth, flockHeight, flockDepth);
    popStyle();
  }

   void keyPressed() {
    switch (key) {
      case 'a':
        animate = !animate;
        break;
      case 's':
        if (scene.eye().reference() == null)
          scene.fitBallInterpolation();
        break;
      case 't':
        scene.shiftTimers();
        break;
      case 'p':
        println("Frame rate: " + frameRate);
        break;
      case 'v':
        avoidWalls = !avoidWalls;
        break;
      case ' ':
        if (scene.eye().reference() != null) {
          scene.lookAt(scene.center());
          // TODO
          // Interpolation before setting the nul reference fires the following warning:
          // 'Both frame and its reference should be detached, or attached to the same graph.'
          //scene.fitBallInterpolation();
          scene.eye().setReference(null);
          scene.fitBallInterpolation();
        } else if (avatar != null) {
          scene.interpolateTo(avatar);
          scene.eye().setReference(avatar);
          // TODO
          // Interpolation after setting the reference fires the following warning:
          // 'Both frame and its reference should be detached, or attached to the same graph.'
          //scene.interpolateTo(avatar);
        }
        break;
    }
  }

  
