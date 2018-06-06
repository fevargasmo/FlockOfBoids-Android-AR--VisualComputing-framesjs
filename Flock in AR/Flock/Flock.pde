import frames.core.Frame;
import frames.primitives.Vector;
import frames.processing.Scene;
import processing.core.PApplet;
import processing.event.MouseEvent;

import java.util.ArrayList;
import jp.nyatla.nyar4psg.*;
import ketai.camera.*;

KetaiCamera cam;
PImage img;
PImage img2;
int refresh = 0;
int block = 0;
MultiMarker nya;
/**
 * Flock is a work in progress still. Known issues:
 * 1. Need to click twice to pick a boid
 * 2. Fires weird setting reference warnings (see TODOs)
 */

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
    //fullScreen(P3D,1);
    size(displayWidth, displayHeight,P3D);
    
  }

  void setup() {
     colorMode(RGB, 100);
     
     cam=new KetaiCamera(this,640,480, 60);
 img = new PImage(640, 480);

 nya=new MultiMarker(this,640,480,"camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
 nya.addARMarker("patt.hiro",80);
    scene = new Scene(this);
    scene.setBoundingBox(new Vector(0,0, 0), new Vector(flockWidth, flockHeight, flockDepth));
    scene.setAnchor(scene.center());
    scene.setFieldOfView(PI / 3);
    scene.fitBall();
    // create and fill the list of boids
    flock = new ArrayList();
    for (int i = 0; i < initBoidNum; i++)
      flock.add(new Boid(scene, new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2)));
      
      
       

 cam.start();
  }
void onCameraPreviewEvent()
{
  cam.read();
  refresh = 1;
}
   void draw() {
     
     if (refresh == 1) {
   block = 1;
   refresh = 0;

   image(cam, 0, 0, displayWidth, displayHeight);
   img.copy(cam, 0, 0, 640, 480, 0, 0, 640, 480);
   nya.detect(img);

   if((!nya.isExistMarker(0))){
     return;
   }

   nya.beginTransform(0);
   translate(0,0,2);
   box(30);
    //background(0);
    ambientLight(128, 128, 128);
    directionalLight(255, 255, 255, 0, 1, -100);
    walls();
    // draw + mouse click picking
    scene.castOnMouseClick();   
   
   nya.endTransform();   
   block = 0;
 }
     
     
     
     
     
     
     
          
   
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

  
