// ignore_for_file: deprecated_member_use_from_same_package

import "dart:async";

import 'package:flutter/services.dart';
import 'internal/inner_headers.dart';

/// ~english
/// The chat room manager class, which manages user joining and exiting the chat room, retrieving the chat room list, and managing member privileges.
/// The sample code for joining a chat room:
/// ```dart
///   try {
///       await EMClient.getInstance.chatRoomManager.joinChatRoom(chatRoomId);
///   } on EMError catch (e) {
///       debugPrint(e.toString());
///   }
/// ```
/// ~end
///
/// ~chinese
///  聊天室管理类，负责聊天室加入和退出、聊天室列表获取以及成员权限管理等。
///  比如，加入聊天室：
///   ```dart
///     try {
///         await EMClient.getInstance.chatRoomManager.joinChatRoom(chatRoomId);
///     } on EMError catch (e) {
///         debugPrint(e.toString());
///     }
///   ```
/// ~end
class EMChatRoomManager {
  static const _channelPrefix = 'com.chat.im';
  static const MethodChannel _channel = const MethodChannel(
      '$_channelPrefix/chat_room_manager', JSONMethodCodec());

  EMChatRoomManager() {
    _channel.setMethodCallHandler((MethodCall call) async {
      Map? argMap = call.arguments;
      if (call.method == ChatMethodKeys.chatRoomChange) {
        return _chatRoomChange(argMap!);
      }
      return null;
    });
  }

  final Map<String, EMChatRoomEventHandler> _eventHandlesMap = {};

  Future<void> _chatRoomChange(Map event) async {
    String? type = event['type'];

    for (var item in _eventHandlesMap.values) {
      switch (type) {
        case EMChatRoomEvent.ON_CHAT_ROOM_DESTROYED:
          String roomId = event['roomId'];
          String? roomName = event['roomName'];
          item.onChatRoomDestroyed?.call(roomId, roomName);
          break;
        case EMChatRoomEvent.ON_MEMBER_JOINED:
          String roomId = event['roomId'];
          String participant = event['participant'];
          String? ext = event['ext'];
          item.onMemberJoinedFromChatRoom?.call(roomId, participant, ext);
          break;
        case EMChatRoomEvent.ON_MEMBER_EXITED:
          String roomId = event['roomId'];
          String? roomName = event['roomName'];
          String participant = event['participant'];
          item.onMemberExitedFromChatRoom?.call(roomId, roomName, participant);
          break;
        case EMChatRoomEvent.ON_REMOVED_FROM_CHAT_ROOM:
          String roomId = event['roomId'];
          String? roomName = event['roomName'];
          String participant = event['participant'];
          LeaveReason? reason;
          int iReason = event['reason'] ?? -1;
          if (iReason == 0) {
            reason = LeaveReason.Kicked;
          } else if (iReason == 2) {
            reason = LeaveReason.Offline;
          }
          item.onRemovedFromChatRoom
              ?.call(roomId, roomName, participant, reason);
          break;
        case EMChatRoomEvent.ON_MUTE_LIST_ADDED:
          String roomId = event['roomId'];
          if (event["mutes"] is Map<String, dynamic>) {
            Map<String, dynamic> mutesDynamic = event["mutes"];
            Map<String, int> mutes = {};
            mutesDynamic.forEach((key, value) {
              if (value is int) {
                mutes[key] = value; // 只添加 int 类型的值
              }
            });
            item.onMuteListAddedFromChatRoom?.call(roomId, mutes);
          }
          break;
        case EMChatRoomEvent.ON_MUTE_LIST_REMOVED:
          String roomId = event['roomId'];
          List<String> mutes = List.from(event['mutes'] ?? []);
          item.onMuteListRemovedFromChatRoom?.call(roomId, mutes);
          break;
        case EMChatRoomEvent.ON_ADMIN_ADDED:
          String roomId = event['roomId'];
          String admin = event['admin'];
          item.onAdminAddedFromChatRoom?.call(roomId, admin);
          break;
        case EMChatRoomEvent.ON_ADMIN_REMOVED:
          String roomId = event['roomId'];
          String admin = event['admin'];
          item.onAdminRemovedFromChatRoom?.call(roomId, admin);
          break;
        case EMChatRoomEvent.ON_OWNER_CHANGED:
          String roomId = event['roomId'];
          String newOwner = event['newOwner'];
          String oldOwner = event['oldOwner'];
          item.onOwnerChangedFromChatRoom?.call(roomId, newOwner, oldOwner);
          break;
        case EMChatRoomEvent.ON_ANNOUNCEMENT_CHANGED:
          String roomId = event['roomId'];
          String announcement = event['announcement'];
          item.onAnnouncementChangedFromChatRoom?.call(roomId, announcement);
          break;
        case EMChatRoomEvent.ON_WHITE_LIST_ADDED:
          String roomId = event['roomId'];
          List<String> members = List.from(event["whitelist"] ?? []);
          item.onAllowListAddedFromChatRoom?.call(roomId, members);
          break;
        case EMChatRoomEvent.ON_WHITE_LIST_REMOVED:
          String roomId = event['roomId'];
          List<String> members = List.from(event["whitelist"] ?? []);
          item.onAllowListRemovedFromChatRoom?.call(roomId, members);
          break;
        case EMChatRoomEvent.ON_ALL_MEMBER_MUTE_STATE_CHANGED:
          String roomId = event['roomId'];
          bool isAllMuted = event['isMuted'];
          item.onAllChatRoomMemberMuteStateChanged?.call(roomId, isAllMuted);
          break;
        case EMChatRoomEvent.ON_SPECIFICATION_CHANGED:
          EMChatRoom room = EMChatRoom.fromJson(event["room"]);
          item.onSpecificationChanged?.call(room);
          break;
        case EMChatRoomEvent.ON_ATTRIBUTES_UPDATED:
          String roomId = event['roomId'];
          Map<String, String> attributes =
              event["attributes"].cast<String, String>();
          String fromId = event["fromId"];
          item.onAttributesUpdated?.call(
            roomId,
            attributes,
            fromId,
          );
          break;
        case EMChatRoomEvent.ON_ATTRIBUTES_REMOVED:
          String roomId = event['roomId'];
          List<String> keys = event["keys"].cast<String>();
          String fromId = event["fromId"];
          item.onAttributesRemoved?.call(
            roomId,
            keys,
            fromId,
          );
          break;
      }
    }
  }

