import 'package:flutter/material.dart';
import '../models/devices.dart';

/// DeviceCard: A reusable, interactive widget displaying a SmartDevice.
/// 
/// Interacts with any concrete subclass of [SmartDevice] polymorphically,
/// calling abstract methods like [getStatus] and [getPrimaryProperty],
/// and device-specific controls for each subclass.
class SmartDeviceCard extends StatelessWidget {
  final SmartDevice device;
  final VoidCallback onStateChanged;

  const SmartDeviceCard({
    super.key,
    required this.device,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Left Device Icon Avatar
            _buildDeviceIcon(),
            const SizedBox(width: 14),

            // Middle Column: Name, Property, Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title: e.g. "Smart Light: Living Room"
                  Text(
                    '${device.deviceType}: ${device.name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Property: e.g. "Brightness: 75%", "Temperature: 22°C"
                  Text(
                    device.getPrimaryProperty(),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Status indicator with dot: e.g. "• Status: ON"
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStatusDotColor(),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Status: ${device.getStatus()}',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right Action Control (Device-Specific)
            _buildDeviceControl(context),
          ],
        ),
      ),
    );
  }

  /// Builds the left-hand icon container based on device subclass & active state
  Widget _buildDeviceIcon() {
    IconData iconData;
    Color iconColor;
    Color bgColor;

    if (device is SmartLight) {
      final light = device as SmartLight;
      if (light.isOn) {
        iconData = Icons.lightbulb_rounded;
        iconColor = const Color(0xFFF59E0B); // Amber
        bgColor = const Color(0xFFFEF3C7);
      } else {
        iconData = Icons.lightbulb_outline_rounded;
        iconColor = Colors.grey.shade400;
        bgColor = Colors.grey.shade100;
      }
    } else if (device is Thermostat) {
      final thermo = device as Thermostat;
      iconData = Icons.thermostat_rounded;
      if (thermo.isHeating) {
        iconColor = const Color(0xFFEF4444); // Red/Orange
        bgColor = const Color(0xFFFEE2E2);
      } else {
        iconColor = Colors.grey.shade500;
        bgColor = Colors.grey.shade100;
      }
    } else if (device is SmartSpeaker) {
      final speaker = device as SmartSpeaker;
      iconData = Icons.speaker_rounded;
      if (speaker.isPlaying) {
        iconColor = const Color(0xFF2563EB); // Vibrant Blue
        bgColor = const Color(0xFFDBEAFE);
      } else {
        iconColor = Colors.grey.shade400;
        bgColor = Colors.grey.shade100;
      }
    } else {
      iconData = Icons.devices_rounded;
      iconColor = Colors.blue;
      bgColor = Colors.blue.shade50;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }

  /// Returns the color of the status indicator dot
  Color _getStatusDotColor() {
    final status = device.getStatus();
    if (status == 'ON' || status == 'Heating' || status == 'Playing') {
      return const Color(0xFF10B981); // Emerald Green
    }
    return Colors.grey.shade400;
  }

  /// Builds the device-specific interactive control on the right side of the card
  Widget _buildDeviceControl(BuildContext context) {
    if (device is SmartLight) {
      final light = device as SmartLight;
      return Transform.scale(
        scale: 0.9,
        child: Switch(
          value: light.isOn,
          activeTrackColor: const Color(0xFF2563EB),
          activeThumbColor: Colors.white,
          onChanged: (bool value) {
            light.performAction();
            onStateChanged();
          },
        ),
      );
    } else if (device is Thermostat) {
      final thermo = device as Thermostat;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus button
          _buildCircleButton(
            icon: Icons.remove,
            onPressed: () {
              thermo.decreaseTemperature();
              onStateChanged();
            },
          ),
          const SizedBox(width: 8),
          // Plus button
          _buildCircleButton(
            icon: Icons.add,
            onPressed: () {
              thermo.increaseTemperature();
              onStateChanged();
            },
          ),
        ],
      );
    } else if (device is SmartSpeaker) {
      final speaker = device as SmartSpeaker;
      return Material(
        color: const Color(0xFF2563EB),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            speaker.performAction();
            onStateChanged();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              speaker.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Helper widget for the circular thermostat adjustment buttons
  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 18,
        icon: Icon(icon, color: Colors.grey.shade700),
        onPressed: onPressed,
      ),
    );
  }
}
