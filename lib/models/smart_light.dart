import 'smart_device.dart';
import 'connectable.dart';
import 'schedulable.dart';

/// Concrete Subclass: SmartLight
/// 
/// OOP Concepts Demonstrated:
/// 1. Inheritance: 'extends SmartDevice'
/// 2. Interface: 'implements Connectable'
/// 3. Mixin: 'with Schedulable'
/// 4. Constructors:
///    - Default Constructor: SmartLight(...)
///    - Named Constructor: SmartLight.off(...)
///    - Named Constructor: SmartLight.preset(...)
/// 5. Keywords:
///    - 'super' to pass parameters to the SmartDevice base class
///    - 'this' to reference instance members and disambiguate parameters
class SmartLight extends SmartDevice with Schedulable implements Connectable {
  int brightness; // 0 to 100 percentage
  bool isOn;
  int _lastActiveBrightness;

  /// Default Constructor:
  /// Uses 'super' to delegate name and type initialization to SmartDevice,
  /// and 'this' to initialize light-specific fields.
  SmartLight({
    required super.name,
    this.brightness = 75,
    this.isOn = true,
  })  : _lastActiveBrightness = brightness > 0 ? brightness : 75,
        super(deviceType: 'Smart Light') {
    if (!isOn) {
      brightness = 0;
    }
  }

  /// Named Constructor: SmartLight.off
  /// Creates a SmartLight that starts in an OFF state with 0% brightness.
  SmartLight.off({
    required super.name,
  })  : _lastActiveBrightness = 75,
        brightness = 0,
        isOn = false,
        super(deviceType: 'Smart Light');

  /// Named Constructor: SmartLight.preset
  /// Creates a SmartLight with custom brightness preset.
  SmartLight.preset({
    required super.name,
    required int presetBrightness,
  })  : _lastActiveBrightness = presetBrightness,
        brightness = presetBrightness,
        isOn = true,
        super(deviceType: 'Smart Light');

  // --- Implementation of Abstract Methods from SmartDevice ---

  @override
  String getStatus() {
    return isOn ? 'ON' : 'OFF';
  }

  @override
  String getPrimaryProperty() {
    return 'Brightness: ${isOn ? brightness : 0}%';
  }

  @override
  void performAction() {
    togglePower();
  }

  /// Specific action for light: toggle power on/off
  void togglePower() {
    isOn = !isOn;
    if (isOn) {
      brightness = _lastActiveBrightness > 0 ? _lastActiveBrightness : 75;
    } else {
      brightness = 0;
    }
  }

  /// Demonstrates 'this' keyword to disambiguate parameter from instance field
  void setBrightnessLevel(int brightness) {
    if (brightness <= 0) {
      isOn = false;
      this.brightness = 0;
    } else {
      isOn = true;
      this.brightness = brightness.clamp(1, 100);
      _lastActiveBrightness = this.brightness;
    }
  }

  // --- Implementation of Connectable Interface ---

  @override
  bool isConnected() {
    return isDeviceConnected;
  }

  @override
  void connect() {
    isDeviceConnected = true;
  }

  @override
  void disconnect() {
    isDeviceConnected = false;
  }
}
