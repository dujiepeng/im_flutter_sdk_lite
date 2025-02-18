package com.easemob.im_flutter_sdk;

import android.content.Context;
import com.hyphenate.chat.EMChatRoom;
import com.hyphenate.chat.EMCmdMessageBody;
import com.hyphenate.chat.EMCombineMessageBody;
import com.hyphenate.chat.EMConversation;
import com.hyphenate.chat.EMCursorResult;
import com.hyphenate.chat.EMCustomMessageBody;
import com.hyphenate.chat.EMFetchMessageOption;
import com.hyphenate.chat.EMFileMessageBody;
import com.hyphenate.chat.EMImageMessageBody;
import com.hyphenate.chat.EMLocationMessageBody;
import com.hyphenate.chat.EMMessage;
import com.hyphenate.chat.EMMessage.Type;
import com.hyphenate.chat.EMMessageBody;
import com.hyphenate.chat.EMNormalFileMessageBody;
import com.hyphenate.chat.EMOptions;
import com.hyphenate.chat.EMPageResult;
import com.hyphenate.chat.EMTextMessageBody;
import com.hyphenate.chat.EMVideoMessageBody;
import com.hyphenate.chat.EMVoiceMessageBody;
import com.hyphenate.exceptions.HyphenateException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

class OptionsHelper {

    static EMOptions fromJson(JSONObject json, Context context) throws JSONException {
        EMOptions options = new EMOptions();
        options.setAppKey(json.getString("appKey"));
        options.setAutoLogin(json.getBoolean("autoLogin"));
        options.setRequireAck(json.getBoolean("requireAck"));
        options.setRequireDeliveryAck(json.getBoolean("requireDeliveryAck"));
        options.setSortMessageByServerTime(json.getBoolean("sortMessageByServerTime"));
        options.setDeleteMessagesAsExitChatRoom(json.getBoolean("deleteMessagesAsExitChatRoom"));
        options.setAutoDownloadThumbnail(json.getBoolean("isAutoDownload"));
        options.allowChatroomOwnerLeave(json.getBoolean("isChatRoomOwnerLeaveAllowed"));
        options.setAutoTransferMessageAttachments(json.getBoolean("serverTransfer"));
        options.setUsingHttpsOnly(json.getBoolean("usingHttpsOnly"));
        options.enableDNSConfig(json.getBoolean("enableDNSConfig"));
        if (!json.getBoolean("enableDNSConfig")) {
            if (json.has("imPort")) {
                options.setImPort(json.getInt("imPort"));
            }
            if (json.has("imServer")) {
                options.setIMServer(json.getString("imServer"));
            }
            if (json.has("restServer")) {
                options.setRestServer(json.getString("restServer"));
            }
            if (json.has("dnsUrl")){
                options.setDnsUrl(json.getString("dnsUrl"));
            }
        }
        return options;
    }
}


class ChatRoomHelper {

    static Map<String, Object> toJson(EMChatRoom chatRoom) {
        Map<String, Object> data = new HashMap<>();
        data.put("roomId", chatRoom.getId());
        data.put("name", chatRoom.getName());
        data.put("desc", chatRoom.getDescription());
        data.put("owner", chatRoom.getOwner());
        data.put("maxUsers", chatRoom.getMaxUsers());
        data.put("memberCount", chatRoom.getMemberCount());
        data.put("adminList", chatRoom.getAdminList());
        data.put("memberList", chatRoom.getMemberList());
        data.put("blockList", chatRoom.getBlacklist());
        data.put("muteList", chatRoom.getMuteList().keySet().toArray());
        data.put("isAllMemberMuted", chatRoom.isAllMemberMuted());
        data.put("announcement", chatRoom.getAnnouncement());
        data.put("permissionType", EnumTools.chatRoomPermissionTypeToInt(chatRoom.getChatRoomPermissionType()));
        return data;
    }

}

class MessageHelper {

