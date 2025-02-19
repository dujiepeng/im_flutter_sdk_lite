import '../internal/inner_headers.dart';

/// ~english
/// The EMOptions class, which contains the settings of the Chat SDK.
///
/// For example, whether to encrypt the messages before sending and whether to automatically accept the friend invitations.
/// ~end
///
/// ~chinese
/// 提供 SDK 聊天相关的设置。
/// 用户可以用来配置 SDK 的各种参数、选项，
/// 比如，发送消息加密，是否自动接受加好友邀请。
/// ~end
class EMOptions {
  /// ~english
  /// The app key that you get from the console when creating the app.
  /// ~end
  ///
  /// ~chinese
  /// 创建 app 时在 console 后台上注册的 app 唯一识别符。
  /// ~end
  final String? appKey;

  /// ~english
  /// Whether to enable automatic login.
  ///
  /// - (Default) `true`: Yes;
  /// - `false`: No.
  /// ~end
  ///
  /// ~chinese
  /// 是否允许自动登录。
  ///
  /// - (默认) `true`：允许;
  /// - `false`：不允许.
  /// ~end
  final bool autoLogin;

  /// ~english
  /// Whether to output the debug information. Make sure to call the method after initializing the EMClient using [EMClient.init].
  ///
  /// - `true`: Yes.
  /// - (Default) `false`: No.
  /// ~end
  ///
  /// ~chinese
  /// 是否输出调试信息，在 EMClient 初始化完成后调用，详见 [EMClient.init]。
  /// - `true`：SDK 会在 log 里输出调试信息；
  /// - （默认）`false`：不会输出调试信息。
  /// ~end
  final bool debugMode;

  /// ~english
  /// Whether to require read receipt after sending a message.
  ///
  /// - (Default) `true`: Yes;
  /// - `false`: No.
  /// ~end
  ///
  /// ~chinese
  /// 是否发送消息已读回执.
  /// - （默认）`true`：是；
  /// - `false`：否。
  /// ~end
  final bool requireAck;

  /// ~english
  /// Whether to require the delivery receipt after sending a message.
  ///
  /// - `true`: Yes;
  /// - (Default) `false`: No.
  /// ~end
  ///
  /// ~chinese
  ///   /// 是否发送消息已送达回执。
  /// - `true`：是。
  /// - （默认）`false`：否。
  /// ~end
  final bool requireDeliveryAck;

  /// ~english
  /// Whether to delete the chat room messages when leaving the chat room.
  ///
  /// - (Default) `true`: Yes;
  /// - `false`: No.
  /// ~end
  ///
  /// ~chinese
  /// 离开聊天室时是否删除消息。
  ///
  /// - （默认）`true`：是；
  /// - `false`：否。
  /// ~end
  final bool deleteMessagesAsExitChatRoom;

  /// ~english
  /// Whether to allow the chat room owner to leave the chat room.
  ///
  /// - (Default) `true`: Yes;
  /// - `false`: No.
  /// ~end
  ///
  /// ~chinese
  /// 是否允许聊天室所有者离开聊天室。
  ///
  /// - （默认）`true`：是；
  /// - `false`：否。
  /// ~end
  final bool isChatRoomOwnerLeaveAllowed;

  /// ~english
  /// Whether to sort the messages by the time when the messages are received by the server.
  ///
  /// - (Default) `true`: Yes;
  /// - `false`: No.
  /// ~end
  ///
  /// ~chinese
  /// 是否根据服务器收到消息的时间对消息进行排序。
  ///
  /// - （默认）`true`：是；
  /// - `false`：否。
  /// ~end
  final bool sortMessageByServerTime;

  /// ~english
  /// Whether only HTTPS is used for REST operations.
  ///
  /// - (Default) `true`: Only HTTPS is used.
  /// - `false`: Both HTTP and HTTPS are allowed.
  /// ~end
  ///
  /// ~chinese
  /// 是否只用 HTTPS。
  ///
  /// - （默认）`true`：是；
  /// - `false`：否。可以同时用 HTTP 和 HTTPS。
  /// ~end
  final bool usingHttpsOnly;

  /// ~english
  /// Whether to upload the message attachments automatically to the chat server.
  ///
  /// - (Default) `true`:  Yes;
  /// - `false`: No. Message attachments are uploaded to a custom path.
  /// ~end
  ///
  /// ~chinese
  /// 是否自动将消息附件上传到聊天服务器。
  ///
  /// - （默认）`true`：是；
  /// - `false`：否。使用自定义路径。
  /// ~end
  final bool serverTransfer;

  /// ~english
  /// Whether to automatically download the thumbnail.
  ///
  /// - (Default) `true`: Yes;
  /// - `false`: No.
  /// ~end
  ///
  /// ~chinese
  /// 是否自动下载缩略图。
  ///
  /// - （默认）`true`：是；
  /// - `false`：否。
  /// ~end
  final bool isAutoDownloadThumbnail;

