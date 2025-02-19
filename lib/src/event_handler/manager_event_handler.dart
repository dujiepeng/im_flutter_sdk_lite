import 'package:flutter/material.dart';

import '../internal/inner_headers.dart';

/// ~english
/// The connection event handler.
///
/// For the occasion of onDisconnected during unstable network condition, you don't need to reconnect manually,
/// the chat SDK will handle it automatically.
///
/// Note: We recommend not to update UI based on those methods, because this method is called on worker thread. If you update UI in those methods, other UI errors might be invoked.
/// Also do not insert heavy computation work here, which might invoke other listeners to handle this connection event.
///
/// Adds connection event handler:
/// ```dart
///   EMClient.getInstance.addConnectionEventHandler(UNIQUE_HANDLER_ID, EMConnectionEventHandler());
/// ```
///
/// Remove a connection event handler:
/// ```dart
///   EMClient.getInstance.removeConnectionEventHandler(UNIQUE_HANDLER_ID);
/// ```
/// ~end
///
/// ~chinese
/// 服务器连接监听类。
///
/// 对于不稳定网络条件下的onDisconnected情况，您不需要手动重新连接，
/// SDK会自动处理。
///
/// 添加 connection event handler:
/// ```dart
///   EMClient.getInstance.addConnectionEventHandler(UNIQUE_HANDLER_ID, EMConnectionEventHandler());
/// ```
///
/// 移除 connection event handler:
/// ```dart
///   EMClient.getInstance.removeConnectionEventHandler(UNIQUE_HANDLER_ID);
/// ```
/// ~end
class EMConnectionEventHandler {
  /// ~english
  /// Occurs when the SDK connects to the chat server successfully.
  /// ~end
  ///
  /// ~chinese
  /// 成功连接到 chat 服务器时触发的回调。
  /// ~end
  final VoidCallback? onConnected;

  /// ~english
  /// Occurs when the SDK disconnects from the chat server.
  ///
  /// Note that the logout may not be performed at the bottom level when the SDK is disconnected.
  /// ~end
  ///
  /// ~chinese
  /// 与 chat 服务器断开连接时触发的回调。
  /// ~end
  final VoidCallback? onDisconnected;

  /// ~english
  /// Occurs when the current user account is logged in to another device.
  /// ~end
  ///
  /// ~chinese
  /// 其他设备登录回调。
  /// ~end
  final void Function(String info)? onUserDidLoginFromOtherDevice;

  /// ~english
  /// Occurs when the current chat user is removed from the server.
  /// ~end
  ///
  /// ~chinese
  /// 当前用户被服务器移除回调。
  /// ~end
  final VoidCallback? onUserDidRemoveFromServer;

  /// ~english
  /// Occurs when the current chat user is banned from accessing the server.
  /// ~end
  ///
  /// ~chinese
  /// 被服务器禁止连接回调。
  /// ~end
  final VoidCallback? onUserDidForbidByServer;

  /// ~english
  /// Occurs when the current chat user changed the password.
  /// ~end
  ///
  /// ~chinese
  /// 用户密码变更回调。
  /// ~end
  final VoidCallback? onUserDidChangePassword;

  /// ~english
  /// Occurs when the current chat user logged to many devices.
  /// ~end
  ///
  /// ~chinese
  /// 登录设备过多回调。
  /// ~end
  final VoidCallback? onUserDidLoginTooManyDevice;

  /// ~english
  /// Occurs when the current chat user is kicked out of the app by another device.
  /// ~end
  ///
  /// ~chinese
  /// 被其他设备踢掉回调。
  /// ~end
  final VoidCallback? onUserKickedByOtherDevice;

  /// ~english
  /// Occurs when the current chat user authentication failed.
  /// ~end
  ///
  /// ~chinese
  /// 鉴权失败回调。
  /// ~end
  final VoidCallback? onUserAuthenticationFailed;

  /// ~english
  /// Occurs when the token is about to expire.
  /// ~end
  ///
  /// ~chinese
  /// token 即将过期时触发。
  /// ~end
  final VoidCallback? onTokenWillExpire;

