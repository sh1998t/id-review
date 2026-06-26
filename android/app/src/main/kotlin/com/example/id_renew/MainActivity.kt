package com.example.id_renew

import android.content.Intent
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.os.Build
import android.util.Log
import com.example.id_renew.fap60.Fap60Controller
import com.example.id_renew.fap60.SocketServerService
import com.example.id_renew.fap60.UsbPermissionHelper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val TAG = "MainActivity"
        private const val CHANNEL = "com.example.id_renew/fap60"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "connectScanner") {
                    connectScanner(result)
                } else {
                    result.notImplemented()
                }
            }
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        Fap60Controller.getInstance(this).registerBroadcast(MainActivity::class.java)

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

    private fun connectScanner(result: MethodChannel.Result) {
        Thread {
            try {
                val device = UsbPermissionHelper.findFap60Device(this)
                val attached = device != null

                if (!attached) {
                    postScannerResult(result, device, false, false, false)
                    return@Thread
                }

                if (!UsbPermissionHelper.hasPermission(this, device!!)) {
                    runOnUiThread {
                        UsbPermissionHelper.requestPermissionIfNeeded(this)
                    }
                    postScannerResult(result, device, true, false, false)
                    return@Thread
                }

                val ctrl = Fap60Controller.getInstance(this)
                val open = ctrl.openDevice()
                postScannerResult(result, device, true, true, open)
            } catch (e: Exception) {
                Log.e(TAG, "connectScanner failed", e)
                runOnUiThread {
                    result.error("CONNECT_FAILED", e.message, null)
                }
            }
        }.start()
    }

    private fun postScannerResult(
        result: MethodChannel.Result,
        device: UsbDevice?,
        attached: Boolean,
        permitted: Boolean,
        open: Boolean,
    ) {
        val ctrl = Fap60Controller.getInstance(this)
        runOnUiThread {
            result.success(
                hashMapOf(
                    "deviceAttached" to attached,
                    "devicePermitted" to permitted,
                    "deviceOpen" to open,
                    "openRetCode" to ctrl.lastOpenRet,
                    "vid" to (device?.vendorId ?: 0),
                    "pid" to (device?.productId ?: 0),
                ),
            )
        }
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
