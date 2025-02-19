package com.easemob.im_flutter_sdk;

public class MethodKey {
    /// EMClient methods
    static final String init = "init";
    static final String createAccount = "createAccount";
    static final String login = "login";
    static final String renewToken = "renewToken";
    static final String logout = "logout";

    static final String uploadLog = "uploadLog";
    static final String compressLogs = "compressLogs";

    static final String getToken = "getToken";
    static final String getCurrentUser = "getCurrentUser";
    static final String isLoggedInBefore = "isLoggedInBefore";
    static final String isConnected = "isConnected";

    static final String onConnected = "onConnected";
    static final String onDisconnected = "onDisconnected";
    static final String onUserDidLoginFromOtherDevice = "onUserDidLoginFromOtherDevice";
    static final String onUserDidRemoveFromServer = "onUserDidRemoveFromServer";
    static final String onUserDidForbidByServer = "onUserDidForbidByServer";
    static final String onUserDidChangePassword = "onUserDidChangePassword";
    static final String onUserDidLoginTooManyDevice = "onUserDidLoginTooManyDevice";
    static final String onUserKickedByOtherDevice = "onUserKickedByOtherDevice";
    static final String onUserAuthenticationFailed = "onUserAuthenticationFailed";
    static final String onSendDataToFlutter = "onSendDataToFlutter";
    static final String onTokenWillExpire = "onTokenWillExpire";
    static final String onTokenDidExpire = "onTokenDidExpire";
    static final String onAppActiveNumberReachLimit = "onAppActiveNumberReachLimit";

    /// EMChatManager methods
    static final String sendMessage = "sendMessage";
    static final String ackMessageRead = "ackMessageRead";
    static final String ackConversationRead = "ackConversationRead";
    static final String recallMessage = "recallMessage";
    static final String downloadAttachment = "downloadAttachment";
    static final String downloadThumbnail = "downloadThumbnail";

    static final String fetchHistoryMessagesByOptions = "fetchHistoryMessagesByOptions";
    static final String deleteRemoteConversation = "deleteRemoteConversation";
    static final String removeMessagesFromServerWithTs = "removeMessagesFromServerWithTs";

    static final String getConversationsFromServerWithCursor = "getConversationsFromServerWithCursor";
    static final String getPinnedConversationsFromServerWithCursor = "getPinnedConversationsFromServerWithCursor";
    static final String pinConversation = "pinConversation";

    /// EMChatManager listener
    static final String onMessagesReceived = "onMessagesReceived";
    static final String onCmdMessagesReceived = "onCmdMessagesReceived";
    static final String onMessagesRead = "onMessagesRead";
    static final String onMessagesDelivered = "onMessagesDelivered";
    static final String onMessagesRecalled = "onMessagesRecalled";

    static final String onConversationUpdate = "onConversationUpdate";
    static final String onConversationHasRead = "onConversationHasRead";

    /// EMMessage listener
    static final String onMessageProgressUpdate = "onMessageProgressUpdate";
    static final String onMessageError = "onMessageError";
    static final String onMessageSuccess = "onMessageSuccess";
    static final String onMessageReadAck = "onMessageReadAck";
    static final String onMessageDeliveryAck = "onMessageDeliveryAck";

    /// EMConversation method
    static final String getLatestMessage = "getLatestMessage";
    static final String getLatestMessageFromOthers = "getLatestMessageFromOthers";

    /// EMChatRoomManager methods
    static final String joinChatRoom = "joinChatRoom";
    static final String leaveChatRoom = "leaveChatRoom";
    static final String fetchPublicChatRoomsFromServer = "fetchPublicChatRoomsFromServer";
    static final String fetchChatRoomInfoFromServer = "fetchChatRoomInfoFromServer";
    static final String getChatRoom = "getChatRoom";
    static final String getAllChatRooms = "getAllChatRooms";

    static final String fetchChatRoomMembers = "fetchChatRoomMembers";
    static final String fetchChatRoomAnnouncement = "fetchChatRoomAnnouncement";

    /// EMChatRoomManagerListener
    static final String chatRoomChange = "onChatRoomChanged";

    /// HandleAction
    static final String startCallback = "startCallback";

    static final String conversationDeleteServerMessageWithTime = "conversationDeleteServerMessageWithTime";
    static final String updateUsingHttpsOnlySetting = "updateUsingHttpsOnlySetting";
    static final String updateDeleteMessageWhenLeaveRoomSetting = "updateDeleteMessageWhenLeaveRoomSetting";
    static final String updateRoomOwnerCanLeaveSetting = "updateRoomOwnerCanLeaveSetting";
    static final String updateAutoDownloadAttachmentThumbnailSetting = "updateAutoDownloadAttachmentThumbnailSetting";
    static final String updateRequireAckSetting = "updateRequireAckSetting";
    static final String updateDeliveryAckSetting = "updateDeliveryAckSetting";
    static final String updateSortMessageByServerTimeSetting = "updateSortMessageByServerTimeSetting";
}