  /// ~english
  /// Whether to enable DNS.
  ///
  /// - (Default) `true`: Yes;
  /// - `false`: No.
  /// ~end
  ///
  /// ~chinese
  /// 是否开启 DNS。
  ///
  /// - （默认）`true`：是；
  /// - `false`：否。
  /// ~end
  final bool enableDNSConfig;

  /// ~english
  /// The DNS URL.
  /// ~end
  ///
  /// ~chinese
  /// DNS 地址。
  /// ~end
  final String? dnsUrl;

  /// ~english
  /// The custom REST server.
  /// ~end
  ///
  /// ~chinese
  /// REST 服务器。
  /// ~end
  final String? restServer;

  /// ~english
  /// The custom IM message server url.
  /// ~end
  ///
  /// ~chinese
  /// 消息服务器。
  /// ~end
  final String? imServer;

  /// ~english
  /// The custom IM server port.
  /// ~end
  ///
  /// ~chinese
  /// 是否使用自定义 IM 服务的端口。用于私有化部署。
  /// ~end
  final int? imPort;

  /// ~english
  /// Whether to include empty conversations when the SDK loads conversations from the local database:
  /// - `true`: Yes;
  /// - (Default) `false`: No.
  /// ~end
  ///
  /// ~chinese
  /// 从本地数据库加载会话时是否包括空会话。
  /// - `true`：包含空会话；
  /// - （默认）`false`：不包含空会话。
  /// ~end
  final bool enableEmptyConversation;

  EMOptions({
    this.appKey,
    this.autoLogin = true,
    this.debugMode = false,
    this.requireAck = true,
    this.requireDeliveryAck = false,
    this.deleteMessagesAsExitChatRoom = true,
    this.isChatRoomOwnerLeaveAllowed = true,
    this.sortMessageByServerTime = true,
    this.usingHttpsOnly = true,
    this.serverTransfer = true,
    this.isAutoDownloadThumbnail = true,
    this.enableDNSConfig = true,
    this.dnsUrl,
    this.restServer,
    this.imPort,
    this.imServer,
    this.enableEmptyConversation = false,
  });

  Map toJson() {
    Map data = new Map();
    data.putIfNotNull("appKey", appKey);
    data.putIfNotNull("autoLogin", autoLogin);
    data.putIfNotNull("debugModel", debugMode);
    data.putIfNotNull(
        "deleteMessagesAsExitChatRoom", deleteMessagesAsExitChatRoom);
    data.putIfNotNull("dnsUrl", dnsUrl);
    data.putIfNotNull("enableDNSConfig", enableDNSConfig);
    data.putIfNotNull("imPort", imPort);
    data.putIfNotNull("imServer", imServer);
    data.putIfNotNull("isAutoDownload", isAutoDownloadThumbnail);
    data.putIfNotNull(
        "isChatRoomOwnerLeaveAllowed", isChatRoomOwnerLeaveAllowed);
    data.putIfNotNull("requireAck", requireAck);
    data.putIfNotNull("requireDeliveryAck", requireDeliveryAck);
    data.putIfNotNull("restServer", restServer);
    data.putIfNotNull("serverTransfer", serverTransfer);
    data.putIfNotNull("sortMessageByServerTime", sortMessageByServerTime);
    data.putIfNotNull("usingHttpsOnly", usingHttpsOnly);
    data.putIfNotNull('loadEmptyConversations', enableEmptyConversation);

    data["usingHttpsOnly"] = this.usingHttpsOnly;

    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }

  EMOptions copyWith({
    bool? usingHttpsOnly,
    bool? deleteMessageWhenLeaveRoom,
    bool? deleteMessagesWhenLeaveGroup,
    bool? roomOwnerCanLeave,
    bool? autoAcceptGroupInvitation,
    bool? acceptInvitationAlways,
    bool? autoDownloadThumbnail,
    bool? requireDeliveryAck,
    bool? requireAck,
    bool? sortMessageByServerTime,
    bool? messagesReceiveCallbackIncludeSend,
    bool? regardImportMessagesAsRead,
  }) {
    return EMOptions(
      appKey: appKey,
      autoLogin: autoLogin,
      debugMode: debugMode,
      requireAck: requireAck ?? this.requireAck,
      requireDeliveryAck: requireDeliveryAck ?? this.requireDeliveryAck,
      deleteMessagesAsExitChatRoom:
          deleteMessageWhenLeaveRoom ?? this.deleteMessagesAsExitChatRoom,
      isChatRoomOwnerLeaveAllowed:
          roomOwnerCanLeave ?? this.isChatRoomOwnerLeaveAllowed,
      sortMessageByServerTime:
          sortMessageByServerTime ?? this.sortMessageByServerTime,
      usingHttpsOnly: usingHttpsOnly ?? this.usingHttpsOnly,
      serverTransfer: serverTransfer,
      isAutoDownloadThumbnail:
          autoDownloadThumbnail ?? this.isAutoDownloadThumbnail,
      enableDNSConfig: enableDNSConfig,
      dnsUrl: dnsUrl,
      restServer: restServer,
      imPort: imPort,
      imServer: imServer,
      enableEmptyConversation: enableEmptyConversation,
    );
  }
}
