import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/env_config.dart'; // TAMBAHAN MODUL 11: Import config agar baseUrl dinamis

class ApiClient {
  final Dio dio;
  final Logger logger = Logger();

  ApiClient() : dio = Dio() {
    // 1. Konfigurasi Dasar
    // SEKARANG BASE URL BERUBAH SECARA OTOMATIS SESUAI FLAVOR!
    dio.options.baseUrl = EnvConfig.baseUrl; // UBAH DI SINI (Modul 11) 
    dio.options.connectTimeout = const Duration(seconds: 10); 
    dio.options.receiveTimeout = const Duration(seconds: 10);

    // 2. Pasang Interceptor (Satpam)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.i('MENGIRIM: [${options.method}] ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.i('BERHASIL [${response.statusCode}]: ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e('ERROR [${e.response?.statusCode}]: ${e.requestOptions.uri}');
          return handler.next(e);
        },
      ),
    );
  }
}