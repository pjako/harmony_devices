library input_device;

/** The state of an analog input button */
class AnalogButton {
  /** The button id */
  final int buttonId;
  /** Value of analog button, between -1.0 and 1.0 */
  double value = 0.0;
  /** The frame when the button was last updated */
  int frame = 0;
  /** The time when the button was last updated */
  double time = 0.0;
  AnalogButton(this.buttonId);
}

class DigitalButton {
  /** buttonId */
  final int buttonId;
  /** Frame when button was last pressed. */
  int framePressed = 0;
  /** Frame when button was last released. */
  int frameReleased = 0;
  /** Time when button was last pressed. */
  double timePressed = 0.0;
  /** Time when button was last released. */
  double timeReleased = 0.0;
  DigitalButton(this.buttonId);

  /** Is button down in this frame? */
  bool get down => framePressed > frameReleased;
  /** Is button up in this frame? */
  bool get up => frameReleased >= framePressed;
}

class DigitalButtonEvent {
  final bool down;
  final int frame;
  final int buttonId;
  final double time;

  DigitalButtonEvent(this.buttonId, this.down, this.frame, this.time);

  String toString() => 'Button: $buttonId DOWN: $down [$frame@$time]';
}

/** A collection of digital input buttons */
class DigitalInput {
  /** Game loop this digital input belongs to. */
  final InputDevice _inputDevice;
  /** Buttons this digital input knows about */
  final Map<int, DigitalButton> buttons =
      new Map<int, DigitalButton>();

  /** Create a digital input that supports all buttons in buttonIds. */
  DigitalInput(this._inputDevice, List<int> buttonIds) {
    for (int buttonId in buttonIds) {
      buttons[buttonId] = new DigitalButton(buttonId);
    }
  }

  /** Deliver an input event */
  void digitalButtonEvent(DigitalButtonEvent event) {
    DigitalButton button = buttons[event.buttonId];
    if (button == null) {
      return;
    }
    if (event.down) {
      if (button.down == false) {
        // Ignore repeated downs.
        button.framePressed = event.frame;
        button.timePressed = event.time;
      }
    } else {
      button.frameReleased = event.frame;
      button.timeReleased = event.time;
    }
  }

  /** Is [buttonId] down this frame? */
  bool isDown(int buttonId) {
    DigitalButton button = buttons[buttonId];
    if (button == null) {
      return false;
    }
    return button.down;
  }

  /** Was [buttonId] just pressed down? */
  bool pressed(int buttonId) {
    DigitalButton button = buttons[buttonId];
    if (button == null) {
      return false;
    }
    return button.framePressed == _inputDevice._frame;
  }

  /** Was [buttonId] just released? */
  bool released(int buttonId) {
    DigitalButton button = buttons[buttonId];
    if (button == null) {
      return false;
    }
    return button.frameReleased == _inputDevice._frame;
  }

  /** Is [buttonId] up this frame? */
  bool isUp(int buttonId) {
    DigitalButton button = buttons[buttonId];
    if (button == null) {
      return true;
    }
    return button.up;
  }

  /** Time [buttonId] was pressed. */
  double timePressed(int buttonId) {
    DigitalButton button = buttons[buttonId];
    if (button == null) {
      return 0.0;
    }
    return button.timePressed;
  }

  /** Time [buttonId] was released. */
  double timeReleased(int buttonId) {
    DigitalButton button = buttons[buttonId];
    if (button == null) {
      return 0.0;
    }
    return button.timeReleased;
  }
}

/** A collection of analog input buttons */
class AnalogInput {
  final Map<int, AnalogButton> buttons =
      new Map<int, AnalogButton>();

  /** Create a digital input that supports all buttons in buttonIds. */
  AnalogInput(List<int> buttonIds) {
    for (int buttonId in buttonIds) {
      buttons[buttonId] = new AnalogButton(buttonId);
    }
  }

  /** The time the button was updated. */
  double timeUpdated(int buttonId) {
    AnalogButton button = buttons[buttonId];
    if (button == null) {
      return 0.0;
    }
    return button.time;
  }

  /** The frame the button was updated. */
  int frameUpdated(int buttonId) {
    AnalogButton button = buttons[buttonId];
    if (button == null) {
      return 0;
    }
    return button.frame;
  }

  /** The value of [buttonId]. */
  double value(int buttonId) {
    AnalogButton button = buttons[buttonId];
    if (button == null) {
      return 0.0;
    }
    return button.value;
  }
}

class GamePad {
  static const int BUTTON0 = 0;
  static const int BUTTON1 = 1;
  static const int BUTTON2 = 2;
  static const int BUTTON3 = 3;
  static const int BUTTON4 = 4;
  static const int BUTTON5 = 5;
  static const int BUTTON6 = 6;

  DigitalInput buttons;
  AnalogInput sticks;

  GameLoopGamepad() {
  }
}


class InputDevice {
  int _frame = 0;
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

  void update(double gameTime, double lostTime, int frame) {
    _frame = frame;

  }

  void processInputEvents(double currentVirtualTime) {

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

  int get gamePadCount => 0;

  GamePad gamePad(int idx) => null;


}