    static Type getTypeFromInt(int iType) {
        switch (iType) {
            case 1:
                return Type.IMAGE;
            case 2:
                return Type.VIDEO;
            case 3:
                return Type.LOCATION;
            case 4:
                return Type.VOICE;
            case 5:
                return Type.FILE;
            case 6:
                return Type.CMD;
            case 7:
                return Type.CUSTOM;
            default:
                return Type.TXT;
        }
    }

    static EMMessage fromJson(JSONObject json) throws JSONException {
        EMMessage message = null;

        JSONObject bodyJson = json.getJSONObject("body");
        EMMessage.Type type = EnumTools.messageBodyTypeFromInt(bodyJson.getInt("type"));
        EMMessage.Direct direct = EnumTools.messageDirectFromInt(json.getInt("direction"));
        if (direct == EMMessage.Direct.SEND) {
            switch (type) {
                case TXT: {
                    message = EMMessage.createSendMessage(Type.TXT);
                    message.addBody(MessageBodyHelper.textBodyFromJson(bodyJson));
                }
                    break;
                case IMAGE: {
                    message = EMMessage.createSendMessage(Type.IMAGE);
                    message.addBody(MessageBodyHelper.imageBodyFromJson(bodyJson));
                }
                    break;
                case LOCATION: {
                    message = EMMessage.createSendMessage(Type.LOCATION);
                    message.addBody(MessageBodyHelper.localBodyFromJson(bodyJson));
                }
                    break;
                case VIDEO: {
                    message = EMMessage.createSendMessage(Type.VIDEO);
                    message.addBody(MessageBodyHelper.videoBodyFromJson(bodyJson));
                }
                    break;
                case VOICE: {
                    message = EMMessage.createSendMessage(Type.VOICE);
                    message.addBody(MessageBodyHelper.voiceBodyFromJson(bodyJson));
                }
                    break;
                case FILE: {
                    message = EMMessage.createSendMessage(Type.FILE);
                    message.addBody(MessageBodyHelper.fileBodyFromJson(bodyJson));
                }
                    break;
                case CMD: {
                    message = EMMessage.createSendMessage(Type.CMD);
                    message.addBody(MessageBodyHelper.cmdBodyFromJson(bodyJson));
                }
                    break;
                case CUSTOM: {
                    message = EMMessage.createSendMessage(Type.CUSTOM);
                    message.addBody(MessageBodyHelper.customBodyFromJson(bodyJson));
                }
                    break;
            }
            if (message != null) {
                message.setDirection(EMMessage.Direct.SEND);
            }
        } else {
            switch (type) {
                case TXT: {
                    message = EMMessage.createReceiveMessage(Type.TXT);
                    message.addBody(MessageBodyHelper.textBodyFromJson(bodyJson));
                    break;
                }
                case IMAGE: {
                    message = EMMessage.createReceiveMessage(Type.IMAGE);
                    message.addBody(MessageBodyHelper.imageBodyFromJson(bodyJson));
                    break;
                }

                case LOCATION: {
                    message = EMMessage.createReceiveMessage(Type.LOCATION);
                    message.addBody(MessageBodyHelper.localBodyFromJson(bodyJson));
                    break;
                }

                case VIDEO: {
                    message = EMMessage.createReceiveMessage(Type.VIDEO);
                    message.addBody(MessageBodyHelper.videoBodyFromJson(bodyJson));
                    break;
                }

                case VOICE: {
                    message = EMMessage.createReceiveMessage(Type.VOICE);
                    message.addBody(MessageBodyHelper.voiceBodyFromJson(bodyJson));
                    break;
                }
                case FILE: {
                    message = EMMessage.createReceiveMessage(Type.FILE);
                    message.addBody(MessageBodyHelper.fileBodyFromJson(bodyJson));
                    break;
                }
                case CMD: {
                    message = EMMessage.createReceiveMessage(Type.CMD);
                    message.addBody(MessageBodyHelper.cmdBodyFromJson(bodyJson));
                    break;
                }
                case CUSTOM: {
                    message = EMMessage.createReceiveMessage(Type.CUSTOM);
                    message.addBody(MessageBodyHelper.customBodyFromJson(bodyJson));
                    break;
                }
            }
            if (message != null) {
                message.setDirection(EMMessage.Direct.RECEIVE);
            }
        }

        if (json.has("to")) {
            message.setTo(json.getString("to"));
        }

        if (json.has("from")) {
            message.setFrom(json.getString("from"));
        }
        message.setAcked(json.getBoolean("hasReadAck"));
        if (EnumTools.messageStatusFromInt(json.getInt("status")) == EMMessage.Status.SUCCESS) {
            message.setUnread(!json.getBoolean("hasRead"));
        }

        message.deliverOnlineOnly(json.getBoolean("deliverOnlineOnly"));

        message.setLocalTime(json.getLong("localTime"));
        if (json.has("serverTime")){
            message.setMsgTime(json.getLong("serverTime"));
        }

        message.setStatus(EnumTools.messageStatusFromInt(json.getInt("status")));
        if (json.has("chatroomMessagePriority")) {
            int intPriority = json.getInt("chatroomMessagePriority");
            if (intPriority == 0) {
                message.setPriority(EMMessage.EMChatRoomMessagePriority.PriorityHigh);
            }else if (intPriority == 1) {
                message.setPriority(EMMessage.EMChatRoomMessagePriority.PriorityNormal);
            }else if (intPriority == 2) {
                message.setPriority(EMMessage.EMChatRoomMessagePriority.PriorityLow);
            }
        }
        message.setChatType(EnumTools.chatTypeFromInt(json.getInt("chatType")));
        if (json.has("msgId")){
            message.setMsgId(json.getString("msgId"));
        }

        if(json.has("attributes")){
            JSONObject data = json.getJSONObject("attributes");
            Iterator iterator = data.keys();
            while (iterator.hasNext()) {
                String key = iterator.next().toString();
                Object result = data.get(key);
                if (result.getClass().getSimpleName().equals("Integer")) {
                    message.setAttribute(key, (Integer) result);
                } else if (result.getClass().getSimpleName().equals("Boolean")) {
                    message.setAttribute(key, (Boolean) result);
                } else if (result.getClass().getSimpleName().equals("Long")) {
                    message.setAttribute(key, (Long) result);
                } else if (result.getClass().getSimpleName().equals("JSONObject")) {
                    message.setAttribute(key, (JSONObject) result);
                } else if (result.getClass().getSimpleName().equals("JSONArray")) {
                    message.setAttribute(key, (JSONArray) result);
                } else {
                    message.setAttribute(key, data.getString(key));
                }
            }
        }

        if (json.has("receiverList")) {
            ArrayList<String> receiverList = new ArrayList<>();
            JSONArray ja = json.getJSONArray("receiverList");
            for (int i = 0; i < ja.length(); i++) {
                receiverList.add((String) ja.get(i));
            }
            message.setReceiverList(receiverList);
        }

        return message;
    }

