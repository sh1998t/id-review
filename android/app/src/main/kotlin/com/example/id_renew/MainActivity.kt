package com.example.id_renew

import android.content.Intent
import android.hardware.usb.UsbManager
import android.os.Build
import android.util.Log
import com.example.id_renew.fap60.Fap60Controller
import com.example.id_renew.fap60.SocketServerService
import com.example.id_renew.fap60.UsbPermissionHelper
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    companion object {
        private const val TAG = "MainActivity"
    }

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
        setIntent(intent)
        handleUsbIntent(intent)
    }

    override fun onResume() {
        super.onResume()
        ensureUsbAccess()
    }

    override fun onDestroy() {
        Fap60Controller.getInstance(this).unregisterBroadcast()
        super.onDestroy()
    }

    private fun ensureUsbAccess() {
        val device = UsbPermissionHelper.findFap60Device(this)
        if (device == null) {
            Log.d(TAG, "No FAP60 scanner connected")
            return
        }

        if (UsbPermissionHelper.hasPermission(this, device)) {
            Thread {
                Fap60Controller.getInstance(this).openDevice()
            }.start()
        } else {
            // Must run on UI thread — system permission dialog requires a visible Activity.
            runOnUiThread {
                UsbPermissionHelper.requestPermissionIfNeeded(this)
            }
        }
    }

    private fun handleUsbIntent(intent: Intent?) {
        if (intent?.action == UsbManager.ACTION_USB_DEVICE_ATTACHED) {
            Log.i(TAG, "USB device attached via intent")
            runOnUiThread { ensureUsbAccess() }
        }
    }
}
