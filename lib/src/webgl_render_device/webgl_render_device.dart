part of webgl_render_device;


class TextureSamplerPairs {
  final List<Texture2D> textures;
  final List<SamplerState> samplerStates;
  TextureSamplerPairs(int textureNum) : textures = new List<Texture2D>(textureNum), samplerStates = new List<SamplerState>(textureNum);
}
class RendererExtraParameters {
  SingleArrayIndexedMesh mesh;
  TextureSamplerPairs textureSamplerPairs;
}

class WebGLRenderDevice extends RenderDevice {
  DebugDrawManager debug;

  CanvasElement _canvas;
  GraphicsDevice _device;
  GraphicsContext _context;
  bool suportsHardwareBatching = false;

  RasterizerState _rasterizationState;
  DepthState _depthState;
  Viewport _viewport;

  WebGLRenderDevice(this._canvas) {
    _device = new GraphicsDevice(_canvas);
    _context = _device.context;
    debug = new WebGLDebugDrawManager(_device);
    _rasterizationState = new RasterizerState.cullCounterClockwise();
    _context.setPrimitiveTopology(PrimitiveTopology.Triangles);
    _depthState = new DepthState.depthWrite();
    _viewport = new Viewport();
    //_context.setRasterizerState(_rasterizationState);
    _viewport.x = 0;
    _viewport.y = 0;
    _viewport.width = _canvas.width;
    _viewport.height = _canvas.height;
  }
  
  void resize(int width, int height) {
    _viewport.width = _canvas.width;
    _viewport.height = _canvas.height;
    
    //_device.
    //_canvas.width = width;
    //_canvas.height = height;
  }
  
  void _compileSubShader(Subshader subshader) {
    ShaderProgram shaderProgram = new ShaderProgram('',_device);
    shaderProgram.vertexShader = new VertexShader('',_device);
    shaderProgram.fragmentShader = new FragmentShader('',_device);
    shaderProgram.vertexShader.source = subshader.vertexSource;
    shaderProgram.fragmentShader.source = subshader.fragmentSource;
    shaderProgram.link();
    print('done');
    subshader.customData = shaderProgram;
  }

  void prepareMesh(MeshParameters parameters) {
    SingleArrayIndexedMesh mesh = new SingleArrayIndexedMesh('', _device);
    //var vertexArray = new Float32List.fromList(_json['vertices']);parameters.
    //var indexArray = new Uint16List.fromList(_json['indices']);
    //print(parameters.debugString);
    mesh.vertexArray.uploadData(parameters.vertexArray, UsagePattern.StaticDraw);
    mesh.indexArray.uploadData(parameters.indexArray, UsagePattern.StaticDraw);
    mesh.count = parameters.indexArray.length;
    List attributes = parameters.attributes;

    attributes.forEach((v) {
      String name = v.name;
      int offset = v.offset;
      int stride = v.stride;
      int count = 1;

      switch (v.format) {
        case 'float': count = 1; break;
        case 'float2': count = 2; break;
        case 'float3': count = 3; break;
        case 'float4': count = 4; break;
        default:
          throw 'Unknow attribute format: ${v.format}';
      }

      SpectreMeshAttribute attribute = new SpectreMeshAttribute(
          name,
          new VertexAttribute(0, 0, offset, stride, DataType.Float32, count,
                              false));
      mesh.attributes[name] = attribute;
    });

    parameters.customData = mesh;
  }

  void prepareTexture(TextureParameters parameters) {
    var tex = parameters.initData;
    if(tex is ImageElement) {
      var spectreTexture = new Texture2D('', _device);
      _device.gl.pixelStorei(UNPACK_FLIP_Y_WEBGL, 1);
      spectreTexture.uploadElement(tex);
      spectreTexture.generateMipmap();
      parameters.customData = spectreTexture;
    }


  }
  void compileShader(Subshader sh) {
    if(sh.customData == null) {
      _compileSubShader(sh);
    }
  }

