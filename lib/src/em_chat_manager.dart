// ignore_for_file: deprecated_member_use_from_same_package

import "dart:async";

import 'package:flutter/services.dart';
import 'internal/inner_headers.dart';
import 'models/fetch_message_options.dart';

/// ~english
/// The chat manager class, responsible for sending and receiving messages, loading and deleting conversations, and downloading attachments.
///
/// The sample code for sending a text message:
///
/// ```dart
///    EMMessage msg = EMMessage.createTxtSendMessage(
///        username: toChatUsername, content: content);
///    await EMClient.getInstance.chatManager.sendMessage(msg);
/// ```
/// ~end
///
/// ~chinese
/// 聊天管理类，该类负责管理会话（加载，删除等）、发送消息、下载消息附件等。
///
/// 比如，发送一条文本消息：
///
/// ```dart
///    EMMessage msg = EMMessage.createTxtSendMessage(
///        targetId: toChatUsername, content: content);
///    await EMClient.getInstance.chatManager.sendMessage(msg);
/// ```
/// ~end
class EMChatManager {
  final Map<String, EMChatEventHandler> _eventHandlesMap = {};

  EMChatManager() {
    ChatChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == ChatMethodKeys.onMessagesReceived) {
        return _onMessagesReceived(call.arguments);
      } else if (call.method == ChatMethodKeys.onCmdMessagesReceived) {
        return _onCmdMessagesReceived(call.arguments);
      } else if (call.method == ChatMethodKeys.onMessagesRead) {
        return _onMessagesRead(call.arguments);
      } else if (call.method == ChatMethodKeys.onMessagesDelivered) {
        return _onMessagesDelivered(call.arguments);
      } else if (call.method == ChatMethodKeys.onMessagesRecalled) {
        return _onMessagesRecalled(call.arguments);
      } else if (call.method == ChatMethodKeys.onConversationUpdate) {
        return _onConversationsUpdate(call.arguments);
      } else if (call.method == ChatMethodKeys.onConversationHasRead) {
        return _onConversationHasRead(call.arguments);
      }
      return null;
    });
  }

  /// ~english
  /// Adds the chat event handler. After calling this method, you can handle for chat event when they arrive.
  ///
  /// Param [identifier] The custom handler identifier, is used to find the corresponding handler.
  ///
  /// Param [handler] The handler for chat event. See [EMChatEventHandler].
  /// ~end
  ///
  /// ~chinese
  /// 添加事件监听。
  ///
  /// Param [identifier] 事件监听对应的 ID。
  ///
  /// Param [handler] 事件监听. 请见 [EMChatEventHandler].
  /// ~end
  void addEventHandler(
    String identifier,
    EMChatEventHandler handler,
  ) {
    _eventHandlesMap[identifier] = handler;
  }

  /// ~english
  /// Remove the chat event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  /// ~end
  ///
  /// ~chinese
  /// 移除事件监听。
  ///
  /// Param [identifier] 要移除监听对应的 ID。
  /// ~end
  void removeEventHandler(String identifier) {
    _eventHandlesMap.remove(identifier);
  }

  /// ~english
  /// Get the chat event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  /// **Return** The chat event handler.
  /// ~end
  ///
  /// ~chinese
  /// 获取事件监听。
  ///
  /// Param [identifier] 要获取监听对应的 ID。
  ///
  /// **Return** 事件监听。
  /// ~end
  EMChatEventHandler? getEventHandler(String identifier) {
    return _eventHandlesMap[identifier];
  }

  /// ~english
  /// Clear all chat event handlers.
  /// ~end
  ///
  /// ~chinese
  /// 清除所有事件监听。
  /// ~end
  void clearEventHandlers() {
    _eventHandlesMap.clear();
  }

  /// ~english
  /// Sends a message.
  ///
  /// **Note**
  /// For attachment messages such as voice, image, or video messages, the SDK automatically uploads the attachment.
  /// You can set whether to upload the attachment to the chat sever using [EMOptions.serverTransfer].
  ///
  /// To listen for the status of sending messages, call [EMChatManager.addMessageEvent].
  ///
  /// Param [message] The message object to be sent: [EMMessage].
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 发消息
  ///
  /// **Note**
  /// 对于语音、图片、视频等附件消息，SDK会自动上传附件。
  /// 可以使用 [EMOptions.serverTransfer] 设置是否将附件上传到聊天服务器。
  ///
  /// 添加发送状态监听使用 [EMChatManager.addMessageEvent].
  ///
  /// Param [message] 需要发送的消息 [EMMessage].
  ///
  /// **Throws** 如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<EMMessage> sendMessage(EMMessage message) async {
    message.status = MessageStatus.PROGRESS;
    Map result = await ChatChannel.invokeMethod(
        ChatMethodKeys.sendMessage, message.toJson());
    try {
      EMError.hasErrorFromResult(result);
      EMMessage msg = EMMessage.fromJson(result[ChatMethodKeys.sendMessage]);
      message.from = msg.from;
      message.to = msg.to;
      message.status = msg.status;
      return message;
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Sends the read receipt to the server.
  ///
  /// This method applies to one-to-one chats only.
  ///
  /// **Warning**
  /// This method only takes effect if you set [EMOptions.requireAck] as `true`.
  ///
  /// **Note**
  /// To send the group message read receipt, call [sendGroupMessageReadAck].
  ///
  /// We recommend that you call [sendConversationReadAck] when entering a chat page, and call this method to reduce the number of method calls.
  ///
  /// Param [message] The message body: [EMMessage].
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 发送消息的已读回执，该方法只针对单聊会话。
  ///
  /// **Warning**
  /// 该方法只有在 [EMOptions.requireAck] 为 `true` 时才生效。
  ///
  /// **Note**
  /// 群消息已读回执，详见 [sendGroupMessageReadAck]。
  ///
  /// 推荐进入会话页面时调用 [sendConversationReadAck]，其他情况下调用该方法以减少调用频率。
  ///
  /// Param [message] 需要发送已读回执的消息。
  ///
  /// **Throws** 如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<bool> sendMessageReadAck(EMMessage message) async {
    Map req = {"to": message.from, "msg_id": message.msgId};
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.ackMessageRead, req);
    try {
      EMError.hasErrorFromResult(result);
      return result.boolValue(ChatMethodKeys.ackMessageRead);
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Sends the conversation read receipt to the server. This method is only for one-to-one chat conversations.
  ///
  /// This method informs the server to set the unread message count of the conversation to 0. In multi-device scenarios, all the devices receive the [EMChatEventHandler.onConversationRead] callback.
  ///
  /// **Note**
  /// This method applies to one-to-one chat conversations only. To send a group message read receipt, call [sendGroupMessageReadAck].
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 发送会话的已读回执，该方法只针对单聊会话。
  ///
  /// 该方法会通知服务器将此会话未读数设置为 0，对话方（包含多端多设备）将会在下面这个回调方法中接收到回调：
  /// [EMChatEventHandler.onConversationRead]。
  ///
  /// **Note**
  /// 发送群组消息已读回执见 [sendGroupMessageReadAck]。
  ///
  /// Param [conversationId] 会话 ID。
  ///
  /// **Throws** 如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<void> sendConversationReadAck(String conversationId) async {
    Map req = {"convId": conversationId};
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.ackConversationRead, req);
    try {
      EMError.hasErrorFromResult(result);
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Recalls the sent message.
  ///
  /// Param [messageId] The message ID.
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 撤回发送成功的消息。
  ///
  /// Param [messageId] 消息 ID。
  ///
  /// **Throws** 如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<void> recallMessage(String messageId, {String? ext}) async {
    Map req = {
      "msg_id": messageId,
    };
    req.putIfNotNull('ext', ext);
    Map result =
        await ChatChannel.invokeMethod(ChatMethodKeys.recallMessage, req);
    try {
      EMError.hasErrorFromResult(result);
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Downloads the attachment files from the server.
  ///
  /// You can call the method again if the attachment download fails.
  ///
  /// Param [message] The message with the attachment that is to be downloaded.
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 下载消息的附件。
  ///
  /// 若附件自动下载失败，也可以调用此方法下载。
  ///
  /// Param [message] 要下载附件的消息。
  ///
  /// **Throws**  如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<void> downloadAttachment(EMMessage message) async {
    Map result = await ChatChannel.invokeMethod(
        ChatMethodKeys.downloadAttachment, {"message": message.toJson()});
    try {
      EMError.hasErrorFromResult(result);
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Downloads the thumbnail if the message has not been downloaded before or if the download fails.
  ///
  /// Param [message] The message object.
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 下载消息的缩略图。
  ///
  /// Param [message] 要下载缩略图的消息，一般图片消息和视频消息有缩略图。
  ///
  /// **Throws**  如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<void> downloadThumbnail(EMMessage message) async {
    Map result = await ChatChannel.invokeMethod(
        ChatMethodKeys.downloadThumbnail, {"message": message.toJson()});
    try {
      EMError.hasErrorFromResult(result);
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Get the list of conversations from the server with pagination.
  ///
  /// The SDK retrieves the list of conversations in the reverse chronological order of their active time (the timestamp of the last message).
  /// If there is no message in the conversation, the SDK retrieves the list of conversations in the reverse chronological order of their creation time.
  ///
  /// Param [cursor] The position from which to start getting data. The SDK retrieves conversations from the latest active one if this parameter is not set.
  ///
  /// Param [pageSize] The number of conversations that you expect to get on each page. The value range is [1,50].
  ///
  /// **Return** The conversation list of the current user.
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 从服务器分页获取会话列表。
  ///
  /// SDK 按照会话活跃时间（会话的最后一条消息的时间戳）倒序返回会话列表。
  /// 若会话中没有消息，则 SDK 按照会话创建时间的倒序返回会话列表。
  ///
  /// Param [cursor] 查询的开始位置，如不传， SDK 从最新活跃的会话开始获取。
  ///
  /// Param [pageSize] 每页期望返回的会话数量。取值范围为 [1,50]。
  ///
  /// **Return** 当前用户的会话列表。
  ///
  /// **Throws**  如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<EMCursorResult<EMConversation>> fetchConversation({
    String? cursor,
    int pageSize = 20,
  }) async {
    Map map = {
      "pageSize": pageSize,
    };
    map.putIfNotNull('cursor', cursor);
    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.getConversationsFromServerWithCursor,
      map,
    );
    try {
      EMError.hasErrorFromResult(result);
      return EMCursorResult.fromJson(
          result[ChatMethodKeys.getConversationsFromServerWithCursor],
          dataItemCallback: (map) {
        return EMConversation.fromJson(map);
      });
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Unidirectionally removes historical message by timestamp from the server.
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// Param [type] The conversation type.
  ///
  /// Param [timestamp] The UNIX timestamp in millisecond. Messages with a timestamp smaller than the specified one will be removed.
  /// ~end
  ///
  /// ~chinese
  /// 根据时间 单向删除服务器会话中的消息和本地消息。
  /// Param [conversationId] 会话 ID。
  ///
  /// Param [type] 会话类型。
  ///
  /// Param [timestamp] 以毫秒为单位的UNIX时间戳。时间戳小于指定时间戳的消息将被删除。
  /// ~end
  Future<void> deleteRemoteMessagesBefore(
      {required String conversationId,
      required EMConversationType type,
      required int timestamp}) async {
    Map request = {
      "convId": conversationId,
      "type": type.index,
      "timestamp": timestamp,
    };
    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.removeMessagesFromServerWithTs,
      request,
    );
    try {
      EMError.hasErrorFromResult(result);
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Gets historical messages of a conversation from the server according to [FetchMessageOptions].
  ///
  /// Param [conversationId] The conversation ID, which is the user ID of the peer user for one-to-one chat, but the group ID for group chat.
  ///
  /// Param [type] The conversation type. See [EMConversationType].
  ///
  /// Param [options] The parameter configuration class for pulling historical messages from the server. See [FetchMessageOptions].
  ///
  /// Param [cursor] The cursor position from which to start querying data.
  ///
  /// Param [pageSize] The number of messages that you expect to get on each page. The value range is [1,50].
  /// ~end
  ///
  /// ~chinese
  /// 根据 [FetchMessageOptions] 从服务器分页获取指定会话的历史消息。
  ///
  /// Param [conversationId] 会话 ID。
  ///
  /// Param [type] 会话类型，详见 [EMConversationType]
  ///
  /// Param [options] 查询历史消息的参数配置接口，详见 [FetchMessageOptions]。
  ///
  /// Param [cursor] 查询的起始游标位置。
  ///
  /// Param [pageSize] 每页期望获取的消息条数。取值范围为 [1,50]。
  /// ~end
  Future<EMCursorResult<EMMessage>> fetchHistoryMessagesByOption(
    String conversationId,
    EMConversationType type, {
    FetchMessageOptions? options,
    String? cursor,
    int pageSize = 50,
  }) async {
    Map req = Map();
    req.putIfNotNull('convId', conversationId);
    req.putIfNotNull('type', type.index);
    req.putIfNotNull('pageSize', pageSize);
    req.putIfNotNull('cursor', cursor);
    req.putIfNotNull('options', options?.toJson());
    Map result = await ChatChannel.invokeMethod(
        ChatMethodKeys.fetchHistoryMessagesByOptions, req);
    try {
      EMError.hasErrorFromResult(result);
      return EMCursorResult<EMMessage>.fromJson(
          result[ChatMethodKeys.fetchHistoryMessagesByOptions],
          dataItemCallback: (value) {
        return EMMessage.fromJson(value);
      });
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Deletes the specified conversation and the related historical messages from the server.
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// Param [conversationType] The conversation type. See  [EMConversationType].
  ///
  /// Param [isDeleteMessage] Whether to delete the chat history when deleting the conversation.
  /// - (default) `true`: Yes.
  /// - `false`: No.
  ///
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 删除服务端的指定 ID 的会话和聊天记录。
  ///
  /// Param [conversationId] 会话 ID。
  ///
  /// Param [conversationType] 会话类型，详见 [EMConversationType]。
  ///
  /// Param [isDeleteMessage] 删除会话时是否同时删除历史消息记录。
  ///
  /// - （默认）`true`：是；
  /// - `false`：否。
  ///
  /// **Throws**  如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<void> deleteRemoteConversation(
    String conversationId, {
    EMConversationType conversationType = EMConversationType.Chat,
    bool isDeleteMessage = true,
  }) async {
    Map req = {};
    req["conversationId"] = conversationId;
    if (conversationType == EMConversationType.Chat) {
      req["conversationType"] = 0;
    } else if (conversationType == EMConversationType.GroupChat) {
      req["conversationType"] = 1;
    } else {
      req["conversationType"] = 2;
    }
    req["isDeleteRemoteMessage"] = isDeleteMessage;

    Map data = await ChatChannel.invokeMethod(
        ChatMethodKeys.deleteRemoteConversation, req);
    try {
      EMError.hasErrorFromResult(data);
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Gets the list of pinned conversations from the server with pagination.
  ///
  /// The SDK returns the pinned conversations in the reverse chronological order of their pinning.
  ///
  /// Param [cursor] The position from which to start getting data. If this parameter is not set, the SDK retrieves conversations from the latest pinned one.
  ///
  /// Param [pageSize] The number of conversations that you expect to get on each page. The value range is [1,50].
  ///
  /// **Return** The pinned conversation list of the current user.
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 分页从服务器获取置顶会话。
  ///
  /// SDK 按照会话的置顶时间的倒序返回会话列表。
  ///
  /// Param [cursor] 查询的开始位置，如不传， SDK 从最新置顶的会话开始查询。
  ///
  /// Param [pageSize] 每页期望返回的会话数量。取值范围为 [1,50]。
  ///
  /// **Return** 当前用户的置顶会话列表。
  ///
  /// **Throws**  如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<EMCursorResult<EMConversation>> fetchPinnedConversations({
    String? cursor,
    int pageSize = 20,
  }) async {
    Map map = {
      "pageSize": pageSize,
    };
    map.putIfNotNull('cursor', cursor);
    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.getPinnedConversationsFromServerWithCursor,
      map,
    );
    try {
      EMError.hasErrorFromResult(result);
      return EMCursorResult.fromJson(
          result[ChatMethodKeys.getPinnedConversationsFromServerWithCursor],
          dataItemCallback: (map) {
        return EMConversation.fromJson(map);
      });
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Sets whether to pin a conversation.
  ///
  /// Param [conversationId] The conversation ID.
  ///
  /// Param [isPinned]  Whether to pin a conversation:
  /// - true: Pin the conversation.
  /// - false: Unpin the conversation.
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 设置是否置顶会话。
  ///
  /// Param [conversationId] 会话 ID。
  ///
  /// Param [isPinned] 是否置顶会话：
  /// - true: 置顶会话。
  /// - false: 取消置顶会话。
  ///
  /// **Throws**  如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<void> pinConversation(
      {required String conversationId, required bool isPinned}) async {
    Map map = {
      'convId': conversationId,
      'isPinned': isPinned,
    };

    Map result = await ChatChannel.invokeMethod(
      ChatMethodKeys.pinConversation,
      map,
    );
    try {
      EMError.hasErrorFromResult(result);
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Adds a message status listener.
  ///
  /// Param [identifier] The ID of the message status listener. The ID is required when you delete a message status listener.
  ///
  /// Param [event] The message status event.
  /// ~end
  ///
  /// ~chinese
  /// 添加消息状态监听。
  ///
  /// Param [identifier] 消息状态监听 ID, 删除监听时需提供。
  ///
  /// Param [event] 消息状态事件。
  /// ~end
  void addMessageEvent(String identifier, ChatMessageEvent event) {
    MessageCallBackManager.getInstance.addMessageEvent(identifier, event);
  }

  /// ~english
  /// Removes a message status listener.
  ///
  /// Param [identifier] The ID of the message status listener. The ID is set when you add a message status listener.
  /// ~end
  ///
  /// ~chinese
  /// 移除消息状态监听。
  ///
  /// Param [identifier] 消息状态监听 ID, 在添加时设置。
  /// ~end
  void removeMessageEvent(String identifier) {
    MessageCallBackManager.getInstance.removeMessageEvent(identifier);
  }

  /// ~english
  /// Clears all message status listeners.
  /// ~end
  ///
  /// ~chinese
  /// 清空所有消息状态监听。
  /// ~end
  void clearMessageEvent() {
    MessageCallBackManager.getInstance.clearAllMessageEvents();
  }

  Future<void> _onMessagesReceived(List messages) async {
    List<EMMessage> messageList = [];
    for (var message in messages) {
      messageList.add(EMMessage.fromJson(message));
    }

    for (var item in _eventHandlesMap.values) {
      item.onMessagesReceived?.call(messageList);
    }
  }

  Future<void> _onCmdMessagesReceived(List messages) async {
    List<EMMessage> list = [];
    for (var message in messages) {
      list.add(EMMessage.fromJson(message));
    }

    for (var item in _eventHandlesMap.values) {
      item.onCmdMessagesReceived?.call(list);
    }
  }

  Future<void> _onMessagesRead(List messages) async {
    List<EMMessage> list = [];
    for (var message in messages) {
      list.add(EMMessage.fromJson(message));
    }

    for (var item in _eventHandlesMap.values) {
      item.onMessagesRead?.call(list);
    }
  }

  Future<void> _onMessagesDelivered(List messages) async {
    List<EMMessage> list = [];
    for (var message in messages) {
      list.add(EMMessage.fromJson(message));
    }

    for (var item in _eventHandlesMap.values) {
      item.onMessagesDelivered?.call(list);
    }
  }

  Future<void> _onMessagesRecalled(List messages) async {
    List<EMMessage> list = [];
    for (var message in messages) {
      list.add(EMMessage.fromJson(message));
    }

    for (var item in _eventHandlesMap.values) {
      item.onMessagesRecalled?.call(list);
    }
  }

  Future<void> _onConversationsUpdate(dynamic obj) async {
    for (var item in _eventHandlesMap.values) {
      item.onConversationsUpdate?.call();
    }
  }

  Future<void> _onConversationHasRead(dynamic obj) async {
    String from = (obj as Map)['from'];
    String to = obj['to'];

    for (var item in _eventHandlesMap.values) {
      item.onConversationRead?.call(from, to);
    }
  }
}

/// ~english
/// The message status event class.
/// During message delivery, the message ID will be changed from a local uuid to a global unique ID that is generated by the server to uniquely identify a message on all devices using the SDK.
/// This API should be implemented in the chat page widget to listen for message status changes.
/// ~end
///
/// ~chinese
/// 消息状态事件类。
/// ~end
class ChatMessageEvent {
  ChatMessageEvent({
    this.onSuccess,
    this.onError,
    this.onProgress,
  });

  /// ~english
  /// Occurs when a message is successfully sent or downloaded.
  ///
  /// Param [msgId] The pre-sending message ID or the ID of the message that is successfully downloaded.
  ///
  /// Param [msg] The message that is successfully sent or downloaded.
  /// ~end
  ///
  /// ~chinese
  /// 消息发送或下载成功回调。
  /// ~end
  final void Function(String msgId, EMMessage msg)? onSuccess;

  /// ~english
  /// Occurs when a message fails to be sent or downloaded.
  ///
  /// Param [msgId] The pre-sending message ID or the ID of the message that fails to be downloaded.
  ///
  /// Param [msg] The message that fails to be sent or downloaded.
  /// ~end
  ///
  /// ~chinese
  /// 消息发送或下载失败回调。
  ///
  /// Param [msgId] 发送前或下载失败的消息 ID。
  ///
  /// Param [msg] 发送或下载失败的消息。
  /// ~end
  final void Function(String msgId, EMMessage msg, EMError error)? onError;

  /// ~english
  /// Occurs when there is a progress for message upload or download. This event is triggered when a message is being uploaded or downloaded.
  ///
  /// Param [msgId] The ID of the message that is being uploaded or downloaded.
  ///
  /// Param [progress] The upload or download progress.
  /// ~end
  ///
  /// ~chinese
  /// 消息上传或下载进度的回调。
  ///
  /// Param [msgId] 正在上传或下载的消息的 ID。
  ///
  /// Param [progress] 上传或下载进度。
  /// ~end
  final void Function(String msgId, int progress)? onProgress;
}

class MessageCallBackManager {
  static const _channelPrefix = 'com.chat.im';
  static const MethodChannel _emMessageChannel =
      const MethodChannel('$_channelPrefix/chat_message', JSONMethodCodec());
  Map<String, ChatMessageEvent> cacheHandleMap = {};
  static MessageCallBackManager? _instance;
  static MessageCallBackManager get getInstance =>
      _instance = _instance ?? MessageCallBackManager._internal();

  MessageCallBackManager._internal() {
    _emMessageChannel.setMethodCallHandler((MethodCall call) async {
      Map<String, dynamic> argMap = call.arguments;
      String? localId = argMap['localId'];
      if (localId == null) return;
      cacheHandleMap.forEach((key, value) {
        if (call.method == ChatMethodKeys.onMessageProgressUpdate) {
          int progress = argMap["progress"];
          value.onProgress?.call(localId, progress);
        } else if (call.method == ChatMethodKeys.onMessageError) {
          EMMessage msg = EMMessage.fromJson(argMap['message']);
          EMError err = EMError.fromJson(argMap['error']);
          value.onError?.call(localId, msg, err);
        } else if (call.method == ChatMethodKeys.onMessageSuccess) {
          EMMessage msg = EMMessage.fromJson(argMap['message']);
          value.onSuccess?.call(localId, msg);
        }
      });

      return null;
    });
  }

  void addMessageEvent(String key, ChatMessageEvent event) {
    cacheHandleMap[key] = event;
  }

  void removeMessageEvent(String key) {
    if (cacheHandleMap.containsKey(key)) {
      cacheHandleMap.remove(key);
    }
  }

  void clearAllMessageEvents() {
    cacheHandleMap.clear();
  }
}
