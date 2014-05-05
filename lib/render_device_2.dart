library render_device;
import 'dart:typed_data';
import 'package:resources_io/resources.dart';
import 'package:vector_math/vector_math.dart';



RenderDevice _device;

abstract class Material {
  factory Material(String name) {
    return _device.createMaterial();
  }

  void set shader(Shader sh);
  Shader get shader;
  RenderJob generateRenderJobs();

  void setTexture(String name, Texture texture);
  Texture getTexture(String name);
  void setConstant(String name, Float32List constant);
  Float32List getConstant(String name);
  void set renderPass(RenderPass pass);
  RenderPass get renderPass;
}
abstract class Texture {
}
abstract class Texture2D {
  factory Texture2D(String name) {
    return _device.createTexture2D();
  }
}
abstract class WebCamTexture {
  factory WebCamTexture(String name) {
    return _device.createWebCamTexture();
  }
}
abstract class MovieTextureTexture {
  factory MovieTextureTexture(String name) {
    return _device.createMovieTextur();
  }
}
abstract class Shader {
  factory Shader(String name) {
    return _device.createShader();
  }
}
abstract class SubShader {

}
abstract class Mesh {

}

class GlobalParameters {
  Matrix4 projection;
  Matrix4 viewMatrix;
  Matrix4 viewProjection;
  Matrix4 modelViewProjection;
  Vector3 eyePosition;
  Vector3 cameraPosition;
  final Map<String,dynamic> uniforms = new Map<String,dynamic>();
  final Map<String,Texture> samplers = new Map<String,Texture>();
}

abstract class InstanceParameter {
  final Map<String,dynamic> uniforms = new Map<String,dynamic>();
  void setInstaceConstants(RenderContext context, Map shaderUniforms);
}
abstract class RenderJob {
  dynamic customData;
  double sortKey;
  InstanceParameter instanceParameter;
  Material material;
  Shader shader;
  Mesh mesh;
  SubShader subShader;
  void destroy();
}


abstract class RenderContext {
  void setConstant(String name, dynamic value);

}

abstract class RenderDevice {
  RenderContext context;
  factory RenderDevice([RenderDevice device]) {
    if(_device != null) return _device;
    _device = device;
    return device;
  }
  Shader createShader();
  Material createMaterial();
  Texture2D createTexture2D();
  WebCamTexture createWebCamTexture();
  MovieTextureTexture createMovieTextur();

  List<RenderJob> generateRenderJobs(Shader shader);

  void drawQueue(List<RenderJob> renderJobs, GlobalParameters gobalParameters, int sortMode) {

  }
}

class RenderPass {
  final int index;
  const RenderPass(this.index);

  static const preBackground = const RenderPass(0);
  static const background = const RenderPass(1);
  static const pastBackground = const RenderPass(2);
  static const preGeometry = const RenderPass(3);
  static const geometry = const RenderPass(4);
  static const pastGeometry = const RenderPass(5);
  static const preAlphaTest = const RenderPass(6);
  static const alphaTest = const RenderPass(7);
  static const pastAlphaTest = const RenderPass(8);
  static const preTransparent = const RenderPass(9);
  static const transparent = const RenderPass(10);
  static const pastTransparent = const RenderPass(11);
  static const preOverlay = const RenderPass(12);
  static const overlay = const RenderPass(13);
  static const pastOverlay = const RenderPass(14);

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
