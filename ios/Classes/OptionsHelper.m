//
//  EMOptions+Flutter.m
//  im_flutter_sdk
//
//  Created by 杜洁鹏 on 2020/10/12.
//

#import "OptionsHelper.h"
#import "ChatHeaders.h"

@implementation EMOptions (Helper)
- (NSDictionary *)toJson {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"appKey"] = self.appkey;
    data[@"autoLogin"] = @(self.isAutoLogin);
    data[@"debugModel"] = @(self.enableConsoleLog);
    data[@"requireAck"] = @(self.enableRequireReadAck);
    data[@"requireDeliveryAck"] = @(self.enableDeliveryAck);
    data[@"sortMessageByServerTime"] = @(self.sortMessageByServerTime);
    data[@"deleteMessagesAsExitChatRoom"] = @(self.deleteMessagesOnLeaveChatroom);
    data[@"isAutoDownload"] = @(self.autoDownloadThumbnail);
    data[@"isChatRoomOwnerLeaveAllowed"] = @(self.canChatroomOwnerLeave);
    data[@"serverTransfer"] = @(self.isAutoTransferMessageAttachments);
    data[@"loadEmptyConversations"] = @(self.loadEmptyConversations);
    data[@"usingHttpsOnly"] = @(self.usingHttpsOnly);
    data[@"enableDNSConfig"] = @(self.enableDnsConfig);
    data[@"imPort"] = @(self.chatPort);
    data[@"imServer"] = self.chatServer;
    data[@"restServer"] = self.restServer;
    data[@"dnsUrl"] = self.dnsURL;
    return data;
}
+ (EMOptions *)fromJson:(NSDictionary *)aJson {
    EMOptions *options = nil;
    options = [EMOptions optionsWithAppkey:aJson[@"appKey"]];
    options.isAutoLogin = [aJson[@"autoLogin"] boolValue];
    options.enableConsoleLog = YES;// [aJson[@"debugModel"] boolValue];
    options.enableRequireReadAck = [aJson[@"requireAck"] boolValue];
    options.enableDeliveryAck = [aJson[@"requireDeliveryAck"] boolValue];
    options.sortMessageByServerTime = [aJson[@"sortMessageByServerTime"] boolValue];
    options.deleteMessagesOnLeaveChatroom = [aJson[@"deleteMessagesAsExitChatRoom"] boolValue];
    options.autoDownloadThumbnail = [aJson[@"isAutoDownload"] boolValue];
    options.canChatroomOwnerLeave = [aJson[@"isChatRoomOwnerLeaveAllowed"] boolValue];
    options.isAutoTransferMessageAttachments = [aJson[@"serverTransfer"] boolValue];
    options.loadEmptyConversations = [aJson[@"loadEmptyConversations"] boolValue];
    options.usingHttpsOnly = [aJson[@"usingHttpsOnly"] boolValue];
    options.enableDnsConfig = [aJson[@"enableDNSConfig"] boolValue];
    options.chatPort = [aJson[@"imPort"] intValue];
    options.chatServer = aJson[@"imServer"];
    options.restServer = aJson[@"restServer"];
    options.dnsURL = aJson[@"dnsURL"];
    return options;
}
@end
