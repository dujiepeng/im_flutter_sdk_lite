package com.easemob.im_flutter_sdk;

import java.util.Map;
import java.util.HashMap;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.hyphenate.EMConnectionListener;
import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMOptions;

import com.hyphenate.exceptions.HyphenateException;


import org.json.JSONException;
import org.json.JSONObject;


public class ClientWrapper extends Wrapper implements MethodCallHandler {

    private ChatManagerWrapper chatManagerWrapper;
    private ChatRoomManagerWrapper chatRoomManagerWrapper;
    private ConversationWrapper conversationWrapper;
    private MessageWrapper messageWrapper;
    public ProgressManager progressManager;
    private EMConnectionListener connectionListener;

    private EMOptions options;

    ClientWrapper(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, String channelName) {
        super(flutterPluginBinding, channelName);
    }

    public void sendDataToFlutter(final Map data) {
        if (data == null) {
            return;
        }
        post(()-> channel.invokeMethod(MethodKey.onSendDataToFlutter, data));
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull Result result) {

        JSONObject param = (JSONObject)call.arguments;
        try {
            if (MethodKey.init.equals(call.method)) {
                init(param, call.method, result);
            }
            else if (MethodKey.createAccount.equals(call.method))
            {
                createAccount(param, call.method, result);
            }
            else if (MethodKey.login.equals(call.method))
            {
                login(param, call.method, result);
            }
            else if (MethodKey.logout.equals(call.method))
            {
                logout(param, call.method, result);
            }
            else if (MethodKey.uploadLog.equals(call.method))
            {
                uploadLog(param, call.method, result);
            }
            else if (MethodKey.compressLogs.equals(call.method))
            {
                compressLogs(param, call.method, result);
            }
            else if (MethodKey.isLoggedInBefore.equals(call.method))
            {
                isLoggedInBefore(param, call.method, result);
            }
            else if (MethodKey.getCurrentUser.equals(call.method))
            {
                getCurrentUser(param, call.method, result);
            }
            else if (MethodKey.getToken.equals(call.method))
            {
                getToken(param, call.method, result);
            }
            else if (MethodKey.isConnected.equals(call.method)) {
                isConnected(param, call.method, result);
            }
            else if (MethodKey.renewToken.equals(call.method)){
                renewToken(param, call.method, result);
            } else if (MethodKey.startCallback.equals(call.method)) {
                startCallback(param, call.method, result);
            }
            // 481
            else if (MethodKey.updateUsingHttpsOnlySetting.equals(call.method)) {
                updateUsingHttpsOnlySetting(param, call.method, result);
            }
            else if (MethodKey.updateDeleteMessageWhenLeaveRoomSetting.equals(call.method)) {
                updateDeleteMessageWhenLeaveRoomSetting(param, call.method, result);
            }
            else if (MethodKey.updateRoomOwnerCanLeaveSetting.equals(call.method)) {
                updateRoomOwnerCanLeaveSetting(param, call.method, result);
            }
            else if (MethodKey.updateAutoDownloadAttachmentThumbnailSetting.equals(call.method)) {
                updateAutoDownloadAttachmentThumbnailSetting(param, call.method, result);
            }
            else if (MethodKey.updateRequireAckSetting.equals(call.method)) {
                updateRequireAckSetting(param, call.method, result);
            }
            else if (MethodKey.updateDeliveryAckSetting.equals(call.method)) {
                updateDeliveryAckSetting(param, call.method, result);
            }
            else if (MethodKey.updateSortMessageByServerTimeSetting.equals(call.method)) {
                updateSortMessageByServerTimeSetting(param, call.method, result);
            }
            else  {
                super.onMethodCall(call, result);
            }

        }catch (JSONException ignored) {

        }
    }
    private void createAccount(JSONObject param, String channelName, Result result) throws JSONException {
        String username = param.getString("username");
        String password = param.getString("password");
        asyncRunnable(()->{
            try {
                EMClient.getInstance().createAccount(username, password);
                onSuccess(result, channelName, username);
            } catch (HyphenateException e) {
                onError(result, e);
            }
        });
    }

    private void login(JSONObject param, String channelName, Result result) throws JSONException {
        boolean isPwd = param.getBoolean("isPassword");
        String username = param.getString("username");
        String pwdOrToken = param.getString("pwdOrToken");
        EMWrapperCallBack callBack = new EMWrapperCallBack(result, channelName, null) {
            @Override
            public void onSuccess() {
                post(() -> {
                    object = EMClient.getInstance().getCurrentUser();
                    super.onSuccess();
                });
            }
        };

        if (isPwd){
            EMClient.getInstance().login(username, pwdOrToken, callBack);
        } else {
            EMClient.getInstance().loginWithToken(username, pwdOrToken, callBack);
        }
    }


