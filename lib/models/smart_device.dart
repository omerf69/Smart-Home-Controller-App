/// Abstract Base Class: SmartDevice
/// 
/// OOP Concepts Demonstrated:
/// 1. Class: Base class for all smart home devices.
/// 2. Abstraction: Declared as an 'abstract' class with abstract methods
///    [getStatus], [performAction], and [getPrimaryProperty].
/// 3. Static Keyword: Maintains a static counter [totalDevices] tracking all created devices.
/// 4. This Keyword: Used in constructors ('this.name') and methods to reference instance members.
abstract class SmartDevice {
  // Static variable tracking total instances created across the entire app
  static int totalDevices = 0;

  // Instance variables
  String name;
  String deviceType;
  bool isDeviceConnected;

  /// Default Constructor:
  /// Demonstrates 'this' keyword to initialize instance variables,
  /// and 'static' keyword to increment total device count.
  SmartDevice({
    required this.name,
    required this.deviceType,
    this.isDeviceConnected = true,
  }) {
    // Increment the static device counter whenever any SmartDevice is instantiated
    SmartDevice.totalDevices++;
  }

  /// Named Constructor:
  /// Demonstrates named constructor syntax in Dart alongside 'this' and 'static'.
  SmartDevice.withInitialConnection({
    required this.name,
    required this.deviceType,
    required bool isConnected,
  }) : isDeviceConnected = isConnected {
    // Increment the static device counter
    SmartDevice.totalDevices++;
  }

  // --- Abstract Methods (Abstraction) ---
  
  /// Returns the current operational status (e.g., 'ON', 'OFF', 'Heating', 'Playing').
  String getStatus();

  /// Performs the primary interactive action for the device.
  void performAction();

  /// Returns the device-specific primary property string (e.g., 'Brightness: 75%').
  String getPrimaryProperty();

  /// Concrete base method demonstrating inheritance and code reuse.
  /// Subclasses can call this via 'super.getDeviceInfo()'.
  String getDeviceInfo() {
    return '$deviceType: $name';
  }

  /// Demonstrates the 'this' keyword to disambiguate parameter name from field name.
  void updateDeviceName(String name) {
    this.name = name;
  }

  /// Decrement helper method if a device is removed from the active controller list.
  static void decrementCount() {
    if (totalDevices > 0) {
      totalDevices--;
    }
  }

  /// Static reset method for resetting state when loading presets.
  static void resetCount() {
    totalDevices = 0;
  }
}
