/// Interface: Connectable
/// 
/// Dart does not have a separate 'interface' keyword; instead, every class 
/// implicitly defines an interface, and abstract classes (or abstract interface classes in Dart 3)
/// are used to define explicit interfaces that subclasses must implement.
abstract class Connectable {
  /// Checks whether the device is currently connected to the smart network.
  bool isConnected();

  /// Connects the device to the smart network.
  void connect();

  /// Disconnects the device from the smart network.
  void disconnect();
}