    private void logout(JSONObject param, String channelName, Result result) throws JSONException {
        boolean unbindToken = param.getBoolean("unbindToken");
        EMClient.getInstance().logout(unbindToken, new EMWrapperCallBack(result, channelName, null){
            @Override
            public void onSuccess() {
                ListenerHandle.getInstance().clearHandle();
                object = true;
                super.onSuccess();
            }
        });
    }

    private void getCurrentUser(JSONObject param, String channelName, Result result) throws JSONException {
        asyncRunnable(()-> onSuccess(result, channelName, EMClient.getInstance().getCurrentUser()));
    }

    private void getToken(JSONObject param, String channelName, Result result) throws JSONException
    {
        asyncRunnable(()-> onSuccess(result, channelName, EMClient.getInstance().getAccessToken()));
    }

    private void isLoggedInBefore(JSONObject param, String channelName, Result result) throws JSONException {
        asyncRunnable(()->{
            EMOptions emOptions = EMClient.getInstance().getOptions();
            onSuccess(result, channelName, EMClient.getInstance().isLoggedInBefore() && emOptions.getAutoLogin());
        });
    }

    private void isConnected(JSONObject param, String channelName, Result result) throws JSONException{
        asyncRunnable(()-> onSuccess(result, channelName, EMClient.getInstance().isConnected()));
    }

    private void uploadLog(JSONObject param, String channelName, Result result) throws JSONException {
        EMClient.getInstance().uploadLog(new EMWrapperCallBack(result, channelName, true));
    }

    private void compressLogs(JSONObject param, String channelName, Result result) throws JSONException {
        asyncRunnable(()->{
            try {
                String path = EMClient.getInstance().compressLogs();
                onSuccess(result, channelName, path);
            } catch (HyphenateException e) {
                onError(result, e);
            }
        });
    }

    private void init(JSONObject param, String channelName, Result result) throws JSONException {
        if (options != null) {
            onSuccess(result, channelName, null);
            return;
        }
        options = OptionsHelper.fromJson(param, this.context);
        EMClient.getInstance().init(this.context, options);
        EMClient.getInstance().setDebugMode(param.getBoolean("debugModel"));

        bindingManagers();
        registerEaseListener();

        onSuccess(result, channelName, null);

    }

    private void renewToken(JSONObject param, String channelName, Result result) throws JSONException {
        String agoraToken = param.getString("agora_token");
        EMClient.getInstance().renewToken(agoraToken, new EMWrapperCallBack(result, channelName,null));
    }

    private void startCallback(JSONObject param, String channelName, Result result) {
        ListenerHandle.getInstance().startCallback();
        onSuccess(result, channelName, null);
    }

    private void bindingManagers() {
        chatManagerWrapper = new ChatManagerWrapper(binging, "chat_manager");
        chatRoomManagerWrapper = new ChatRoomManagerWrapper(binging, "chat_room_manager");
        conversationWrapper = new ConversationWrapper(binging, "chat_conversation");
        messageWrapper = new MessageWrapper(binging, "chat_message");
        progressManager = new ProgressManager(binging, "file_progress_manager");
    }

    private void clearAllListener() {
        if (chatManagerWrapper != null) chatManagerWrapper.unRegisterEaseListener();
        if (chatRoomManagerWrapper != null) chatRoomManagerWrapper.unRegisterEaseListener();
        if (conversationWrapper != null) conversationWrapper.unRegisterEaseListener();
        if (messageWrapper != null) messageWrapper.unRegisterEaseListener();
        if (progressManager != null) progressManager.unRegisterEaseListener();
    }

    @Override
    public void unRegisterEaseListener() {
        EMClient.getInstance().removeConnectionListener(connectionListener);
        clearAllListener();
    }


