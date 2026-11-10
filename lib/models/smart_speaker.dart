import 'smart_device.dart';
import 'connectable.dart';

/// Concrete Subclass: SmartSpeaker
/// 
/// OOP Concepts Demonstrated:
/// 1. Inheritance: 'extends SmartDevice'
/// 2. Interface: 'implements Connectable'
/// 3. Constructors:
///    - Default Constructor: SmartSpeaker(...)
///    - Named Constructor: SmartSpeaker.active(...)
///    - Named Constructor: SmartSpeaker.partyMode(...)
/// 4. Keywords:
///    - 'super' delegating base construction
///    - 'this' referencing instance members and disambiguating parameters
class SmartSpeaker extends SmartDevice implements Connectable {
  int volume; // 0 to 100 percentage
  bool isPlaying;

  /// Default Constructor:
  /// Uses 'super' to pass name and type to base class SmartDevice,
  /// and 'this' to assign volume and playing state.
  SmartSpeaker({
    required super.name,
    this.volume = 40,
    this.isPlaying = false,
  }) : super(deviceType: 'Smart Speaker');

  /// Named Constructor: SmartSpeaker.active
  /// Creates a speaker that is immediately set to playing state.
  SmartSpeaker.active({
    required super.name,
    this.volume = 50,
  })  : isPlaying = true,
        super(deviceType: 'Smart Speaker');

  /// Named Constructor: SmartSpeaker.partyMode
  /// Sets high volume and begins playing.
  SmartSpeaker.partyMode({
    required super.name,
  })  : volume = 80,
        isPlaying = true,
        super(deviceType: 'Smart Speaker');

  // --- Implementation of Abstract Methods from SmartDevice ---

  @override
  String getStatus() {
    return isPlaying ? 'Playing' : 'Paused';
  }

  @override
  String getPrimaryProperty() {
    return 'Volume: $volume%';
  }

  @override
  void performAction() {
    togglePlayback();
  }

  /// Toggles playback between Playing and Paused
  void togglePlayback() {
    isPlaying = !isPlaying;
  }

  /// Demonstrates 'this' keyword to disambiguate parameter from instance field
  void setSpeakerVolume(int volume) {
    this.volume = volume.clamp(0, 100);
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