  void prepareRenderJob(RenderJob job) {
    if(job.shader.customData == null) {
      _compileSubShader(job.shader);
    }
    if(job.meshParameters.customData == null) {
      prepareMesh(job.meshParameters);
    }
    ShaderProgram program = job.shader.customData as ShaderProgram;
    int textureLength = program.samplers.length;
    if(job.materialParameters.customData == null) {
      job.materialParameters.customData = new TextureSamplerPairs(textureLength);
      job.materialParameters.textures.forEach((String name, TextureParameters texParameter) {
        if(texParameter.customData == null) {
          prepareTexture(texParameter);
        }
        var shaderSampler = program.samplers[name];
        int idx = shaderSampler.textureUnit;
        job.materialParameters.customData.textures[idx] = texParameter.customData;
        job.materialParameters.customData.samplerStates[idx] = new SamplerState.linearWrap('', _device);
      });
      /*for(var tex in job.materialParameters.textures.values) {
        job.materialParameters.customData.textures.add(tex.customData);
        job.materialParameters.customData.samplerStates.add(new SamplerState.linearWrap('', _device));
      }*/
    }

    if(job.customData == null) {
      job.customData = new InputLayout('', _device);
    }
    InputLayout input = job.customData;
    input.mesh = job.meshParameters.customData;
    input.shaderProgram = job.shader.customData;
    if(job.renderParameters.customData == null) {
      if(job.renderParameters.usesLightmaps) {
        TextureSamplerPairs matPair = job.materialParameters.customData;
        TextureSamplerPairs pair = new TextureSamplerPairs(textureLength);
        for(int i=0; i < textureLength; i++) {
          pair.samplerStates[i] = matPair.samplerStates[i];
          pair.textures[i] = matPair.textures[i];
        }
        if(job.renderParameters.lightmap.customData == null) {
          prepareTexture(job.renderParameters.lightmap);
        }
        var lightTex = job.renderParameters.lightmap.customData;
        var lightSampler = new SamplerState.linearWrap('LightMap', _device);
        var shaderSampler = program.samplers['LightMap'];
        int idx = shaderSampler.textureUnit;
        pair.samplerStates[idx] = lightSampler;
        pair.textures[idx] = lightTex;
        job.renderParameters.customData = pair;

      } else {
        job.renderParameters.customData = job.materialParameters.customData;
      }
    }

  }

  static final _opaque = new BlendState.opaque();
  static final _additive = new BlendState.additive();
  static final _alphaBlend = new BlendState.alphaBlend();
  static final _nonPremultiplied = new BlendState.nonPremultiplied();

  void setBlendMode(BlendMode modus) {
    switch(modus) {
      case(BlendMode.opaque):
        _context.setBlendState(_opaque);
        break;
      case(BlendMode.additive):
        _context.setBlendState(_additive);
        break;
      case(BlendMode.alphaBlend):
        _context.setBlendState(_alphaBlend);
        break;
      case(BlendMode.nonPremultiplied):
        _context.setBlendState(_nonPremultiplied);
        break;
    }

  }

  static final _none = new DepthState.none();
  static final _read = new DepthState.depthRead();
  static final _write = new DepthState.depthWrite();

  void setDepthMode(DepthMode modus) {
    switch(modus) {
      case(DepthMode.depthRead):
        _context.setDepthState(_read);
        break;
      case(DepthMode.depthWrite):
        _context.setDepthState(_write);
        break;
      case(DepthMode.none):
        _context.setDepthState(_none);
        break;
    }

  }

  void drawBatch(List<RenderBatchJob> renderBatchJobs, GlobalParameters gobalParameters) {

  }

