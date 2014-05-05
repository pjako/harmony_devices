library box2d_device;
import 'package:box2d/box2d.dart';
import 'physics2d_device.dart';
import 'dart:math';


class Box2DRigidBody implements RigidBody2d {
  final Box2dDevice device;
  CircleShape _shape;
  Body _body;
  Fixture _fixture;
  Box2DRigidBody(this.device) {
    _body = device._world.createBody(new BodyDef()
    ..type = BodyType.DYNAMIC
    ..allowSleep = true);
    _shape = new CircleShape();
    _shape.radius = 0.2;
    
    //_shape.computeMass(new MassData() ..mass = 10.0, 1.0);
    _fixture = _body.createFixtureFromShape(_shape);
    _fixture.restitution = 0.0;
    _fixture.density = 0.05;
    //_fixture.friction = 0.0;
    _fixture.userData = this;
    //_body.
  }
  
  void collide(var other) {
    print('RigidBody collides: ${other}');
    if(other is Box2DPolygonCollider) {
      other.points;
    }
  }

  Vector2 get velocity => _body.linearVelocity;
  void set velocity(Vector2 vel) {
    vel.copyInto(_body.linearVelocity);
  }
  double get damping => _body.linearDamping;
  void set damping(double d) {
    _body.linearDamping = d;
  }

  Vector2 get position => _body.position;

  void applyAngularImpulse(double imp) {
    _body.applyAngularImpulse(imp);
  }
  void applyForce(Vector2 force, Vector2 point) {
    _body.applyForce(force, point);
  }

}


class Box2dDevice extends Physics2DDevice implements ContactListener {
  World _world;

  Box2dDevice() {
    _world = new World(new Vector2.zero(), true, new DefaultWorldPool());
  }

  RigidBody2d createRigidBody() => new Box2DRigidBody(this);

  PolygonCollider createPolygonCollider() => new Box2DPolygonCollider(this);
  BoxCollider createBoxCollider() => new Box2DBoxCollider(this);
  CircleCollider createCircleCollider() => new Box2DCircleCollider(this);
  
  void debugDraw() {
    _world.drawDebugData();
  }
  
  var _debugDevice;
  void setDebugDrawer(DebugDrawDevice device) {
    _debugDevice = new Device2dDebugDraw(device);
    _world.debugDraw = _debugDevice;
  }

  void step(double dt) {
    _world.step(dt, 10, 10);
    //_world.contactListener = this;
  }
  void debug() {
    _world.drawDebugData();
  }

  /**
   * Called when two fixtures begin to touch.
   */
  void beginContact(Contact contact) {
    /*
    var a = contact.fixtureA.userData;
    var b = contact.fixtureB.userData;
    //contact.fixtureA.fixtureA.
    print(contact.touching);
    if(contact.fixtureA.shape is PolygonShape) {
      print(contact.fixtureA.shape.centroid);
    }
    if(contact.fixtureB.shape is PolygonShape) {
      print(contact.fixtureB.shape.centroid);
    }
    
    a.collide(b);
    b.collide(a);
    */

    //contact.fixtureA.userData.
  }

  /**
   * Called when two fixtures cease to touch.
   */
  void endContact(Contact contact) {

  }

  /**
   * This is called after a contact is updated. This allows you to inspect a
   * contact before it goes to the solver. If you are careful, you can modify
   * the contact manifold (e.g. disable contact).
   * A copy of the old manifold is provided so that you can detect changes.
   * Note: this is called only for awake bodies.
   * Note: this is called even when the number of contact points is zero.
   * Note: this is not called for sensors.
   * Note: if you set the number of contact points to zero, you will not
   * get an EndContact callback. However, you may get a BeginContact callback
   * the next step.
   * Note: the oldManifold parameter is pooled, so it will be the same object
   * for every callback for each thread.
   */
  void preSolve(Contact contact, Manifold oldManifold) {
  }

  /**
   * This lets you inspect a contact after the solver is finished. This is
   * useful for inspecting impulses.
   * Note: the contact manifold does not include time of impact impulses,
   * which can be arbitrarily large if the sub-step is small. Hence the impulse
   * is provided explicitly in a separate data structure.
   * Note: this is only called for contacts that are touching, solid, and awake.
   */
   void postSolve(Contact contact, ContactImpulse impulse) {
   }

}

var _baseBodyDef = new BodyDef()
..allowSleep = false
..type = BodyType.STATIC;