  /// ~english
  /// Adds the room event handler. After calling this method, you can handle for new room event when they arrive.
  ///
  /// Param [identifier] The custom handler identifier, is used to find the corresponding handler.
  ///
  /// Param [handler] The handle for room event. See [EMChatRoomEventHandler].
  /// ~end
  ///
  /// ~chinese
  /// 添加房间事件处理程序。调用此方法后，您可以在新的房间事件到达时处理它们。
  ///
  /// Param [identifier] 自定义聊天室事件 ID，用于查找相应的处理程序。
  ///
  /// Param [handler] 聊天室事件 请参见 [EMChatRoomEventHandler].
  /// ~end
  void addEventHandler(
    String identifier,
    EMChatRoomEventHandler handler,
  ) {
    _eventHandlesMap[identifier] = handler;
  }

  /// ~english
  /// Remove the room event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  /// ~end
  ///
  /// ~chinese
  /// 移除聊天室事件
  ///
  /// Param [identifier] 聊天室事件 ID。
  /// ~end
  void removeEventHandler(String identifier) {
    _eventHandlesMap.remove(identifier);
  }

  /// ~english
  /// Get the room event handler.
  ///
  /// Param [identifier] The custom handler identifier.
  ///
  /// **Return** The room event handler.
  /// ~end
  ///
  /// ~chinese
  /// 获取聊天室事件。
  ///
  /// Param [identifier] 要获取的事件 ID。
  ///
  /// **Return** 聊天室事件。
  /// ~end
  EMChatRoomEventHandler? getEventHandler(String identifier) {
    return _eventHandlesMap[identifier];
  }

  /// ~english
  /// Clear all room event handlers.
  /// ~end
  ///
  /// ~chinese
  /// 清除所有聊天室事件。
  /// ~end
  void clearEventHandlers() {
    _eventHandlesMap.clear();
  }

