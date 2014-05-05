library debug_device;
import 'package:vector_math/vector_math.dart';


class DebugDevice {
  
  
  void measureStart(String markName, String Category) {
    
  }
  
  void measureEnd(String markName) {
    
  }


  void update(double dt) {

  }
  void render() {

  }
  void drawLine(Vector3 start, Vector3 finish, Vector4 color, num duration, bool depthEnabled) {
  }
  void drawCross(Vector3 point, Vector4 color, num size, num duration, bool depthEnabled) {
  }
  void drawSphere(Vector3 center, num radius, Vector4 color, num duration, bool depthEnabled) {
  }
  void drawPlane(Vector3 normal, Vector3 center, double size,
                Vector4 color, num duration, bool depthEnabled,
                int numSegments) {
  }
  void drawCone(Vector3 apex, Vector3 direction, num height, num angle,
               Vector4 color, num duration, bool depthEnabled,
               int numSegments) {
  }
  void drawArc(Vector3 center, Vector3 planeNormal, num radius, num startAngle,
              num stopAngle, Vector4 color, num duration,
              bool depthEnabled, int numSegments) {
  }
  void drawCircle(Vector3 center, Vector3 planeNormal, num radius, Vector4 color,
                 num duration, bool depthEnabled,
                 int numSegments) {
  }
  void drawAxes(Matrix4 xform, num size,
               num duration, bool depthEnabled) {
  }
  void drawTriangle(Vector3 vertex0, Vector3 vertex1, Vector3 vertex2, Vector4 color,
                   num duration, bool depthEnabled) {
  }
  void drawAABB(Vector3 boxMin, Vector3 boxMax, Vector4 color,
               num duration, bool depthEnabled) {

  }

}