var _polygonShape = new PolygonShape();

class Box2DPolygonCollider implements PolygonCollider {
  dynamic customData;
  final Box2dDevice device;
  Body _body;
  //PolygonShape _shape;
  Fixture _fixture;
  
  void setFromWithCentroid(List<Vector2> otherVertices, Vector2 centroid) {
    _fixture.shape.setFromWithCentroid(otherVertices, centroid, otherVertices.length);
  }
  
  void setToBox(double hx, double hy) {
    _fixture.shape.setAsBoxWithCenterAndAngle(hx, hy, new Vector2.zero(), 0.0);
    //_fixture.shape.setAsBox(hx, hy);
    //_shape.setAsBox(hx, hy);
  }
  
  void set position(Vector2 pos) {
    _body.setTransform(pos, _body.angle);
  }
  
  void collide(var other) {
    print(other);
    
  }

  bool get isTrigger => _fixture.isSensor;
  void set isTrigger(bool trigger) {
    _fixture.isSensor = trigger;
  }

  bool get active => _body.active;
  void set active(bool active_) {
    _body.active = active_;
  }

  bool overlapPoint(Vector2 point) => _fixture.shape.testPoint(_transform, point);

  List<Vector2> get points => _fixture.shape.vertices;
  int get pathCount => _fixture.shape.vertexCount;
  void set points(List<Vector2> p) {
    _fixture.shape.setFrom(p, p.length);
  }

  Box2DPolygonCollider(this.device) {
    _body = device._world.createBody(_baseBodyDef);
    //_shape = new PolygonShape();
    var fixDef = new FixtureDef()
    ..shape = new PolygonShape()
    ..isSensor = false;
    _fixture = _body.createFixture(fixDef);
    _fixture.shape;
    _fixture.userData = this;
  }

}

class Box2DBoxCollider implements BoxCollider {
  dynamic customData;
  final Box2dDevice device;
  Body _body;
  PolygonShape _shape;
  Fixture _fixture;
  final Vector2 _size = new Vector2(1.0,1.0);
  final Vector2 _center = new Vector2.zero();
  //double _angle = 0.0;
  
  void collide(var other) {
    print(other);
  }

  bool get isTrigger => _fixture.isSensor;
  void set isTrigger(bool trigger) {
    _fixture.isSensor = trigger;
  }

  bool get active => _body.active;
  void set active(bool active_) {
    _body.active = active_;
  }

  bool overlapPoint(Vector2 point) => _shape.testPoint(_transform, point);

  Vector2 get size => _size;
  void set size(Vector2 s) {
    _size.setFrom(s);
    _shape.setAsBoxWithCenterAndAngle(_size.x, _size.y, _center, 0.0);
  }
  Vector2 get center => _center;
  void set center(Vector2 c) {
    _center.setFrom(c);
    _shape.setAsBoxWithCenterAndAngle(_size.x, _size.y, _center, 0.0);
  }

  Box2DBoxCollider(this.device) {
    _body = device._world.createBody(_baseBodyDef);
    _shape = new PolygonShape();
    _fixture = _body.createFixtureFromShape(_shape);
    _fixture.userData = this;
  }

}

Transform _transform = new Transform();
class Box2DCircleCollider implements CircleCollider {
  dynamic customData;
  final Box2dDevice device;
  CircleShape _shape;
  Body _body;
  Fixture _fixture;
  double get radius => _shape.radius;
  void set radius(double r) {
    _shape.radius = r;
  }
  Vector2 get center => _shape.position;
  void set center(Vector2 c) {
    _shape.position.setFrom(c);
  }

  bool get isTrigger => _fixture.isSensor;
  void set isTrigger(bool trigger) {
    _fixture.isSensor = trigger;
  }
  bool get active => _body.active;
  void set active(bool active_) {
    _body.active = active_;
  }

  bool overlapPoint(Vector2 point) => _shape.testPoint(_transform, point);

  Box2DCircleCollider(this.device) {
    _body = device._world.createBody(_baseBodyDef);
    _shape = new CircleShape();
    _fixture = _body.createFixtureFromShape(_shape);
    _fixture.userData = this;
  }
}




class Device2dDebugDraw extends DebugDraw {
  // TODO(gregbglw): Draw joints once have them implemented. Also draw other
  // neat stuff described below.