  /// ~english
  /// Occurs when the token has expired.
  /// ~end
  ///
  /// ~chinese
  /// token 已过期时触发。
  /// ~end
  final VoidCallback? onTokenDidExpire;

  /// ~english
  ///  The number of daily active users (DAU) or monthly active users (MAU) for the app has reached the upper limit.
  /// ~end
  ///
  /// ~chinese
  /// 应用程序的日活跃用户数量（DAU）或月活跃用户数量（MAU）达到上限。
  /// ~end
  final VoidCallback? onAppActiveNumberReachLimit;

  /// ~english
  /// The chat connection listener callback.
  ///
  /// Param [onConnected] The SDK connects to the chat server successfully.
  ///
  /// Param [onDisconnected] The SDK disconnects from the chat server.
  ///
  /// Param [onUserDidLoginFromOtherDevice] The current user account is logged in to another device.
  ///
  /// Param [onUserDidRemoveFromServer] The current chat user is removed from the server.
  ///
  /// Param [onUserDidForbidByServer] The current chat user is banned by the server.
  ///
  /// Param [onUserDidChangePassword] The current chat user is changed password.
  ///
  /// Param [onUserDidLoginTooManyDevice] The current chat user logged in to many devices.
  ///
  /// Param [onUserKickedByOtherDevice] The current chat user is kicked by another device.
  ///
  /// Param [onUserAuthenticationFailed] The authentication for the chat user failed.
  ///
  /// Param [onTokenWillExpire] The token is about to expire.
  ///
  /// Param [onTokenDidExpire] The token has expired.
  ///
  /// Param [onAppActiveNumberReachLimit] The number of daily active users (DAU) or monthly active users (MAU) for the app has reached the upper limit.
  ///
  /// ~end
  ///
  /// ~chinese
  /// 连接状态监听。
  ///
  /// Param [onConnected] 成功连接到 chat 服务器时触发的回调。
  ///
  /// Param [onDisconnected] 和 chat 服务器断开连接时触发的回调。
  ///
  /// Param [onUserDidLoginFromOtherDevice] 其他设备登录回调。
  ///
  /// Param [onUserDidRemoveFromServer] 被服务器移除回调。
  ///
  /// Param [onUserDidForbidByServer] 被服务器禁止连接回调。
  ///
  /// Param [onUserDidChangePassword] 用户密码变更回调。
  ///
  /// Param [onUserDidLoginTooManyDevice] 登录设备过多回调。
  ///
  /// Param [onUserKickedByOtherDevice] 被其他设备踢掉回调。
  ///
  /// Param [onUserAuthenticationFailed] 鉴权失败回调。
  ///
  /// Param [onTokenWillExpire] Agora token 即将过期时回调。
  ///
  /// Param [onTokenDidExpire] Agora token 已过期时回调。
  ///
  /// Param [onAppActiveNumberReachLimit] 应用程序的日活跃用户数量（DAU）或月活跃用户数量（MAU）达到上限时回调。
  ///
  /// ~end
  EMConnectionEventHandler({
    this.onConnected,
    this.onDisconnected,
    this.onUserDidLoginFromOtherDevice,
    this.onUserDidRemoveFromServer,
    this.onUserDidForbidByServer,
    this.onUserDidChangePassword,
    this.onUserDidLoginTooManyDevice,
    this.onUserKickedByOtherDevice,
    this.onUserAuthenticationFailed,
    this.onTokenWillExpire,
    this.onTokenDidExpire,
    this.onAppActiveNumberReachLimit,
  });
}

