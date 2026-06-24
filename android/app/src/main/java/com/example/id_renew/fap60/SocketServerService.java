package com.example.id_renew.fap60;

import android.app.AlarmManager;
import android.hardware.usb.UsbDevice;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.IBinder;
import android.os.SystemClock;
import android.util.Log;

import com.example.id_renew.R;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class SocketServerService extends Service {

    private static final String TAG = "Fap60Server";
    private static final int PORT = 7777;
    private static final String CHANNEL_ID = "fap60_server";

    private ServerSocket mServerSocket;
    private ExecutorService mThreadPool;
    private volatile boolean mRunning = false;

    @Override
    public void onCreate() {
        super.onCreate();
        createNotificationChannel();
        startForeground(1, buildNotification());
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (!mRunning) {
            mRunning = true;
            mThreadPool = Executors.newCachedThreadPool();
            mThreadPool.submit(this::runServer);
        }
        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        mRunning = false;
        try {
            if (mServerSocket != null) mServerSocket.close();
        } catch (IOException ignored) {
        }
        if (mThreadPool != null) mThreadPool.shutdownNow();
        scheduleRestart();
        super.onDestroy();
    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {
        scheduleRestart();
        super.onTaskRemoved(rootIntent);
    }

    private void scheduleRestart() {
        Intent restart = new Intent(this, SocketServerService.class);
        PendingIntent pi = PendingIntent.getService(
                this, 1, restart,
                PendingIntent.FLAG_ONE_SHOT | PendingIntent.FLAG_IMMUTABLE);
        AlarmManager am = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        if (am != null) {
            am.set(AlarmManager.ELAPSED_REALTIME,
                    SystemClock.elapsedRealtime() + 1000, pi);
        }
    }

    private void runServer() {
        try {
            mServerSocket = new ServerSocket(PORT);
            Log.i(TAG, "Listening on port " + PORT);
            while (mRunning) {
                Socket client = mServerSocket.accept();
                mThreadPool.submit(() -> handleClient(client));
            }
        } catch (IOException e) {
            if (mRunning) Log.e(TAG, "Server error", e);
        }
    }

    private void handleClient(Socket socket) {
        try {
            socket.setSoTimeout(30000);
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(socket.getInputStream(), "UTF-8"));
            PrintWriter out = new PrintWriter(socket.getOutputStream(), true);

            String line = in.readLine();
            if (line == null || line.isEmpty()) {
                socket.close();
                return;
            }

            Log.d(TAG, "Request: " + line);
            JSONObject response = dispatch(line);
            out.println(response.toString());
            Log.d(TAG, "Response sent, status=" + response.optString("status"));
        } catch (Exception e) {
            Log.e(TAG, "Client error", e);
            try {
                PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
                out.println(errorJson("", "", e.getMessage()));
            } catch (IOException ignored) {
            }
        } finally {
            try {
                socket.close();
            } catch (IOException ignored) {
            }
        }
    }

    private JSONObject dispatch(String rawJson) {
        String id = "", device = "", method = "";
        try {
            JSONObject req = new JSONObject(rawJson);
            id = req.optString("id", "");
            device = req.optString("device", "");
            method = req.optString("method", "");

            if (!"FAP60".equalsIgnoreCase(device)) {
                return errorJson(id, method, "Unknown device: " + device);
            }

            switch (method.toLowerCase()) {
                case "picture":
                    return handlePicture(req, id);
                case "status":
                    return handleStatus(id);
                default:
                    return errorJson(id, method, "Unknown method: " + method);
            }
        } catch (Exception e) {
            return errorJson(id, method, "Parse error: " + e.getMessage());
        }
    }

    private JSONObject handlePicture(JSONObject req, String id) throws Exception {
        int imageType = req.optInt("imageType", 1);

        Fap60Controller ctrl = Fap60Controller.getInstance(this);
        Fap60Controller.CaptureResult r = ctrl.capture(imageType);

        JSONObject resp = new JSONObject();
        resp.put("id", id);
        resp.put("device", "FAP60");
        resp.put("method", "picture");

        if (r.success) {
            resp.put("status", "ok");
            resp.put("image", r.image);
            resp.put("format", r.format);
            resp.put("width", r.width);
            resp.put("height", r.height);
            resp.put("fingers", r.fingers);
            resp.put("isLeftHand", r.isLeftHand);
            resp.put("imageType", imageType);

            JSONArray qualityArr = new JSONArray();
            if (r.quality != null) {
                for (int q : r.quality) qualityArr.put(q);
            }
            resp.put("quality", qualityArr);

            JSONArray fingerArr = new JSONArray();
            if (r.fingerImages != null) {
                for (String fi : r.fingerImages) {
                    fingerArr.put(fi != null ? fi : JSONObject.NULL);
                }
            }
            resp.put("fingerImages", fingerArr);

            if (imageType == Fap60Controller.IMAGE_TYPE_TWO_THUMBS && r.fingerImages != null) {
                resp.put("thumbRight", r.fingerImages.length > 0 && r.fingerImages[0] != null
                        ? r.fingerImages[0] : JSONObject.NULL);
                resp.put("thumbLeft", r.fingerImages.length > 1 && r.fingerImages[1] != null
                        ? r.fingerImages[1] : JSONObject.NULL);
            }
        } else {
            resp.put("status", "error");
            resp.put("error", r.error);
        }
        return resp;
    }

    private JSONObject handleStatus(String id) throws Exception {
        Fap60Controller ctrl = Fap60Controller.getInstance(this);
        UsbDevice device = UsbPermissionHelper.findFap60Device(this);
        boolean attached = device != null;
        boolean permitted = attached
                && UsbPermissionHelper.hasPermission(this, device);
        boolean open = ctrl.isDeviceOpen();
        if (attached && permitted && !open) {
            open = ctrl.openDevice();
        }

        JSONObject resp = new JSONObject();
        resp.put("id", id);
        resp.put("device", "FAP60");
        resp.put("method", "status");
        resp.put("status", "ok");
        resp.put("deviceAttached", attached);
        resp.put("devicePermitted", permitted);
        resp.put("deviceOpen", open);
        return resp;
    }

    private JSONObject errorJson(String id, String method, String message) {
        try {
            JSONObject resp = new JSONObject();
            resp.put("id", id);
            resp.put("device", "FAP60");
            resp.put("method", method);
            resp.put("status", "error");
            resp.put("error", message);
            return resp;
        } catch (Exception e) {
            return new JSONObject();
        }
    }

    private void createNotificationChannel() {
        NotificationChannel channel = new NotificationChannel(
                CHANNEL_ID,
                getString(R.string.fap60_notification_channel_name),
                NotificationManager.IMPORTANCE_LOW);
        getSystemService(NotificationManager.class).createNotificationChannel(channel);
    }

    private Notification buildNotification() {
        return new Notification.Builder(this, CHANNEL_ID)
                .setContentTitle(getString(R.string.fap60_notification_title))
                .setContentText(getString(R.string.fap60_notification_text))
                .setSmallIcon(android.R.drawable.ic_menu_info_details)
                .build();
    }
}
