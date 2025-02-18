package com.easemob.im_flutter_sdk;

import com.hyphenate.EMConversationListener;
import com.hyphenate.EMMessageListener;
import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.*;
import com.hyphenate.chat.EMConversation.EMSearchDirection;
import com.hyphenate.chat.EMConversation.EMConversationType;

import com.hyphenate.chat.EMCursorResult;
import com.hyphenate.chat.EMMessage;
import com.hyphenate.exceptions.HyphenateException;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


public class ChatManagerWrapper extends Wrapper implements MethodCallHandler {

    private final MethodChannel messageChannel;
    private EMMessageListener messageListener;
    private EMConversationListener conversationListener;


    ChatManagerWrapper(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, String channelName) {
        super(flutterPluginBinding, channelName);
        messageChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.chat.im/chat_message", JSONMethodCodec.INSTANCE);
        registerEaseListener();
    }


    @Override
    public void onMethodCall(MethodCall call, Result result) {
        JSONObject params = (JSONObject) call.arguments;
        try {
            if (MethodKey.sendMessage.equals(call.method)) {
                sendMessage(params, call.method, result);
            } else if (MethodKey.resendMessage.equals(call.method)) {
                resendMessage(params, call.method, result);
            } else if (MethodKey.ackMessageRead.equals(call.method)) {
                ackMessageRead(params, call.method, result);
            } else if (MethodKey.ackConversationRead.equals(call.method)) {
                ackConversationRead(params, call.method, result);
            } else if (MethodKey.recallMessage.equals(call.method)) {
                recallMessage(params, call.method, result);
            } else if (MethodKey.getConversation.equals(call.method)) {
                getConversation(params, call.method, result);
            } else if (MethodKey.getUnreadMessageCount.equals(call.method)) {
                getUnreadMessageCount(params, call.method, result);
            }else if (MethodKey.downloadAttachment.equals(call.method)) {
                downloadAttachment(params, call.method, result);
            } else if (MethodKey.downloadThumbnail.equals(call.method)) {
                downloadThumbnail(params, call.method, result);
            }  else if (MethodKey.fetchHistoryMessagesByOptions.equals(call.method)) {
                fetchHistoryMessagesByOptions(params, call.method, result);
            } else if (MethodKey.getMessage.equals(call.method)) {
                getMessage(params, call.method, result);
            } else if (MethodKey.deleteRemoteConversation.equals(call.method)){
                deleteRemoteConversation(params, call.method, result);
            }else if (MethodKey.removeMessagesFromServerWithTs.equals(call.method)) {
                removeMessagesFromServerWithTs(params, call.method, result);
            } else if (MethodKey.getConversationsFromServerWithCursor.equals(call.method)) {
                getConversationsFromServerWithCursor(params, call.method, result);
            } else if (MethodKey.getPinnedConversationsFromServerWithCursor.equals(call.method)) {
                getPinnedConversationsFromServerWithCursor(params, call.method, result);
            } else if (MethodKey.pinConversation.equals(call.method)) {
                pinConversation(params, call.method, result);
            }
            else {
                super.onMethodCall(call, result);
            }
        } catch (JSONException ignored) {

        }
    }

