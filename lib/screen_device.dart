library screen_device;

abstract class ScreenDevice {
  ScreenDevice() {}
  int get height => 0;
  int get width => 0;
  bool get mouseLocked => false;
  bool get fullscreen => true;
}