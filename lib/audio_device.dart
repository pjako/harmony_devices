library audio_device;
import 'package:resources_io/resources.dart';


class AudioClip {
  factory AudioClip(AudioDevice device, String name) {
    return device.createAudioClip(name);
  }

}


/*
class Sound {
  num get _volume => 0;

  /** Is the sound scheduled to be played? */
  bool get isScheduled => false;
  /** Is the sound playing right now? */
  bool get isPlaying => false;
  /** Is the sound finished being played? */
  bool get isFinished => false;

  /** Is the sound paused? */
  bool get pause => true;

  /** Pause or unpause the sound. */
  void set pause(bool b) {
  }

  /**
   * Time cursor for sound. Will be negative is sound is scheduled
   * to be played. Positive if playing.
   */
  num get time => 0;

  /** Start playing this sound in [when] seconds. */
  void play([num when=0.0]) {
  }

  /** Fading linear IN this sound with [delay] and the [fadeDuration] with [volume] and [playFromStart] or just unpause */
  void fadeIn(num delay, num fadeDuration,[bool playFromStart = true, num targetVolume = 1.0]) {
  }
  /** Fading linear this sound with [delay] and the [fadeDuration] out and [doPause] or just stop  */
  void fadeOut(num delay, num fadeDuration, [bool doPause = false]) {

  }

  /** Starts fading linear this sound with [delay] and the [fadeDuration] till it reaches the [targetFadeVolumen]  */
  void fade(num delay, num fadeDuration, num targetFadeVolumen) {
  }

  /** Stop playing this sound */
  void stop() {
  }

  /** Get the volume of the sound. 0.0 <= volume <= 1.0. */
  num get volume => 0;

  /** Set the volume for the sound. */
  void set volume(num v) {

  }
}
*/

class Listener {

  factory Listener(AudioDevice device, String name) {
    return device.createListener(name);
  }

  num get dopplerFactor => 0.0;

  void set dopplerFactor(num df) {
  }

  num get speedOfSound => 0.0;

  void set speedOfSound(num sos) {
  }

  void setPosition(num x, num y, num z) {
  }

  void setOrientation(num x, num y, num z, num xUp, num yUp, num zUp) {
  }

  void setVelocity(num x, num y, num z) {
  }
}
class Source {

  factory Source(AudioDevice device, String name) {
    return device.createSource(name);
  }

  /** Is the source muted? */
  bool get mute {
    return true;
  }

  /** Mute or unmute the source. */
  void set mute(bool b) {
  }

  /** Play [clip] from the source. */
  void playOnce(AudioClip clip) {
    //return null;
  }

  /** Play [clip] from the source starting in [delay] seconds. */
  void playOnceIn(num delay, AudioClip clip) {
    //return null;
  }

  /** Play [clip] from the source in a loop. */
  void playLooped(AudioClip clip) {
    return playLoopedIn(0.0, clip);
  }

  /** Play [clip] from the source in a loop starting in [delay]
   * seconds.
   */
  void playLoopedIn(num delay, AudioClip clip) {
    return null;
  }
  

  /** Is the source currently paused? */
  bool get pause => true;

  /** Pause or resume the source */
  void set pause(bool b) {
  }
  /** Stop the source. Affects all playing and scheduled sounds. */
  void stop() {
  }

  /** X position of the source. */
  num get x => 0;
  /** Y position of the source. */
  num get y => 0;
  /** Z position of the source. */
  num get z => 0;

  num get volume => 0;

  void set volume(num v) {
  }

  /**
   * Set the position of the source.
   */
  void setPosition(num x, num y, num z) {
  }

  /**
   * Set the linear velocity of the source.
   */
  void setVelocity(num x, num y, num z) {
  }

}


class AudioDevice {

  /** Sample rate of the audio driver */
  num get sampleRate => 0.0;

  /** Get the music volume. */
  num get musicVolume => 0.0;
  /** Set the music volume. */
  void set musicVolume(num mv) {
  }

  /** Get the master volume. */
  num get masterVolume => 0.0;
  /** Set the master volume. */
  void set masterVolume(num mv) {
  }

  /** Get the sources volume */
  num get sourceVolume => 0.0;
  /** Set the sources volume */
  void set sourceVolume(num mv) {
  }

  /** Is the master volume muted? */
  bool get mute => true;

  /** Control the master mute */
  void set mute(bool b) {
  }
  
  void playMusic(AudioClip clip) {
    
  }
  
  void crossFadeMusicLinear(AudioClip clip, double delay, double fadeDuration) {
  }

  /** Pause both music and source based sounds. */
  void pauseAll() {
  }

  /** Resume both music and source based sounds. */
  void resumeAll() {
  }

  /** Pause source base sounds. */
  void pauseSources() {
  }

  /** Resume source base sounds. */
  void resumeSources() {
  }
  void removeClip(String name) {

  }
  
  

  /** Create an [AudioSource] and assign it [name] */
  Source createSource(String name) {
  }

  Listener createListener(String name) {
  }

  AudioClip createAudioClip(String name) {

  }

}