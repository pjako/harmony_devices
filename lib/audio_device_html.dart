library audio_device_html;
import 'dart:async';
import 'audio_device.dart';
import 'dart:typed_data';
import 'package:simple_audio/simple_audio.dart'  as am;
import 'package:resources_io/resources.dart';
@HandlesAsset('wav')
@HandlesAsset('mp3')
@HandlesAsset('ogg')
class AudioClipHandler extends AssetHandler {
  final AudioDeviceHtml _device;
  List<WebAudioClip> _cache = [];

  AudioClipHandler(): _device = _audioDevice;

  Asset _getFree() {
    if(_cache.isEmpty) {
      return new WebAudioClip(_device);
    }
    return _cache.removeLast();
  }

  Asset create() => _getFree();

  Asset load(String src, LoaderDevice loader) {
    var clip = create();

    loader.loadFileAsBinary(src).then((buffer) {
      var aclip = new am.AudioClip.external(_device,src,src);

      aclip.loadFromByteBuffer(buffer).then((onValue) {
        clip._clip = aclip;
        this.loadingDone(clip);
      });
    });

    return clip;
  }
  bool unload(Asset asset) {
    var clip = asset as WebAudioClip;
    _device.removeClip(clip.assetId);
    clip._clip = null;
    clip._rawBuffer = null;
    _cache.add(asset);
    return true;

  }
  Future save(Asset asset, String src, LocalFileHandler saveDevice) {
    var clip = asset as WebAudioClip;
    return saveDevice.saveBinary(asset.assetId, clip._rawBuffer);
  }
}


class WebAudioClip extends Asset implements AudioClip  {
  final AudioDeviceHtml _device;
  ByteBuffer _rawBuffer;
  am.AudioClip _clip;
  WebAudioClip(this._device);

}


class WebAudioSource implements Source {
  final am.AudioSource _source;

  WebAudioSource(this._source);

  /** Is the source muted? */
  bool get mute {
    return _source.mute;
  }

  void set mute(bool b) {
    _source.mute = b;
  }

  void playOnce(AudioClip clip) {
    _source.playOnce((clip as WebAudioClip)._clip);
  }

  void playOnceIn(num delay, AudioClip clip) {
    _source.playOnceIn(delay, (clip as WebAudioClip)._clip);
  }

  void playLooped(AudioClip clip) {
    playLoopedIn(0.0, clip);
  }

  void playLoopedIn(num delay, AudioClip clip) {
    _source.playLoopedIn(delay, (clip as WebAudioClip)._clip);
  }

  bool get pause => _source.pause;

  void set pause(bool b) {
    _source.pause = b;
  }

  num get volume => _source.volume;

  void set volume(num v) {
    _source.volume = v;
  }


  void stop() {
  }


  num get x => _source.x;

  num get y => _source.y;

  num get z => _source.z;

  /**
   * Set the position of the source.
   */
  void setPosition(num x, num y, num z) {
    _source.setPosition(x, y, z);
  }

  /**
   * Set the linear velocity of the source.
   */
  void setVelocity(num x, num y, num z) {
    _source.setVelocity(x, y, z);
  }
}

class WebAudioListener implements Listener {
  final AudioDeviceHtml _device;


  WebAudioListener(this._device);

  num get dopplerFactor => _device.dopplerFactor;

  void set dopplerFactor(num df) {
    _device.dopplerFactor = df;
  }

  num get speedOfSound => _device.speedOfSound;

  void set speedOfSound(num sos) {
    _device.speedOfSound = sos;
  }

  void setPosition(num x, num y, num z) {
    _device.setPosition(x, y, z);
  }

  void setOrientation(num x, num y, num z, num xUp, num yUp, num zUp) {
    _device.setOrientation(x, y, z, xUp, yUp, zUp);
  }

  void setVelocity(num x, num y, num z) {
    _device.setVelocity(x, y, z);
  }
}
AudioDeviceHtml _audioDevice;

class AudioDeviceHtml extends am.AudioManager implements AudioDevice {

  AudioDeviceHtml() : super('') {
    _audioDevice = this;
  }
  
  void playMusic(AudioClip clip) {
    music.clip = (clip as WebAudioClip)._clip;
    music.play(); 
    
  }
  void crossFadeMusicLinear(AudioClip clip, double delay, double fadeDuration) {
    music.crossFadeLinear(delay, fadeDuration, (clip as WebAudioClip)._clip);
  }

  /** Create an [AudioSource] and assign it [name] */
  Source createSource(String name) {
    return new WebAudioSource(this.makeSource(name));
  }

  Listener createListener(String name) {
    return new WebAudioListener(this);
  }
  AudioClip createAudioClip(String name) {
    return new WebAudioClip(this);
  }

}



