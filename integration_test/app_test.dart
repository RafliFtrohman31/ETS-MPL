import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:utd_advanced_app/main.dart' as app; // Pastikan path main.dart sesuai

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // Hubungkan ke Emulator

  testWidgets('End-to-End: Alur Login Admin Sukses', (WidgetTester tester) async {
    app.main(); // Jalankan aplikasi asli
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Isi email
    final fieldEmail = find.byKey(const Key('field_email'));
    await tester.enterText(fieldEmail, 'admin@utd.id');

    // Isi password
    final fieldPassword = find.byKey(const Key('field_password'));
    await tester.enterText(fieldPassword, 'rahasia123');

    // Tutup keyboard & Klik login
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    
    final tombolLogin = find.byKey(const Key('tombol_login'));
    await tester.tap(tombolLogin);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Pembuktian sukses masuk Beranda
    expect(find.text('Selamat Datang Admin!'), findsOneWidget);
    expect(find.text('LOGIN SEKARANG'), findsNothing);
  });
}