/// ~english
/// The chat event handler.
///
/// This handler is used to check whether messages are received. If messages are sent successfully, a delivery receipt will be returned (delivery receipt needs to be enabled: [EMOptions.requireDeliveryAck].
/// If the peer user reads the received message, a read receipt will be returned (read receipt needs to be enabled: [EMOptions.requireAck]).
/// This API should be implemented in the app to listen for message status changes.
///
/// Adds chat event handler:
/// ```dart
///   EMClient.getInstance.chatManager.addEventHandler(UNIQUE_HANDLER_ID, EMChatEventHandler());
/// ```
///
/// Removes a chat event handler:
/// ```dart
///   EMClient.getInstance.chatManager.removeEventHandler(UNIQUE_HANDLER_ID);
/// ```
/// ~end
///
/// ~chinese
/// Chat 事件监听。
///
/// 用于监听收消息，已读回执，等回调。
///
/// 添加监听：
/// ```dart
///   EMClient.getInstance.chatManager.addEventHandler(UNIQUE_HANDLER_ID, EMChatEventHandler());
/// ```
///
/// 移除监听：
/// ```dart
///   EMClient.getInstance.chatManager.removeEventHandler(UNIQUE_HANDLER_ID);
/// ```
/// ~end
class EMChatEventHandler {
  /// ~english
  /// Occurs when a message is received.
  ///
  /// This callback is triggered to notify the user when a message such as texts or an image, video, voice, location, or file is received.
  /// ~end
  ///
  /// ~chinese
  /// 收到消息回调。
  /// 在收到文本、图片、视频、语音、地理位置和文件等消息时，通过此回调通知用户。
  /// ~end
  final void Function(List<EMMessage> messages)? onMessagesReceived;

  /// ~english
  /// Occurs when a command message is received.
  ///
  /// This callback only contains a command message body that is usually invisible to users.
  /// ~end
  ///
  /// ~chinese
  /// 收到命令消息回调。
  /// 与 [onMessagesReceived] 不同, 这个回调只包含命令的消息，命令消息通常不对用户展示。
  /// ~end
  final void Function(List<EMMessage> messages)? onCmdMessagesReceived;

  /// ~english
  /// Occurs when a read receipt is received for a message.
  /// ~end
  ///
  /// ~chinese
  /// 收到单聊消息已读回执的回调。
  /// ~end
  final void Function(List<EMMessage> messages)? onMessagesRead;

  /// ~english
  /// Occurs when a delivery receipt is received.
  /// ~end
  ///
  /// ~chinese
  /// 收到消息已送达回执的回调。
  /// ~end
  final void Function(List<EMMessage> messages)? onMessagesDelivered;

  @Deprecated('Use [onMessagesRecalledInfo] instead')

  /// ~english
  /// Occurs when a received message is recalled.
  /// ~end
  ///
  /// ~chinese
  /// 已收到的消息被撤回的回调。
  /// ~end
  final void Function(List<EMMessage> messages)? onMessagesRecalled;

  /// ~english
  /// Occurs when the conversation updated.
  /// ~end
  ///
  /// ~chinese
  /// 会话更新事件回调。
  /// ~end
  final VoidCallback? onConversationsUpdate;

  /// ~english
  /// Occurs when a conversation read receipt is received.
  ///
  /// This event is triggered in the following scenarios:
  /// (1) The message is read by the recipient (The conversation read receipt is sent).
  /// Upon receiving this event, the SDK sets the [EMMessage.hasReadAck] property of the message in the conversation to `true` in the local database.
  /// (2) In the multi-device login scenario, when one device sends a conversation read receipt,
  /// the server will set the number of unread messages to 0, and the callback occurs on the other devices.
  /// and the [EMMessage.hasReadAck] property of the message in the conversation is set to `true` in the local database.
  /// ~end
  ///
  /// ~chinese
  /// 收到会话已读回执的回调。
  ///
  /// 回调此方法的场景：
  /// （1）消息被接收方阅读，即接收方发送了会话已读回执。
  /// SDK 在接收到此事件时，会将本地数据库中该会话中消息的 `[EMMessage.hasReadAck]` 属性置为 `true`。
  /// （2）多端多设备登录场景下，一端发送会话已读回执，服务器端会将会话的未读消息数置为 0，
  /// 同时其他端会回调此方法，并将本地数据库中该会话中消息的 `[EMMessage.hasReadAck]` 属性置为 `true`。
  /// ~end
  final void Function(String from, String to)? onConversationRead;

