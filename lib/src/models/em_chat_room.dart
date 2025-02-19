import '../internal/inner_headers.dart';

/// ~english
/// The chat room instance class.
///
/// **Note**
/// To get the correct value, ensure that you call [EMChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
/// ~end
///
/// ~chinese
/// 聊天室信息类，包含内存中的聊天室信息。
///
/// **Note**
/// 如需最新数据，需从服务器获取：[EMChatRoomManager.fetchChatRoomInfoFromServer]。
/// ~end
class EMChatRoom {
  EMChatRoom._private({
    required this.roomId,
    this.name,
    this.description,
    this.owner,
    this.announcement,
    this.memberCount,
    this.maxUsers,
    this.adminList,
    this.memberList,
    this.isAllMemberMuted,
    this.permissionType = EMChatRoomPermissionType.None,
  });

  String toString() => toJson().toString();

  factory EMChatRoom.fromJson(Map<String, dynamic> map) {
    return EMChatRoom._private(
      roomId: map["roomId"],
      name: map["name"],
      description: map["desc"],
      owner: map["owner"],
      memberCount: map["memberCount"],
      maxUsers: map["maxUsers"],
      adminList: map.getList("adminList"),
      memberList: map.getList("memberList"),
      announcement: map["announcement"],
      permissionType: EMChatRoomPermissionType.values[map["permissionType"]],
      isAllMemberMuted: map.boolValue("isAllMemberMuted"),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = roomId;
    data.putIfNotNull("name", name);
    data.putIfNotNull("desc", description);
    data.putIfNotNull("owner", owner);
    data.putIfNotNull("memberCount", memberCount);
    data.putIfNotNull("maxUsers", maxUsers);
    data.putIfNotNull("adminList", adminList);
    data.putIfNotNull("memberList", memberList);
    data.putIfNotNull("announcement", announcement);
    data.putIfNotNull("isAllMemberMuted", isAllMemberMuted);
    data['permissionType'] = permissionType.index;

    return data;
  }

  /// ~english
  /// Gets the chat room ID.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [EMChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  /// ~end
  ///
  /// ~chinese
  /// 从内存中获取聊天室 ID。
  ///
  /// **Note**
  /// 如需最新数据，需从服务器获取：[EMChatRoomManager.fetchChatRoomInfoFromServer]。
  /// ~end
  final String roomId;

  /// ~english
  /// Gets the chat room name from the memory.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [EMChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  /// ~end
  ///
  /// ~chinese
  /// 从内存中获取聊天室名称。
  ///
  /// **Note**
  /// 如需最新数据，需从服务器获取：[EMChatRoomManager.fetchChatRoomInfoFromServer]。
  /// ~end
  final String? name;

  /// ~english
  /// Gets the chat room description from the memory.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [EMChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  /// ~end
  ///
  /// ~chinese
  /// 从内存中获取聊天室描述。
  ///
  /// **Note**
  /// 如需最新数据，需从服务器获取：[EMChatRoomManager.fetchChatRoomInfoFromServer]。
  /// ~end
  final String? description;

  /// ~english
  /// Gets the chat room owner ID. If this method returns an empty string, the SDK fails to get chat room details.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [EMChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  /// ~end
  ///
  /// ~chinese
  /// 从内存中获取聊天室所有者 ID。
  ///
  /// **Note**
  /// 如需最新数据，需从服务器获取：[EMChatRoomManager.fetchChatRoomInfoFromServer]。
  /// ~end
  final String? owner;

  /// ~english
  /// Gets the chat room announcement in the chat room from the memory.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [EMChatRoomManager.fetchChatRoomAnnouncement] before calling this method. Otherwise, the return value may not be correct.
  /// ~end
  ///
  /// ~chinese
  /// 从内存中获取聊天室公告。
  ///
  /// **Note**
  /// 如需最新数据，需从服务器获取：[EMChatRoomManager.fetchChatRoomInfoFromServer]。
  /// ~end
  final String? announcement;

  /// ~english
  /// This includes the chat room owner, administrators, and regular members.
  /// You can get this information after joining the chat room.
  /// This property is updated when members join or leave the chat room.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室的当前人数
  /// 包括聊天室所有者、管理员与普通成员
  /// 加入聊天室即可获取
  /// 当聊天室有成员进出时，此属性会更新。
  /// ~end
  final int? memberCount;

  /// ~english
  /// Gets the maximum number of members in the chat room from the memory, which is set/specified when the chat room is created.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [EMChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  /// ~end
  ///
  /// ~chinese
  /// 从内存中获取聊天室最大人数限制，在创建聊天室时设置。
  ///
  /// **Note**
  /// 如需最新数据，需从服务器获取：{[EMChatRoomManager.fetchChatRoomInfoFromServer]。
  /// ~end
  final int? maxUsers;

  /// ~english
  /// Gets the chat room admin list.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [EMChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  /// ~end
  ///
  /// ~chinese
  /// 从内存中获取聊天室管理员列表。
  ///
  /// **Note**
  /// 如需最新数据，需从服务器获取：[EMChatRoomManager.fetchChatRoomInfoFromServer]。
  /// ~end
  final List<String>? adminList;

  /// ~english
  /// Gets the member list.
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [EMChatRoomManager.fetchChatRoomMembers].
  /// ~end
  ///
  /// ~chinese
  /// 从内存中获取聊天室成员列表。
  ///
  /// **Note**
  /// 如需最新数据，需从服务器获取：[EMChatRoomManager.fetchChatRoomMembers]。
  /// ~end
  final List<String>? memberList;

  /// ~english
  /// Checks whether all members are muted,This property is available once join the chat room.
  /// After joining the chat room, when you receive a callback for muting or unmuting all members, this property will be updated.
  /// ~end
  ///
  /// ~chinese
  /// 聊天室成员是否全部被禁言。
  /// 聊天室成员是否全部被禁言,加入聊天室即可获取。
  /// 加入聊天室后，收到一键禁言/取消禁言的回调时，该状态会更新。
  /// ~end
  final bool? isAllMemberMuted;

  /// ~english
  /// Gets the current user's role in the chat room. The role types: [EMChatRoomPermissionType].
  ///
  /// **Note**
  /// To get the correct value, ensure that you call [EMChatRoomManager.fetchChatRoomInfoFromServer] before calling this method.
  /// ~end
  ///
  /// ~chinese
  /// 从内存中获取当前用户在聊天室角色，详见 [EMChatRoomPermissionType]。
  ///
  /// **Note**
  /// 如果需要获取最新值，请调用 [EMChatRoomManager.fetchChatRoomInfoFromServer]。
  /// ~end
  final EMChatRoomPermissionType permissionType;
}
