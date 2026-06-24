package com.example.id_renew

import android.content.Intent
import android.hardware.usb.UsbManager
import android.os.Build
import com.example.id_renew.fap60.Fap60Controller
import com.example.id_renew.fap60.SocketServerService
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        val ctrl = Fap60Controller.getInstance(this)
        ctrl.registerBroadcast(MainActivity::class.java)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(Intent(this, SocketServerService::class.java))
        } else {
            startService(Intent(this, SocketServerService::class.java))
        }

        handleUsbIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleUsbIntent(intent)
    }

    override fun onResume() {
        super.onResume()
        Thread {
            Fap60Controller.getInstance(this).openDevice()
        }.start()
    }

    override fun onDestroy() {
        Fap60Controller.getInstance(this).unregisterBroadcast()
        super.onDestroy()
    }

    private fun handleUsbIntent(intent: Intent?) {
        if (intent?.action == UsbManager.ACTION_USB_DEVICE_ATTACHED) {
            Thread {
                Fap60Controller.getInstance(this).openDevice()
            }.start()
        }
    }
}