  /// ~english
  /// The chat event handler.
  ///
  /// Param [onMessagesReceived] Occurs when a message is received.
  ///
  /// Param [onCmdMessagesReceived] Occurs when a command message is received.
  ///
  /// Param [onMessagesRead] Occurs when a read receipt is received for a one-to-one message.
  ///
  /// Param [onMessagesDelivered] Occurs when a delivery receipt is received.
  ///
  /// Param [onMessagesRecalled] Occurs when a received message is recalled.
  ///
  /// Param [onConversationsUpdate] Occurs when a conversation is updated.
  ///
  /// Param [onConversationRead] Occurs when a conversation read receipt is received.
  /// ~end
  ///
  /// ~chinese
  /// 消息事件监听。
  ///
  /// Param [onMessagesReceived] 在收到文本、图片、视频、语音、地理位置和文件等消息时，通过此回调通知用户。
  ///
  /// Param [onCmdMessagesReceived] 收到命令消息回调。
  ///
  /// Param [onMessagesRead] 收到单聊消息已读回执的回调。
  ///
  /// Param [onMessagesDelivered] 收到消息已送达回执的回调。
  ///
  /// Param [onMessagesRecalled] 已收到的消息被撤回的回调。
  ///
  /// Param [onConversationsUpdate] 会话更新事件回调。
  ///
  /// Param [onConversationRead] 收到会话已读回执的回调。
  ///
  /// ~end
  EMChatEventHandler({
    this.onMessagesReceived,
    this.onCmdMessagesReceived,
    this.onMessagesRead,
    this.onMessagesDelivered,
    this.onMessagesRecalled,
    this.onConversationsUpdate,
    this.onConversationRead,
  });
}

/// ~english
/// The chat room event handler.
///
/// Adds a chat event handler:
/// ```dart
///   EMClient.getInstance.chatRoomManager.addEventHandler(UNIQUE_HANDLER_ID, EMChatRoomEventHandler());
/// ```
///
/// Removes a chat room event handler:
/// ```dart
///   EMClient.getInstance.chatRoomManager.removeEventHandler(UNIQUE_HANDLER_ID);
/// ```
/// ~end
///
/// ~chinese
/// 聊天室事件监听。
///
/// 添加监听:
/// ```dart
///   EMClient.getInstance.chatRoomManager.addEventHandler(UNIQUE_HANDLER_ID, EMChatRoomEventHandler());
/// ```
///
/// Removes a chat room event handler:
/// ```dart
///   EMClient.getInstance.chatRoomManager.removeEventHandler(UNIQUE_HANDLER_ID);
/// ```
/// ~end
class EMChatRoomEventHandler {
  /// ~english
  /// Occurs when a member is changed to be an admin.
  /// ~end
  ///
  /// ~chinese
  /// 有成员设置为聊天室管理员的回调。
  /// ~end
  final void Function(
    String roomId,
    String admin,
  )? onAdminAddedFromChatRoom;

  /// ~english
  /// Occurs when an admin is removed.
  /// ~end
  ///
  /// ~chinese
  /// 移除聊天室管理员权限的回调。
  /// ~end
  final void Function(
    String roomId,
    String admin,
  )? onAdminRemovedFromChatRoom;

  /// ~english
  /// Occurs when all members in the chat room are muted or unmuted.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室全员禁言状态变化回调。
  /// ~end
  final void Function(
    String roomId,
    bool isAllMuted,
  )? onAllChatRoomMemberMuteStateChanged;

  /// ~english
  /// Occurs when the chat room member(s) is/are added to the allowlist.
  /// ~end
  ///
  /// ~chinese
  /// 有成员被加入聊天室白名单的回调。
  /// ~end
  final void Function(
    String roomId,
    List<String> members,
  )? onAllowListAddedFromChatRoom;

