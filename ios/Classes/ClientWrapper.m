//
//  EMClientWrapper.m
//  
//
//  Created by 杜洁鹏 on 2019/10/8.
//

#import "ClientWrapper.h"
#import "MethodKeys.h"
#import "ChatManagerWrapper.h"
#import "ConversationWrapper.h"
#import "ChatroomManagerWrapper.h"
#import "OptionsHelper.h"
#import "MessageWrapper.h"
#import "ProgressManager.h"
#import "ListenerHandle.h"
#import "EnumTools.h"

@interface ClientWrapper () <EMClientDelegate, FlutterPlugin>
{
    ChatManagerWrapper *_chatManager;
    ConversationWrapper *_conversationManager;
    ChatroomManagerWrapper *_roomManager;
    MessageWrapper *_msgWrapper;
    ProgressManager *_progressManager;
}
@end

@implementation ClientWrapper {
    EMOptions *_options;
}



- (void)sendDataToFlutter:(NSDictionary *)aData {
    if (aData == nil) {
        return;
    }
    [self.channel invokeMethod:ChatSendDataToFlutter
                     arguments:aData];
}


- (instancetype)initWithChannelName:(NSString *)aChannelName
                          registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if(self = [super initWithChannelName:aChannelName
                               registrar:registrar]) {
        
    }
    return self;
}

#pragma mark - FlutterPlugin

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([ChatInit isEqualToString:call.method])
    {
        [self initSDKWithDict:call.arguments
                  channelName:call.method
                       result:result];
    }
    else if ([ChatCreateAccount isEqualToString:call.method])
    {
        [self createAccount:call.arguments
                channelName:call.method
                     result:result];
    }
    else if ([ChatLogin isEqualToString:call.method])
    {
        [self login:call.arguments
        channelName:call.method
             result:result];
    }
    else if ([ChatLogout isEqualToString:call.method])
    {
        [self logout:call.arguments
         channelName:call.method
              result:result];
    }
    else if ([ChatUploadLog isEqualToString:call.method])
    {
        [self uploadLog:call.arguments
            channelName:call.method
                 result:result];
    }
    else if ([ChatCompressLogs isEqualToString:call.method])
    {
        [self compressLogs:call.arguments
               channelName:call.method
                    result:result];
    }
    else if([ChatIsLoggedInBefore isEqualToString:call.method])
    {
        [self isLoggedInBefore:call.arguments
                   channelName:call.method
                        result:result];
    }
    else if([ChatGetCurrentUser isEqualToString:call.method])
    {
        [self getCurrentUser:call.arguments
                 channelName:call.method
                      result:result];
    }
    else if([ChatGetToken isEqualToString:call.method])
    {
        [self getToken:call.arguments
           channelName:call.method
                result:result];
    }
    else if([ChatIsConnected isEqualToString:call.method])
    {
        [self isConnected:call.arguments
              channelName:call.method
                   result:result];
    }
    else if ([ChatRenewToken isEqualToString:call.method]){
        [self renewToken:call.arguments
             channelName:call.method
                  result:result];
    }else if ([ChatStartCallback isEqualToString:call.method]){
        [self startCallBack:call.arguments
                channelName:call.method
                     result:result];
    }
    // 481
    else if ([ChatUpdateUsingHttpsOnlySetting isEqualToString:call.method]){
        [self updateUsingHttpsOnlySetting:call.arguments
                              channelName:call.method
                                   result:result];
    }
    else if ([ChatUpdateDeleteMessageWhenLeaveRoomSetting isEqualToString:call.method]){
        [self updateDeleteMessageWhenLeaveRoomSetting:call.arguments
                                          channelName:call.method
                                               result:result];
    }
    else if ([ChatUpdateRoomOwnerCanLeaveSetting isEqualToString:call.method]){
        [self updateRoomOwnerCanLeaveSetting:call.arguments
                                 channelName:call.method
                                      result:result];
    }
    else if ([ChatUpdateAutoDownloadAttachmentThumbnailSetting isEqualToString:call.method]){
        [self updateAutoDownloadAttachmentThumbnailSetting:call.arguments
                                               channelName:call.method
                                                    result:result];
    }
    else if ([ChatUpdateRequireAckSetting isEqualToString:call.method]){
        [self updateRequireAckSetting:call.arguments
                          channelName:call.method
                               result:result];
    }
    else if ([ChatUpdateDeliveryAckSetting isEqualToString:call.method]){
        [self updateDeliveryAckSetting:call.arguments
                           channelName:call.method
                                result:result];
    }
    else if ([ChatUpdateSortMessageByServerTimeSetting isEqualToString:call.method]){
        [self updateSortMessageByServerTimeSetting:call.arguments
                                       channelName:call.method
                                            result:result];
    }
    else {
        [super handleMethodCall:call result:result];
    }
}


