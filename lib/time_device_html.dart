library time_device_html;
import 'dart:html';
import 'time_device.dart';

//typedef double GetTime();

double _performance() => window.performance.now();

var _stopWatch = new Stopwatch()
..start();
double _fallbackTime() => _stopWatch.elapsedMilliseconds * 1000;

class TimeDeviceHtml implements TimeDevice {
  double updateTimeStep = 0.015;
  final GetTime _currentTime;
  double get timeSinceStartup => _currentTime();
  Update updateCallback;
  int _requestId;
  TimeDeviceHtml() : _currentTime = Performance.supported ? _performance : _fallbackTime;


  void start() {
    window.requestAnimationFrame(_update);
  }
  void _update(_) {
    if(updateCallback != null) {
      updateCallback();
    }
    _requestId = window.requestAnimationFrame(_update);
  }

  void stop() {
    if(_requestId != null) {
      window.cancelAnimationFrame(_requestId);
      _requestId = null;
    }
  }
}