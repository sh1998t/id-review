package com.example.id_renew.fap60;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.os.Build;
import android.util.Log;

/**
 * Receives the result of {@link UsbManager#requestPermission}.
 */
public class UsbPermissionReceiver extends BroadcastReceiver {

    private static final String TAG = "UsbPermissionReceiver";

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent == null) return;

        String action = intent.getAction();
        if (UsbPermissionHelper.ACTION_USB_PERMISSION.equals(action)) {
            handlePermissionResult(context, intent);
            return;
        }

        if (UsbManager.ACTION_USB_DEVICE_ATTACHED.equals(action)) {
            UsbDevice device = getDevice(intent);
            if (device != null && UsbPermissionHelper.isFap60Device(device)) {
                Log.i(TAG, "FAP60 attached vid=" + device.getVendorId()
                        + " pid=" + device.getProductId());
                if (context instanceof android.app.Activity) {
                    UsbPermissionHelper.requestPermissionIfNeeded((android.app.Activity) context);
                } else {
                    UsbPermissionHelper.openDeviceIfPermitted(context);
                }
            }
        }
    }

    private void handlePermissionResult(Context context, Intent intent) {
        UsbDevice device = getDevice(intent);
        boolean granted = intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false);

        if (device == null) {
            Log.w(TAG, "Permission result without device extra");
            return;
        }

        Log.i(TAG, "USB permission granted=" + granted + " vid="
                + device.getVendorId() + " pid=" + device.getProductId());

        if (granted) {
            UsbPermissionHelper.openDeviceIfPermitted(context);
        } else {
            Log.w(TAG, "User denied USB permission");
        }
    }

    private static UsbDevice getDevice(Intent intent) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return intent.getParcelableExtra(UsbManager.EXTRA_DEVICE, UsbDevice.class);
        }
        return intent.getParcelableExtra(UsbManager.EXTRA_DEVICE);
    }
}
