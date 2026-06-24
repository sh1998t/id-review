package com.example.id_renew.fap60;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.hardware.usb.UsbDevice;
import android.util.Base64;
import android.util.Log;

import com.cs.fap.api.CSFapManager;
import com.cs.fap.api.Constants;
import com.cs.fap.api.FapCaptureParam;
import com.cs.fap.api.FapInitParam;
import com.cs.fap.api.onCaptureImageListener;
import com.cs.fap.api.onDeviceChangeListener;

import java.io.ByteArrayOutputStream;
import java.util.concurrent.CopyOnWriteArrayList;

public class Fap60Controller implements onCaptureImageListener, onDeviceChangeListener {

    private static final String TAG = "Fap60Controller";

    public interface StatusListener {
        void onDeviceStatusChanged(boolean connected);
    }

    public interface ThumbProgressListener {
        void onThumbCaptured(int thumbIndex, String label);
    }

    private ThumbProgressListener mThumbListener;

    public void setThumbProgressListener(ThumbProgressListener l) {
        mThumbListener = l;
    }

    private static volatile Fap60Controller sInstance;

    private final Context mContext;
    private final CSFapManager mManager;
    private final FapInitParam mInitParam;
    private volatile boolean mDeviceOpen = false;

    private final CopyOnWriteArrayList<StatusListener> mListeners = new CopyOnWriteArrayList<>();

    public static class CaptureResult {
        public final boolean success;
        public final String image;
        public final String format;
        public final int width;
        public final int height;
        public final int fingers;
        public final int[] quality;
        public final String[] fingerImages;
        public final boolean isLeftHand;
        public final String error;

        CaptureResult(String error) {
            this.success = false;
            this.image = null;
            this.format = null;
            this.width = 0;
            this.height = 0;
            this.fingers = 0;
            this.quality = null;
            this.fingerImages = null;
            this.isLeftHand = false;
            this.error = error;
        }

        CaptureResult(String image, int width, int height,
                      int fingers, int[] quality, String[] fingerImages, boolean isLeftHand) {
            this.success = true;
            this.image = image;
            this.format = "png";
            this.width = width;
            this.height = height;
            this.fingers = fingers;
            this.quality = quality;
            this.fingerImages = fingerImages;
            this.isLeftHand = isLeftHand;
            this.error = null;
        }
    }

    private Fap60Controller(Context context) {
        mContext = context.getApplicationContext();
        mManager = CSFapManager.getInstance(mContext, this);
        mInitParam = new FapInitParam(null, 0, 0, 0,
                mContext.getFilesDir().getAbsolutePath(), 0);
    }

    public static Fap60Controller getInstance(Context context) {
        if (sInstance == null) {
            synchronized (Fap60Controller.class) {
                if (sInstance == null) {
                    sInstance = new Fap60Controller(context);
                }
            }
        }
        return sInstance;
    }

    public void addStatusListener(StatusListener l) {
        mListeners.add(l);
    }

    public void removeStatusListener(StatusListener l) {
        mListeners.remove(l);
    }

    private void notifyStatus(boolean connected) {
        for (StatusListener l : mListeners) l.onDeviceStatusChanged(connected);
    }

    public void registerBroadcast(Class<?> activityClass) {
        mManager.CS_registerBroadcast(activityClass);
    }

    public void unregisterBroadcast() {
        mManager.CS_unregisterBroadcast();
    }

    public synchronized boolean openDevice() {
        if (mDeviceOpen) return true;
        int ret = mManager.CS_openDevice(mInitParam);
        Log.i(TAG, "CS_openDevice ret=" + ret + " vid=" + mInitParam.vid + " pid=" + mInitParam.pid);
        mDeviceOpen = (ret == Constants.ErrorStatus.CS_STATUS_OK);
        if (mDeviceOpen) notifyStatus(true);
        return mDeviceOpen;
    }

    public boolean isDeviceOpen() {
        return mManager.CS_isDeviceOpen();
    }

    public synchronized void cancelCapture() {
        mManager.CS_cancelCaptureImage();
    }

    public static final int IMAGE_TYPE_TWO_THUMBS = 3;