    static Map<String, Object> toJson(EMMessage message) {
        Map<String, Object> data = new HashMap<>();
        switch (message.getType()) {
            case TXT: {
                data.put("body", MessageBodyHelper.textBodyToJson((EMTextMessageBody) message.getBody()));
            }
                break;
            case IMAGE: {
                data.put("body", MessageBodyHelper.imageBodyToJson((EMImageMessageBody) message.getBody()));
            }
                break;
            case LOCATION: {
                data.put("body", MessageBodyHelper.localBodyToJson((EMLocationMessageBody) message.getBody()));
            }
                break;
            case CMD: {
                data.put("body", MessageBodyHelper.cmdBodyToJson((EMCmdMessageBody) message.getBody()));
            }
                break;
            case CUSTOM: {
                data.put("body", MessageBodyHelper.customBodyToJson((EMCustomMessageBody) message.getBody()));
            }
                break;
            case FILE: {
                data.put("body", MessageBodyHelper.fileBodyToJson((EMNormalFileMessageBody) message.getBody()));
            }
                break;
            case VIDEO: {
                data.put("body", MessageBodyHelper.videoBodyToJson((EMVideoMessageBody) message.getBody()));
            }
                break;
            case VOICE: {
                data.put("body", MessageBodyHelper.voiceBodyToJson((EMVoiceMessageBody) message.getBody()));
            }
                break;
        }

        if (message.ext().size() > 0 && null != message.ext()) {
            data.put("attributes", message.ext());
        }
        data.put("from", message.getFrom());
        data.put("to", message.getTo());
        data.put("hasReadAck", message.isAcked());
        data.put("hasDeliverAck", message.isDelivered());
        data.put("localTime", message.localTime());
        data.put("serverTime", message.getMsgTime());
        data.put("status", EnumTools.messageStatusToInt(message.status()));
        data.put("chatType", EnumTools.chatTypeToInt(message.getChatType()));
        data.put("direction", EnumTools.messageDirectToInt(message.direct()));
        data.put("conversationId", message.conversationId());
        data.put("msgId", message.getMsgId());
        data.put("hasRead", !message.isUnread());
        data.put("onlineState", message.isOnlineState());

        return data;
    }
}


