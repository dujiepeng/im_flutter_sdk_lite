class ChatMethodKeys {
  /// EMClient methods
  static const String init = "init";

  static const String createAccount = "createAccount";
  static const String login = "login";
  static const String renewToken = "renewToken";
  static const String logout = "logout";

  static const String uploadLog = "uploadLog";
  static const String compressLogs = "compressLogs";

  static const String getToken = "getToken";
  static const String getCurrentUser = "getCurrentUser";
  static const String isLoggedInBefore = "isLoggedInBefore";
  static const String isConnected = "isConnected";

  /// EMClient listener
  static const String onConnected = "onConnected";
  static const String onDisconnected = "onDisconnected";
  static const String onUserDidLoginFromOtherDevice =
      "onUserDidLoginFromOtherDevice";
  static const String onUserDidRemoveFromServer = "onUserDidRemoveFromServer";
  static const String onUserDidForbidByServer = "onUserDidForbidByServer";
  static const String onUserDidChangePassword = "onUserDidChangePassword";
  static const String onUserDidLoginTooManyDevice =
      "onUserDidLoginTooManyDevice";
  static const String onUserKickedByOtherDevice = "onUserKickedByOtherDevice";
  static const String onUserAuthenticationFailed = "onUserAuthenticationFailed";

  static const String onSendDataToFlutter = "onSendDataToFlutter";
  static const String onTokenWillExpire = "onTokenWillExpire";
  static const String onTokenDidExpire = "onTokenDidExpire";
  static const String onAppActiveNumberReachLimit =
      'onAppActiveNumberReachLimit';

  /// EMChatManager methods
  static const String sendMessage = "sendMessage";
  static const String ackMessageRead = "ackMessageRead";
  static const String ackConversationRead = "ackConversationRead";
  static const String recallMessage = "recallMessage";
  static const String downloadAttachment = "downloadAttachment";
  static const String downloadThumbnail = "downloadThumbnail";

  static const String fetchHistoryMessagesByOptions = "fetchHistoryMessagesByOptions";
  static const String deleteRemoteConversation = "deleteRemoteConversation";
  static const String removeMessagesFromServerWithTs = "removeMessagesFromServerWithTs";

  static const String getConversationsFromServerWithCursor = 'getConversationsFromServerWithCursor';
  static const String getPinnedConversationsFromServerWithCursor = 'getPinnedConversationsFromServerWithCursor';
  static const String pinConversation = 'pinConversation';
  
  /// EMChatManager listener
  static const String onMessagesReceived = "onMessagesReceived";
  static const String onCmdMessagesReceived = "onCmdMessagesReceived";
  static const String onMessagesRead = "onMessagesRead";
  static const String onMessagesDelivered = "onMessagesDelivered";
  static const String onMessagesRecalled = "onMessagesRecalled";

  static const String onConversationUpdate = "onConversationUpdate";
  static const String onConversationHasRead = "onConversationHasRead";

  /// EMMessage listener
  static const String onMessageProgressUpdate = "onMessageProgressUpdate";
  static const String onMessageError = "onMessageError";
  static const String onMessageSuccess = "onMessageSuccess";
  static const String onMessageReadAck = "onMessageReadAck";
  static const String onMessageDeliveryAck = "onMessageDeliveryAck";

  /// EMConversation method
  static const String getLatestMessage = "getLatestMessage";
  static const String getLatestMessageFromOthers = "getLatestMessageFromOthers";

  /// EMChatRoomManager methods
  static const String joinChatRoom = "joinChatRoom";
  static const String leaveChatRoom = "leaveChatRoom";
  static const String fetchPublicChatRoomsFromServer = "fetchPublicChatRoomsFromServer";
  static const String fetchChatRoomInfoFromServer = "fetchChatRoomInfoFromServer";
  static const String getChatRoom = "getChatRoom";
  static const String getAllChatRooms = "getAllChatRooms";

  static const String fetchChatRoomMembers = "fetchChatRoomMembers";

  static const String fetchChatRoomAnnouncement = "fetchChatRoomAnnouncement";
  /// EMChatRoomManagerListener
  static const String chatRoomChange = "onChatRoomChanged";

  /// HandleAction
  static const String startCallback = "startCallback";

  static const String conversationDeleteServerMessageWithTime = 'conversationDeleteServerMessageWithTime';
  static const String updateUsingHttpsOnlySetting = 'updateUsingHttpsOnlySetting';
  
  static const String updateDeleteMessageWhenLeaveRoomSetting = 'updateDeleteMessageWhenLeaveRoomSetting';
  static const String updateRoomOwnerCanLeaveSetting = 'updateRoomOwnerCanLeaveSetting';

  static const String updateAutoDownloadAttachmentThumbnailSetting = 'updateAutoDownloadAttachmentThumbnailSetting';
  static const String updateRequireAckSetting = 'updateRequireAckSetting';
  static const String updateDeliveryAckSetting = 'updateDeliveryAckSetting';
  static const String updateSortMessageByServerTimeSetting = 'updateSortMessageByServerTimeSetting';

}
