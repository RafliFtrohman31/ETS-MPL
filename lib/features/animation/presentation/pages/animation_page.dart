import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

// Menggunakan TickerProviderStateMixin agar halaman bisa menangani lebih dari 1 AnimationController (Metronome)
class _AnimationPageState extends State<AnimationPage> with TickerProviderStateMixin {
  // 1. Siapkan Mesin Waktu (Controller)
  late AnimationController _spinController;
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi Controller 1: Untuk Bintang Berputar
    _spinController = AnimationController(
      vsync: this, // Menghubungkan mesin ke Ticker halaman ini
      duration: const Duration(seconds: 2), // Satu putaran penuh butuh 2 detik
    );
    // Perintahkan mesin untuk jalan dan mengulang terus menerus (loop)
    _spinController.repeat();

    // Inisialisasi Controller 2: Untuk Animasi Lottie
    _lottieController = AnimationController(
      vsync: this,
      // Durasi dikosongkan karena nanti akan mengikuti durasi asli dari file JSON Lottie
    );
  }

  @override
  void dispose() {
    // WAJIB! Semua mesin harus dihancurkan saat halaman ditutup untuk mencegah Memory Leak
    _spinController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Animations'),
        backgroundColor: const Color(0xFF008080), // Menyamakan tema teal kamu
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Explicit Animation (Putaran Tanpa Henti):", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              
              // AnimatedBuilder akan digambar ulang 60 kali/detik mengikuti putaran Controller
              AnimatedBuilder(
                animation: _spinController,
                builder: (context, child) {
                  return Transform.rotate(
                    // Nilai _spinController.value bergerak dari 0.0 sampai 1.0. 
                    // Dikalikan dengan 6.2831853 (2 * Pi) karena rotasi menggunakan hitungan Radian
                    angle: _spinController.value * 6.2831853,
                    child: child, // Merujuk ke Icon bintang di bawah
                  );
                },
                // Child diletakkan di luar builder agar Icon tidak perlu di-rebuild dari nol (menghemat CPU)
                child: const Icon(Icons.star, size: 100, color: Colors.orange),
              ),
              
              const SizedBox(height: 50),
              const Divider(),
              const SizedBox(height: 50),
              
              const Text(
                "Lottie Integration (Animasi Desainer):", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              
              // Memanggil file animasi JSON langsung dari URL internet
              Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_x62chJ.json',
                width: 150,
                height: 150,
                controller: _lottieController, // Sambungkan ke controller
                onLoaded: (composition) {
                  // Saat file JSON selesai didownload, samakan durasi controller dengan durasi asli buatan desainer
                  _lottieController.duration = composition.duration;
                },
              ),
              const SizedBox(height: 20),
              
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008080), 
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  _lottieController.reset();    // Kembalikan waktu animasi ke detik 0
                  _lottieController.forward();  // Jalankan maju sampai selesai
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text("Mainkan Animasi Ceklis"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}