#pragma mark - Actions
- (void)initSDKWithDict:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    
    __weak typeof(self) weakSelf = self;
    
    if(_options) {
        [weakSelf wrapperCallBack:result
                      channelName:ChatInit
                            error:nil
                           object:nil];
        return;
    }
    
    _options = [EMOptions fromJson:param];

    [EMClient.sharedClient initializeSDKWithOptions:_options];

    [self registerManagers];
    [weakSelf wrapperCallBack:result
                  channelName:ChatInit
                        error:nil
                       object:nil];
}


- (void)registerManagers {
    [self clearAllListener];
    [EMClient.sharedClient addDelegate:self delegateQueue:nil];
    _chatManager = [[ChatManagerWrapper alloc] initWithChannelName:EMChannelName(@"chat_manager")registrar:self.flutterPluginRegister];
    _conversationManager = [[ConversationWrapper alloc] initWithChannelName:EMChannelName(@"chat_conversation") registrar:self.flutterPluginRegister];
    _roomManager =[[ChatroomManagerWrapper alloc] initWithChannelName:EMChannelName(@"chat_room_manager") registrar:self.flutterPluginRegister];
    _msgWrapper = [[MessageWrapper alloc] initWithChannelName:EMChannelName(@"chat_message") registrar:self.flutterPluginRegister];
    _progressManager = [[ProgressManager alloc] initWithChannelName:EMChannelName(@"file_progress_manager")  registrar:self.flutterPluginRegister];
}

- (void)clearAllListener {
    [_chatManager unRegisterEaseListener];
    [_conversationManager unRegisterEaseListener];
    [_roomManager unRegisterEaseListener];
    [_msgWrapper unRegisterEaseListener];
    [super unRegisterEaseListener];
    [EMClient.sharedClient removeDelegate:self];
}

// 由父类调用，不需要调用 clearAllListener方法，每个manager中都由父类调用。
- (void)unRegisterEaseListener {
    [EMClient.sharedClient removeDelegate:self];
}

- (ProgressManager *)progressManager {
    return _progressManager;
}

- (void)createAccount:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *username = param[@"username"];
    NSString *password = param[@"password"];
    [EMClient.sharedClient registerWithUsername:username
                                       password:password
                                     completion:^(NSString *aUsername, EMError *aError)
     {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:aUsername];
    }];
}

- (void)login:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *username = param[@"username"];
    NSString *pwdOrToken = param[@"pwdOrToken"];
    BOOL isPwd = [param[@"isPassword"] boolValue];
    
    if (isPwd) {

        [EMClient.sharedClient loginWithUsername:username
                                        password:pwdOrToken
                                      completion:^(NSString *aUsername, EMError *aError){

            [weakSelf wrapperCallBack:result
                          channelName:aChannelName
                                error:aError
                               object:EMClient.sharedClient.currentUsername];
        }];
    }else {
        [EMClient.sharedClient loginWithUsername:username
                                           token:pwdOrToken
                                      completion:^(NSString *aUsername, EMError *aError)
         {
            [weakSelf wrapperCallBack:result
                          channelName:aChannelName
                                error:aError
                               object:EMClient.sharedClient.currentUsername];
        }];
    }
}

