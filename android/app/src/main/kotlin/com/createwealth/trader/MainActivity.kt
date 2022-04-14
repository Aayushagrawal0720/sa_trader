package com.createwealth.trader

import androidx.annotation.NonNull
import com.google.firebase.messaging.Constants.MessageNotificationKeys.CHANNEL
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.NetworkInterface
import java.util.*

class MainActivity : FlutterActivity() {

    private val CHANNEL = "mac.channel";

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "getMAC") {
                val mac = getMacAddress();
                result.success(mac);
            }
        }
    }

    private fun getMacAddress(): String? {
        try {
            val all: List<NetworkInterface> =
                Collections.list<NetworkInterface>(NetworkInterface.getNetworkInterfaces())
            for (nif in all) {
                if (!nif.getName().equals("wlan0", ignoreCase = true)) continue
                val macBytes: ByteArray = nif.getHardwareAddress() ?: return ""
                val res1 = StringBuilder()
                for (b in macBytes) {
                    res1.append(String.format("%02X:", b))
                }
                if (res1.length > 0) {
                    res1.deleteCharAt(res1.length - 1)
                }
                return res1.toString()
            }
        } catch (ex: java.lang.Exception) {
        }
        return "02:00:00:00:00:00"
    }
}
