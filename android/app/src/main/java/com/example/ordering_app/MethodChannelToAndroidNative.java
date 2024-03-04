package com.example.ordering_app;

import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;

public class MethodChannelToAndroidNative {
    private final MethodChannel channel;
    private final Handler mainHandler;
    public MethodChannelToAndroidNative(MethodChannel channel) {
        this.channel = channel;
        this.mainHandler = new Handler(Looper.getMainLooper());
    }

    public void checkInternetConnection(Result result) {
        AsyncTask.execute(() -> {
            try {
                boolean isConnected = isDeviceConnectedToInternet();
                String connectionResult = isConnected ? "Connected" : "Not Connected";
                Log.d("MethodChannelToAndroidNative", "Result: " + connectionResult);

                Log.d("MethodChannelToAndroidNative", "checkInternetConnection executed on thread: " + Thread.currentThread().getName());

                postToMainThread(() -> result.success(connectionResult));
            } catch (Exception e) {
                Log.e("MethodChannelToAndroidNative", "Error checking internet connection: " + e.getMessage());
                result.error("INTERNET_CONNECTION_ERROR", "Error checking internet connection", null);
            }
        });
    }

    private void postToMainThread(Runnable runnable) {
        mainHandler.post(runnable);
    }

    private boolean isDeviceConnectedToInternet() {
        try {
            URL url = new URL("https://www.google.com");
            HttpURLConnection urlc = (HttpURLConnection) url.openConnection();
            urlc.setRequestProperty("User-Agent", "Test");
            urlc.setRequestProperty("Connection", "close");
            urlc.setConnectTimeout(1500);
            urlc.connect();

            int responseCode = urlc.getResponseCode();
            Log.d("MethodChannelToAndroidNative", "Response Code: " + responseCode);

            return (responseCode >= HttpURLConnection.HTTP_OK && responseCode < HttpURLConnection.HTTP_MULT_CHOICE);
            //HTTP_MULT_CHOICE - Added in API level 1, Multiple Choices, Constant Value : 300
            //HTTP_OK - Added in API level 1, OK, Constant Value : 200
        } catch (IOException e) {
            Log.e("MethodChannelToAndroidNative", "Error checking internet connection: " + e.getMessage());
            return false;
        }
    }
}
