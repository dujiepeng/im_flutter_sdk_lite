//
//  EMChatManagerWrapper.m
//
//
//  Created by 杜洁鹏 on 2019/10/8.
//

#import "ChatManagerWrapper.h"
#import "MethodKeys.h"
#import "NSArray+Helper.h"
#import "MessageHelper.h"
#import "ConversationHelper.h"
#import "ErrorHelper.h"
#import "CursorResultHelper.h"
#import "FetchServerMessagesOptionHelper.h"
#import "EnumTools.h"
#import "Helper.h"

@interface ChatManagerWrapper () <EMChatManagerDelegate>
@property (nonatomic, strong) FlutterMethodChannel *messageChannel;

@end

@implementation ChatManagerWrapper
- (instancetype)initWithChannelName:(NSString *)aChannelName
                          registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if(self = [super initWithChannelName:aChannelName
                               registrar:registrar]) {
        [EMClient.sharedClient.chatManager addDelegate:self delegateQueue:nil];
        FlutterJSONMethodCodec *codec = [FlutterJSONMethodCodec sharedInstance];
        self.messageChannel = [FlutterMethodChannel methodChannelWithName:@"com.chat.im/chat_message"
                                                          binaryMessenger:[registrar messenger]
                                                                    codec:codec];
        
    }
    return self;
}


- (void)unRegisterEaseListener {
    [EMClient.sharedClient.chatManager removeDelegate:self];
}

#pragma mark - FlutterPlugin

- (void)handleMethodCall:(FlutterMethodCall*)call
                  result:(FlutterResult)result {
    if ([ChatSendMessage isEqualToString:call.method]) {
        [self sendMessage:call.arguments
              channelName:call.method
                   result:result];
    } else if ([ChatAckMessageRead isEqualToString:call.method]) {
        [self ackMessageRead:call.arguments
                 channelName:call.method
                      result:result];
    } else if ([ChatAckConversationRead isEqualToString:call.method]) {
        [self ackConversationRead:call.arguments
                      channelName:call.method
                           result:result];
    } else if ([ChatRecallMessage isEqualToString:call.method]) {
        [self recallMessage:call.arguments
                channelName:call.method
                     result:result];
    } else if ([ChatGetConversation isEqualToString:call.method]) {
        [self getConversation:call.arguments
                  channelName:call.method
                       result:result];
    }  else if ([ChatGetMessage isEqualToString:call.method]) {
        [self getMessageWithMessageId:call.arguments
                          channelName:call.method
                               result:result];
    }  else if ([ChatGetUnreadMessageCount isEqualToString:call.method]) {
        [self getUnreadMessageCount:call.arguments
                        channelName:call.method
                             result:result];
    } else if ([ChatDownloadAttachment isEqualToString:call.method]) {
        [self downloadAttachment:call.arguments
                     channelName:call.method
                          result:result];
    } else if ([ChatDownloadThumbnail isEqualToString:call.method]) {
        [self downloadThumbnail:call.arguments
                    channelName:call.method
                         result:result];
    } else if ([ChatDownloadMessageAttachmentInCombine isEqualToString:call.method]) {
        [self downloadMessageAttachmentInCombine:call.arguments
                                     channelName:call.method
                                          result:result];
    } else if ([ChatDownloadMessageThumbnailInCombine isEqualToString:call.method]) {
        [self downloadMessageThumbnailInCombine:call.arguments
                                    channelName:call.method
                                         result:result];
    } else if ([ChatDeleteConversation isEqualToString:call.method]) {
        [self deleteConversation:call.arguments
                     channelName:call.method
                          result:result];
    } else if ([ChatFetchHistoryMessagesByOptions isEqualToString:call.method]) {
        [self fetchHistoryMessagesByOptions:call.arguments
                                channelName:call.method
                                     result:result];
    } else if ([ChatDeleteRemoteConversation isEqualToString:call.method]){
        [self deleteRemoteConversation:call.arguments
                           channelName:call.method
                                result:result];
    } else if ([ChatRemoveMessagesFromServerWithTs isEqualToString: call.method]) {
        [self removeMessagesFromServerWithTs:call.arguments
                                 channelName:call.method
                                      result:result];
    } else if ([GetConversationsFromServerWithCursor isEqualToString:call.method]) {
        [self getConversationsFromServerWithCursor:call.arguments channelName:call.method result:result];
    } else if ([GetPinnedConversationsFromServerWithCursor isEqualToString:call.method]) {
        [self getPinnedConversationsFromServerWithCursor:call.arguments channelName:call.method result:result];
    } else if ([PinConversation isEqualToString:call.method]) {
        [self pinConversation:call.arguments channelName:call.method result:result];
    }
    // 450
    // 481
    // 4.10
    else {
        [super handleMethodCall:call result:result];
    }
}

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    
}


