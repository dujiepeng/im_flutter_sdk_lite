package com.easemob.im_flutter_sdk;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMConversation;
import com.hyphenate.chat.EMMessage;

import org.json.JSONException;
import org.json.JSONObject;


public class ConversationWrapper extends Wrapper implements MethodCallHandler{

    ConversationWrapper(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, String channelName) {
        super(flutterPluginBinding, channelName);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {

        JSONObject param = (JSONObject)call.arguments;

        try { 
            if (MethodKey.getLatestMessage.equals(call.method)) {
                getLatestMessage(param, call.method, result);
            }
            else if (MethodKey.getLatestMessageFromOthers.equals(call.method)) {
                getLatestMessageFromOthers(param, call.method, result);
            }

            else if (MethodKey.conversationDeleteServerMessageWithTime.equals(call.method)) {
                deleteLocalAndServerMessagesByTime(param, call.method, result);
            }
            else
            {
                super.onMethodCall(call, result);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void getLatestMessage(JSONObject params, String channelName, Result result) throws JSONException {
        EMConversation conversation = conversationWithParam(params);

        asyncRunnable(()->{
            EMMessage msg = conversation.getLastMessage();
            onSuccess(result, channelName, msg != null ? MessageHelper.toJson(msg) : null);
        });
    }

    private void getLatestMessageFromOthers(JSONObject params, String channelName, Result result) throws JSONException {
        EMConversation conversation = conversationWithParam(params);

        asyncRunnable(()->{
            EMMessage msg = conversation.getLatestMessageFromOthers();
            onSuccess(result, channelName, msg != null ? MessageHelper.toJson(msg) : null);
        });
    }

    private EMConversation conversationWithParam(JSONObject params ) throws JSONException {
        String convId = params.getString("convId");
        EMConversation.EMConversationType type = EnumTools.conversationTypeFromInt(params.getInt("type"));
        return EMClient.getInstance().chatManager().getConversation(convId, type, true);
    }

    private void deleteLocalAndServerMessagesByTime(JSONObject params, String channelName, Result result) throws JSONException {
        EMConversation conversation = conversationWithParam(params);
        long beforeMs = params.optLong("beforeMs");
        conversation.removeMessagesFromServer(beforeMs, new EMWrapperCallBack(result, channelName,null));
    }

}
