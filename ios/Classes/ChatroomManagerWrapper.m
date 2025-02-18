//
//  EMChatroomManagerWrapper.m
//  im_flutter_sdk
//
//  Created by easemob-DN0164 on 2019/10/18.
//

#import "ChatroomManagerWrapper.h"
#import "MethodKeys.h"

#import "CursorResultHelper.h"
#import "PageResultHelper.h"
#import "ChatroomHelper.h"
#import "ListenerHandle.h"

@interface ChatroomManagerWrapper () <EMChatroomManagerDelegate>

@end

@implementation ChatroomManagerWrapper

- (instancetype)initWithChannelName:(NSString *)aChannelName
                          registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if(self = [super initWithChannelName:aChannelName
                               registrar:registrar]) {
        
        [EMClient.sharedClient.roomManager addDelegate:self delegateQueue:nil];
    }
    return self;
}

- (void)unRegisterEaseListener {
    [EMClient.sharedClient.roomManager removeDelegate:self];
}

#pragma mark - FlutterPlugin

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([ChatJoinChatRoom isEqualToString:call.method])
    {
        [self joinChatroom:call.arguments
               channelName:call.method
                    result:result];
    }
    else if ([ChatLeaveChatRoom isEqualToString:call.method]) {
        [self leaveChatroom:call.arguments
                channelName:call.method
                     result:result];
    }
    else if ([ChatGetChatroomsFromServer isEqualToString:call.method]) {
        [self getChatroomsFromServer:call.arguments
                         channelName:call.method
                              result:result];
    }

    else if ([ChatFetchChatRoomFromServer isEqualToString:call.method]) {
        [self fetchChatroomInfoFromServer:call.arguments
                              channelName:call.method
                                   result:result];
    }
    else if ([ChatGetChatRoom isEqualToString:call.method]) {
        [self getChatroom:call.arguments
              channelName:call.method
                   result:result];
    }
    else if ([ChatGetAllChatRooms isEqualToString:call.method]) {
        [self getAllChatrooms:call.arguments
                  channelName:call.method
                       result:result];
    }
    else if ([ChatGetChatroomMemberListFromServer isEqualToString:call.method]) {
        [self getChatroomMemberListFromServer:call.arguments
                                  channelName:call.method
                                       result:result];
    }
    else if ([ChatFetchChatroomAnnouncement isEqualToString:call.method]) {
        [self fetchChatroomAnnouncement:call.arguments
                            channelName:call.method
                                 result:result];
    }
    else {
        [super handleMethodCall:call result:result];
    }
}

#pragma mark - Actions

- (void)getChatroomsFromServer:(NSDictionary *)param
                   channelName:(NSString *)aChannelName
                        result:(FlutterResult)result {
    NSInteger page = [param[@"pageNum"] integerValue];
    NSInteger pageSize = [param[@"pageSize"] integerValue];
    
    __weak typeof(self) weakSelf = self;
    
    [EMClient.sharedClient.roomManager getChatroomsFromServerWithPage:page
                                                             pageSize:pageSize
                                                           completion:^(EMPageResult *aResult, EMError *aError)
     {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:[aResult toJson]];
    }];
}


- (void)joinChatroom:(NSDictionary *)param
         channelName:(NSString *)aChannelName
              result:(FlutterResult)result {
    
    __weak typeof(self) weakSelf = self;
    NSString *chatroomId = param[@"roomId"];
    NSString *ext = param[@"ext"];
    BOOL leaveOtherRooms = [param[@"leaveOtherRooms"] boolValue];
    [EMClient.sharedClient.roomManager joinChatroom:chatroomId
     ext:ext leaveOtherRooms:leaveOtherRooms completion:^(EMChatroom *aChatroom, EMError *aError)
     {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:@(!!aChatroom)];
    }];
}

- (void)leaveChatroom:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    
    __weak typeof(self) weakSelf = self;
    
    NSString *chatroomId = param[@"roomId"];
    [EMClient.sharedClient.roomManager leaveChatroom:chatroomId
                                          completion:^(EMError *aError)
     {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:nil];
    }];
}

- (void)fetchChatroomInfoFromServer:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *chatroomId = param[@"roomId"];
    [EMClient.sharedClient.roomManager getChatroomSpecificationFromServerWithId:chatroomId completion:^(EMChatroom * _Nullable aChatroom, EMError * _Nullable aError) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:[aChatroom toJson]];
    }];
}

- (void)getChatroom:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    
    __weak typeof(self)weakSelf = self;
    EMChatroom *chatroom = [EMChatroom chatroomWithId:param[@"roomId"]];
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:[chatroom toJson]];
}

- (void)getAllChatrooms:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.roomManager getChatroomsFromServerWithPage:0
                                                             pageSize:-1
                                                           completion:^(EMPageResult *aResult, EMError *aError)
     {
        NSMutableArray *list = [NSMutableArray array];
        for (EMChatroom *room in aResult.list) {
            [list addObject:[room toJson]];
        }
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:list];
    }];
}

- (void)getChatroomMemberListFromServer:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    
    __weak typeof(self) weakSelf = self;
    
    NSString *chatroomId = param[@"roomId"];
    NSString *cursor = param[@"cursor"];
    NSInteger pageSize = [param[@"pageSize"] integerValue];
    [EMClient.sharedClient.roomManager getChatroomMemberListFromServerWithId:chatroomId
                                                                      cursor:cursor
                                                                    pageSize:pageSize
                                                                  completion:^(EMCursorResult *aResult, EMError *aError)
     {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:[aResult toJson]];

    }];
}


- (void)fetchChatroomAnnouncement:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    
    __weak typeof(self) weakSelf = self;
    
    NSString *chatroomId = param[@"roomId"];
    [EMClient.sharedClient.roomManager getChatroomAnnouncementWithId:chatroomId
                                                          completion:^(NSString *aAnnouncement, EMError *aError)
    {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:aAnnouncement];
    }];
}