class MessageBodyHelper {

    static Map<String, Object> getParentMap(EMMessageBody body){
        Map<String, Object> data = new HashMap<>();
        return data;
    }

     public static EMTextMessageBody textBodyFromJson(JSONObject json) throws JSONException {
        String content = json.getString("content");
        EMTextMessageBody body = new EMTextMessageBody(content);
        return body;
    }

    static Map<String, Object> textBodyToJson(EMTextMessageBody body) {
        Map<String, Object> data = getParentMap(body);
        data.put("content", body.getMessage());
        data.put("type", EnumTools.messageBodyTypeToInt(Type.TXT));
        return data;
    }

    static EMLocationMessageBody localBodyFromJson(JSONObject json) throws JSONException {
        double latitude = json.getDouble("latitude");
        double longitude = json.getDouble("longitude");
        String address = null;
        String buildingName = null;
        if (json.has("address")){
            address = json.getString("address");
        }

        if (json.has("buildingName")){
            buildingName = json.getString("buildingName");
        }

        EMLocationMessageBody body = new EMLocationMessageBody(address, latitude, longitude, buildingName);

        return body;
    }

    static Map<String, Object> localBodyToJson(EMLocationMessageBody body) {
        Map<String, Object> data = getParentMap(body);
        data.put("latitude", body.getLatitude());
        data.put("longitude", body.getLongitude());
        data.put("buildingName", body.getBuildingName());
        data.put("address", body.getAddress());
        data.put("type", EnumTools.messageBodyTypeToInt(Type.LOCATION));
        return data;
    }

    static EMCmdMessageBody cmdBodyFromJson(JSONObject json) throws JSONException {
        String action = json.getString("action");
        boolean deliverOnlineOnly = json.getBoolean("deliverOnlineOnly");

        EMCmdMessageBody body = new EMCmdMessageBody(action);
        body.deliverOnlineOnly(deliverOnlineOnly);

        return body;
    }

    static Map<String, Object> cmdBodyToJson(EMCmdMessageBody body) {
        Map<String, Object> data = getParentMap(body);
        data.put("deliverOnlineOnly", body.isDeliverOnlineOnly());
        data.put("action", body.action());
        data.put("type", EnumTools.messageBodyTypeToInt(Type.CMD));
        return data;
    }

