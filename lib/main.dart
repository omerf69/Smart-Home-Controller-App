import 'package:flutter/material.dart';
import 'models/devices.dart';
import 'widgets/smart_device_card.dart';

void main() {
  runApp(const SmartHomeControllerApp());
}

class SmartHomeControllerApp extends StatelessWidget {
  const SmartHomeControllerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home Controller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF2563EB),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const SmartHomeScreen(),
    );
  }
}

class SmartHomeScreen extends StatefulWidget {
  const SmartHomeScreen({super.key});

  @override
  State<SmartHomeScreen> createState() => _SmartHomeScreenState();
}

class _SmartHomeScreenState extends State<SmartHomeScreen> {
  // List of active SmartDevice objects
  final List<SmartDevice> _devices = [];

  @override
  void initState() {
    super.initState();
    // Initialize the default device list (demonstrating default and named constructors)
    _loadSampleDevices(threeDevicesMode: false);
  }

  /// Populates the device list using both Default and Named Constructors.
  /// Also demonstrates Mixin and Interface methods.
  void _loadSampleDevices({required bool threeDevicesMode}) {
    // Reset static device counter before re-populating
    SmartDevice.resetCount();
    _devices.clear();

    if (threeDevicesMode) {
      // 3 Devices Mode (Matches Page 2, Left Screenshot)
      
      // 1. SmartLight created with DEFAULT constructor
      final light = SmartLight(
        name: 'Living Room',
        brightness: 75,
        isOn: true,
      );
      // Demonstrating Mixin (Schedulable)
      light.setSchedule('07:30 AM');
      _devices.add(light);

      // 2. Thermostat created with DEFAULT constructor
      final thermostat = Thermostat(
        name: 'Bedroom',
        temperature: 22.0,
        isHeating: true,
      );
      // Demonstrating Interface (Connectable)
      thermostat.connect();
      _devices.add(thermostat);

      // 3. SmartSpeaker created with DEFAULT constructor
      final speaker = SmartSpeaker(
        name: 'Kitchen',
        volume: 40,
        isPlaying: false,
      );
      _devices.add(speaker);
    } else {
      // 5 Devices Mode (Matches Page 2, Right Screenshot)

      // 1. SmartLight created with NAMED constructor (SmartLight.off)
      final light1 = SmartLight.off(
        name: 'Living Room',
      );
      _devices.add(light1);

      // 2. SmartLight created with NAMED constructor (SmartLight.preset)
      final light2 = SmartLight.preset(
        name: 'Kitchen',
        presetBrightness: 50,
      );
      // Demonstrating Schedulable mixin
      light2.setSchedule('19:00 PM');
      _devices.add(light2);

      // 3. Thermostat created with DEFAULT constructor
      final thermostat1 = Thermostat(
        name: 'Bedroom',
        temperature: 24.0,
        isHeating: true,
      );
      _devices.add(thermostat1);

      // 4. SmartSpeaker created with DEFAULT constructor
      final speaker1 = SmartSpeaker(
        name: 'Kitchen',
        volume: 40,
        isPlaying: true,
      );
      _devices.add(speaker1);

      // 5. SmartSpeaker created with NAMED constructor (SmartSpeaker.active)
      // Here volume is 25% and paused to match right screenshot exactly
      final speaker2 = SmartSpeaker(
        name: 'Office',
        volume: 25,
        isPlaying: false,
      );
      _devices.add(speaker2);
    }

    setState(() {});
  }