    private void registerEaseListener() {


        if (connectionListener != null) {
            EMClient.getInstance().removeConnectionListener(connectionListener);
        }

        connectionListener = new EMConnectionListener() {
            @Override
            public void onConnected() {
                Map<String, Object> data = new HashMap<>();
                data.put("connected", Boolean.TRUE);
                post(()-> channel.invokeMethod(MethodKey.onConnected, data));
            }

            @Override
            public void onDisconnected(int errorCode) {
                if (errorCode == 207) {
                    ListenerHandle.getInstance().clearHandle();
                    post(() -> channel.invokeMethod(MethodKey.onUserDidRemoveFromServer, null));
                }else if (errorCode == 305) {
                    ListenerHandle.getInstance().clearHandle();
                    post(() -> channel.invokeMethod(MethodKey.onUserDidForbidByServer, null));
                }else if (errorCode == 216) {
                    ListenerHandle.getInstance().clearHandle();
                    post(() -> channel.invokeMethod(MethodKey.onUserDidChangePassword, null));
                }else if (errorCode == 214) {
                    ListenerHandle.getInstance().clearHandle();
                    post(() -> channel.invokeMethod(MethodKey.onUserDidLoginTooManyDevice, null));
                }
                else if (errorCode == 217) {
                    ListenerHandle.getInstance().clearHandle();
                    post(() -> channel.invokeMethod(MethodKey.onUserKickedByOtherDevice, null));
                }
                else if (errorCode == 202) {
                    ListenerHandle.getInstance().clearHandle();
                    post(() -> channel.invokeMethod(MethodKey.onUserAuthenticationFailed, null));
                }
                else if (errorCode == 8) {
                    post(() -> channel.invokeMethod(MethodKey.onAppActiveNumberReachLimit, null));
                }
                else {
                    post(() -> channel.invokeMethod(MethodKey.onDisconnected, null));
                }
            }

            @Override
            public void onTokenExpired() {
                post(()-> channel.invokeMethod(MethodKey.onTokenDidExpire, null));
            }

            @Override
            public void onTokenWillExpire() {
                post(()-> channel.invokeMethod(MethodKey.onTokenWillExpire, null));
            }

        };

        EMClient.getInstance().addConnectionListener(connectionListener);

    }

    // 481
    private void updateUsingHttpsOnlySetting(JSONObject param, String channelName, Result result) throws JSONException {
        boolean usingHttpsOnly = param.getBoolean("usingHttpsOnly");
        EMClient.getInstance().getOptions().setUsingHttpsOnly(usingHttpsOnly);
        asyncRunnable(()->onSuccess(result, channelName, null));
    }

    private void updateDeleteMessageWhenLeaveRoomSetting(JSONObject param, String channelName, Result result) throws JSONException {
        boolean deleteMessageWhenLeaveRoom = param.getBoolean("deleteMessageWhenLeaveRoom");
        EMClient.getInstance().getOptions().setDeleteMessagesAsExitChatRoom(deleteMessageWhenLeaveRoom);
        asyncRunnable(()-> onSuccess(result, channelName, null));
    }
    private void updateRoomOwnerCanLeaveSetting(JSONObject param, String channelName, Result result) throws JSONException {
        boolean roomOwnerCanLeave = param.getBoolean("roomOwnerCanLeave");
        EMClient.getInstance().getOptions().allowChatroomOwnerLeave(roomOwnerCanLeave);
        asyncRunnable(()-> onSuccess(result, channelName, null));
    }

    private void updateAutoDownloadAttachmentThumbnailSetting(JSONObject param, String channelName, Result result) throws JSONException {
        boolean autoDownloadThumbnail = param.getBoolean("autoDownloadThumbnail");
        EMClient.getInstance().getOptions().setAutoDownloadThumbnail(autoDownloadThumbnail);
        asyncRunnable(()-> onSuccess(result, channelName, null));
    }
    private void updateRequireAckSetting(JSONObject param, String channelName, Result result) throws JSONException {
        boolean requireAck = param.getBoolean("requireAck");
        EMClient.getInstance().getOptions().setRequireAck(requireAck);
        asyncRunnable(()-> onSuccess(result, channelName, null));
    }
    private void updateDeliveryAckSetting(JSONObject param, String channelName, Result result) throws JSONException {
        boolean requireDeliveryAck = param.getBoolean("requireDeliveryAck");
        EMClient.getInstance().getOptions().setRequireDeliveryAck(requireDeliveryAck);
        asyncRunnable(()-> onSuccess(result, channelName, null));
    }
    private void updateSortMessageByServerTimeSetting(JSONObject param, String channelName, Result result) throws JSONException {
        boolean sortMessageByServerTime = param.getBoolean("sortMessageByServerTime");
        EMClient.getInstance().getOptions().setSortMessageByServerTime(sortMessageByServerTime);
        asyncRunnable(()-> onSuccess(result, channelName, null));
    }

}