- (void)logout:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    BOOL unbindToken = [param[@"unbindToken"] boolValue];
    [EMClient.sharedClient logout:unbindToken completion:^(EMError *aError) {
        if(aError == nil) {
            [ListenerHandle.sharedInstance clearHandle];
        }
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:@(!aError)];
    }];
}

- (void)getCurrentUser:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString* username = EMClient.sharedClient.currentUsername;
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:username];
    
}

- (void)uploadLog:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    [EMClient.sharedClient uploadDebugLogToServerWithCompletion:^(EMError *aError) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:nil];
    }];
}

- (void)compressLogs:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    [EMClient.sharedClient getLogFilesPathWithCompletion:^(NSString *aPath, EMError *aError) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:aError
                           object:aPath];
    }];
}

- (void)isLoggedInBefore:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(EMClient.sharedClient.isLoggedIn)];
    
}

- (void)getToken:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result{
    [self wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:EMClient.sharedClient.accessUserToken];
}


- (void)isConnected:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result{
    [self wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(EMClient.sharedClient.isConnected)];
}

- (void)renewToken:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result{
    __weak typeof(self)weakSelf = self;
    NSString *newAgoraToken = param[@"agora_token"];
    [EMClient.sharedClient renewToken:newAgoraToken completion:^(EMError * _Nullable aError) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:nil
                           object:nil];
    }];
}

- (void)startCallBack:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result{
    __weak typeof(self)weakSelf = self;
    [ListenerHandle.sharedInstance startCallback];
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:nil];
}

#pragma - mark EMClientDelegate

- (void)connectionStateDidChange:(EMConnectionState)aConnectionState {
    BOOL isConnected = aConnectionState == EMConnectionConnected;
    if (isConnected) {
        [self.channel invokeMethod:ChatOnConnected
                         arguments:nil];
    }else {
        [self.channel invokeMethod:ChatOnDisconnected
                         arguments:nil];
    }
}

- (void)autoLoginDidCompleteWithError:(EMError *)aError {
    if (aError.code == EMErrorServerServingForbidden) {
         [self userDidForbidByServer];
    }else if (aError.code == EMErrorAppActiveNumbersReachLimitation) {
        [self activeNumbersReachLimitation];
    }
}

- (void)activeNumbersReachLimitation {
    [self.channel invokeMethod:ChatOnAppActiveNumberReachLimit arguments:nil];
}

// 声网token即将过期
- (void)tokenWillExpire:(EMErrorCode)aErrorCode {
    [self.channel invokeMethod:ChatOnTokenWillExpire arguments:nil];
}

// 声网token过期
- (void)tokenDidExpire:(EMErrorCode)aErrorCode {
    [ListenerHandle.sharedInstance clearHandle];
    [self.channel invokeMethod:ChatOnTokenDidExpire
                     arguments:nil];
}

//- (void)userAccountDidLoginFromOtherDevice:(NSString *)aDeviceName {
//    [EMListenerHandle.sharedInstance clearHandle];
//    [self.channel invokeMethod:ChatOnUserDidLoginFromOtherDevice
//                     arguments:@{@"deviceName": aDeviceName}];
//}

- (void)userAccountDidRemoveFromServer {
    [ListenerHandle.sharedInstance clearHandle];
    [self.channel invokeMethod:ChatOnUserDidRemoveFromServer
                     arguments:nil];
}

- (void)userDidForbidByServer {
    [ListenerHandle.sharedInstance clearHandle];
    [self.channel invokeMethod:ChatOnUserDidForbidByServer
                     arguments:nil];
}


