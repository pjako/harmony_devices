library physics2d_device;
import 'package:vector_math/vector_math.dart';



abstract class Collider2D {
  dynamic customData;
  
  
  void collide(Collider2D other) {
    print(other);
  }


  bool get active;
  void set active(bool active);

  bool get isTrigger;
  void set isTrigger(bool trigger);

  bool overlapPoint(Vector2 point) {
    throw new UnimplementedError();
  }
}


abstract class CircleCollider implements Collider2D {

  double get radius;
  void set radius(double r) {
  }
  Vector2 get center;
  void set center(Vector2 c) {
  }

  factory CircleCollider(Physics2DDevice device) {
    return device.createCircleCollider();
  }
}

abstract class PolygonCollider implements Collider2D {

  List<Vector2> get points;
  void set points(List<Vector2> p);
  
  void setFromWithCentroid(List<Vector2> otherVertices, Vector2 centroid);
  
  void setToBox(double hx, double hy);
  
  void set position(Vector2 pos);

  factory PolygonCollider(Physics2DDevice device) {
    return device.createPolygonCollider();
  }
}

abstract class BoxCollider implements Collider2D {

  Vector2 get size;
  void set size(Vector2 s) {
  }
  Vector2 get center;
  void set center(Vector2 c) {
  }

  factory BoxCollider(Physics2DDevice device) {
    return device.createBoxCollider();
  }
}

abstract class RigidBody2d {
  factory RigidBody2d(Physics2DDevice device) {
    return device.createRigidBody();
  }

  Vector2 get velocity => null;

  Vector2 get position => null;

  void applyAngularImpulse(double imp) {
  }
  void applyForce(Vector2 force, Vector2 point) {
  }

  void set velocity(Vector2 vel) {
  }
  double get damping => null;
  void set damping(double d) {
  }

}


class DebugDrawDevice {
  void drawLine(Vector3 start, Vector3 end, Vector4 color) {
    
  }
  void drawPoint(Vector3 start, Vector4 color) {
    
  }
  void drawCircle(Vector3 point, double radius, Vector4 color) {
    
  }
}

class Physics2DDevice {
  
  void debugDraw() {
    
  }
  
  void setDebugDrawer(DebugDrawDevice device) {
    
  }

  BoxCollider createBoxCollider() {

  }

  RigidBody2d createRigidBody() {

  }

  PolygonCollider createPolygonCollider() {

  }
  CircleCollider createCircleCollider() {

  }

  void step(double dt) {
  }

}


typedef onCollide(dynamic other);

