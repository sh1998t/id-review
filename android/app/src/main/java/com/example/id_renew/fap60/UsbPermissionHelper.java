package com.example.id_renew.fap60;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.os.Build;
import android.util.Log;

import java.util.HashMap;

/**
 * Requests USB permission for FAP60 scanners (vendor 53013 / 0xCF15).
 * The Cs466 SDK uses {@code com.example.USB_PERMISSION} internally; we use our
 * own action and open the device once the system grants access.
 */
public final class UsbPermissionHelper {

    private static final String TAG = "UsbPermissionHelper";
    public static final String ACTION_USB_PERMISSION =
            "com.example.id_renew.USB_PERMISSION";

    /** FAP60 vendor id — must match device_filter.xml */
    private static final int VENDOR_ID = 53013;

    private UsbPermissionHelper() {
    }

    public static boolean isFap60Device(UsbDevice device) {
        return device != null && device.getVendorId() == VENDOR_ID;
    }

    public static UsbDevice findFap60Device(Context context) {
        UsbManager usbManager = (UsbManager) context.getSystemService(Context.USB_SERVICE);
        if (usbManager == null) return null;

        HashMap<String, UsbDevice> devices = usbManager.getDeviceList();
        for (UsbDevice device : devices.values()) {
            if (isFap60Device(device)) {
                return device;
            }
        }
        return null;
    }

    public static boolean hasPermission(Context context, UsbDevice device) {
        UsbManager usbManager = (UsbManager) context.getSystemService(Context.USB_SERVICE);
        return usbManager != null && device != null && usbManager.hasPermission(device);
    }

    /**
     * Shows the system USB permission dialog when needed.
     *
     * @return true if permission is already granted for a connected FAP60 device
     */
    public static boolean requestPermissionIfNeeded(Activity activity) {
        UsbDevice device = findFap60Device(activity);
        if (device == null) {
            Log.d(TAG, "No FAP60 device found on USB bus");
            return false;
        }

        if (hasPermission(activity, device)) {
            Log.d(TAG, "USB permission already granted vid="
                    + device.getVendorId() + " pid=" + device.getProductId());
            return true;
        }

        UsbManager usbManager = (UsbManager) activity.getSystemService(Context.USB_SERVICE);
        if (usbManager == null) return false;

        Intent intent = new Intent(ACTION_USB_PERMISSION);
        intent.setPackage(activity.getPackageName());

        int pendingFlags = PendingIntent.FLAG_UPDATE_CURRENT;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            pendingFlags |= PendingIntent.FLAG_IMMUTABLE;
        }

        PendingIntent pendingIntent = PendingIntent.getBroadcast(
                activity, 0, intent, pendingFlags);

        Log.i(TAG, "Requesting USB permission vid="
                + device.getVendorId() + " pid=" + device.getProductId());
        usbManager.requestPermission(device, pendingIntent);
        return false;
    }

    public static void openDeviceIfPermitted(Context context) {
        UsbDevice device = findFap60Device(context);
        if (device == null) return;
        if (!hasPermission(context, device)) return;

        new Thread(() -> Fap60Controller.getInstance(context).openDevice()).start();
    }
}
