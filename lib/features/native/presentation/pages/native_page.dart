import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativePage extends StatefulWidget {
  const NativePage({super.key});

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  // SINKRONISASI: Pastikan nama channel ini sama dengan di MainActivity.kt
  static const platform = MethodChannel('utd.ac.id/native_jembatan');

  String _batteryDisplay = '--';
  int _batteryRawValue = 0;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel(); // Ambil data awal saat halaman dibuka
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
      // LOGIKA NIM RAFLI 20123048
      await platform.invokeMethod('showToast', {
        "pesan": "Halo Rafly (20123048)! Fitur Native Berhasil."
      });
    } on PlatformException catch (e) {
      debugPrint("Gagal memanggil Toast: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Palet Warna Kalem & Cerah
    const Color primaryColor = Color(0xFF008080); // Teal Kalem
    const Color secondaryColor = Color(0xFFE0F2F1); // Soft Teal
    const Color backgroundColor = Color(0xFFF9FBFB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'RAFLI HARDWARE',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2, fontSize: 18, color: Colors.white),
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
            // Area Status Baterai dengan Gaya Kalem
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 45),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "SISTEM MONITORING BATERAI",
                    style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 35),
                  // Visual Baterai dengan Gradasi Status
                  _buildBatteryIcon(primaryColor, secondaryColor),
                  const SizedBox(height: 25),
                  Text(
                    _batteryDisplay,
                    style: const TextStyle(color: Colors.black87, fontSize: 56, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    "KAPASITAS SAAT INI",
                    style: TextStyle(color: primaryColor.withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 35),
            
            // Menu Aksi (Grid Visual)
            _buildActionCard(
              title: "PERBARUI STATUS",
              subtitle: "Ambil kapasitas baterai terbaru dari sistem OS",
              icon: Icons.sync_rounded,
              color: secondaryColor,
              iconColor: primaryColor,
              onTap: _getBatteryLevel,
            ),
            
            const SizedBox(height: 16),
            
            _buildActionCard(
              title: "TAMPILKAN TOAST",
              subtitle: "Panggil fungsi Toast Native Android (NIM 48)",
              icon: Icons.chat_bubble_outline_rounded,
              color: primaryColor,
              iconColor: Colors.white,
              titleColor: Colors.white,
              onTap: _showNativeToast,
            ),
            
            const SizedBox(height: 50),
            // Detail Teknis
            const Text(
              "COMMUNICATION MODE: METHOD CHANNEL (BINARY MESSENGER)",
              style: TextStyle(color: Colors.black26, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 5),
            const Text(
              "UTD ADVANCED APP - ETS 2026",
              style: TextStyle(color: Colors.black12, fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Baterai Kustom dengan Warna Dinamis
  Widget _buildBatteryIcon(Color teal, Color softTeal) {
    // Logika warna: Merah jika < 20%, Oranye jika < 50%, Hijau jika > 50%
    Color statusColor = _batteryRawValue < 20 ? Colors.redAccent : (_batteryRawValue < 50 ? Colors.orangeAccent : teal);

    return Container(
      width: 130,
      height: 65,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 4),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: _batteryRawValue / 100,
            child: Container(
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.bolt_rounded,
              color: _batteryRawValue > 50 ? Colors.white : Colors.black26,
              size: 32,
            ),
          )
        ],
      ),
    );
  }

  // Widget Kartu Aksi dengan Desain Kalem
  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    Color titleColor = Colors.black87,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: titleColor, fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: titleColor.withValues(alpha: 0.6), fontSize: 10)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: titleColor.withValues(alpha: 0.3), size: 14),
          ],
        ),
      ),
    );
  }
}