  /// ~english
  /// Occurs when the chat room member(s) is/are removed from the allowlist.
  /// ~end
  ///
  /// ~chinese
  /// 有成员被移出聊天室白名单的回调。
  /// ~end
  final void Function(
    String roomId,
    List<String> members,
  )? onAllowListRemovedFromChatRoom;

  /// ~english
  /// Occurs when the announcement changed.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室公告更新回调。
  /// ~end
  final void Function(
    String roomId,
    String announcement,
  )? onAnnouncementChangedFromChatRoom;

  /// ~english
  /// Occurs when the chat room is destroyed.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室解散的回调。
  /// ~end
  final void Function(
    String roomId,
    String? roomName,
  )? onChatRoomDestroyed;

  /// ~english
  /// Occurs when a member leaves the chat room.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室成员主动退出回调。
  /// ~end
  final void Function(
    String roomId,
    String? roomName,
    String participant,
  )? onMemberExitedFromChatRoom;

  /// ~english
  /// Occurs when a user joins the chat room.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室加入新成员回调。
  /// ~end
  final void Function(String roomId, String participant, String? ext)?
      onMemberJoinedFromChatRoom;

  /// ~english
  /// Occurs when a chat room member(s) is/are added to mute list.
  /// ~end
  ///
  /// ~chinese
  /// 有成员被禁言回调。
  /// ~end
  final void Function(
    String roomId,
    Map<String, int> mutes,
  )? onMuteListAddedFromChatRoom;

  /// ~english
  /// Occurs when the a chat room member(s) is/are removed from mute list.
  /// ~end
  ///
  /// ~chinese
  /// 有成员从禁言列表中移除回调。
  /// ~end
  final void Function(
    String roomId,
    List<String> mutes,
  )? onMuteListRemovedFromChatRoom;

  /// ~english
  /// Occurs when the chat room ownership is transferred.
  /// ~end
  ///
  /// ~chinese
  /// 转移聊天室的所有权的回调。
  /// ~end
  final void Function(
    String roomId,
    String newOwner,
    String oldOwner,
  )? onOwnerChangedFromChatRoom;

  /// ~english
  /// Occurs when a user is removed from a chat room.
  /// ~end
  ///
  /// ~chinese
  /// 当前用户被移出聊天室回调。
  /// ~end
  final void Function(
    String roomId,
    String? roomName,
    String? participant,
    LeaveReason? reason,
  )? onRemovedFromChatRoom;

  /// ~english
  /// Occurs when the chat room specifications changes. All chat room members receive this event.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室详情变更。
  /// ~end
  final void Function(EMChatRoom room)? onSpecificationChanged;

  /// ~english
  /// Occurs when the custom chat room attributes (key-value) are updated.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室属性变更。
  /// ~end
  final void Function(
    String roomId,
    Map<String, String> attributes,
    String from,
  )? onAttributesUpdated;

  /// ~english
  /// Occurs when the custom chat room attributes (key-value) are removed.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室属性被删除。
  /// ~end
  final void Function(
    String roomId,
    List<String> removedKeys,
    String from,
  )? onAttributesRemoved;

