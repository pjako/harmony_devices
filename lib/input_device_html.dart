library input_device_html;
import 'dart:html';
import 'input_device.dart';




class InputDeviceHtml implements InputDevice {
  CanvasElement element;
  int get mouseLastFrameUpdate => -1;
  double get mouseLastUpdateTime => 0.0;
  int get mouseX => 0;
  int get mouseY => 0;
  int get mouseDx => 0;
  int get mouseDy => 0;
  int get mouseClampX => 0;
  int get mouseClampY => 0;
  int get wheelDx => 0;
  int get wheelDy => 0;
  bool get mouseWithinCanvas => true;

  double get mouseXaxis => 0.0;
  double get mouseYaxis => 0.0;
  InputDeviceHtml(CanvasElement this.element);


  void update(double gameTime, double lostTime, int frame) {
    super.update(gameTime, lostTime, frame);

  }


  void processInputEvents(double currentVirtualTime) {
      //double currentVirtualTime = _gameTime + _timeLost;
      _processKeyboardEvents(currentVirtualTime);
      _processMouseEvents(currentVirtualTime);
      _processTouchEvents(currentVirtualTime);
    }

    void _processKeyboardEvents(double currentVirtualTime) {
      int idx = 0;
      for (;idx < _keyboardEvents.length; idx++) {
        double timeStamp = _keyboardEventTime[idx];
        if(currentVirtualTime < timeStamp) {
          idx--;
          break;
        }
        KeyboardEvent keyboardEvent = _keyboardEvents[idx];
        DigitalButtonEvent event;
        bool down = keyboardEvent.type == "keydown";
        double time = GameLoop.timeStampToSeconds(keyboardEvent.timeStamp);
        int buttonId = keyboardEvent.keyCode;
        event = new DigitalButtonEvent(buttonId, down, frame, time);
        _keyboard.digitalButtonEvent(event);
      }
      if (idx > 0) {
        _keyboardEvents.removeRange(0, idx);
        _keyboardEventTime.removeRange(0, idx);
      }
    }

    void _processMouseEvents(double currentVirtualTime) {
      mouse._resetAccumulators();
      // TODO(alexgann): Remove custom offset logic once dart:html supports natively (M6).
      final docElem = document.documentElement;
      final box = element.getBoundingClientRect();
      int canvasX = (box.left + window.pageXOffset - docElem.clientLeft).floor();
      int canvasY = (box.top  + window.pageYOffset - docElem.clientTop).floor();
      int idx = 0;
      for(;idx < _mouseEvents.length; idx++) {
        double timeStamp = _mouseEventTime[idx];
        if(currentVirtualTime < timeStamp) {
          idx--;
          break;
        }
        MouseEvent mouseEvent = _mouseEvents[idx];
        bool moveEvent = mouseEvent.type == 'mousemove';
        bool wheelEvent = mouseEvent.type == 'mousewheel';
        bool down = mouseEvent.type == 'mousedown';
        double time = GameLoop.timeStampToSeconds(mouseEvent.timeStamp);
        if (moveEvent) {
          int mouseX = mouseEvent.page.x;
          int mouseY = mouseEvent.page.y;
          int x = mouseX - canvasX;
          int y = mouseY - canvasY;
          int clampX = 0;
          int clampY = 0;
          bool withinCanvas = false;
          if(mouseX < canvasX) {
            clampX = 0;
          } else if(mouseX > canvasX+width) {
            clampX = width;
          } else {
            clampX = x;
            withinCanvas = true;
          }
          if(mouseY < canvasY) {
            clampY = 0;
            withinCanvas = false;
          } else if(mouseY > canvasY+height) {
            clampY = height;
            withinCanvas = false;
          } else {
            clampY = y;
          }

          int dx = mouseEvent.client.x-_lastMousePos.x;
          int dy = mouseEvent.client.y-_lastMousePos.y;
          _lastMousePos = mouseEvent.client;
          var event = new GameLoopMouseEvent(x, y, dx, dy, clampX, clampY, withinCanvas, time, frame);
          _mouse.gameLoopMouseEvent(event);
        } else if (wheelEvent) {
          WheelEvent wheel = mouseEvent as WheelEvent;
          _mouse._accumulateWheel(wheel.deltaX, wheel.deltaY);
        } else {
          int buttonId = mouseEvent.button;
          var event = new DigitalButtonEvent(buttonId, down, frame, time);
          _mouse.digitalButtonEvent(event);
        }
      }
      if (idx > 0) {
        _mouseEvents.removeRange(0, idx);
        _mouseEventTime.removeRange(0, idx);
      }
    }

