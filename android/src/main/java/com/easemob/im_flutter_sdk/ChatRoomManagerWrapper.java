package com.easemob.im_flutter_sdk;

import com.hyphenate.EMChatRoomChangeListener;
import com.hyphenate.EMError;
import com.hyphenate.EMResultCallBack;
import com.hyphenate.chat.EMChatRoom;
import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMCursorResult;
import com.hyphenate.chat.EMPageResult;
import com.hyphenate.exceptions.HyphenateException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class ChatRoomManagerWrapper extends Wrapper implements MethodChannel.MethodCallHandler {

    private EMChatRoomChangeListener chatRoomChangeListener;

    ChatRoomManagerWrapper(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, String channelName) {
        super(flutterPluginBinding, channelName);
        registerEaseListener();
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {

        JSONObject param = (JSONObject) call.arguments;
        try {
            if (MethodKey.joinChatRoom.equals(call.method)) {
                joinChatRoom(param, call.method, result);
            } else if (MethodKey.leaveChatRoom.equals(call.method)) {
                leaveChatRoom(param, call.method, result);
            } else if (MethodKey.fetchPublicChatRoomsFromServer.equals(call.method)) {
                fetchPublicChatRoomsFromServer(param, call.method, result);
            } else if (MethodKey.fetchChatRoomInfoFromServer.equals(call.method)) {
                fetchChatRoomInfoFromServer(param, call.method, result);
            } else if (MethodKey.getChatRoom.equals(call.method)) {
                getChatRoom(param, call.method, result);
            } else if (MethodKey.fetchChatRoomMembers.equals(call.method)) {
                fetchChatRoomMembers(param, call.method, result);
            } else if (MethodKey.fetchChatRoomAnnouncement.equals(call.method)) {
                fetchChatRoomAnnouncement(param, call.method, result);
            } else {
                super.onMethodCall(call, result);
            }
        } catch (JSONException ignored) {

        }
    }

    private void joinChatRoom(JSONObject param, String channelName, MethodChannel.Result result) throws JSONException {
        String roomId = param.getString("roomId");
        String ext = param.optString("ext");
        Boolean leaveOther = param.optBoolean("leaveOtherRooms");
        EMValueWrapperCallBack<EMChatRoom> callBack = new EMValueWrapperCallBack<EMChatRoom>(result, channelName) {
            @Override
            public void onSuccess(EMChatRoom object) {
                updateObject(ChatRoomHelper.toJson(object));
            }
        };

        EMClient.getInstance().chatroomManager().joinChatRoom(roomId, leaveOther, ext, callBack);
    }

    private void leaveChatRoom(JSONObject param, String channelName, MethodChannel.Result result) throws JSONException {
        String roomId = param.getString("roomId");

        asyncRunnable(() -> {
            EMClient.getInstance().chatroomManager().leaveChatRoom(roomId);
            onSuccess(result, channelName, true);
        });
    }

    private void fetchPublicChatRoomsFromServer(JSONObject param, String channelName, MethodChannel.Result result)
            throws JSONException {
        int pageNum = param.getInt("pageNum");
        int pageSize = param.getInt("pageSize");

        EMClient.getInstance().chatroomManager().asyncFetchPublicChatRoomsFromServer(pageNum, pageSize,
                new EMValueWrapperCallBack<EMPageResult<EMChatRoom>>(result, channelName) {
                    @Override
                    public void onSuccess(EMPageResult object) {
                        updateObject(PageResultHelper.toJson(object));
                    }

                    @Override
                    public void onError(int code, String desc) {
                        super.onError(code, desc);
                    }
                });
    }

    private void fetchChatRoomInfoFromServer(JSONObject param, String channelName, MethodChannel.Result result)
            throws JSONException {
        String roomId = param.getString("roomId");

        asyncRunnable(() -> {
            EMChatRoom room = null;
            try {
                room = EMClient.getInstance().chatroomManager().fetchChatRoomFromServer(roomId);
                onSuccess(result, channelName, ChatRoomHelper.toJson(room));
            } catch (HyphenateException e) {
                onError(result, e);
            }
        });
    }

    private void getChatRoom(JSONObject param, String channelName, MethodChannel.Result result) throws JSONException {
        String roomId = param.getString("roomId");

        asyncRunnable(() -> {
            EMChatRoom room = EMClient.getInstance().chatroomManager().getChatRoom(roomId);
            onSuccess(result, channelName,room != null ? ChatRoomHelper.toJson(room) : null);
        });
    }

    private void fetchChatRoomMembers(JSONObject param, String channelName, MethodChannel.Result result)
            throws JSONException {
        String roomId = param.getString("roomId");
        String cursor = null;
        if(param.has("cursor")) {
            cursor = param.getString("cursor");
        }
        int pageSize = param.getInt("pageSize");

        String finalCursor = cursor;
        asyncRunnable(() -> {
            try {
                EMCursorResult<String> cursorResult = EMClient.getInstance().chatroomManager()
                        .fetchChatRoomMembers(roomId, finalCursor, pageSize);
                onSuccess(result, channelName, CursorResultHelper.toJson(cursorResult));
            } catch (HyphenateException e) {
                onError(result, e);
            }
        });
    }

    private void fetchChatRoomAnnouncement(JSONObject param, String channelName, MethodChannel.Result result)
            throws JSONException {
        String roomId = param.getString("roomId");

        asyncRunnable(() -> {
            try {
                String announcement = EMClient.getInstance().chatroomManager().fetchChatRoomAnnouncement(roomId);
                onSuccess(result, channelName, announcement);
            } catch (HyphenateException e) {
                onError(result, e);
            }
        });
    }

    private void registerEaseListener() {

        if (chatRoomChangeListener != null) {
            EMClient.getInstance().chatroomManager().removeChatRoomListener(chatRoomChangeListener);
        }

        chatRoomChangeListener = new EMChatRoomChangeListener() {

            @Override
            public void onWhiteListAdded(String chatRoomId, List<String> whitelist) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", chatRoomId);
                            data.put("whitelist", whitelist);
                            data.put("type", "onRoomWhiteListAdded");
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );

            }

            @Override
            public void onWhiteListRemoved(String chatRoomId, List<String> whitelist) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", chatRoomId);
                            data.put("whitelist", whitelist);
                            data.put("type", "onRoomWhiteListRemoved");
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );
            }

            @Override
            public void onAllMemberMuteStateChanged(String chatRoomId, boolean isMuted) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", chatRoomId);
                            data.put("isMuted", isMuted);
                            data.put("type", "onRoomAllMemberMuteStateChanged");
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );

            }

            @Override
            public void onChatRoomDestroyed(String roomId, String roomName) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", roomId);
                            data.put("roomName", roomName);
                            data.put("type", "onRoomDestroyed");
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );

            }


            public void onMemberJoined(String roomId, String participant, String ext) {
                ListenerHandle.getInstance().addHandle(
                        () -> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", roomId);
                            data.put("participant", participant);
                            data.put("type", "onRoomMemberJoined");
                            if(ext != null) {
                                data.put("ext", ext);
                            }
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );
            }

            @Override
            public void onMemberExited(String roomId, String roomName, String participant) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", roomId);
                            data.put("roomName", roomName);
                            data.put("participant", participant);
                            data.put("type", "onRoomMemberExited");
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );

            }

            @Override
            public void onRemovedFromChatRoom(int reason, String roomId, String roomName, String participant) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", roomId);
                            data.put("roomName", roomName);
                            data.put("participant", participant);
                            data.put("type", "onRoomRemoved");
                            data.put("reason", reason);
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );

            }

            @Override
            public void onMuteListAdded(String s, List<String> list, long l) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", s);
                            data.put("mutes", list);
                            data.put("type", "onRoomMuteListAdded");
                            data.put("expireTime", l);
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );
            }


            @Override
            public void onMuteListRemoved(String chatRoomId, List<String> mutes) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", chatRoomId);
                            data.put("mutes", mutes);
                            data.put("type", "onRoomMuteListRemoved");
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );

            }

            @Override
            public void onAdminAdded(String chatRoomId, String admin) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", chatRoomId);
                            data.put("admin", admin);
                            data.put("type", "onRoomAdminAdded");
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );

            }

            @Override
            public void onAdminRemoved(String chatRoomId, String admin) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", chatRoomId);
                            data.put("admin", admin);
                            data.put("type", "onRoomAdminRemoved");
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );
            }

            @Override
            public void onOwnerChanged(String chatRoomId, String newOwner, String oldOwner) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", chatRoomId);
                            data.put("newOwner", newOwner);
                            data.put("oldOwner", oldOwner);
                            data.put("type", "onRoomOwnerChanged");
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );

            }

            @Override
            public void onAnnouncementChanged(String chatRoomId, String announcement) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", chatRoomId);
                            data.put("announcement", announcement);
                            data.put("type", "onRoomAnnouncementChanged");
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );
            }

            @Override
            public void onSpecificationChanged(EMChatRoom room) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("room", ChatRoomHelper.toJson(room));
                            data.put("type", "onRoomSpecificationChanged");
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );
            }

            @Override
            public void onAttributesUpdate(String chatRoomId, Map<String, String> attributeMap, String from) {
                ListenerHandle.getInstance().addHandle(
                        ()-> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", chatRoomId);
                            data.put("type", "onRoomAttributesDidUpdated");
                            data.put("attributes", attributeMap);
                            data.put("fromId", from);
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );
            }

            @Override
            public void onAttributesRemoved(String chatRoomId, List<String> keyList, String from) {
                ListenerHandle.getInstance().addHandle(
                        () -> {
                            Map<String, Object> data = new HashMap<>();
                            data.put("roomId", chatRoomId);
                            data.put("keys", keyList);
                            data.put("type", "onRoomAttributesDidRemoved");
                            data.put("fromId", from);
                            post(() -> channel.invokeMethod(MethodKey.chatRoomChange, data));
                        }
                );
            }
        };

        EMClient.getInstance().chatroomManager().addChatRoomChangeListener(chatRoomChangeListener);
    }

    @Override
    public void unRegisterEaseListener() {
        EMClient.getInstance().chatroomManager().removeChatRoomListener(chatRoomChangeListener);
    }
}