  /// ~english
  /// The chat room manager listener callback.
  ///
  /// Param [onAdminAddedFromChatRoom] A member is changed to be an admin.
  ///
  /// Param [onAdminRemovedFromChatRoom] An admin is been removed.
  ///
  /// Param [onAllChatRoomMemberMuteStateChanged] All members in the chat room are muted or unmuted.
  ///
  /// Param [onAllowListAddedFromChatRoom] The chat room member(s) is/are added to the allowlist.
  ///
  /// Param [onAllowListRemovedFromChatRoom] The chat room member(s) is/are removed from the allowlist.
  ///
  /// Param [onAnnouncementChangedFromChatRoom] The announcement is changed.
  ///
  /// Param [onChatRoomDestroyed] The chat room is destroyed.
  ///
  /// Param [onMemberExitedFromChatRoom] A member leaves the chat room.
  ///
  /// Param [onMemberJoinedFromChatRoom] A user joins the chat room.
  ///
  /// Param [onMuteListAddedFromChatRoom] The chat room member(s) is/are added to mute list.
  ///
  /// Param [onMuteListRemovedFromChatRoom] The chat room member(s) is/are removed from mute list.
  ///
  /// Param [onOwnerChangedFromChatRoom] The chat room ownership is transferred.
  ///
  /// Param [onRemovedFromChatRoom] The chat room member(s) is/are removed from the allowlist.
  ///
  /// Param [onSpecificationChanged] The chat room specification changed.
  ///
  /// Param [onAttributesUpdated] The chat room attribute(s) is/are updated.
  ///
  /// Param [onAttributesRemoved] The chat room attribute(s) is/are removed.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室事件监听。
  ///
  /// Param [onAdminAddedFromChatRoom] 有成员设置为聊天室管理员的回调。
  ///
  /// Param [onAdminRemovedFromChatRoom] 移除聊天室管理员权限的回调。
  ///
  /// Param [onAllChatRoomMemberMuteStateChanged] 聊天室全员禁言状态变化回调。
  ///
  /// Param [onAllowListAddedFromChatRoom] 有成员被加入聊天室白名单的回调。
  ///
  /// Param [onAllowListRemovedFromChatRoom] 有成员被移出聊天室白名单的回调。
  ///
  /// Param [onAnnouncementChangedFromChatRoom] 聊天室公告更新回调。
  ///
  /// Param [onChatRoomDestroyed] 聊天室解散的回调。
  ///
  /// Param [onMemberExitedFromChatRoom] 聊天室成员主动退出回调。
  ///
  /// Param [onMemberJoinedFromChatRoom] 聊天室加入新成员回调。
  ///
  /// Param [onMuteListAddedFromChatRoom] 有成员被禁言回调。
  ///
  /// Param [onMuteListRemovedFromChatRoom] 有成员从禁言列表中移除回调。
  ///
  /// Param [onOwnerChangedFromChatRoom] 转移聊天室的所有权的回调。
  ///
  /// Param [onRemovedFromChatRoom] 聊天室成员被移出聊天室回调。
  ///
  /// Param [onSpecificationChanged] 聊天室详情变更。
  ///
  /// Param [onAttributesUpdated] 聊天室属性变更。
  ///
  /// Param [onAttributesRemoved] 聊天室属性被删除。
  /// ~end
  EMChatRoomEventHandler({
    this.onAdminAddedFromChatRoom,
    this.onAdminRemovedFromChatRoom,
    this.onAllChatRoomMemberMuteStateChanged,
    this.onAllowListAddedFromChatRoom,
    this.onAllowListRemovedFromChatRoom,
    this.onAnnouncementChangedFromChatRoom,
    this.onChatRoomDestroyed,
    this.onMemberExitedFromChatRoom,
    this.onMemberJoinedFromChatRoom,
    this.onMuteListAddedFromChatRoom,
    this.onMuteListRemovedFromChatRoom,
    this.onOwnerChangedFromChatRoom,
    this.onRemovedFromChatRoom,
    this.onSpecificationChanged,
    this.onAttributesUpdated,
    this.onAttributesRemoved,
  });
}

/// ~english
/// The message thread event handler, which handles message thread events such as creating or leaving a message thread.
///
/// Adds a message thread event handler:
/// ```dart
///   EMClient.getInstance.chatThreadManager.addEventHandler(UNIQUE_HANDLER_ID, EMChatThreadEventHandler());
/// ```
///
/// Removes a chat event handler:
/// ```dart
/// EMClient.getInstance.chatThreadManager.removeEventHandler(UNIQUE_HANDLER_ID);
/// ```
/// ~end
///
/// ~chinese
/// Thread 事件监听
///
/// 添加监听:
/// ```dart
///   EMClient.getInstance.chatThreadManager.addEventHandler(UNIQUE_HANDLER_ID, EMChatThreadEventHandler());
/// ```
///
/// 移除监听:
/// ```dart
/// EMClient.getInstance.chatThreadManager.removeEventHandler(UNIQUE_HANDLER_ID);
/// ```
/// ~end

