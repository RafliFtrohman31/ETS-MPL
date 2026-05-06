import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativePage extends StatefulWidget {
  const NativePage({super.key});

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  // SINKRONISASI: Channel harus sama dengan MainActivity.kt
  static const platform = MethodChannel('utd.ac.id/native_jembatan');

  String _batteryDisplay = '--';
  int _batteryRawValue = 0;

  @override
  void initState() {
    super.initState();
    // Ambil data baterai saat pertama kali halaman dibuka
    _getBatteryLevel();
  }

  // 1. Fungsi mengambil data baterai dari Kotlin (Modul 7)
  Future<void> _getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      setState(() {
        _batteryRawValue = result;
        _batteryDisplay = '$result%';
      });
    } on PlatformException catch (e) {
      setState(() {
        _batteryDisplay = "Err";
      });
      debugPrint("Gagal mengambil baterai: '${e.message}'.");
    }
  }

  // 2. Fungsi memunculkan Toast melalui Kotlin (Modul 7)
  Future<void> _showNativeToast() async {
    try {
      await platform.invokeMethod('showToast', {
        // Pastikan kata kuncinya adalah "pesan"
        "pesan": "Halo Rafly (20123048)! Fitur Native Berhasil.",
      });
    } on PlatformException catch (e) {
      debugPrint("Gagal memanggil Toast: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Palet Warna: Soft Teal (Cerah & Kalem)
    const Color primaryColor = Color(0xFF008080); // Teal
    const Color secondaryColor = Color(0xFFE0F2F1); // Teal Muda
    const Color backgroundColor = Color(0xFFF9FBFB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'RAFLI HARDWARE',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Area Status Baterai (Desain Kartu Kalem)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 45),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "BATTERY MONITORING SYSTEM",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 35),
                  _buildBatteryVisual(primaryColor, secondaryColor),
                  const SizedBox(height: 25),
                  Text(
                    _batteryDisplay,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 60,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    "KAPASITAS PERANGKAT",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // Tombol Kontrol Native
            _buildControlCard(
              title: "REFRESH DATA",
              subtitle: "Sync ulang kapasitas baterai OS",
              icon: Icons.refresh_rounded,
              bgColor: secondaryColor,
              contentColor: primaryColor,
              onTap: _getBatteryLevel,
            ),

            const SizedBox(height: 16),

            _buildControlCard(
              title: "TAMPILKAN TOAST",
              subtitle: "Trigger Android Native Toast (NIM 48)",
              icon: Icons.notifications_active_outlined,
              bgColor: primaryColor,
              contentColor: Colors.white,
              onTap: _showNativeToast,
            ),

            const SizedBox(height: 50),
            // Footer Info
            Text(
              "NIM: 20123048 - MUHAMAD TAUPIK",
              style: TextStyle(
                color: Colors.grey.withOpacity(0.5),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Visual Baterai Dinamis
  Widget _buildBatteryVisual(Color teal, Color softTeal) {
    // Warna berubah sesuai level baterai
    Color levelColor = _batteryRawValue < 20
        ? Colors.redAccent
        : (_batteryRawValue < 50 ? Colors.orangeAccent : teal);

    return Container(
      width: 140,
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 4),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(5),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: _batteryRawValue / 100,
            child: Container(
              decoration: BoxDecoration(
                color: levelColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.bolt_rounded,
              color: _batteryRawValue > 40 ? Colors.white : Colors.black12,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }

  // Widget Tombol Kontrol dengan Desain Seragam
  Widget _buildControlCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color bgColor,
    required Color contentColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: contentColor, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: contentColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: contentColor.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: contentColor.withOpacity(0.3),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
