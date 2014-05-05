library physics3d_device;
import 'package:vector_math/vector_math.dart';


class Physics3DDevice {
  
  void debugDraw() {
    
  }
  
  void setDebugDrawer(DebugDrawDevice device) {
    
  }

  BoxCollider3D createBoxCollider() {

  }

  RigidBody3D createRigidBody() {

  }

  void update(double gameTime) {
    
  }

}



abstract class Collider3D {
  dynamic customData;
  
  
  void collide(Collider3D other) {
    print(other);
  }


  bool get active;
  void set active(bool active);

  bool get isTrigger;
  void set isTrigger(bool trigger);

  bool overlapPoint(Vector3 point);
}


abstract class BoxCollider3D extends Collider3D {
  Vector3 get size;
  factory BoxCollider3D(Physics3dDevice device) {
    return device.createBoxCollider();
  }
}


abstract class RigidBody3D {
  factory RigidBody3D(Physics3dDevice device) {
    return device.createRigidBody();
  }

  Vector3 get velocity => null;

  void applyAngularImpulse(double imp) {
  }
  void applyForce(Vector3 force, Vector3 point) {
  }

  void set velocity(Vector3 vel) {
  }
  double get damping => null;
  void set damping(double d) {
  }
}