#pragma mark - Actions

- (void)sendMessage:(NSDictionary *)param
        channelName:(NSString *)aChannelName
             result:(FlutterResult)result {
    
    __weak typeof(self) weakSelf = self;
    __block EMChatMessage *msg = [EMChatMessage fromJson:param];
    __block NSString *msgId = msg.messageId;
    
    [EMClient.sharedClient.chatManager sendMessage:msg
                                          progress:^(int progress) {
        [weakSelf.messageChannel invokeMethod:ChatOnMessageProgressUpdate
                                    arguments:@{
            @"progress":@(progress),
            @"localId":msgId
        }];
    } completion:^(EMChatMessage *message, EMError *error) {
        if (error) {
            [weakSelf.messageChannel invokeMethod:ChatOnMessageError
                                        arguments:@{
                @"error":[error toJson],
                @"localId":msgId,
                @"message":[message toJson]
            }];
        }else {
            [weakSelf.messageChannel invokeMethod:ChatOnMessageSuccess
                                        arguments:@{
                @"message":[message toJson],
                @"localId":msgId
            }];
        }
    }];
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:[msg toJson]];
}

- (void)ackMessageRead:(NSDictionary *)param
           channelName:(NSString *)aChannelName
                result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *msgId = param[@"msg_id"];
    NSString *to = param[@"to"];
    [EMClient.sharedClient.chatManager sendMessageReadAck:msgId
                                                   toUser:to
                                               completion:^(EMError *aError)
     {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:@(!aError)];
    }];
}


- (void)ackConversationRead:(NSDictionary *)param
                channelName:(NSString *)aChannelName
                     result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *conversationId = param[@"convId"];
    [EMClient.sharedClient.chatManager ackConversationRead:conversationId
                                                completion:^(EMError *aError)
     {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:@(!aError)];
    }];
}

- (void)recallMessage:(NSDictionary *)param
          channelName:(NSString *)aChannelName
               result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *msgId = param[@"msg_id"];
    EMChatMessage *msg = [EMClient.sharedClient.chatManager getMessageWithMessageId:msgId];
    if (!msg) {
        EMError *error = [EMError errorWithDescription:@"The message was not found" code:EMErrorMessageInvalid];
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error
                           object:@(!error)];
        return;
    }
    [EMClient.sharedClient.chatManager recallMessageWithMessageId:msgId completion:^(EMError * _Nullable aError) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:@(!aError)];
    }];
}

- (void)getMessageWithMessageId:(NSDictionary *)param
                    channelName:(NSString *)aChannelName
                         result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *msgId = param[@"msg_id"];
    EMChatMessage *msg = [EMClient.sharedClient.chatManager getMessageWithMessageId:msgId];
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:[msg toJson]];
}

- (void)getConversation:(NSDictionary *)param
            channelName:(NSString *)aChannelName
                 result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *conId = param[@"convId"];
    EMConversationType type = [EnumTools conversationTypeFromInt:[param[@"type"] intValue]];
    BOOL needCreate = [param[@"createIfNeed"] boolValue];
    EMConversation *con = [EMClient.sharedClient.chatManager getConversation:conId
                                                                        type:type
                                                            createIfNotExist:needCreate];
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:[con toJson]];
}


