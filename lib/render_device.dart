library render_device;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';




class RenderPass {
  final int index;
  const RenderPass(this.index);

  static const RenderPass background = const RenderPass(0);
  static const RenderPass geometry = const RenderPass(1);
  static const RenderPass alphaTest = const RenderPass(2);
  static const RenderPass transparent = const RenderPass(3);
  static const RenderPass overlay = const RenderPass(4);

  static RenderPass parse(String pass) {
    switch(pass) {
      case('background'):
        return background;
      case('geometry'):
        return geometry;
      case('alphaTest'):
        return alphaTest;
      case('transparent'):
        return transparent;
      case('overlay'):
        return overlay;
    }

  }

}
class LightParameters {
  Vector3 lightColor;
  Vector3 lightPosition;
  Matrix4 lightViewInverseTransposeFalloff;
}


class GlobalParameters {
  Matrix4 projection;
  Matrix4 viewMatrix;
  Matrix4 viewProjection;
  Matrix4 modelViewProjection;
  Vector3 eyePosition;
  Vector3 cameraPosition;
  final Map<String,dynamic> uniforms = new Map<String,dynamic>();
  final Map<String,TextureParameters> samplers = new Map<String,TextureParameters>();

}




class TextureParameters {
  dynamic customData;
  dynamic initData;

  void delete() {

  }
}

class MaterialParameters {
  dynamic customData;
  ShaderParameters shaderParameters;
  final Map<String,TextureParameters> textures = new Map<String,TextureParameters>();
  final Map<String,dynamic> uniforms = new Map<String,dynamic>();
}

class MeshAttribute {
  final int stride;
  final int offset;
  final String name;
  final String format;
  MeshAttribute(this.name,this.format,this.offset,this.stride);
}


class MeshParameters {
  dynamic customData;
  Float32List vertexArray;
  Uint16List indexArray;
  String debugString;
  final List<MeshAttribute> attributes = [];
  int get stride {
    var first = attributes.first;
    if(first == null) return 0;
    return first.stride;
  }
  int get positionOffset {
    for(var att in attributes) {
      if(att.name == 'POSITION') {
        return att.offset;
      }
    }
    return 0;
  }

  void delete() {
  }
}

class Subshader {
  String name;
  dynamic customData;
  RenderPass pass;
  String vertexSource;
  String fragmentSource;
}

class ShaderParameters {
  final Map<String,dynamic> uniforms = new Map<String,dynamic>();
  final Map<String,TextureParameters> samplers = new Map<String,TextureParameters>();
  ShaderParameters();

  void delete() {

  }
}

class ShaderProperty {
  final String tagName;
  final String varName;
  final type;
  final dynamic defaultValue;
  ShaderProperty( this.tagName, this.varName, this.type, this.defaultValue);
}


class RenderJob {
  dynamic customData;
  double sortKey;
  static final List<RenderJob> _renderJobList = [];
  static RenderJob _allocate() {
    if(_renderJobList.isEmpty) return new RenderJob._internal();
    return _renderJobList.removeLast();
  }
  void destroy() {
    _renderJobList.add(this);
  }

  factory RenderJob() {
    var obj = _allocate();
    obj.customData = null;
    obj.sortKey = null;
    obj.materialParameters = null;
    obj.meshParameters = null;
    obj.renderParameters = null;
    obj.shader = null;
    return obj;
  }
  RenderJob._internal();




  RendererParameters renderParameters;
  MaterialParameters materialParameters;
  ShaderParameters shaderParameter;
  MeshParameters meshParameters;
  Subshader shader;
}

class RendererParameters {
  dynamic customData;
  final Map rendererConstants = {};
  Float32List skinnedBones;
  Matrix4 worldMatrix;
  Matrix4 worldViewMatrix;
  Matrix4 worldViewProjection;
  bool usesLightmaps = false;
  final Vector4 lightmapTilingOffset = new Vector4.zero();
  int lightmapIndex = -1;
  TextureParameters lightmap;
}



class BlendMode {
  final int _modus;
  const BlendMode(this._modus);
  static const additive = const BlendMode(0);
  static const alphaBlend = const BlendMode(1);
  static const nonPremultiplied = const BlendMode(2);
  static const opaque = const BlendMode(3);
}
class DepthMode {
  final int _modus;
  const DepthMode(this._modus);
  static const none = const DepthMode(0);
  static const depthWrite = const DepthMode(1);
  static const depthRead = const DepthMode(2);
}


class RenderBatchJob {
  List<RendererParameters> renderParametersList;
  MaterialParameters materialParameters;
  MeshParameters meshParameters;
  Subshader subshader;
}
abstract class RenderConstantInput {
  void setConstant(String name, dynamic value);
}

