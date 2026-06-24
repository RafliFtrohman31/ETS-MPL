class EnvConfig {
  EnvConfig._(); // Mencegah kelas diinstansiasi langsung [cite: 515]

  // 1. Menangkap variabel 'ENV_NAME' dari terminal (Dev / Prod) [cite: 516]
  static const String environment = String.fromEnvironment( 
    'ENV_NAME',
    defaultValue: 'DEVELOPMENT', 
  );

  // 2. Menangkap variabel 'BASE_URL' dari terminal [cite: 521]
  static const String baseUrl = String.fromEnvironment( 
    'BASE_URL', 
    defaultValue: 'https://fakestoreapi.com/dev_api', // Default fallback [cite: 524, 525]
  );

  // 3. Menangkap variabel 'SHOW_DEBUG_BANNER' (True / False) [cite: 527]
  static const bool showDebugBanner = bool.fromEnvironment( 
    'SHOW_DEBUG_BANNER',
    defaultValue: true, 
  );

  // Fungsi praktis untuk mengecek apakah kita di Production [cite: 532]
  static bool get isProduction => environment == 'PRODUCTION'; 
}