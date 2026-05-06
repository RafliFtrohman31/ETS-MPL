import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Untuk compute

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    // 1. Hubungkan ke WebSocket CoinCap
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.coincap.io/prices?assets=bitcoin'),
    );
  }

  @override
  void dispose() {
    _channel.sink.close(); // Tutup koneksi saat pindah halaman[cite: 3]
    super.dispose();
  }

  // 2. LOGIKA PERSONAL NIM (20123048): Isolate Compute[cite: 8]
  // Terakhir NIM 48 -> 48 x 10.000.000 = 480.000.000 kali looping[cite: 8]
  void _hitungPajak() async {
    print("Mulai menghitung di Isolate...");
    int hasil = await compute(tugasHitungBerat, 480000000); 
    print("Selesai! Hasil: $hasil");
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kalkulasi Selesai: $hasil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Harga Bitcoin'), backgroundColor: Colors.orange),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.currency_bitcoin, size: 100, color: Colors.orange),
            // 3. StreamBuilder untuk update harga real-time tanpa setState[cite: 3]
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Text('Koneksi Error');
                if (!snapshot.hasData) return const CircularProgressIndicator();

                final data = jsonDecode(snapshot.data.toString());
                return Text(
                  '\$ ${data['bitcoin']}',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green),
                );
              },
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(), // Indikator ini tidak boleh macet saat hitung[cite: 3]
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _hitungPajak,
              child: const Text('Kalkulasi Pajak Kripto (Isolate)'),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. FUNGSI TOP-LEVEL (Wajib di luar class agar bisa dibaca Isolate)[cite: 3]
int tugasHitungBerat(int jumlahLooping) {
  int hasil = 0;
  for (int i = 0; i < jumlahLooping; i++) {
    hasil += i;
  }
  return hasil;
}