- (void)getUnreadMessageCount:(NSDictionary *)param
                  channelName:(NSString *)aChannelName
                       result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSArray *conList = [EMClient.sharedClient.chatManager getAllConversations];
    int unreadCount = 0;
    EMError *error = nil;
    for (EMConversation *con in conList) {
        unreadCount += con.unreadMessagesCount;
    }
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:error
                       object:@(unreadCount)];
}

- (void)downloadMessageAttachmentInCombine:(NSDictionary *)param
                               channelName:(NSString *)aChannelName
                                    result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    __block EMChatMessage *msg = [EMChatMessage fromJson:param[@"message"]];
    [EMClient.sharedClient.chatManager downloadMessageAttachment:msg
                                                        progress:^(int progress)
     {
        [weakSelf.messageChannel invokeMethod:ChatOnMessageProgressUpdate
                                    arguments:@{
            @"progress":@(progress),
            @"localId": msg.messageId
        }];
    } completion:^(EMChatMessage *message, EMError *error)
     {
        if (error) {
            NSDictionary *msgDict = [self updateDownloadStatus:EMDownloadStatusFailed message:message thumbnail:NO];
            [weakSelf.messageChannel invokeMethod:ChatOnMessageError
                                        arguments:@{
                @"error":[error toJson],
                @"localId":msg.messageId,
                @"message":msgDict
            }];
        }else {
            NSDictionary *msgDict = [self updateDownloadStatus:EMDownloadStatusSucceed message:message thumbnail:NO];
            [weakSelf.messageChannel invokeMethod:ChatOnMessageSuccess
                                        arguments:@{
                @"message": msgDict,
                @"localId": msg.messageId
            }];
        }
    }];
    
    NSDictionary *msgDict = [self updateDownloadStatus:EMDownloadStatusDownloading message:msg thumbnail:NO];
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:msgDict];
}

- (void)downloadMessageThumbnailInCombine:(NSDictionary *)param
                              channelName:(NSString *)aChannelName
                                   result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    __block EMChatMessage *msg = [EMChatMessage fromJson:param[@"message"]];
    [EMClient.sharedClient.chatManager downloadMessageThumbnail:msg
                                                       progress:^(int progress)
     {
        [weakSelf.messageChannel invokeMethod:ChatOnMessageProgressUpdate
                                    arguments:@{
            @"progress":@(progress),
            @"localId":msg.messageId
        }];
    } completion:^(EMChatMessage *message, EMError *error)
     {
        if (error) {
            NSDictionary *msgDict = [self updateDownloadStatus:EMDownloadStatusFailed message:message thumbnail:YES];
            [weakSelf.messageChannel invokeMethod:ChatOnMessageError
                                        arguments:@{
                @"error":[error toJson],
                @"localId":msg.messageId,
                @"message":msgDict
            }];
        }else {
            NSDictionary *msgDict = [self updateDownloadStatus:EMDownloadStatusSucceed message:message thumbnail:YES];
            [weakSelf.messageChannel invokeMethod:ChatOnMessageSuccess
                                        arguments:@{
                @"message":msgDict,
                @"localId":msg.messageId
            }];
        }
    }];
    NSDictionary *msgDict = [self updateDownloadStatus:EMDownloadStatusDownloading message:msg thumbnail:YES];
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:msgDict];
}

- (void)downloadAttachment:(NSDictionary *)param
               channelName:(NSString *)aChannelName
                    result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    __block EMChatMessage *msg = [EMChatMessage fromJson:param[@"message"]];
    EMChatMessage *tmpMsg = [EMClient.sharedClient.chatManager getMessageWithMessageId:msg.messageId];
    NSLog(@"downloadAttachment msg: %@", tmpMsg);
    [EMClient.sharedClient.chatManager downloadMessageAttachment:tmpMsg
                                                        progress:^(int progress)
     {
        [weakSelf.messageChannel invokeMethod:ChatOnMessageProgressUpdate
                                    arguments:@{
            @"progress":@(progress),
            @"localId": msg.messageId
        }];
    } completion:^(EMChatMessage *message, EMError *error)
     {
        if (error) {
            NSDictionary *msgDict = [self updateDownloadStatus:EMDownloadStatusFailed message:message thumbnail:NO];
            [weakSelf.messageChannel invokeMethod:ChatOnMessageError
                                        arguments:@{
                @"error":[error toJson],
                @"localId": msg.messageId,
                @"message":msgDict
            }];
        }else {
            NSDictionary *msgDict = [self updateDownloadStatus:EMDownloadStatusSucceed message:message thumbnail:NO];
            [weakSelf.messageChannel invokeMethod:ChatOnMessageSuccess
                                        arguments:@{
                @"message":msgDict,
                @"localId": msg.messageId
            }];
        }
    }];
    
    NSDictionary *msgDict = [self updateDownloadStatus:EMDownloadStatusDownloading message:msg thumbnail:NO];
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:msgDict];
}