class RenderDevice {
  static RenderDevice current;
  bool suportsHardwareBatching = false;
  DebugDrawManager debug;// = new DebugDrawManager();
  
  
  
  void resize(int width, int height) {
    
  }

  void update(double dt) {

  }

  void compileShader(Subshader subshader) {

  }

  void prepareRenderer(RendererParameters parameters) {

  }

  void prepareMesh(MeshParameters parameters) {

  }

  void prepareTexture(TextureParameters texture) {


  }

  void prepareRenderJob(RenderJob job) {

  }

  void setBlendMode(BlendMode modus) {

  }

  void setDepthMode(DepthMode modus) {

  }


  void drawBatch(List<RenderBatchJob> renderBatchJobs, GlobalParameters gobalParameters) {

  }

  void drawQueue(List<RenderJob> renderJobs, GlobalParameters gobalParameters, int sortMode) {

  }

  void debugDraw(Matrix4 viewProjectionMat) {

  }

  void clear(Vector4 color, double depth, stencil) {

  }

  void reset() {

  }

}



class DebugDrawManager {


  void update(double dt) {

  }

  /** Add a line primitive extending from [start] to [finish].
   * Filled with [color].
   *
   * Optional parameters: [duration] and [depthEnabled].
   */
  void drawLine(Vector3 start, Vector3 finish, Vector4 color, num duration, bool depthEnabled) {
  }

  /** Add a cross primitive at [point]. Filled with [color].
   *
   * Optional paremeters: [size], [duration], and [depthEnabled].
   */
  void drawCross(Vector3 point, Vector4 color, num size, num duration, bool depthEnabled) {
  }

  /** Add a sphere primitive at [center] with [radius]. Filled with [color].
   *
   * Optional paremeters: [duration] and [depthEnabled].
   */
  void drawSphere(Vector3 center, num radius, Vector4 color, num duration, bool depthEnabled) {
  }
  /// Add a plane primitive whose normal is [normal] at is located at
  /// [center]. The plane is drawn as a grid of [size] square. Drawn
  /// with [color].
  /// Optional parameters: [duration], [depthEnabled] and [numSegments].
  void drawPlane(Vector3 normal, Vector3 center, double size,
                Vector4 color, num duration, bool depthEnabled,
                int numSegments) {
  }

  /** Add a cone primitive at [apex] with [height] and [angle]. Filled with
   *  [color].
   *
   * Optional parameters: [duration], [depthEnabled] and [numSegments].
   */
  void drawCone(Vector3 apex, Vector3 direction, num height, num angle,
               Vector4 color, num duration, bool depthEnabled,
               int numSegments) {
  }

  /** Add an arc primitive at [center] in the plane whose normal is
   * [planeNormal] with a [radius]. The arc begins at [startAngle] and extends
   * to [stopAngle]. Filled with [color].
   *
   * Optional parameters: [duration], [depthEnabled], and [numSegments].
   */
  void drawArc(Vector3 center, Vector3 planeNormal, num radius, num startAngle,
              num stopAngle, Vector4 color, num duration,
              bool depthEnabled, int numSegments) {
  }

  /** Add an circle primitive at [center] in the plane whose normal is
   * [planeNormal] with a [radius]. Filled with [color].
   *
   * Optional parameters: [duration], [depthEnabled], and [numSegments].
   */
  void drawCircle(Vector3 center, Vector3 planeNormal, num radius, Vector4 color,
                 num duration, bool depthEnabled,
                 int numSegments) {
  }

  /// Add a coordinate system primitive. Derived from [xform]. Scaled by [size].
  ///
  /// X,Y, and Z axes are colored Red,Green, and Blue
  ///
  /// Optional paremeters: [duration], and [depthEnabled]
  void drawAxes(Matrix4 xform, num size,
               num duration, bool depthEnabled) {
  }

  /// Add a triangle primitives from vertices [vertex0], [vertex1],
  /// and [vertex2]. Filled with [color].
  ///
  /// Optional parameters: [duration] and [depthEnabled]
  void drawTriangle(Vector3 vertex0, Vector3 vertex1, Vector3 vertex2, Vector4 color,
                   num duration, bool depthEnabled) {
  }

  /// Add an Axis Aligned Bounding Box with corners at [boxMin] and [boxMax].
  /// Filled with [color].
  ///
  /// Option parameters: [duration] and [depthEnabled]
  void drawAABB(Vector3 boxMin, Vector3 boxMax, Vector4 color,
               num duration, bool depthEnabled) {

  }

}