  /// ~english
  /// Joins the chat room.
  ///
  /// To exit the chat room, call [leaveChatRoom].
  ///
  /// Param [roomId] The ID of the chat room to join.
  ///
  /// Param [leaveOther] Whether to leave all the currently joined chat rooms when joining a chat room.
  ///
  /// Param [ext] The extension information.
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 加入聊天室
  ///
  /// 退出聊天室，调用 [leaveChatRoom].
  ///
  /// Param [roomId] 要加入的聊天室ID。
  ///
  /// Parm [leaveOther] 加入聊天室时候，是否退出已加入的聊天室。
  ///
  /// Param [ext] 扩展信息。
  ///
  /// **Throws** 如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<void> joinChatRoom(
    String roomId, {
    bool leaveOther = true,
    String? ext,
  }) async {
    Map req = {
      "roomId": roomId,
      "leaveOtherRooms": leaveOther,
    };
    req.putIfNotNull("ext", ext);

    Map result = await _channel.invokeMethod(ChatMethodKeys.joinChatRoom, req);
    try {
      EMError.hasErrorFromResult(result);
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Leaves the chat room.
  ///
  /// Param [roomId] The ID of the chat room to leave.
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 离开聊天室。
  ///
  /// Param [roomId] 聊天室 ID。
  ///
  /// **Throws** 如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<void> leaveChatRoom(String roomId) async {
    Map result = await _channel
        .invokeMethod(ChatMethodKeys.leaveChatRoom, {"roomId": roomId});
    try {
      EMError.hasErrorFromResult(result);
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Gets chat room data from the server with pagination.
  ///
  /// Param [pageNum] The page number, starting from 1.
  ///
  /// Param [pageSize] The number of records per page.
  ///
  /// **Return** Chat room data. See [EMPageResult].
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 以分页的方式从服务器获取聊天室数据。
  ///
  /// Param [pageNum] 当前页码，从 1 开始。
  ///
  /// Param [pageSize] 每页返回的记录数。
  ///
  /// **Return** 分页获取结果，详见 [EMPageResult]。
  ///
  /// **Throws** 如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<EMPageResult<EMChatRoom>> fetchPublicChatRoomsFromServer({
    int pageNum = 1,
    int pageSize = 200,
  }) async {
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.fetchPublicChatRoomsFromServer,
        {"pageNum": pageNum, "pageSize": pageSize});
    try {
      EMError.hasErrorFromResult(result);
      return EMPageResult<EMChatRoom>.fromJson(
          result[ChatMethodKeys.fetchPublicChatRoomsFromServer],
          dataItemCallback: (map) {
        return EMChatRoom.fromJson(map);
      });
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Gets the details of the chat room from the server.
  /// By default, the details do not include the chat room member list.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// **Return** The chat room instance.
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 从服务器获取聊天室详情，默认不取成员列表。
  ///
  /// Param [roomId] 聊天室 ID。
  ///
  /// **Return** 返回聊天室对象。
  ///
  /// **Throws** 如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<EMChatRoom> fetchChatRoomInfoFromServer(
    String roomId, {
    bool fetchMembers = false,
  }) async {
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.fetchChatRoomInfoFromServer,
        {"roomId": roomId, "fetchMembers": fetchMembers});
    try {
      EMError.hasErrorFromResult(result);
      return EMChatRoom.fromJson(
          result[ChatMethodKeys.fetchChatRoomInfoFromServer]);
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Gets the chat room in the cache.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// **Return** The chat room instance. Returns null if the chat room is not found in the cache.
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 从内存中获取聊天室。
  ///
  /// Param [roomId] 聊天室 ID。
  ///
  /// **Return** 返回聊天室对象。如果内存中不存在聊天室对象，返回 null。
  ///
  /// **Throws** 如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<EMChatRoom?> getChatRoomWithId(String roomId) async {
    Map result = await _channel
        .invokeMethod(ChatMethodKeys.getChatRoom, {"roomId": roomId});
    try {
      EMError.hasErrorFromResult(result);
      if (result.containsKey(ChatMethodKeys.getChatRoom)) {
        return EMChatRoom.fromJson(result[ChatMethodKeys.getChatRoom]);
      } else {
        return null;
      }
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Gets the chat room member list.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// Param [cursor] The cursor position from which to start getting data.
  ///
  /// Param [pageSize] The number of members per page.
  ///
  /// **Return** The list of chat room members. See [EMCursorResult]. If [EMCursorResult.cursor] is an empty string (""), all data is fetched.
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 获取聊天室成员列表。
  ///
  /// 返回的结果中，当 EMCursorResult.cursor 为空字符串 ("") 时，表示没有更多数据。
  ///
  /// Param [roomId] 聊天室 ID。
  ///
  /// Param [cursor] 从这个游标位置开始取数据。
  ///
  /// Param [pageSize] 每页返回的成员数。
  ///
  /// **Return** 分页获取结果 [EMCursorResult]。
  ///
  /// **Throws** 如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<EMCursorResult<String>> fetchChatRoomMembers(
    String roomId, {
    String? cursor,
    int pageSize = 200,
  }) async {
    Map req = {"roomId": roomId, "pageSize": pageSize};
    req.putIfNotNull("cursor", cursor);
    Map result =
        await _channel.invokeMethod(ChatMethodKeys.fetchChatRoomMembers, req);
    try {
      EMError.hasErrorFromResult(result);
      return EMCursorResult<String>.fromJson(
          result[ChatMethodKeys.fetchChatRoomMembers],
          dataItemCallback: (obj) => obj);
    } on EMError catch (e) {
      throw e;
    }
  }

  /// ~english
  /// Gets the chat room announcement from the server.
  ///
  /// Param [roomId] The chat room ID.
  ///
  /// **Return** The chat room announcement.
  ///
  /// **Throws** A description of the exception. See [EMError].
  /// ~end
  ///
  /// ~chinese
  /// 从服务器获取聊天室公告内容。
  ///
  /// Param [roomId] 聊天室 ID。
  ///
  /// **Return** 聊天室公告。
  ///
  /// **Throws** 如果有异常会在这里抛出，包含错误码和错误描述，详见 [EMError]。
  /// ~end
  Future<String?> fetchChatRoomAnnouncement(
    String roomId,
  ) async {
    Map req = {"roomId": roomId};
    Map result = await _channel.invokeMethod(
        ChatMethodKeys.fetchChatRoomAnnouncement, req);
    try {
      EMError.hasErrorFromResult(result);
      return result[ChatMethodKeys.fetchChatRoomAnnouncement];
    } on EMError catch (e) {
      throw e;
    }
  }
}
