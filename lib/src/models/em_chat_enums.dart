/// ~english
/// The conversation types.
/// ~end
///
/// ~chinese
/// 会话类型枚举。
/// ~end
enum EMConversationType {
  /// ~english
  /// One-to-one chat.
  /// ~end
  ///
  /// ~chinese
  /// 单聊。
  /// ~end
  Chat,

  /// ~english
  /// Group chat.
  /// ~end
  ///
  /// ~chinese
  /// 群聊。
  /// ~end
  GroupChat,

  /// ~english
  /// Chat room.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室。
  /// ~end
  ChatRoom,
}

/// ~english
/// The chat types.
///
/// There are three chat types: one-to-one chat, group chat, and chat room.
/// ~end
///
/// ~chinese
/// 会话类型枚举。
/// ~end
enum ChatType {
  /// ~english
  /// One-to-one chat.
  /// ~end
  ///
  /// ~chinese
  ///  单聊。
  /// ~end
  Chat,

  /// ~english
  /// Group chat.
  /// ~end
  ///
  /// ~chinese
  /// 群聊。
  /// ~end
  GroupChat,

  /// ~english
  /// Chat room.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室。
  /// ~end
  ChatRoom,
}

/// ~english
/// The message directions.
///
/// Whether the message is sent or received.
/// ~end
///
/// ~chinese
/// 消息的方向类型枚举类。
///
/// 区分是发送消息还是接收到的消息。
/// ~end
enum MessageDirection {
  /// ~english
  /// This message is sent from the local user.
  /// ~end
  ///
  /// ~chinese
  /// 该消息是当前用户发送出去的。
  /// ~end
  SEND,

  /// ~english
  /// The message is received by the local user.
  /// ~end
  ///
  /// ~chinese
  /// 该消息是当前用户接收到的。
  /// ~end
  RECEIVE,
}

/// ~english
/// The message sending/reception status.
/// ~end
///
/// ~chinese
/// 消息的发送/接收状态枚举类。
/// ~end
enum MessageStatus {
  /// ~english
  /// The message is created.
  /// ~end
  ///
  /// ~chinese
  /// 消息已创建待发送。
  /// ~end
  CREATE,

  /// ~english
  /// The message is being delivered/received.
  /// ~end
  ///
  /// ~chinese
  /// 正在发送/接收。
  /// ~end
  PROGRESS,

  /// ~english
  /// The message is successfully delivered/received.
  /// ~end
  ///
  /// ~chinese
  /// 发送/接收成功。
  /// ~end
  SUCCESS,

  /// ~english
  /// The message fails to be delivered/received.
  /// ~end
  ///
  /// ~chinese
  /// 发送/接收失败。
  /// ~end
  FAIL,
}

/// ~english
/// The download status of the attachment file.
/// ~end
///
/// ~chinese
/// 消息附件的下载状态。
/// ~end
enum DownloadStatus {
  /// ~english
  /// The file message is being downloaded.
  /// ~end
  ///
  /// ~chinese
  /// 正在下载。
  /// ~end
  DOWNLOADING,

  /// ~english
  /// The file message download succeeds.
  /// ~end
  ///
  /// ~chinese
  /// 下载成功。
  /// ~end
  SUCCESS,

  /// ~english
  /// The file message download fails.
  /// ~end
  ///
  /// ~chinese
  /// 下载失败。
  /// ~end
  FAILED,

  /// ~english
  /// The file message download is pending.
  /// ~end
  ///
  /// ~chinese
  /// 等待下载。
  /// ~end
  PENDING,
}

/// ~english
/// The message types.
/// ~end
///
/// ~chinese
/// 消息类型枚举。
/// ~end
enum MessageType {
  /// ~english
  /// The text message.
  /// ~end
  ///
  /// ~chinese
  /// 文本消息。
  /// ~end
  TXT,

  /// ~english
  /// The image message.
  /// ~end
  ///
  /// ~chinese
  /// 图片消息。
  /// ~end
  IMAGE,

  /// ~english
  /// The video message.
  /// ~end
  ///
  /// ~chinese
  /// 视频消息。
  /// ~end
  VIDEO,

  /// ~english
  /// The location message.
  /// ~end
  ///
  /// ~chinese
  /// 位置消息。
  /// ~end
  LOCATION,

  /// ~english
  /// The voice message.
  /// ~end
  ///
  /// ~chinese
  /// 语音消息。
  /// ~end
  VOICE,

  /// ~english
  /// The file message.
  /// ~end
  ///
  /// ~chinese
  /// 文件消息。
  /// ~end
  FILE,

  /// ~english
  /// The command message.
  /// ~end
  ///
  /// ~chinese
  /// 命令消息。
  /// ~end
  CMD,

  /// ~english
  /// The custom message.
  /// ~end
  ///
  /// ~chinese
  /// 自定义消息。
  /// ~end
  CUSTOM,
}

/// ~english
/// The chat room roles.
/// ~end
///
/// ~chinese
/// 聊天室角色类型枚举。
/// ~end
enum EMChatRoomPermissionType {
  /// ~english
  /// Unknown.
  /// ~end
  ///
  /// ~chinese
  /// 未知类型。
  /// ~end
  None,

  /// ~english
  /// The regular chat room member.
  /// ~end
  ///
  /// ~chinese
  /// 普通成员。
  /// ~end
  Member,

  /// ~english
  /// The chat room admin.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室管理员。
  /// ~end
  Admin,

  /// ~english
  /// The chat room owner.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室所有者。
  /// ~end
  Owner,
}

/// ~english
/// The message search directions.
/// ~end
///
/// ~chinese
/// 消息检索方向类型枚举。
/// ~end
enum EMSearchDirection {
  /// ~english
  /// Messages are retrieved in the reverse chronological order of when the server receives the message.
  /// ~end
  ///
  /// ~chinese
  /// 按消息中的时间戳的倒序搜索。
  /// ~end
  Up,

  /// ~english
  /// Messages are retrieved in the chronological order of when the server receives the message.
  /// ~end
  ///
  /// ~chinese
  /// 按消息中的时间戳的顺序搜索。
  /// ~end
  Down,
}

/// ~english
/// Chat room message priorities.
/// ~end
///
/// ~chinese
/// 聊天室消息优先级。
/// ~end
enum ChatRoomMessagePriority {
  /// ~english
  /// High
  /// ~end
  ///
  /// ~chinese
  /// 高
  /// ~end
  High,

  /// ~english
  /// Normal
  /// ~end
  ///
  /// ~chinese
  /// 中
  /// ~end
  Normal,

  /// ~english
  /// Low
  /// ~end
  ///
  /// ~chinese
  /// 低
  /// ~end
  Low,
}

/// ~english
/// Leave chat room reason
/// ~end
/// ~chinese
/// 离开聊天室原因
/// ~end

enum LeaveReason {
  ///
  /// ~english
  /// Kicked out
  /// ~end
  /// ~chinese
  /// 被移除
  /// ~end
  Kicked,

  /// ~english
  /// offline
  /// ~end
  /// ~chinese
  /// 离线
  /// ~end
  Offline,
}