    void _processTouchEvents(double currentVirtualTime) {
      int idx = 0;
      for(; idx < _touchEvents.length; idx++) {
        _TouchEvent touchEvent = _touchEvents[idx];
        if(touchEvent.time > currentVirtualTime) {
          idx--;
          break;
        }
        touchEvent = _touchEvents[idx];
        switch (touchEvent.type) {
          case _TouchEvent.Start:
            _touchSet._start(touchEvent.event);
            break;
          case _TouchEvent.End:
            _touchSet._end(touchEvent.event);
            break;
          case _TouchEvent.Move:
            _touchSet._move(touchEvent.event);
            break;
          default:
            throw new StateError('Invalid TouchEvent type.');
        }
      }
      if (idx > 0) {
        _touchEvents.removeRange(0, idx-1);
      }
  }

  bool buttonPressed(int buttonId) {
    return false;
  }
  bool buttonDown(int buttonId) {
    return false;
  }
  bool buttonUp(int buttonId) {
    return true;
  }
  bool buttonReleased(int buttonId) {
    return false;
  }
  double buttonTimePressed(int buttonId) {
    return 0.0;
  }
  double buttonTimeReleased(int buttonId) {
    return 0.0;
  }


  bool keyPressed(int keyId) {
    return false;
  }
  bool keyDown(int keyId) {
    return false;
  }
  bool keyUp(int keyId) {
    return true;
  }
  bool keyReleased(int keyId) {
    return false;
  }
  double keyTimePressed(int keyId) {
    return 0.0;
  }
  double keyTimeReleased(int keyId) {
    return 0.0;
  }




  final List<_TouchEvent> _touchEvents = new List<_TouchEvent>();
  void _touchStartEvent(TouchEvent event) {
    _touchEvents.add(new _TouchEvent(event, _TouchEvent.Start,
        time));
  }
  void _touchMoveEvent(TouchEvent event) {
    _touchEvents.add(new _TouchEvent(event, _TouchEvent.Move,
        time));
  }
  void _touchEndEvent(TouchEvent event) {
    _touchEvents.add(new _TouchEvent(event, _TouchEvent.End,
        time));
  }

  final List<KeyboardEvent> _keyboardEvents = new List<KeyboardEvent>();
  final List<double> _keyboardEventTime = new List<double>();
  void _keyDown(KeyboardEvent event) {
    _keyboardEvents.add(event);
    _keyboardEventTime.add(time);
  }

  void _keyUp(KeyboardEvent event) {
    _keyboardEvents.add(event);
    _keyboardEventTime.add(time);
  }

  final List<MouseEvent> _mouseEvents = new List<MouseEvent>();
  final List<double> _mouseEventTime = new List<double>();
  void _mouseDown(MouseEvent event) {
    _mouseEvents.add(event);
    _mouseEventTime.add(time);
  }

  void _mouseUp(MouseEvent event) {
    _mouseEvents.add(event);
    _mouseEventTime.add(time);
  }

  void _mouseMove(MouseEvent event) {
    _mouseEvents.add(event);
    _mouseEventTime.add(time);
  }

  void _mouseWheel(MouseEvent event) {
    _mouseEvents.add(event);
    _mouseEventTime.add(time);
    event.preventDefault();
  }
}