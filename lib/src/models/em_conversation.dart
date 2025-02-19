import 'dart:core';
import 'package:flutter/services.dart';

import '../internal/inner_headers.dart';

/// ~english
/// The conversation class, indicating a one-to-one chat, a group chat, or a conversation chat. It contains the messages that are sent and received within the conversation.
///
/// The following code shows how to get the number of the unread messages from the conversation.
/// ```dart
///   // ConversationId can be the other party id, the group id, or the chat room id.
///   EMConversation? con = await EMClient.getInstance.chatManager.getConversation(conversationId);
///   int? unreadCount = con?.unreadCount;
/// ```
/// ~end
///
/// ~chinese
/// 会话类，用于定义单聊会话、群聊会话和聊天室会话。每类会话中包含发送和接收的消息。
///
/// 以下示例代码展示如何从会话中获取未读消息数：
/// ```dart
///   // The `ConversationId` can be the other party ID, the group ID, or the chat room ID.
///   EMConversation? con = await EMClient.getInstance.chatManager.getConversation(conversationId);
///   int? unreadCount = con?.unreadCount;
/// ```
/// ~end
class EMConversation {
  EMConversation._private(
    this.id,
    this.type,
    this.isPinned,
    this.pinnedTime,
  );

  factory EMConversation.fromJson(Map<String, dynamic> map) {
    EMConversation ret = EMConversation._private(
      map["convId"],
      EMConversationType.values[map["type"]],
      map["isPinned"] ?? false,
      map["pinnedTime"] ?? 0,
    );

    return ret;
  }

  Map<String, dynamic> _toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["type"] = this.type.index;
    data["convId"] = this.id;

    return data;
  }

  /// ~english
  /// The conversation ID.
  ///
  /// For one-to-one chat，the conversation ID is the username of the other party.
  /// For group chat, the conversation ID is the group ID, not the group name.
  /// For chat room, the conversation ID is the chat room ID, not the chat room name.
  /// For help desk, the conversation ID is the username of the other party.
  /// ~end
  ///
  /// ~chinese
  /// 获取会话 ID。
  ///
  /// 对于单聊类型，会话 ID 同时也是对方用户的名称。
  /// 对于群聊类型，会话 ID 同时也是群组的 ID，并不同于群组的名称。
  /// 对于聊天室类型，会话 ID 同时也是聊天室的 ID，并不同于聊天室的名称。
  /// 对于 HelpDesk 类型，会话 ID 与单聊类型相同，是对方用户的名称。
  ///
  /// **Return** 会话 ID。
  /// ~end
  final String id;

  /// ~english
  /// The conversation type.
  /// ~end
  ///
  /// ~chinese
  /// 会话类型。
  /// ~end
  final EMConversationType type;

  /// ~english
  /// Whether the conversation is pinned:
  /// - `true`: Yes;
  /// - `false`: No.
  /// ~end
  ///
  /// ~chinese
  /// 是否为置顶会话：
  /// - `true`：是；
  /// - `false`：否。
  /// ~end
  final bool isPinned;

  /// ~english
  ///  The UNIX timestamp when the conversation is pinned. The unit is millisecond. This value is `0` when the conversation is not pinned.
  /// ~end
  ///
  /// ~chinese
  /// 会话置顶的 UNIX 时间戳，单位为毫秒。未置顶时值为 `0`。
  /// ~end
  final int pinnedTime;

  static const MethodChannel _emConversationChannel =
      const MethodChannel('com.chat.im/chat_conversation', JSONMethodCodec());

  /// ~english
  /// Gets the last message from the conversation.
  ///
  /// The operation does not affect the unread message count.
  ///
  /// The SDK gets the latest message from the local memory first. If no message is found, the SDK loads the message from the local database and then puts it in the memory.
  ///
  /// **Return** The message instance.
  /// ~end
  ///
  /// ~chinese
  /// 获取会话的最新一条消息。
  ///
  /// 不影响未读数统计。
  ///
  /// 会先从缓存中获取，如果没有则从本地数据库获取后存入缓存。
  ///
  /// **Return** 消息体实例。
  /// ~end
  Future<EMMessage?> latestMessage() async {
    Map req = this._toJson();
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.getLatestMessage, req);
    try {
      EMError.hasErrorFromResult(result);
      if (result.containsKey(ChatMethodKeys.getLatestMessage)) {
        return EMMessage.fromJson(result[ChatMethodKeys.getLatestMessage]);
      } else {
        return null;
      }
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Gets the latest message from the conversation.
  ///
  /// **Return** The message instance.
  /// ~end
  ///
  /// ~chinese
  /// 获取最近收到的一条消息。
  ///
  /// **Return** 消息体实例。
  /// ~end
  Future<EMMessage?> lastReceivedMessage() async {
    Map req = this._toJson();
    Map result = await _emConversationChannel.invokeMethod(
        ChatMethodKeys.getLatestMessageFromOthers, req);
    try {
      EMError.hasErrorFromResult(result);
      if (result.containsKey(ChatMethodKeys.getLatestMessageFromOthers)) {
        return EMMessage.fromJson(
            result[ChatMethodKeys.getLatestMessageFromOthers]);
      } else {
        return null;
      }
    } on EMError catch (e) {
      throw e;
    }
  }
}