  /// Adds a new device to show dynamic creation and static counter increment
  void _addNewDeviceDialog() {
    String deviceName = '';
    String selectedType = 'Smart Light';
    bool useNamedConstructor = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Smart Device', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Device Name (e.g. Balcony, Study)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => deviceName = val,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Device Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Smart Light', child: Text('Smart Light')),
                    DropdownMenuItem(value: 'Thermostat', child: Text('Thermostat')),
                    DropdownMenuItem(value: 'Smart Speaker', child: Text('Smart Speaker')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => selectedType = val);
                    }
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Use Named Constructor', style: TextStyle(fontSize: 14)),
                  subtitle: Text(
                    useNamedConstructor ? 'e.g. .preset(), .eco(), .active()' : 'Default Constructor',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  value: useNamedConstructor,
                  onChanged: (val) => setDialogState(() => useNamedConstructor = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final name = deviceName.trim().isEmpty ? 'Room ${_devices.length + 1}' : deviceName.trim();
                SmartDevice newDevice;

                if (selectedType == 'Smart Light') {
                  newDevice = useNamedConstructor
                      ? SmartLight.preset(name: name, presetBrightness: 60)
                      : SmartLight(name: name, brightness: 80, isOn: true);
                } else if (selectedType == 'Thermostat') {
                  newDevice = useNamedConstructor
                      ? Thermostat.eco(name: name)
                      : Thermostat(name: name, temperature: 21.0, isHeating: true);
                } else {
                  newDevice = useNamedConstructor
                      ? SmartSpeaker.active(name: name, volume: 65)
                      : SmartSpeaker(name: name, volume: 50, isPlaying: false);
                }

                setState(() {
                  _devices.add(newDevice);
                });
                Navigator.pop(ctx);
              },
              child: const Text('Add Device'),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows OOP Requirements mapping summary
  void _showOOPInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.school, color: Color(0xFF2563EB)),
            SizedBox(width: 8),
            Text('OOP Architecture', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _OOPBadge(concept: 'Class', detail: 'Base SmartDevice & subclasses SmartLight, Thermostat, SmartSpeaker.'),
              _OOPBadge(concept: 'Objects', detail: 'Multiple device objects created and rendered on UI.'),
              _OOPBadge(concept: 'Constructor', detail: 'Both default (SmartLight(...)) and named (.off(), .preset(), .eco(), .active()) used.'),
              _OOPBadge(concept: 'Inheritance', detail: 'SmartLight, Thermostat, SmartSpeaker extend SmartDevice.'),
              _OOPBadge(concept: 'Abstraction', detail: 'SmartDevice is abstract; getStatus(), performAction() are implemented by subclasses.'),
              _OOPBadge(concept: 'Interface', detail: 'Connectable interface implemented with isConnected(), connect(), disconnect().'),
              _OOPBadge(concept: 'Mixin', detail: 'Schedulable mixin with setSchedule(), clearSchedule() attached via "with".'),
              _OOPBadge(concept: 'Keywords', detail: 'static (totalDevices counter), super (super constructor call), this (instance binding).'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Home Controller'),
        actions: [
          // Button to switch preset between 3 devices and 5 devices from HW2.pdf
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            tooltip: 'Presets & Options',
            onSelected: (val) {
              if (val == '3_devices') {
                _loadSampleDevices(threeDevicesMode: true);
              } else if (val == '5_devices') {
                _loadSampleDevices(threeDevicesMode: false);
              } else if (val == 'info') {
                _showOOPInfoDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: '3_devices',
                child: Row(
                  children: [
                    Icon(Icons.filter_3, size: 20, color: Color(0xFF2563EB)),
                    SizedBox(width: 8),
                    Text('Load Sample 1 (3 Devices)'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: '5_devices',
                child: Row(
                  children: [
                    Icon(Icons.filter_5, size: 20, color: Color(0xFF2563EB)),
                    SizedBox(width: 8),
                    Text('Load Sample 2 (5 Devices)'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'info',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Color(0xFF2563EB)),
                    SizedBox(width: 8),
                    Text('View OOP Requirements Info'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Device Card List
          Expanded(
            child: _devices.isEmpty
                ? const Center(
                    child: Text(
                      'No smart devices found.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      return SmartDeviceCard(
                        device: device,
                        onStateChanged: () {
                          // Update UI upon user interaction with any device card
                          setState(() {});
                        },
                      );
                    },
                  ),
          ),

          // Bottom Bar: Required "Total Devices: X" from STATIC variable
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 1.0),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // This text MUST come from the static variable SmartDevice.totalDevices
                  Text(
                    'Total Devices: ${SmartDevice.totalDevices}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),

                  // Quick Action to Add a Device and verify static counter updates
                  TextButton.icon(
                    onPressed: _addNewDeviceDialog,
                    icon: const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF2563EB)),
                    label: const Text(
                      'Add Device',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OOPBadge extends StatelessWidget {
  final String concept;
  final String detail;

  const _OOPBadge({required this.concept, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.3),
          children: [
            TextSpan(
              text: '• $concept: ',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            TextSpan(text: detail),
          ],
        ),
      ),
    );
  }
}
