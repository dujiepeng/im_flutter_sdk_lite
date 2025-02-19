//
//  EMConversationWrapper.m
//  
//
//  Created by 杜洁鹏 on 2019/10/8.
//

#import "ConversationWrapper.h"
#import "MethodKeys.h"

#import "MessageHelper.h"
#import "ConversationHelper.h"
#import "EnumTools.h"
#import "Helper.h"

@interface ConversationWrapper ()

@end

@implementation ConversationWrapper
- (instancetype)initWithChannelName:(NSString *)aChannelName
                          registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if(self = [super initWithChannelName:aChannelName
                               registrar:registrar]) {
    }
    return self;
}

#pragma mark - FlutterPlugin

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
     if ([ChatGetLatestMsg isEqualToString:call.method]) {
        [self getLatestMessage:call.arguments
                   channelName:call.method
                        result:result];
    } else if ([ChatGetLatestMsgFromOthers isEqualToString:call.method]) {
        [self getLatestMessageFromOthers:call.arguments
                             channelName:call.method
                                  result:result];
    } else if ([ChatConversationDeleteServerMessageWithTime isEqualToString:call.method]) {
        [self deleteServerMessagesByTime:call.arguments
                         channelName:call.method
                              result:result];
    }
    
    
    
    else {
        [super handleMethodCall:call result:result];
    }
}


#pragma mark - Private
- (void)getConversationWithParam:(NSDictionary *)param
                      completion:(void(^)(EMConversation *conversation))aCompletion
{
    __weak NSString *conversationId = param[@"convId"];
    EMConversationType type = [EnumTools conversationTypeFromInt:[param[@"type"] intValue]];
    EMConversation *conversation = [EMClient.sharedClient.chatManager getConversation:conversationId
                                                                                 type:type
                                                                     createIfNotExist:YES];
    if (aCompletion) {
        aCompletion(conversation);
    }
}

#pragma mark - Actions

- (void)getLatestMessage:(NSDictionary *)param
             channelName:(NSString *)aChannelName
                  result:(FlutterResult)result
{
    __weak typeof(self) weakSelf = self;
    [self getConversationWithParam:param
                        completion:^(EMConversation *conversation)
     {
        EMChatMessage *msg = conversation.latestMessage;
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:nil
                           object:[msg toJson]];
    }];
}

- (void)getLatestMessageFromOthers:(NSDictionary *)param
                       channelName:(NSString *)aChannelName
                            result:(FlutterResult)result
{
    __weak typeof(self) weakSelf = self;
    [self getConversationWithParam:param
                        completion:^(EMConversation *conversation)
     {
        EMChatMessage *msg = conversation.lastReceivedMessage;
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:nil
                           object:[msg toJson]];
    }];
}


- (void)deleteServerMessagesByTime:(NSDictionary *)param
                   channelName:(NSString *)aChannelName
                      result:(FlutterResult)result{
    long long ts = [param[@"beforeMs"] longLongValue];
    __weak typeof(self) weakSelf = self;
    [self getConversationWithParam:param
                        completion:^(EMConversation *conversation)
     {
        [conversation removeMessagesFromServerWithTimeStamp:ts completion:^(EMError * _Nullable aError) {
            [weakSelf wrapperCallBack:result
                          channelName:aChannelName
                                error:aError
                               object:nil];
        }];
    }];
}


@end