    static EMCustomMessageBody customBodyFromJson(JSONObject json) throws JSONException {
        String event = json.getString("event");
        EMCustomMessageBody body = new EMCustomMessageBody(event);

        if (json.has("params") && json.get("params") != JSONObject.NULL) {
        JSONObject jsonObject = json.getJSONObject("params");
        Map<String, String> params = new HashMap<>();
        Iterator iterator = jsonObject.keys();
        while (iterator.hasNext()) {
            String key = iterator.next().toString();
            params.put(key, jsonObject.getString(key));
        }
        body.setParams(params);
        }
        return body;
    }

    static Map<String, Object> customBodyToJson(EMCustomMessageBody body) {
        Map<String, Object> data = getParentMap(body);
        data.put("event", body.event());
        data.put("params", body.getParams());
        data.put("type", EnumTools.messageBodyTypeToInt(Type.CUSTOM));
        return data;
    }

    static EMFileMessageBody fileBodyFromJson(JSONObject json) throws JSONException {
        String localPath = json.getString("localPath");
        File file = new File(localPath);

        EMNormalFileMessageBody body = new EMNormalFileMessageBody(file);
        if (json.has("displayName")){
            body.setFileName(json.getString("displayName"));
        }
        if (json.has("remotePath")){
            body.setRemoteUrl(json.getString("remotePath"));
        }
        if (json.has("secret")){
            body.setSecret(json.getString("secret"));
        }
        body.setDownloadStatus(EnumTools.downloadStatusFromInt(json.getInt("fileStatus")));
        if (json.has("fileSize")){
            body.setFileLength(json.getInt("fileSize"));
        }

        return body;
    }

    static Map<String, Object> fileBodyToJson(EMNormalFileMessageBody body) {
        Map<String, Object> data = getParentMap(body);
        data.put("localPath", body.getLocalUrl());
        data.put("fileSize", body.getFileSize());
        data.put("displayName", body.getFileName());
        data.put("remotePath", body.getRemoteUrl());
        data.put("secret", body.getSecret());
        data.put("fileStatus", EnumTools.downloadStatusToInt(body.downloadStatus()));
        data.put("type", EnumTools.messageBodyTypeToInt(Type.FILE));
        return data;
    }

    static EMImageMessageBody imageBodyFromJson(JSONObject json) throws JSONException {
        String localPath = json.getString("localPath");
        File file = new File(localPath);

        EMImageMessageBody body = new EMImageMessageBody(file);
        if (json.has("displayName")){
            body.setFileName(json.getString("displayName"));
        }
        if (json.has("remotePath")){
            body.setRemoteUrl(json.getString("remotePath"));
        }
        if (json.has("secret")){
            body.setSecret(json.getString("secret"));
        }
        if (json.has("thumbnailLocalPath")) {
            body.setThumbnailLocalPath(json.getString("thumbnailLocalPath"));
        }
        if (json.has("thumbnailRemotePath")){
            body.setThumbnailUrl(json.getString("thumbnailRemotePath"));
        }
        if (json.has("thumbnailSecret")){
            body.setThumbnailSecret(json.getString("thumbnailSecret"));
        }
        if (json.has("fileSize")){
            body.setFileLength(json.getInt("fileSize"));
        }
        if (json.has("width") && json.has("height")){
            int width = json.getInt("width");
            int height = json.getInt("height");
            body.setThumbnailSize(width, height);
        }
        if (json.has("sendOriginalImage")){
            body.setSendOriginalImage(json.getBoolean("sendOriginalImage"));
        }

        if (json.has("fileStatus")){
            body.setDownloadStatus(EnumTools.downloadStatusFromInt(json.getInt("fileStatus")));
        }

        return body;
    }

