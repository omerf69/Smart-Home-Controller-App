import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home_controller/main.dart';
import 'package:smart_home_controller/models/devices.dart';

void main() {
  group('Smart Device OOP Unit Tests', () {
    setUp(() {
      SmartDevice.resetCount();
    });

    test('Constructors and Inheritance test', () {
      // Test default constructor
      final light = SmartLight(name: 'Living Room', brightness: 75, isOn: true);
      expect(light.name, 'Living Room');
      expect(light.brightness, 75);
      expect(light.isOn, true);
      expect(light.getStatus(), 'ON');
      expect(light.getPrimaryProperty(), 'Brightness: 75%');
      expect(light, isA<SmartDevice>());

      // Test named constructor
      final lightOff = SmartLight.off(name: 'Kitchen');
      expect(lightOff.isOn, false);
      expect(lightOff.brightness, 0);
      expect(lightOff.getStatus(), 'OFF');
      expect(lightOff.getPrimaryProperty(), 'Brightness: 0%');

      // Test static variable counter
      expect(SmartDevice.totalDevices, 2);
    });

    test('Thermostat interaction and interface test', () {
      final thermo = Thermostat(name: 'Bedroom', temperature: 22.0, isHeating: true);
      expect(thermo.temperature, 22.0);
      expect(thermo.getStatus(), 'Heating');
      expect(thermo.getPrimaryProperty(), 'Temperature: 22°C');

      // Test interaction
      thermo.increaseTemperature();
      expect(thermo.temperature, 23.0);
      expect(thermo.getPrimaryProperty(), 'Temperature: 23°C');

      thermo.decreaseTemperature();
      expect(thermo.temperature, 22.0);

      // Test Connectable interface
      expect(thermo.isConnected(), isTrue);
      thermo.disconnect();
      expect(thermo.isConnected(), isFalse);
      thermo.connect();
      expect(thermo.isConnected(), isTrue);
    });

    test('SmartSpeaker interaction test', () {
      final speaker = SmartSpeaker(name: 'Kitchen', volume: 40, isPlaying: false);
      expect(speaker.getStatus(), 'Paused');
      expect(speaker.getPrimaryProperty(), 'Volume: 40%');

      speaker.performAction();
      expect(speaker.getStatus(), 'Playing');

      speaker.performAction();
      expect(speaker.getStatus(), 'Paused');
    });

    test('Schedulable mixin test', () {
      final light = SmartLight(name: 'Porch');
      expect(light.hasSchedule, isFalse);
      light.setSchedule('08:00 AM');
      expect(light.hasSchedule, isTrue);
      expect(light.scheduledTime, '08:00 AM');
      expect(light.getScheduleSummary(), 'Scheduled at 08:00 AM');
      light.clearSchedule();
      expect(light.hasSchedule, isFalse);
    });
  });

  group('Widget UI Smoke & Interaction Tests', () {
    testWidgets('Renders devices and static total count accurately', (WidgetTester tester) async {
      await tester.pumpWidget(const SmartHomeControllerApp());
      await tester.pumpAndSettle();

      // Verify app bar title
      expect(find.text('Smart Home Controller'), findsOneWidget);

      // Verify bottom text from static counter
      expect(find.text('Total Devices: 5'), findsOneWidget);

      // Verify presence of all three device types
      expect(find.text('Smart Light: Living Room'), findsOneWidget);
      expect(find.text('Thermostat: Bedroom'), findsOneWidget);
      expect(find.text('Smart Speaker: Kitchen'), findsOneWidget);

      // Test Thermostat plus button interaction
      expect(find.text('Temperature: 24°C'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();
      expect(find.text('Temperature: 25°C'), findsOneWidget);

      // Test Speaker play/pause toggle interaction
      final pauseButton = find.byIcon(Icons.pause_rounded);
      expect(pauseButton, findsOneWidget);
      await tester.tap(pauseButton);
      await tester.pumpAndSettle();
      // Should now be paused and have play icon
      expect(find.byIcon(Icons.play_arrow_rounded), findsWidgets);
    });
  });
}