  void drawQueue(List<RenderJob> renderJobs, GlobalParameters gobalParameters, int sortMode) {
    _device.context.setViewport(_viewport);
    Matrix4 vm = gobalParameters.viewMatrix;

    
    
    for(RenderJob job in renderJobs) {

      SingleArrayIndexedMesh mesh = job.meshParameters.customData;
      ShaderProgram shaderProgram = job.shader.customData;
      MaterialParameters mat = job.materialParameters;
      InputLayout input = job.customData;
      Matrix4 wm = job.renderParameters.worldMatrix;
      Matrix4 pvwm = job.renderParameters.worldViewProjection;
      //job.renderParameters.worldViewMatrix

      TextureSamplerPairs  tsp = job.renderParameters.customData;

      //_device.context.reset();
      _device.context.setShaderProgram(shaderProgram);

      //_device.context.setPrimitiveTopology(PrimitiveTopology.Triangles);
      //_device.context.setRasterizerState(_rasterizationState);

      shaderProgram.uniforms.forEach((String uniformName, ShaderProgramUniform value) {

        /*
         *
         * ModelMatrix
         * ProjetionMatrix
         * MVMatrix
         * MVCMatrix
         */
        switch(uniformName) {

          case('cameraTransform'):
            _device.context.setConstant('cameraTransform', pvwm.storage);
            break;
          case('MATRIX_MVP'):
            _device.context.setConstant('MATRIX_MVP', pvwm.storage);
            //print('Matrix_MVP: ${wm}');
            break;
          case('modelViewMatrix'):
            _device.context.setConstant('modelViewMatrix', (vm*wm).storage);
            break;
          case('cameraPosition'):
            _device.context.setConstant('cameraPosition', gobalParameters.cameraPosition.storage);
          break;
          case('MATRIX_M'):
            _device.context.setConstant('MATRIX_M', wm.storage);
          break;
          case('MATRIX_MV'):
            _device.context.setConstant('MATRIX_MV', (vm*wm).storage);
          break;
          case('MATRIX_P'):
            _device.context.setConstant('MATRIX_P', gobalParameters.projection.storage);
          break;
          case('MATRIX_VP'):
            _device.context.setConstant('MATRIX_VP', (gobalParameters.viewMatrix*gobalParameters.projection).storage);
          break;
          case('projectionMatrix'):
            _device.context.setConstant('projectionMatrix', gobalParameters.projection.storage);
          break;
          case('BONE_MATRICES[0]'):
            _device.context.setConstant('BONE_MATRICES[0]', job.renderParameters.skinnedBones);
          break;
          default:
            var value = mat.uniforms[uniformName];
            if(value != null) {
              _device.context.setConstant(uniformName, value);
            } else {
            }
        }
      });
      //_device.context.setConstant('cameraTransform', pvwm.storage);

      /*
      mat.uniforms.forEach((String name, dynamic value) {
        _device.context.setConstant(name, value);
        //print('$name: $value');//if(name=="_cutOff")
      });
      */
      if(job.renderParameters.usesLightmaps) {
        _device.context.setConstant('lightmapTilingOffset', job.renderParameters.lightmapTilingOffset.storage);
        //print(job.renderParameters.lightmapTilingOffset.storage);
      }
      _device.context.setTextures(0, tsp.textures);
      _device.context.setSamplers(0, tsp.samplerStates);


      //print(cameraNormal);
      //_device.context.setConstant('normalTransform', cameraNormal.storage);
      //_device.context.setConstant('objectTransform', wm.storage);
      //print(wm.storage);

      //_device.context.setConstant('lightDirection', new Float32List.fromList([0.0,1.0,0.0]) );


      //context.setBlendState(_skyboxBlendState);
      //context.setRasterizerState(_skyboxRasterizerState);
      //context.setDepthState(_skyboxDepthState);

      // Set Material Constants


      // Draw the mesh
      //print(renderer._inputLayout.mesh);
      _device.context.setInputLayout(input);
      _device.context.setIndexedMesh(mesh);
      _device.context.drawIndexedMesh(mesh);
      
      
      //_device.context.setDepthState(_write);
      /*
      while(renderJobs.length > 0) {
        var job = renderJobs.first;
        TextureSamplerPairs  tsp = job.renderParameters.customData;
        ShaderProgram shaderProgram = job.shader.customData;
        MaterialParameters mat = job.materialParameters;
        _device.context.setTextures(0, tsp.textures);
        _device.context.setSamplers(0, tsp.samplerStates);
        shaderProgram.uniforms.forEach((String uniformName, ShaderProgramUniform value) {
          switch(uniformName) {
            case('cameraTransform'):
              //_device.context.setConstant('cameraTransform', pvwm.storage);
              break;
            case('modelViewMatrix'):
              //_device.context.setConstant('modelViewMatrix', (vm*wm).storage);
              break;
            case('cameraPosition'):
              _device.context.setConstant('cameraPosition', gobalParameters.cameraPosition.storage);
            break;
            case('projectionMatrix'):
              _device.context.setConstant('projectionMatrix', gobalParameters.projection.storage);
            break;
            default:
              var value = mat.uniforms[uniformName];
              if(value != null) {
                _device.context.setConstant(uniformName, value);
              }
          }
        }
        */
        /*

        for(int i=0; i < renderJobs.length; i++) {
          var renderJob = renderJobs[i];
          if(renderJob.materialParameters != job.materialParameters) continue;
          renderJobs.removeAt(i);
          Matrix4 wm = renderJobs.renderParameters.worldMatrix;
          Matrix4 pvwm = renderJobs.renderParameters.worldViewProjection;
          _device.context.setConstant('cameraTransform', pvwm.storage);
          if(shaderProgram.uniforms.containsKey('modelViewMatrix')) {
            _device.context.setConstant('modelViewMatrix', (vm*wm).storage);
          }
        }
      }*/
      
      
      // Optimize Texture use
    }

  }

  void debugDraw(Matrix4 viewProjectionMat) {
    //Debug.drawCross(new Vector3.zero(), DebugDrawManager.ColorBlue);
    //Debug.drawLine(new Vector3(0.0,1.0,0.0), new Vector3(0.0,3.0,0.0), DebugDrawManager.ColorBlue);
    //Debug.drawAABB(new Vector3(-1.0,-1.0,-1.0), new Vector3(1.0,1.0,1.0), DebugDrawManager.ColorRed);
    //(debug as WebGLDebugDrawManager).update(Time.deltaTime);
    (debug as WebGLDebugDrawManager).prepareForRender();
    (debug as WebGLDebugDrawManager).render(viewProjectionMat);
  }

  void clear(Vector4 color, double depth, double stencil) {
    _device.context.clearColorAndDepthBuffer( color.x, color.y, color.z, color.w, depth);

  }
  void update(double dt) {
    debug.update(dt);
  }
  void reset() {

  }
}