- (void)downloadThumbnail:(NSDictionary *)param
              channelName:(NSString *)aChannelName
                   result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    __block EMChatMessage *msg = [EMChatMessage fromJson:param[@"message"]];
    EMChatMessage *tmpMsg = [EMClient.sharedClient.chatManager getMessageWithMessageId:msg.messageId];
    [EMClient.sharedClient.chatManager downloadMessageThumbnail:tmpMsg
                                                       progress:^(int progress)
     {
        [weakSelf.messageChannel invokeMethod:ChatOnMessageProgressUpdate
                                    arguments:@{
            @"progress":@(progress),
            @"localId":msg.messageId
        }];
    } completion:^(EMChatMessage *message, EMError *error)
     {
        if (error) {
            NSDictionary *msgDict = [self updateDownloadStatus:EMDownloadStatusFailed message:message thumbnail:YES];
            [weakSelf.messageChannel invokeMethod:ChatOnMessageError
                                        arguments:@{
                @"error":[error toJson],
                @"localId":msg.messageId,
                @"message":msgDict
            }];
        }else {
            NSDictionary *msgDict = [self updateDownloadStatus:EMDownloadStatusSucceed message:message thumbnail:YES];
            [weakSelf.messageChannel invokeMethod:ChatOnMessageSuccess
                                        arguments:@{
                @"message":msgDict,
                @"localId":msg.messageId
            }];
        }
    }];
    NSDictionary *msgDict = [self updateDownloadStatus:EMDownloadStatusDownloading message:msg thumbnail:YES];
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:msgDict];
}

// 用于修改下载状态。
- (NSDictionary *)updateDownloadStatus:(EMDownloadStatus)status
                               message:(EMChatMessage *)msg
                             thumbnail:(BOOL)isThumbnail
{
    BOOL canUpdate = NO;
    switch(msg.body.type){
        case EMMessageBodyTypeFile:
        case EMMessageBodyTypeVoice:{
            if(isThumbnail) {
                break;
            }
        }
        case EMMessageBodyTypeVideo:
        case EMMessageBodyTypeImage:{
            canUpdate = YES;
        }
            break;
        default:
            break;
    }
    
    if(canUpdate) {
        EMMessageBody *body = msg.body;
        if(msg.body.type == EMMessageBodyTypeFile) {
            EMFileMessageBody *tmpBody = (EMFileMessageBody *)body;
            tmpBody.downloadStatus = status;
            body = tmpBody;
        }else if(msg.body.type == EMMessageBodyTypeVoice) {
            EMVoiceMessageBody *tmpBody = (EMVoiceMessageBody *)body;
            tmpBody.downloadStatus = status;
            body = tmpBody;
        }else if(msg.body.type == EMMessageBodyTypeImage) {
            EMImageMessageBody *tmpBody = (EMImageMessageBody *)body;
            if(isThumbnail) {
                tmpBody.thumbnailDownloadStatus = status;
            }else {
                tmpBody.downloadStatus = status;
            }
            body = tmpBody;
        }else if(msg.body.type == EMMessageBodyTypeVideo) {
            EMVideoMessageBody *tmpBody = (EMVideoMessageBody *)body;
            if(isThumbnail) {
                tmpBody.thumbnailDownloadStatus = status;
            }else {
                tmpBody.downloadStatus = status;
            }
            body = tmpBody;
        }
        msg.body = body;
    }
    return [msg toJson];
}

