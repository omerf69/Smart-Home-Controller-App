import 'smart_device.dart';
import 'connectable.dart';
import 'schedulable.dart';

/// Concrete Subclass: Thermostat
/// 
/// OOP Concepts Demonstrated:
/// 1. Inheritance: 'extends SmartDevice'
/// 2. Interface: 'implements Connectable'
/// 3. Mixin: 'with Schedulable'
/// 4. Constructors:
///    - Default Constructor: Thermostat(...)
///    - Named Constructor: Thermostat.eco(...)
///    - Named Constructor: Thermostat.boost(...)
/// 5. Keywords:
///    - 'super' calling base class constructor
///    - 'this' referencing instance properties and disambiguating parameters
class Thermostat extends SmartDevice with Schedulable implements Connectable {
  double temperature; // Temperature in Celsius (°C)
  bool isHeating;

  /// Default Constructor:
  /// Uses 'super' for base class setup and 'this' for own fields.
  Thermostat({
    required super.name,
    this.temperature = 22.0,
    this.isHeating = true,
  }) : super(deviceType: 'Thermostat');

  /// Named Constructor: Thermostat.eco
  /// Sets up an eco-friendly mode preset (19°C, idle heating).
  Thermostat.eco({
    required super.name,
  })  : temperature = 19.0,
        isHeating = false,
        super(deviceType: 'Thermostat');

  /// Named Constructor: Thermostat.boost
  /// Sets up boost mode (26°C, active heating).
  Thermostat.boost({
    required super.name,
  })  : temperature = 26.0,
        isHeating = true,
        super(deviceType: 'Thermostat');

  // --- Implementation of Abstract Methods from SmartDevice ---

  @override
  String getStatus() {
    return isHeating ? 'Heating' : 'Idle';
  }

  @override
  String getPrimaryProperty() {
    return 'Temperature: ${temperature.toInt()}°C';
  }

  @override
  void performAction() {
    isHeating = !isHeating;
  }

  /// Adjusts temperature up by 1°C
  void increaseTemperature() {
    if (temperature < 35.0) {
      temperature += 1.0;
      if (temperature >= 20.0) {
        isHeating = true;
      }
    }
  }

  /// Adjusts temperature down by 1°C
  void decreaseTemperature() {
    if (temperature > 10.0) {
      temperature -= 1.0;
      if (temperature <= 17.0) {
        isHeating = false;
      }
    }
  }

  /// Demonstrates 'this' keyword to distinguish parameter from instance variable
  void setTargetTemperature(double temperature) {
    this.temperature = temperature;
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
