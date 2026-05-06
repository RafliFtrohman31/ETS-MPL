import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // LOGIKA NIM RAFLI: Delay 8 detik sesuai digit terakhir NIM 20123048
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Palet Warna Cerah & Kalem (Soft Teal Theme)
    const Color primaryColor = Color(0xFF008080); // Teal Kalem
    const Color backgroundColor = Color(0xFFF9FBFB); // Putih bersih kalem

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Dekorasi Lingkaran Halus (Aksen Kalem)
          Positioned(
            top: -50,
            left: -50,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: primaryColor.withValues(alpha: 0.05),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO RAFLI STORE: Elegan & Minimalis
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag_rounded, // Ikon tas belanja
                    size: 70,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 40),
                // JUDUL TOKO
                const Text(
                  'RAFLI',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                    letterSpacing: 6,
                  ),
                ),
                Text(
                  'STORE EXCLUSIVE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor.withValues(alpha: 0.6),
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 60),
                // LOADING INDICATOR KALEM
                SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    color: primaryColor,
                    minHeight: 2,
                  ),
                ),
                const SizedBox(height: 25),
                // IDENTITAS PERSONAL
                Text(
                  'NIM: 20123048',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // FOOTER
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'DESIGNED BY Rafli Faturohman',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}