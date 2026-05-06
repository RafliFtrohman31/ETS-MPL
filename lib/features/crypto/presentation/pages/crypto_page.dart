import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

// 1. FUNGSI ISOLATE (MODUL 5)
int tugasMenghitungBeratRafli(int jumlahLooping) {
  int hasil = 0;
  for (int i = 0; i < jumlahLooping; i++) {
    hasil += i;
  }
  return hasil;
}

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  late WebSocketChannel _channel;
  String _currentPrice = '0.00';
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    // INTEGRASI WEBSOCKET (MODUL 5) - BINANCE API
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://data-stream.binance.vision/ws/btcusdt@trade'),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Palet Warna Cerah & Kalem (Soft Teal Theme)
    const Color primaryColor = Color(0xFF008080); // Teal
    const Color secondaryColor = Color(0xFFE0F2F1); // Soft Teal
    const Color backgroundColor = Color(0xFFF9FBFB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'RAFLI CRYPTO HUB',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white, letterSpacing: 1.1),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // HEADER INFO OPERATOR (DETAIL TAMBAHAN)
            _buildOperatorCard(primaryColor, secondaryColor),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // KARTU HARGA UTAMA
                  _buildModernPriceCard(primaryColor, secondaryColor),
                  
                  const SizedBox(height: 24),
                  
                  // GRID DETAIL STATISTIK (TAMBAHAN DETAIL)
                  _buildMarketStats(primaryColor),

                  const SizedBox(height: 30),

                  // INDIKATOR STABILITAS SISTEM
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('SYSTEM STABILITY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                            Icon(Icons.verified_user_outlined, size: 18, color: _isCalculating ? Colors.orange : Colors.green),
                          ],
                        ),
                        const SizedBox(height: 15),
                        LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(_isCalculating ? Colors.orange : primaryColor),
                          backgroundColor: secondaryColor,
                        ),
                        const SizedBox(height: 10),
                        const Text('ISOLATE AKAN MENCEGAH UI FREEZING SAAT KALKULASI BERAT', 
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // TOMBOL EXECUTE ISOLATE (NIM 48)
                  _buildExecuteButton(primaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorCard(Color primary, Color secondary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: Colors.green),
              SizedBox(width: 8),
              Text('LIVE NETWORK', style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w800)),
            ],
          ),
          Text('OPERATOR: RAFLI - 48', style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildModernPriceCard(Color primary, Color secondary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: primary.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: secondary, shape: BoxShape.circle),
            child: Icon(Icons.currency_bitcoin_rounded, size: 40, color: primary),
          ),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: _channel.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Text('ERROR CONNECTION', style: TextStyle(color: Colors.red));
              if (!snapshot.hasData) return const CircularProgressIndicator();

              final data = jsonDecode(snapshot.data.toString());
              _currentPrice = double.parse(data['p'] ?? '0').toStringAsFixed(2);

              return Column(
                children: [
                  Text('\$ $_currentPrice', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.black87)),
                  const SizedBox(height: 5),
                  const Text('BTC/USDT REAL-TIME', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMarketStats(Color primary) {
    return Row(
      children: [
        _statItem("VOL (24H)", "1.2B", Icons.bar_chart_rounded, primary),
        const SizedBox(width: 12),
        _statItem("HIGH", "64.2K", Icons.trending_up_rounded, Colors.green),
        const SizedBox(width: 12),
        _statItem("LOW", "61.8K", Icons.trending_down_rounded, Colors.red),
      ],
    );
  }

  Widget _statItem(String label, String val, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
            Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildExecuteButton(Color primary) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _isCalculating ? Colors.grey : primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        onPressed: _isCalculating ? null : () async {
          setState(() => _isCalculating = true);
          
          // LOGIKA NIM 48: 48 * 10.000.000 = 480 Juta kali looping
          const int countFactor = 48 * 10000000; 
          final result = await compute(tugasMenghitungBeratRafli, countFactor);

          setState(() => _isCalculating = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('NIM 48 SUCCESS: $result'),
              backgroundColor: primary,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        child: _isCalculating 
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('CALCULATE TAX (NIM 48 ISOLATE)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}