  /// draw shapes
  static const int e_shapeBit = 0x0001;
  /// draw joint connections
  static const int e_jointBit = 0x0002;
  /// draw core (TimeOfImpact) shapes
  static const int e_aabbBit = 0x0004;
  /// draw axis aligned boxes
  static const int e_pairBit = 0x0008;
  /// draw center of mass
  static const int e_centerOfMassBit = 0x0010;
  /// draw dynamic tree.
  static const int e_dynamicTreeBit = 0x0020;
  /// draw with lines (vs. default filled polygons).
  static const int e_lineDrawingBit = 0x0040;

  int flags = e_shapeBit;
  ViewportTransform viewportTransform;
  DebugDrawDevice _draw;

  Device2dDebugDraw(this._draw) : super(
      new ViewportTransform(new Vector2.zero(), new Vector2(100000.0,100000.0),1.0));

  void appendFlags(int value) { flags |= value; }
  void clearFlags(int value) { flags &= ~value; }

  /** Draw a closed polygon provided in CCW order. */
  void drawPolygon(List<Vector2> vertices, int vertexCount, Color3 color) {
    //print('##############################');
    for(int i=0; vertexCount > i; i++) {
      final Vector2 vector0 = vertices[i];
      final Vector3 vec0 = new Vector3(vector0.x, 0.3, vector0.y);
      int r = i;
      if(i >= vertexCount) i = 0;
      final Vector2 vector1 = vertices[r];
      final Vector3 vec1 = new Vector3(vector1.x, 0.3, vector1.y);
      _draw.drawLine(vec0, vec1, new Vector4(color.x/255,color.y/255,color.z/255,1.0));
      
    }
    
  }

  /** Draws the given point with the given radius and color.  */
  void drawPoint(Vector2 point, num radiusOnScreen, Color3 color) {
    
  }

  /** Draw a solid closed polygon provided in CCW order. */
  void drawSolidPolygon(List<Vector2> vertices, int vertexCount, Color3 color) {
    //print('##############################');
    for(int i=0; vertexCount > i; i++) {
      final Vector2 vector0 = vertices[i];
      final Vector3 vec0 = new Vector3(vector0.x, 0.6, vector0.y);
      int r = i+1;
      if(r >= vertexCount) r = 0;
      final Vector2 vector1 = vertices[r];
      final Vector3 vec1 = new Vector3(vector1.x, 0.6, vector1.y);
      _draw.drawLine(vec0, vec1, new Vector4(color.x/255,color.y/255,color.z/255,1.0));
      //print(i);
    }
    
  }

  /** Draw a circle. */
  void drawCircle(Vector2 center, num radius, Color3 color, [Vector2 axis]) {
    _draw.drawCircle(new Vector3(center.x, 0.6, center.y), radius.toDouble(), new Vector4(color.x/255,color.y/255,color.z/255,1.0));
  }

  /** Draw a solid circle. */
  void drawSolidCircle(Vector2 center, num radius, Color3 color, [Vector2 axis]) {
    _draw.drawCircle(new Vector3(center.x, 0.6, center.y), radius.toDouble(), new Vector4(color.x/255,color.y/255,color.z/255,1.0));
  }

  /** Draw a line segment. */
  void drawSegment(Vector2 p1, Vector2 p2, Color3 color) {
    
  }

  /** Draw a transform.  Choose your own length scale. */
  void drawTransform(Transform xf, Color3 color) {
    
  }

  /** Draw a string. */
  // TODO(dominich): font.
  void drawString(num x, num y, String s, Color3 color) {
    
  }

  /**
   * Sets the center of the viewport to the given x and y values and the
   * viewport scale to the given scale.
   */
  void setCamera(num x, num y, num scale) {
    viewportTransform.setCamera(x,y,scale);
  }

  /**
   * Screen coordinates are specified in argScreen. These coordinates are
   * converted to World coordinates and placed in the argWorld return vector.
   */
  void getScreenToWorldToOut(Vector2 argScreen, Vector2 argWorld) {
    viewportTransform.getScreenToWorld(argScreen, argWorld);
  }

  /**
   * World coordinates are specified in argWorld. These coordinates are
   * converted to screen coordinates and placed in the argScreen return vector.
   */
  void getWorldToScreenToOut(Vector2 argWorld, Vector2 argScreen) {
    viewportTransform.getWorldToScreen(argWorld, argScreen);
  }
}