    static Map<String, Object> imageBodyToJson(EMImageMessageBody body) {
        Map<String, Object> data = getParentMap(body);
        data.put("localPath", body.getLocalUrl());
        data.put("displayName", body.getFileName());
        data.put("remotePath", body.getRemoteUrl());
        data.put("secret", body.getSecret());
        data.put("fileStatus", EnumTools.downloadStatusToInt(body.downloadStatus()));
        data.put("thumbnailLocalPath", body.thumbnailLocalPath());
        data.put("thumbnailRemotePath", body.getThumbnailUrl());
        data.put("thumbnailSecret", body.getThumbnailSecret());
        data.put("thumbnailStatus", EnumTools.downloadStatusToInt(body.thumbnailDownloadStatus()));
        data.put("height", body.getHeight());
        data.put("width", body.getWidth());
        data.put("sendOriginalImage", body.isSendOriginalImage());
        data.put("fileSize", body.getFileSize());
        data.put("type", EnumTools.messageBodyTypeToInt(Type.IMAGE));
        return data;
    }

    static EMVideoMessageBody videoBodyFromJson(JSONObject json) throws JSONException {
        String localPath = json.getString("localPath");
        int duration = json.getInt("duration");
        EMVideoMessageBody body = new EMVideoMessageBody(localPath, null, duration, 0);

        if (json.has("thumbnailRemotePath")){
            body.setThumbnailUrl(json.getString("thumbnailRemotePath"));
        }
        if (json.has("thumbnailLocalPath")) {
            body.setLocalThumb(json.getString("thumbnailLocalPath"));
        }
        if (json.has("thumbnailSecret")){
            body.setThumbnailSecret(json.getString("thumbnailSecret"));
        }
        if (json.has("displayName")){
            body.setFileName(json.getString("displayName"));
        }
        if (json.has("remotePath")){
            body.setRemoteUrl(json.getString("remotePath"));
        }
        if (json.has("secret")){
            body.setSecret(json.getString("secret"));
        }
        if (json.has("fileSize")){
            body.setVideoFileLength(json.getInt("fileSize"));
        }

        if(json.has("fileStatus")){
            body.setDownloadStatus(EnumTools.downloadStatusFromInt(json.getInt("fileStatus")));
        }

        if (json.has("width") && json.has("height")){
            int width = json.getInt("width");
            int height = json.getInt("height");
            body.setThumbnailSize(width, height);
        }


        return body;
    }

    static Map<String, Object> videoBodyToJson(EMVideoMessageBody body) {
        Map<String, Object> data = getParentMap(body);
        data.put("localPath", body.getLocalUrl());
        data.put("thumbnailLocalPath", body.getLocalThumb());
        data.put("duration", body.getDuration());
        data.put("thumbnailRemotePath", body.getThumbnailUrl());
        data.put("thumbnailSecret", body.getThumbnailSecret());
        data.put("thumbnailStatus", EnumTools.downloadStatusToInt(body.thumbnailDownloadStatus()));
        data.put("displayName", body.getFileName());
        data.put("height", body.getThumbnailHeight());
        data.put("width", body.getThumbnailWidth());
        data.put("remotePath", body.getRemoteUrl());
        data.put("fileStatus", EnumTools.downloadStatusToInt(body.downloadStatus()));
        data.put("secret", body.getSecret());
        data.put("fileSize", body.getVideoFileLength());
        data.put("type", EnumTools.messageBodyTypeToInt(Type.VIDEO));

        return data;
    }

    static EMVoiceMessageBody voiceBodyFromJson(JSONObject json) throws JSONException {
        String localPath = json.getString("localPath");
        File file = new File(localPath);
        int duration = json.getInt("duration");
        EMVoiceMessageBody body = new EMVoiceMessageBody(file, duration);
        body.setDownloadStatus(EnumTools.downloadStatusFromInt(json.getInt("fileStatus")));
        if (json.has("displayName")){
            body.setFileName(json.getString("displayName"));
        }
        if (json.has("secret")){
            body.setSecret(json.getString("secret"));
        }
        if (json.has("remotePath")){
            body.setRemoteUrl(json.getString("remotePath"));
        }
        if (json.has("fileSize")){
            body.setFileLength(json.getLong("fileSize"));
        }

        return body;
    }

