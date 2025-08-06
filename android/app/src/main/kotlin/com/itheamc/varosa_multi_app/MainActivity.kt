package com.itheamc.varosa_multi_app

import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import com.itheamc.varosa_multi_app.native_button.NativeButtonViewFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.Locale

class MainActivity : FlutterActivity() {
    private val _channelName = "com.itheamc.varosa_multi_app/native_channel"
    private lateinit var _channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Registering Native Button View
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "native-button",
                NativeButtonViewFactory(flutterEngine.dartExecutor.binaryMessenger)
            )

        // Initialize Method Channel
        _channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            _channelName
        )

        // Set Method Call Handler
        _channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceInfo" -> {
                    try {
                        val sampleInfo = mapOf(
                            "batteryLevel" to getBatteryLevel(),
                            "deviceModel" to getDeviceModel(),
                            "isCharging" to isDeviceCharging(),
                            "systemTime" to getSystemTime()
                        )
                        result.success(sampleInfo)
                    } catch (e: Exception) {
                        result.error(e.message ?: "Unable to get device info.", null, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    /**
     * Method to get the battery level
     */
    private fun getBatteryLevel(): Int {
        return try {
            val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } catch (_: Exception) {
            0
        }
    }

    /**
     * Method to get the device model
     */
    private fun getDeviceModel(): String {
        return "${Build.MANUFACTURER} ${Build.MODEL}"
    }

    /**
     * Method to get the charging status
     */
    private fun isDeviceCharging(): Boolean {
        return try {
            val intentFilter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
            val batteryStatus = registerReceiver(null, intentFilter)
            val status = batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1

            status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL
        } catch (_: Exception) {
            false
        }
    }

    /**
     * Method to get the system time
     */
    private fun getSystemTime(): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssXXX", Locale.getDefault())
        return dateFormat.format(java.util.Date())
    }
}