    public synchronized CaptureResult capture(int imageType) {
        if (!isDeviceOpen()) {
            if (!openDevice()) return new CaptureResult("Device not open");
        }

        if (imageType == IMAGE_TYPE_TWO_THUMBS) {
            return captureTwoThumbs();
        }

        boolean isRoll = (imageType == Constants.ScanImageType.ImageTypeRoll);
        int sdkType = isRoll ? Constants.ScanImageType.ImageTypeRoll
                : Constants.ScanImageType.ImageTypeRFour;

        FapCaptureParam param = mManager.CS_captureImage(sdkType, 0, 0, 1, this);

        if (param == null) return new CaptureResult("Capture returned null");

        Log.i(TAG, "capture errCode=" + param.errCode + " imageType=" + param.imageType
                + " miss=" + param.miss_finger_num + " isLFour=" + param.isLFourFinger
                + " oriLen=" + (param.oriImageData != null ? param.oriImageData.length : 0)
                + " smallLen=" + (param.smallImageData != null ? param.smallImageData.length : 0));

        boolean cancelled = param.errCode == Constants.ErrorStatus.CS_ERR_CANCEL_CAPTURE_IMAGE
                || param.errCode == Constants.ErrorStatus.CS_ERR_CAPTURE_IMAGE_TIMEOUT;
        if (cancelled) return new CaptureResult("Capture error code: " + param.errCode);

        boolean hasData = param.oriImageData != null && param.oriImageData.length > 0;
        boolean ok = param.errCode == Constants.ErrorStatus.CS_STATUS_OK
                || (isRoll && (param.errCode == Constants.ErrorStatus.CS_GZ_IMAGE_MERGING
                || param.errCode == Constants.ErrorStatus.CS_GZ_IMAGE_MERGE_FINISH))
                || hasData;

        if (!ok) return new CaptureResult("Capture error code: " + param.errCode);
        if (!hasData) return new CaptureResult("No image data");

        Bitmap fullBmp = BitmapFactory.decodeByteArray(
                param.oriImageData, 0, param.oriImageData.length);
        if (fullBmp == null) return new CaptureResult("Failed to decode full image");

        int w = fullBmp.getWidth();
        int h = fullBmp.getHeight();
        String fullB64 = bitmapToBase64(fullBmp);

        int fingerCount;
        boolean isLeftHand = (param.isLFourFinger > 0);
        if (isRoll) {
            fingerCount = (param.miss_finger_num == 0) ? 1 : 0;
        } else {
            fingerCount = Math.max(0, 4 - param.miss_finger_num);
        }

        int[] quality = new int[fingerCount];
        String[] fingerImages = new String[fingerCount];

        if (!isRoll && fingerCount > 0
                && param.smallImageData != null && param.imgPos != null) {
            int fw = param.imgPos[0].w;
            int fh = param.imgPos[0].h;
            int fingerSize = 1078 + fw * fh;

            for (int i = 0; i < fingerCount; i++) {
                int offset = i * fingerSize;
                if (offset + fingerSize <= param.smallImageData.length) {
                    Bitmap fb = BitmapFactory.decodeByteArray(
                            param.smallImageData, offset, fingerSize);
                    if (fb != null) {
                        fingerImages[i] = bitmapToBase64(fb);
                        fb.recycle();
                    } else {
                        fingerImages[i] = null;
                    }
                }
                if (i < param.imgPos.length) {
                    quality[i] = param.imgPos[i].score;
                }
            }
        }

        return new CaptureResult(fullB64, w, h, fingerCount, quality, fingerImages, isLeftHand);
    }

    private CaptureResult captureTwoThumbs() {
        String[] images = new String[2];
        int[] quality = new int[2];
        String[] labels = {"Right thumb", "Left thumb"};

        for (int i = 0; i < 2; i++) {
            final int idx = i;
            if (mThumbListener != null) mThumbListener.onThumbCaptured(idx, labels[idx]);

            FapCaptureParam param = mManager.CS_captureImage(
                    Constants.ScanImageType.ImageTypeRoll, 0, 0, 1, this);
            if (param == null) {
                return new CaptureResult("Cancelled at step " + (idx + 1));
            }

            boolean ok = param.errCode == Constants.ErrorStatus.CS_STATUS_OK
                    || param.errCode == Constants.ErrorStatus.CS_GZ_IMAGE_MERGING
                    || param.errCode == Constants.ErrorStatus.CS_GZ_IMAGE_MERGE_FINISH;
            if (!ok) {
                return new CaptureResult("Error step " + (idx + 1) + ": errCode=" + param.errCode);
            }
            if (param.oriImageData == null || param.oriImageData.length == 0) {
                return new CaptureResult("No data at step " + (idx + 1));
            }

            Bitmap bmp = BitmapFactory.decodeByteArray(
                    param.oriImageData, 0, param.oriImageData.length);
            if (bmp == null) {
                return new CaptureResult("Decode error at step " + (idx + 1));
            }

            images[idx] = bitmapToBase64(bmp);
            quality[idx] = (param.imgPos != null && param.imgPos.length > 0)
                    ? param.imgPos[0].score : 0;
        }

        return new CaptureResult(images[0], 0, 0, 2, quality, images, false);
    }

    private String bitmapToBase64(Bitmap bmp) {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        bmp.compress(Bitmap.CompressFormat.PNG, 100, out);
        bmp.recycle();
        return Base64.encodeToString(out.toByteArray(), Base64.NO_WRAP);
    }

    @Override
    public void onCaptureCallback(FapCaptureParam fapCaptureParam) {
    }

    @Override
    public void onAttach(UsbDevice usbDevice) {
        openDevice();
    }

    @Override
    public void onDetach(UsbDevice usbDevice) {
        mDeviceOpen = false;
        notifyStatus(false);
    }

    @Override
    public void onCancel(UsbDevice usbDevice) {
        mDeviceOpen = false;
        notifyStatus(false);
    }
}