#pragma mark - EMChatroomManagerWrapper

- (void)userDidJoinChatroom:(EMChatroom *)aChatroom
                       user:(NSString *)aUsername
                        ext:(NSString * _Nullable)ext {

    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomMemberJoined",
            @"roomId":aChatroom.chatroomId,
            @"participant":aUsername,
            @"ext": ext
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}

- (void)userDidLeaveChatroom:(EMChatroom *)aChatroom
                        user:(NSString *)aUsername {
    
    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomMemberExited",
            @"roomId":aChatroom.chatroomId,
            @"roomName":aChatroom.subject,
            @"participant":aUsername
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}

- (void)didDismissFromChatroom:(EMChatroom *)aChatroom
                        reason:(EMChatroomBeKickedReason)aReason {

    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSString *type;
        NSDictionary *map;
        if (aReason == EMChatroomBeKickedReasonDestroyed) {
            type = @"onRoomDestroyed";
            map = @{
                @"type":type,
                @"roomId":aChatroom.chatroomId,
                @"roomName":aChatroom.subject,
            };
        } else if (aReason == EMChatroomBeKickedReasonBeRemoved) {
            type = @"onRoomRemoved";
            map = @{
                @"type":type,
                @"roomId":aChatroom.chatroomId,
                @"roomName":aChatroom.subject,
                @"participant":[[EMClient sharedClient] currentUsername],
                @"reason": @(aReason)
            };
        }

        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}

    

- (void)chatroomMuteListDidUpdate:(EMChatroom *)aChatroom
                addedMutedMembers:(NSArray *)aMutes
                       muteExpire:(NSInteger)aMuteExpire {
    
    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomMuteListAdded",
            @"roomId":aChatroom.chatroomId,
            @"mutes":aMutes,
            @"expireTime":[NSString stringWithFormat:@"%ld", (long)aMuteExpire]
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}

- (void)chatroomMuteListDidUpdate:(EMChatroom *)aChatroom
              removedMutedMembers:(NSArray *)aMutes {
    
    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomMuteListRemoved",
            @"roomId":aChatroom.chatroomId,
            @"mutes":aMutes
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}

- (void)chatroomAdminListDidUpdate:(EMChatroom *)aChatroom
                        addedAdmin:(NSString *)aAdmin {
    
    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomAdminAdded",
            @"roomId":aChatroom.chatroomId,
            @"admin":aAdmin
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}

- (void)chatroomAdminListDidUpdate:(EMChatroom *)aChatroom
                      removedAdmin:(NSString *)aAdmin {
    
    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomAdminRemoved",
            @"roomId":aChatroom.chatroomId,
            @"admin":aAdmin
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}

- (void)chatroomOwnerDidUpdate:(EMChatroom *)aChatroom
                      newOwner:(NSString *)aNewOwner
                      oldOwner:(NSString *)aOldOwner {
    
    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomOwnerChanged",
            @"roomId":aChatroom.chatroomId,
            @"newOwner":aNewOwner,
            @"oldOwner":aOldOwner
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}

- (void)chatroomAnnouncementDidUpdate:(EMChatroom *)aChatroom
                         announcement:(NSString *)aAnnouncement {
    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomAnnouncementChanged",
            @"roomId":aChatroom.chatroomId,
            @"announcement":aAnnouncement
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}

- (void)chatroomWhiteListDidUpdate:(EMChatroom *)aChatroom
             addedWhiteListMembers:(NSArray *)aMembers {
    
    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomWhiteListAdded",
            @"roomId":aChatroom.chatroomId,
            @"whitelist":aMembers
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}


- (void)chatroomWhiteListDidUpdate:(EMChatroom *)aChatroom
           removedWhiteListMembers:(NSArray *)aMembers {
    
    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomWhiteListRemoved",
            @"roomId":aChatroom.chatroomId,
            @"whitelist":aMembers
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}


- (void)chatroomAllMemberMuteChanged:(EMChatroom *)aChatroom
                    isAllMemberMuted:(BOOL)aMuted {
    
    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomAllMemberMuteStateChanged",
            @"roomId":aChatroom.chatroomId,
            @"isMuted":@(aMuted)
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}

- (void)chatroomSpecificationDidUpdate:(EMChatroom *)aChatroom {
    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomSpecificationChanged",
            @"room":[aChatroom toJson]
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}

- (void)chatroomAttributesDidUpdated:(NSString *)roomId
                        attributeMap:(NSDictionary<NSString *, NSString *> *)attributeMap
                                from:(NSString *)fromId {
    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomAttributesDidUpdated",
            @"roomId":roomId,
            @"attributes":attributeMap,
            @"fromId": fromId
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}
- (void)chatroomAttributesDidRemoved:(NSString *)roomId
                          attributes:(NSArray<NSString *> *)attributes
                                from:(NSString *)fromId {
    __weak typeof(self) weakSelf = self;
    [ListenerHandle.sharedInstance addHandle:^{
        NSDictionary *map = @{
            @"type":@"onRoomAttributesDidRemoved",
            @"roomId":roomId,
            @"keys":attributes,
            @"fromId": fromId
        };
        [weakSelf.channel invokeMethod:ChatChatroomChanged arguments:map];
    }];
}


#pragma mark - EMChatroom Pack Method

// 聊天室成员获取结果转字典
- (NSDictionary *)dictionaryWithCursorResult:(EMCursorResult *)cursorResult
{
    NSDictionary *resultDict = @{@"data":cursorResult.list,
                                 @"cursor":cursorResult.cursor
                                };
    return resultDict;
}




#pragma mark - 481


@end