- (void)deleteConversation:(NSDictionary *)param
               channelName:(NSString *)aChannelName
                    result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *conversationId = param[@"convId"];
    BOOL isDeleteMsgs = [param[@"deleteMessages"] boolValue];
    [EMClient.sharedClient.chatManager deleteConversation:conversationId
                                         isDeleteMessages:isDeleteMsgs
                                               completion:^(NSString *aConversationId, EMError *aError)
     {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:@(!aError)];
    }];
}

- (void)fetchHistoryMessagesByOptions:(NSDictionary *)param
                          channelName:(NSString *)aChannelName
                               result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *conversationId = param[@"convId"];
    EMConversationType type = [EnumTools conversationTypeFromInt:[param[@"type"] intValue]];
    int pageSize = [param[@"pageSize"] intValue];
    NSString *cursor = param[@"cursor"];
    EMFetchServerMessagesOption *options;
    if(param[@"options"]) {
        options = [EMFetchServerMessagesOption fromJson:param[@"options"]];
    }
    [EMClient.sharedClient.chatManager fetchMessagesFromServerBy:conversationId conversationType:type cursor:cursor pageSize:pageSize option:options completion:^(EMCursorResult<EMChatMessage *> * _Nullable aResult, EMError * _Nullable aError) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:[aResult toJson]];
    }];
}

- (void)deleteRemoteConversation:(NSDictionary *)param
                     channelName:(NSString *)aChannelName
                          result:(FlutterResult)result
{
    __weak typeof(self) weakSelf = self;
    NSString *conversationId = param[@"conversationId"];
    EMConversationType type = [EnumTools conversationTypeFromInt:[param[@"conversationType"] intValue]];
    BOOL isDeleteRemoteMessage = [param[@"isDeleteRemoteMessage"] boolValue];
    
    [EMClient.sharedClient.chatManager deleteServerConversation:conversationId
                                               conversationType:type
                                         isDeleteServerMessages:isDeleteRemoteMessage
                                                     completion:^(NSString *aConversationId, EMError *aError)
     {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:@(!aError)];
    }];
}

- (void)removeMessagesFromServerWithTs:(NSDictionary *)param
                           channelName:(NSString *)aChannelName
                                result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *convId = param[@"convId"];
    EMConversationType type = [EnumTools conversationTypeFromInt:[param[@"type"] intValue]];
    long timestamp = [param[@"timestamp"] longValue];
    
    if(!EMClient.sharedClient.isLoggedIn) {
        EMError *e = [EMError errorWithDescription:@"Not login" code:EMErrorUserNotLogin];
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:e
                           object:@(!e)];
        return;
    }
    
    if(convId == nil || convId.length == 0 || type == EMConversationTypeChatRoom || timestamp <= 0) {
        EMError *e = [EMError errorWithDescription:@"Invalid parameter" code:EMErrorInvalidParam];
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:e
                           object:@(!e)];
        return;
    }
    
    EMConversation *conversation = [EMClient.sharedClient.chatManager getConversation:convId type:type createIfNotExist:YES];
    [conversation removeMessagesFromServerWithTimeStamp:timestamp completion:^(EMError * _Nullable aError) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:@(!aError)];
    }];
}

- (void)getConversationsFromServerWithCursor:(NSDictionary *)param
                                 channelName:(NSString *)aChannelName
                                      result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *cursor = param[@"cursor"];
    int pageSize = [param[@"pageSize"] intValue];
    [EMClient.sharedClient.chatManager getConversationsFromServerWithCursor:cursor pageSize:pageSize completion:^(EMCursorResult<EMConversation *> * _Nullable ret, EMError * _Nullable error) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error
                           object:[ret toJson]];
    }];
}