    static Map<String, Object> voiceBodyToJson(EMVoiceMessageBody body) {
        Map<String, Object> data = getParentMap(body);
        data.put("localPath", body.getLocalUrl());
        data.put("duration", body.getLength());
        data.put("displayName", body.getFileName());
        data.put("remotePath", body.getRemoteUrl());
        data.put("fileStatus", EnumTools.downloadStatusToInt(body.downloadStatus()));
        data.put("secret", body.getSecret());
        data.put("type", EnumTools.messageBodyTypeToInt(Type.VOICE));
        data.put("fileSize", body.getFileSize());
        return data;
    }
}

class ConversationHelper {

    static Map<String, Object> toJson(EMConversation conversation) {
        Map<String, Object> data = new HashMap<>();
        data.put("convId", conversation.conversationId());
        data.put("type", EnumTools.conversationTypeToInt(conversation.getType()));
        data.put("isPinned", conversation.isPinned());
        data.put("pinnedTime", conversation.getPinnedTime());
        return data;
    }
}

class CursorResultHelper {

    static Map<String, Object> toJson(EMCursorResult result) {
        Map<String, Object> data = new HashMap<>();
        data.put("cursor", result.getCursor());
        List<Object> jsonList = new ArrayList<>();
        if (result.getData() != null){
            List list = (List) result.getData();
            for (Object obj : list) {
                if (obj instanceof EMMessage) {
                    jsonList.add(MessageHelper.toJson((EMMessage) obj));
                }


                if (obj instanceof EMChatRoom) {
                    jsonList.add(ChatRoomHelper.toJson((EMChatRoom) obj));
                }


                if (obj instanceof String) {
                    jsonList.add(obj);
                }

                if (obj instanceof EMConversation) {
                    jsonList.add(ConversationHelper.toJson((EMConversation) obj));
                }

            }
        }
        data.put("list", jsonList);

        return data;
    }
}

class PageResultHelper {

    static Map<String, Object> toJson(EMPageResult result) {
        Map<String, Object> data = new HashMap<>();
        data.put("count", result.getPageCount());
        List<Map> jsonList = new ArrayList<>();
        if (result.getData() != null){
            List list = (List) result.getData();
            for (Object obj : list) {
                if (obj instanceof EMMessage) {
                    jsonList.add(MessageHelper.toJson((EMMessage) obj));
                }

                if (obj instanceof EMChatRoom) {
                    jsonList.add(ChatRoomHelper.toJson((EMChatRoom) obj));
                }
            }
        }
        data.put("list", jsonList);
        return data;
    }
}

class ErrorHelper {
    static Map<String, Object> toJson(int errorCode, String desc) {
        Map<String, Object> data = new HashMap<>();
        data.put("code", errorCode);
        data.put("description", desc);
        return data;
    }
}

class HyphenateExceptionHelper {
    static Map<String, Object> toJson(HyphenateException e) {
        Map<String, Object> data = new HashMap<>();
        data.put("code", e.getErrorCode());
        data.put("description", e.getDescription());
        return data;
    }
}

class FetchHistoryOptionsHelper {
    static EMFetchMessageOption fromJson(JSONObject json) throws JSONException {
        EMFetchMessageOption options = new EMFetchMessageOption();
        EMConversation.EMSearchDirection direction = EnumTools.searchDirectionFromInt(json.optInt("direction"));
        options.setDirection(direction);
        options.setIsSave(json.getBoolean("needSave"));
        options.setStartTime(json.getLong("startTs"));
        options.setEndTime(json.getLong("endTs"));
        if (json.has("from")){
            options.setFrom(json.getString("from"));
        }
        if (json.has("msgTypes")){
            List<EMMessage.Type> list = new ArrayList<>();
            JSONArray array = json.getJSONArray("msgTypes");
            for (int i = 0; i < array.length(); i++) {
                Type type = EnumTools.messageBodyTypeFromInt(array.getInt(i));
                list.add(type);
            }
            if (list.size() > 0) {
                options.setMsgTypes(list);
            }
        }

        return options;
    }
}

