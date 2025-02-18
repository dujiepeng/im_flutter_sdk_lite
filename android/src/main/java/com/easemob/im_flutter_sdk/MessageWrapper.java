package com.easemob.im_flutter_sdk;

import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMMessage;

import org.json.JSONObject;


import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MessageWrapper extends Wrapper implements MethodChannel.MethodCallHandler {
    public MessageWrapper(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, String channelName) {
        super(flutterPluginBinding, channelName);
    }


    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        JSONObject param = (JSONObject)call.arguments;
        super.onMethodCall(call, result);
    }
}
