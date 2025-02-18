//
//  EMChatMessageWrapper.m
//  im_flutter_sdk
//
//  Created by 杜洁鹏 on 2022/5/5.
//

#import <Flutter/Flutter.h>
#import "ChatHeaders.h"
#import "MessageWrapper.h"
#import "MethodKeys.h"


@implementation MessageWrapper
- (instancetype)initWithChannelName:(NSString *)aChannelName
                          registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if(self = [super initWithChannelName:aChannelName
                               registrar:registrar]) {
    }
    return self;
}


#pragma mark - FlutterPlugin

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    [super handleMethodCall:call result:result];
}

- (EMChatMessage *)getMessageWithId:(NSString *)aMessageId {
    return [EMClient.sharedClient.chatManager getMessageWithMessageId:aMessageId];
}

@end