    private void sendMessage(JSONObject params, String channelName, Result result) throws JSONException {
        final EMMessage msg = MessageHelper.fromJson(params);
        final String localId = msg.getMsgId();
        msg.setMessageStatusCallback(new EMWrapperCallBack(result, channelName, null) {
            @Override
            public void onSuccess() {
                post(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("message", MessageHelper.toJson(msg));
                    map.put("localId", localId);
                    messageChannel.invokeMethod(MethodKey.onMessageSuccess, map);
                });
            }

            @Override
            public void onProgress(int progress, String status) {
                post(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("progress", progress);
                    map.put("localId", localId);
                    messageChannel.invokeMethod(MethodKey.onMessageProgressUpdate, map);
                });
            }

            @Override
            public void onError(int code, String desc) {
                Map<String, Object> data = new HashMap<>();
                data.put("code", code);
                data.put("description", desc);
                post(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("message", MessageHelper.toJson(msg));
                    map.put("localId", localId);
                    map.put("error", data);
                    messageChannel.invokeMethod(MethodKey.onMessageError, map);
                });
            }
        });
        asyncRunnable(() -> {
            EMClient.getInstance().chatManager().sendMessage(msg);
            onSuccess(result, channelName, MessageHelper.toJson(msg));
        });
    }

    private void resendMessage(JSONObject params, String channelName, Result result) throws JSONException {
        EMMessage tempMsg = MessageHelper.fromJson(params);
        EMMessage msg = EMClient.getInstance().chatManager().getMessage(tempMsg.getMsgId());
        if (msg == null) {
            msg = tempMsg;
        }
        msg.setStatus(EMMessage.Status.CREATE);
        EMMessage finalMsg = msg;
        final String localId = finalMsg.getMsgId();
        finalMsg.setMessageStatusCallback(new EMWrapperCallBack(result, channelName, null) {
            @Override
            public void onSuccess() {
                post(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("message", MessageHelper.toJson(finalMsg));
                    map.put("localId", localId);
                    messageChannel.invokeMethod(MethodKey.onMessageSuccess, map);
                });
            }

            @Override
            public void onProgress(int progress, String status) {
                post(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("progress", progress);
                    map.put("localId", localId);
                    messageChannel.invokeMethod(MethodKey.onMessageProgressUpdate, map);
                });
            }


            @Override
            public void onError(int code, String desc) {
                Map<String, Object> data = new HashMap<>();
                data.put("code", code);
                data.put("description", desc);
                post(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("message", MessageHelper.toJson(finalMsg));
                    map.put("localId", localId);
                    map.put("error", data);
                    messageChannel.invokeMethod(MethodKey.onMessageError, map);
                });
            }
        });
        EMClient.getInstance().chatManager().sendMessage(msg);
        asyncRunnable(() -> onSuccess(result, channelName, MessageHelper.toJson(finalMsg)));
    }

    private void ackMessageRead(JSONObject params, String channelName, Result result) throws JSONException {
        String msgId = params.getString("msg_id");
        String to = params.getString("to");

        asyncRunnable(() -> {
            try {
                EMClient.getInstance().chatManager().ackMessageRead(to, msgId);
                onSuccess(result, channelName, true);
            } catch (HyphenateException e) {
                onError(result, e);
            }
        });
    }

    private void ackConversationRead(JSONObject params, String channelName, Result result) throws JSONException {
        String conversationId = params.getString("convId");
        asyncRunnable(() -> {
            try {
                EMClient.getInstance().chatManager().ackConversationRead(conversationId);
                onSuccess(result, channelName, true);
            } catch (HyphenateException e) {
                onError(result, e);
            }
        });
    }

    private void recallMessage(JSONObject params, String channelName, Result result) throws JSONException {
        String msgId = params.getString("msg_id");
        asyncRunnable(() -> {
            try {
                EMMessage msg = EMClient.getInstance().chatManager().getMessage(msgId);
                if (msg != null) {
                    EMClient.getInstance().chatManager().recallMessage(msg);
                    onSuccess(result, channelName, true);
                }else {
                    onError(result, new HyphenateException(500, "The message was not found"));
                }
            } catch (HyphenateException e) {
                onError(result, e);
            }
        });
    }

    private void getMessage(JSONObject params, String channelName, Result result) throws JSONException {
        String msgId = params.getString("msg_id");

        asyncRunnable(() -> {
            EMMessage msg = EMClient.getInstance().chatManager().getMessage(msgId);
            if(msg == null) {
                onSuccess(result, channelName, null);
            }else {
                onSuccess(result, channelName, MessageHelper.toJson(msg));
            }
        });
    }

    private void getConversation(JSONObject params, String channelName, Result result) throws JSONException {
        String conId = params.getString("convId");
        boolean createIfNeed = true;
        if (params.has("createIfNeed")) {
            createIfNeed = params.getBoolean("createIfNeed");
        }

        EMConversationType type = EnumTools.conversationTypeFromInt(params.getInt("type"));

        boolean finalCreateIfNeed = createIfNeed;
        asyncRunnable(() -> {
            EMConversation conversation = EMClient.getInstance().chatManager().getConversation(conId, type, finalCreateIfNeed);
            onSuccess(result, channelName, conversation != null ? ConversationHelper.toJson(conversation) : null);
        });
    }

    private void getUnreadMessageCount(JSONObject params, String channelName, Result result) throws JSONException {
        asyncRunnable(() -> {
            int count = EMClient.getInstance().chatManager().getUnreadMessageCount();
            onSuccess(result, channelName, count);
        });
    }


    private void removeMessagesFromServerWithTs(JSONObject params, String channelName, Result result) throws JSONException {
        String conversationId = params.getString("convId");
        EMConversation.EMConversationType type = EnumTools.conversationTypeFromInt(params.getInt("type"));
        EMConversation conversation = EMClient.getInstance().chatManager().getConversation(conversationId, type, true);
        long timestamp = 0;
        if(params.has("timestamp")) {
            timestamp = params.getLong("timestamp");
        }
        conversation.removeMessagesFromServer(timestamp, new EMWrapperCallBack(result, channelName, null));
    }

    private void downloadAttachment(JSONObject params, String channelName, Result result) throws JSONException {
        EMMessage tempMsg = MessageHelper.fromJson(params.getJSONObject("message"));
        final EMMessage msg = EMClient.getInstance().chatManager().getMessage(tempMsg.getMsgId());
        msg.setMessageStatusCallback(new EMWrapperCallBack(result, channelName, null) {
            @Override
            public void onSuccess() {
                post(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("message", updateDownloadStatus(EMFileMessageBody.EMDownloadStatus.SUCCESSED, msg, false));
                    map.put("localId", msg.getMsgId());
                    messageChannel.invokeMethod(MethodKey.onMessageSuccess, map);
                });
            }

            @Override
            public void onProgress(int progress, String status) {
                post(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("progress", progress);
                    map.put("localId", msg.getMsgId());
                    messageChannel.invokeMethod(MethodKey.onMessageProgressUpdate, map);
                });
            }

            @Override
            public void onError(int code, String desc) {
                Map<String, Object> data = new HashMap<>();
                data.put("code", code);
                data.put("description", desc);
                post(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("message", updateDownloadStatus(EMFileMessageBody.EMDownloadStatus.FAILED, msg, false));
                    map.put("localId", msg.getMsgId());
                    map.put("error", data);
                    messageChannel.invokeMethod(MethodKey.onMessageError, map);
                });
            }
        });
        asyncRunnable(() -> {
            EMClient.getInstance().chatManager().downloadAttachment(msg);
            onSuccess(result, channelName, updateDownloadStatus(EMFileMessageBody.EMDownloadStatus.DOWNLOADING, msg, false));
        });
    }

    private void downloadThumbnail(JSONObject params, String channelName, Result result) throws JSONException {
        EMMessage tempMsg = MessageHelper.fromJson(params.getJSONObject("message"));
        final EMMessage msg = EMClient.getInstance().chatManager().getMessage(tempMsg.getMsgId());
        msg.setMessageStatusCallback(new EMWrapperCallBack(result, channelName, null) {
            @Override
            public void onSuccess() {
                post(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("message", updateDownloadStatus(EMFileMessageBody.EMDownloadStatus.SUCCESSED, msg, true));
                    map.put("localId", msg.getMsgId());
                    messageChannel.invokeMethod(MethodKey.onMessageSuccess, map);
                });
            }

            @Override
            public void onProgress(int progress, String status) {
                post(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("progress", progress);
                    map.put("localId", msg.getMsgId());
                    messageChannel.invokeMethod(MethodKey.onMessageProgressUpdate, map);
                });
            }

            @Override
            public void onError(int code, String desc) {
                Map<String, Object> data = new HashMap<>();
                data.put("code", code);
                data.put("description", desc);
                post(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("message", updateDownloadStatus(EMFileMessageBody.EMDownloadStatus.FAILED, msg, true));
                    map.put("localId", msg.getMsgId());
                    map.put("error", data);
                    messageChannel.invokeMethod(MethodKey.onMessageError, map);
                });
            }
        });
        asyncRunnable(() -> {
            EMClient.getInstance().chatManager().downloadThumbnail(msg);
            onSuccess(result, channelName, updateDownloadStatus(EMFileMessageBody.EMDownloadStatus.DOWNLOADING, msg, true));
        });
    }

    private Map<String, Object> updateDownloadStatus(EMFileMessageBody.EMDownloadStatus downloadStatus, EMMessage msg, boolean isThumbnail) {
        boolean canUpdate = false;
        switch (msg.getType()) {
            case FILE:
            case VOICE: {
                if (isThumbnail) {
                    break;
                }
            }
            case IMAGE:
            case VIDEO:
            {
                canUpdate = true;
            }
            break;
            default:
                break;
        }
        if (canUpdate) {
            EMMessageBody body = msg.getBody();
            if (msg.getType() == EMMessage.Type.FILE) {
                EMFileMessageBody tmpBody = (EMFileMessageBody) body;
                tmpBody.setDownloadStatus(downloadStatus);
                body = tmpBody;
            }else if (msg.getType() == EMMessage.Type.VOICE) {
                EMVoiceMessageBody tmpBody = (EMVoiceMessageBody) body;
                tmpBody.setDownloadStatus(downloadStatus);
                body = tmpBody;
            }else if (msg.getType() == EMMessage.Type.IMAGE) {
                EMImageMessageBody tmpBody = (EMImageMessageBody) body;
                if (isThumbnail) {
                     tmpBody.setThumbnailDownloadStatus(downloadStatus);
                }else {
                    tmpBody.setDownloadStatus(downloadStatus);
                }

                body = tmpBody;
            }else if (msg.getType() == EMMessage.Type.VIDEO) {
                EMVideoMessageBody tmpBody = (EMVideoMessageBody) body;
                if (isThumbnail) {
                    tmpBody.setThumbnailDownloadStatus(downloadStatus);
                }else {
                    tmpBody.setDownloadStatus(downloadStatus);
                }

                body = tmpBody;
            }

            msg.setBody(body);
        }
        return MessageHelper.toJson(msg);
    }


    private void fetchHistoryMessagesByOptions(JSONObject params, String channelName, Result result) throws JSONException {
        String conId = params.getString("convId");
        EMConversationType type = EnumTools.conversationTypeFromInt(params.getInt("type"));
        int pageSize = params.getInt("pageSize");
        String cursor = null;
        if (params.has("cursor")) {
             cursor = params.getString("cursor");
        }
        EMFetchMessageOption option = null;
        if (params.has("options")) {
            option = FetchHistoryOptionsHelper.fromJson(params.getJSONObject("options"));
        }

        EMValueWrapperCallBack<EMCursorResult<EMMessage>> callBack = new EMValueWrapperCallBack<EMCursorResult<EMMessage>>(result,
                channelName) {
            @Override
            public void onSuccess(EMCursorResult<EMMessage> result) {
                updateObject(CursorResultHelper.toJson(result));
            }
        };

        EMClient.getInstance().chatManager().asyncFetchHistoryMessages(conId, type, pageSize, cursor, option, callBack);
    }

    private void deleteRemoteConversation(JSONObject params, String channelName, Result result) throws JSONException {
        String conversationId = params.getString("conversationId");
        EMConversationType type = EnumTools.conversationTypeFromInt(params.getInt("conversationType"));
        boolean isDeleteRemoteMessage = params.getBoolean("isDeleteRemoteMessage");
        EMClient.getInstance().chatManager().deleteConversationFromServer(conversationId, type, isDeleteRemoteMessage, new EMWrapperCallBack(result, channelName, null));
    }


    private void getConversationsFromServerWithCursor(JSONObject params, String channelName, Result result) throws JSONException {
        String cursor = params.optString("cursor");
        int pageSize = params.optInt("pageSize");
        EMClient.getInstance().chatManager().asyncFetchConversationsFromServer(pageSize, cursor, new EMValueWrapperCallBack<EMCursorResult<EMConversation>>(result, channelName){
            @Override
            public void onSuccess(EMCursorResult<EMConversation> object) {
                super.updateObject(CursorResultHelper.toJson(object));
            }
        });
    }

    private void getPinnedConversationsFromServerWithCursor(JSONObject params, String channelName, Result result) throws JSONException {
        String cursor = params.optString("cursor");
        int pageSize = params.optInt("pageSize");
        EMClient.getInstance().chatManager().asyncFetchPinnedConversationsFromServer(pageSize, cursor, new EMValueWrapperCallBack<EMCursorResult<EMConversation>>(result, channelName){
            @Override
            public void onSuccess(EMCursorResult<EMConversation> object) {
                super.updateObject(CursorResultHelper.toJson(object));
            }
        });
    }
    private void pinConversation(JSONObject params, String channelName, Result result) throws JSONException {
        String convId = params.optString("convId");
        boolean isPinned = params.optBoolean("isPinned", false);
        EMClient.getInstance().chatManager().asyncPinConversation(convId, isPinned, new EMWrapperCallBack(result, channelName, null));
    }

    @Override
    public void unRegisterEaseListener() {
        EMClient.getInstance().chatManager().removeMessageListener(messageListener);
        EMClient.getInstance().chatManager().removeConversationListener(conversationListener);
    }

    private void registerEaseListener() {

        if (messageListener != null) {
            EMClient.getInstance().chatManager().removeMessageListener(messageListener);
        }

        messageListener = new EMMessageListener() {
            @Override
            public void onMessageReceived(List<EMMessage> messages) {
                ArrayList<Map<String, Object>> msgList = new ArrayList<>();
                for (EMMessage message : messages) {
                    msgList.add(MessageHelper.toJson(message));
                }
                post(() -> channel.invokeMethod(MethodKey.onMessagesReceived, msgList));
            }

            @Override
            public void onCmdMessageReceived(List<EMMessage> messages) {
                ArrayList<Map<String, Object>> msgList = new ArrayList<>();
                for (EMMessage message : messages) {
                    msgList.add(MessageHelper.toJson(message));
                }
                post(() -> channel.invokeMethod(MethodKey.onCmdMessagesReceived, msgList));
            }

            @Override
            public void onMessageRead(List<EMMessage> messages) {
                ArrayList<Map<String, Object>> msgList = new ArrayList<>();
                for (EMMessage message : messages) {
                    msgList.add(MessageHelper.toJson(message));
                    post(() -> messageChannel.invokeMethod(MethodKey.onMessageReadAck,
                            MessageHelper.toJson(message)));
                }

                post(() -> channel.invokeMethod(MethodKey.onMessagesRead, msgList));
            }

            @Override
            public void onMessageDelivered(List<EMMessage> messages) {
                ArrayList<Map<String, Object>> msgList = new ArrayList<>();
                for (EMMessage message : messages) {
                    msgList.add(MessageHelper.toJson(message));
                    post(() -> messageChannel.invokeMethod(MethodKey.onMessageDeliveryAck,
                            MessageHelper.toJson(message)));
                }
                post(() -> channel.invokeMethod(MethodKey.onMessagesDelivered, msgList));
            }

            @Override
            public void onMessageRecalled(List<EMMessage> messages) {
                ArrayList<Map<String, Object>> msgList = new ArrayList<>();
                for (EMMessage message : messages) {
                    msgList.add(MessageHelper.toJson(message));
                }
                post(() -> channel.invokeMethod(MethodKey.onMessagesRecalled, msgList));
            }

        };

        if (conversationListener != null) {
            EMClient.getInstance().chatManager().removeConversationListener(conversationListener);
        }
        conversationListener = new EMConversationListener() {

            @Override
            public void onConversationUpdate() {
                Map<String, Object> data = new HashMap<>();
                post(() -> channel.invokeMethod(MethodKey.onConversationUpdate, data));
            }

            @Override
            public void onConversationRead(String from, String to) {
                Map<String, Object> data = new HashMap<>();
                data.put("from", from);
                data.put("to", to);
                post(() -> channel.invokeMethod(MethodKey.onConversationHasRead, data));
            }
        };

        EMClient.getInstance().chatManager().addMessageListener(messageListener);
        EMClient.getInstance().chatManager().addConversationListener(conversationListener);
    }

}