- (void)getPinnedConversationsFromServerWithCursor:(NSDictionary *)param
                                       channelName:(NSString *)aChannelName
                                            result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *cursor = param[@"cursor"];
    int pageSize = [param[@"pageSize"] intValue];
    [EMClient.sharedClient.chatManager getPinnedConversationsFromServerWithCursor:cursor pageSize:pageSize completion:^(EMCursorResult<EMConversation *> * _Nullable ret, EMError * _Nullable error) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error
                           object:[ret toJson]];
    }];
}

- (void)pinConversation:(NSDictionary *)param
            channelName:(NSString *)aChannelName
                 result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *convId = param[@"convId"];
    BOOL isPinned = [param[@"isPinned"] boolValue];
    [EMClient.sharedClient.chatManager pinConversation:convId isPinned:isPinned completionBlock:^(EMError * _Nullable error) {
        [weakSelf wrapperCallBack:result channelName:aChannelName error:error object:@(!error)];
    }];
}

#pragma mark - 450

#pragma mark - EMChatManagerDelegate


- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    [self.channel invokeMethod:ChatOnConversationUpdate
                     arguments:nil];
}

- (void)onConversationRead:(NSString *)from
                        to:(NSString *)to {
    [self.channel invokeMethod:ChatOnConversationHasRead
                     arguments:@{@"from":from, @"to": to}];
}

- (void)messagesDidReceive:(NSArray *)aMessages {
    NSMutableArray *msgList = [NSMutableArray array];
    for (EMChatMessage *msg in aMessages) {
        
        [msgList addObject:[msg toJson]];
    }
    [self.channel invokeMethod:ChatOnMessagesReceived
                     arguments:msgList];
}

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    NSMutableArray *cmdMsgList = [NSMutableArray array];
    for (EMChatMessage *msg in aCmdMessages) {
        [cmdMsgList addObject:[msg toJson]];
    }
    
    [self.channel invokeMethod:ChatOnCmdMessagesReceived
                     arguments:cmdMsgList];
}

- (void)messagesDidRead:(NSArray *)aMessages {
    NSMutableArray *list = [NSMutableArray array];
    for (EMChatMessage *msg in aMessages) {
        NSDictionary *json = [msg toJson];
        [list addObject:json];
        [self.messageChannel invokeMethod:ChatOnMessageReadAck
                                arguments:json];
    }
    
    [self.channel invokeMethod:ChatOnMessagesRead arguments:list];
}

- (void)messagesDidDeliver:(NSArray *)aMessages {
    NSMutableArray *list = [NSMutableArray array];
    for (EMChatMessage *msg in aMessages) {
        NSDictionary *json = [msg toJson];
        [list addObject:json];
        [self.messageChannel invokeMethod:ChatOnMessageDeliveryAck
                                arguments:@{@"message":json}];
    }
    
    [self.channel invokeMethod:ChatOnMessagesDelivered
                     arguments:list];
}



- (void)messagesDidRecall:(NSArray *)aMessages {
    NSMutableArray *list = [NSMutableArray array];
    for (EMChatMessage *msg in aMessages) {
        [list addObject:[msg toJson]];
    }
    
    [self.channel invokeMethod:ChatOnMessagesRecalled
                     arguments:list];
}

- (void)onMessageContentChanged:(EMChatMessage *)message operatorId:(NSString *)operatorId operationTime:(NSUInteger)operationTime {
    NSDictionary *dict = @{
        @"message": [message toJson],
        @"operator": operatorId,
        @"operationTime": @(operationTime)
    };
    
    [self.channel invokeMethod:onMessageContentChanged
                     arguments:dict];
}

- (void)messageAttachmentStatusDidChange:(EMChatMessage *)aMessage error:(EMError *)aError {
    
}

#pragma mark 460
- (void)messagesInfoDidRecall:(NSArray<EMRecallMessageInfo *> *)aRecallMessagesInfo {
    NSMutableArray *list = [NSMutableArray array];
    for (EMRecallMessageInfo *info in aRecallMessagesInfo) {
        [list addObject:[info.recallMessage toJson]];
    }
    
    [self.channel invokeMethod:onMessagesRecalledInfo
                     arguments:list];
}

#pragma mark 481

#pragma mark 4.10

@end