- (void)userAccountDidForcedToLogout:(EMError *)aError {
    [ListenerHandle.sharedInstance clearHandle];
    if (aError.code == EMErrorUserKickedByChangePassword) {
        [self.channel invokeMethod:ChatOnUserDidChangePassword
                         arguments:nil];
    } else if (aError.code == EMErrorUserLoginTooManyDevices) {
        [self.channel invokeMethod:ChatOnUserDidLoginTooManyDevice
                         arguments:nil];
    } else if (aError.code == EMErrorUserKickedByOtherDevice) {
        [self.channel invokeMethod:ChatOnUserKickedByOtherDevice
                         arguments:nil];
    } else if (aError.code == EMErrorUserAuthenticationFailed) {
        [self.channel invokeMethod:ChatOnUserAuthenticationFailed
                         arguments:nil];
    }
}


# pragma mark - 481
- (void)userAccountDidLoginFromOtherDevice:(NSString *)aDeviceName {
    [ListenerHandle.sharedInstance clearHandle];
    [self.channel invokeMethod:ChatOnUserDidLoginFromOtherDevice
                     arguments:aDeviceName];
}


- (void)updateUsingHttpsOnlySetting:(NSDictionary *)param
                        channelName:(NSString *)aChannelName
                             result:(FlutterResult)result 
{
    __weak typeof(self)weakSelf = self;
    BOOL usingHttpsOnly = [param[@"usingHttpsOnly"] boolValue];
    EMClient.sharedClient.options.usingHttpsOnly = usingHttpsOnly;
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:nil];
}

- (void)updateDeleteMessageWhenLeaveRoomSetting:(NSDictionary *)param
                                    channelName:(NSString *)aChannelName
                                         result:(FlutterResult)result
{
    __weak typeof(self)weakSelf = self;
    BOOL deleteMessageWhenLeaveRoom = [param[@"deleteMessageWhenLeaveRoom"] boolValue];
    EMClient.sharedClient.options.deleteMessagesOnLeaveChatroom = deleteMessageWhenLeaveRoom;
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:nil];
}

- (void)updateRoomOwnerCanLeaveSetting:(NSDictionary *)param
                           channelName:(NSString *)aChannelName
                                result:(FlutterResult)result
{
    __weak typeof(self)weakSelf = self;
    BOOL roomOwnerCanLeave = [param[@"roomOwnerCanLeave"] boolValue];
    EMClient.sharedClient.options.canChatroomOwnerLeave = roomOwnerCanLeave;
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:nil];
}

- (void)updateAutoDownloadAttachmentThumbnailSetting:(NSDictionary *)param
                                         channelName:(NSString *)aChannelName
                                              result:(FlutterResult)result
{
    __weak typeof(self)weakSelf = self;
    BOOL autoDownloadThumbnail = [param[@"autoDownloadThumbnail"] boolValue];
    EMClient.sharedClient.options.autoDownloadThumbnail = autoDownloadThumbnail;
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:nil];
}

- (void)updateRequireAckSetting:(NSDictionary *)param
                    channelName:(NSString *)aChannelName
                         result:(FlutterResult)result
{
    __weak typeof(self)weakSelf = self;
    BOOL requireAck = [param[@"requireAck"] boolValue];
    EMClient.sharedClient.options.enableRequireReadAck = requireAck;
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:nil];
}

- (void)updateDeliveryAckSetting:(NSDictionary *)param
                     channelName:(NSString *)aChannelName
                          result:(FlutterResult)result
{
    __weak typeof(self)weakSelf = self;
    BOOL requireDeliveryAck = [param[@"requireDeliveryAck"] boolValue];
    EMClient.sharedClient.options.enableDeliveryAck = requireDeliveryAck;
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:nil];
}

- (void)updateSortMessageByServerTimeSetting:(NSDictionary *)param
                                 channelName:(NSString *)aChannelName
                                      result:(FlutterResult)result
{
    __weak typeof(self)weakSelf = self;
    BOOL sortMessageByServerTime = [param[@"sortMessageByServerTime"] boolValue];
    EMClient.sharedClient.options.sortMessageByServerTime = sortMessageByServerTime;
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:nil];
}


@end
