import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativePage extends StatefulWidget {
  const NativePage({super.key});

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  static const platform = MethodChannel('utd.ac.id/native_jembatan');
  String _batteryLevel = 'Belum dicek';

  Future<void> _getBattery() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      setState(() { _batteryLevel = 'Baterai: $result%'; });
    } on PlatformException catch (e) {
      setState(() { _batteryLevel = "Gagal: '${e.message}'."; });
    }
  }

  Future<void> _showToast() async {
    await platform.invokeMethod('showToast', {"pesan": "Halo Rafly - 20123048"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Native Integration')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_batteryLevel, style: const TextStyle(fontSize: 24)),
            ElevatedButton(onPressed: _getBattery, child: const Text('Cek Baterai')),
            ElevatedButton(onPressed: _showToast, child: const Text('Munculkan Toast')),
          ],
        ),
      ),
    );
  }
}