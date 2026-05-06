package com.example.utd_advanced_app

import android.content.Context
import android.os.BatteryManager
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "utd.ac.id/native_jembatan"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()
                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Baterai tidak terbaca.", null)
                }
            }else if (call.method == "showToast") {
              // Pastikan menggunakan "pesan" agar sinkron dengan Flutter
                val teks = call.argument<String>("pesan") 
    
                if (teks != null) {
                    Toast.makeText(this, teks, Toast.LENGTH_SHORT).show()
                    result.success(true)
                } else {
                    // Ini adalah pesan error yang muncul di log Rafly tadi
                    result.error("INVALID_ARGUMENT", "Pesan tidak ditemukan", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        // Mengambil kapasitas baterai secara langsung (Modul 7)
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }
}