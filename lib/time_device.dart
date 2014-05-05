library time_device;
import 'dart:async';




typedef void Update();

typedef double GetTime();

var _stopWatch = new Stopwatch()
..start();
double _fallbackTime() => _stopWatch.elapsedMilliseconds * 1000;

class TimeDevice {
  Duration _duration;
  final GetTime _currentTime;
  double get timeSinceStartup => _currentTime();
  Timer _timer;
  TimeDevice() : _currentTime = _fallbackTime, _duration = new Duration(milliseconds: (0.015*1000.0).toInt()) {

  }
  Update updateCallback;
  void start() {
    Timer.run(_update);

  }
  void stop() {
    if(_timer != null) {
      _timer.cancel();
      _timer = null;
    }

  }

  void _update() {
    if(updateCallback != null) {
      updateCallback();
    }

    _timer = new Timer(_duration, _update);
  }


}