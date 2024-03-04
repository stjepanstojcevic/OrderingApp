package com.example.ordering_app;

import android.os.Bundle;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

import com.example.ordering_app.MethodChannelToAndroidNative;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "orderingappMC";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        MethodChannel channel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL);
        MethodChannelToAndroidNative methodChannelToAndroidNative = new MethodChannelToAndroidNative(channel);

        channel.setMethodCallHandler((call, result) -> {
            if (call.method.equals("checkInternetConnection")) {
                methodChannelToAndroidNative.checkInternetConnection(result);
            } else {
                result.notImplemented();
            }
        });
    }
}