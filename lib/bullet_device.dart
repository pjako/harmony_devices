library bullet_device;
import 'physics3d_device.dart';
import 'package:dullet_physics/dullet_physics.dart';
import 'package:dullet_physics/physic_math.dart';





class DulletDevice extends Physics3DDevice {
  World _world;
  
  Physics3dDevice() {
    _world = new WebGLPhysicsWorld(() => gameTime * 1000.0);
  }
  
  void debugDraw() {
    
  }
  
  void setDebugDrawer(DebugDrawDevice device) {
    
  }

  BoxCollider3D createBoxCollider() {
    return new DulletBoxCollider();
  }

  RigidBody3D createRigidBody() {

  }

  void update(double gameTime) {
    _world.update(gameTime);
  }

}


class DulletBoxCollider implements BoxCollider3D {
  WebGLPhysicsCollisionObject _box;
  Vector3 get size => _box.shape.intertia;
  
  DulletBoxCollider() {
    var boxShapeStatic = new WebGLPhysicsBoxShape(
        new Vector3(1.0,1.0,1.0),
        margin : 0.001
    );

    _box = new WebGLPhysicsCollisionObject(
      shape : boxShapeStatic,
      transform : new Matrix43.identity(),
      friction : 0.5,
      restitution : 0.3,
      group: WebGLPhysicsDevice.FILTER_STATIC,
      mask: WebGLPhysicsDevice.FILTER_ALL
    );
    
  }
  
  void collide(Collider3D other) {
    print(other);
  }


  bool get active => _box.isActive();
  void set active(bool active) {

  }

  bool get isTrigger => false;
  void set isTrigger(bool trigger) {
    
  }

  bool overlapPoint(Vector3 point);
}