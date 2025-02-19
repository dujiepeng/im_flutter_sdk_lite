//
//  EMSDKMethod.h
//
//
//  Created by 杜洁鹏 ChatOn 2019/10/8.
//

#import <Foundation/Foundation.h>

#pragma mark - EMClientWrapper
static NSString *const ChatInit = @"init";
static NSString *const ChatCreateAccount = @"createAccount";
static NSString *const ChatLogin = @"login";
static NSString *const ChatRenewToken = @"renewToken";
static NSString *const ChatLogout = @"logout";

static NSString *const ChatUploadLog = @"uploadLog";
static NSString *const ChatCompressLogs = @"compressLogs";

static NSString *const ChatGetToken = @"getToken";
static NSString *const ChatGetCurrentUser = @"getCurrentUser";
static NSString *const ChatIsLoggedInBefore = @"isLoggedInBefore";
static NSString *const ChatIsConnected = @"isConnected";


#pragma mark - EMClientDelegate
static NSString *const ChatOnConnected = @"onConnected";
static NSString *const ChatOnDisconnected = @"onDisconnected";
static NSString *const ChatOnUserDidLoginFromOtherDevice = @"onUserDidLoginFromOtherDevice";
static NSString *const ChatOnUserDidRemoveFromServer = @"onUserDidRemoveFromServer";
static NSString *const ChatOnUserDidForbidByServer = @"onUserDidForbidByServer";
static NSString *const ChatOnUserDidChangePassword = @"onUserDidChangePassword";
static NSString *const ChatOnUserDidLoginTooManyDevice = @"onUserDidLoginTooManyDevice";
static NSString *const ChatOnUserKickedByOtherDevice = @"onUserKickedByOtherDevice";
static NSString *const ChatOnUserAuthenticationFailed = @"onUserAuthenticationFailed";

static NSString *const ChatSendDataToFlutter = @"onSendDataToFlutter";
static NSString *const ChatOnTokenWillExpire = @"onTokenWillExpire";
static NSString *const ChatOnTokenDidExpire = @"onTokenDidExpire";
static NSString *const ChatOnAppActiveNumberReachLimit = @"onAppActiveNumberReachLimit";


#pragma mark - EMChatManagerWrapper
static NSString *const ChatSendMessage = @"sendMessage";
static NSString *const ChatAckMessageRead = @"ackMessageRead";
static NSString *const ChatAckConversationRead = @"ackConversationRead";
static NSString *const ChatRecallMessage = @"recallMessage";
static NSString *const ChatDownloadAttachment = @"downloadAttachment";
static NSString *const ChatDownloadThumbnail = @"downloadThumbnail";

static NSString *const ChatFetchHistoryMessagesByOptions = @"fetchHistoryMessagesByOptions";
static NSString *const ChatDeleteRemoteConversation = @"deleteRemoteConversation";
static NSString *const ChatRemoveMessagesFromServerWithTs = @"removeMessagesFromServerWithTs";

static NSString *const GetConversationsFromServerWithCursor = @"getConversationsFromServerWithCursor";
static NSString *const GetPinnedConversationsFromServerWithCursor = @"getPinnedConversationsFromServerWithCursor";
static NSString *const PinConversation = @"pinConversation";


#pragma mark - EMChatManagerDelegate
static NSString *const ChatOnMessagesReceived = @"onMessagesReceived";
static NSString *const ChatOnCmdMessagesReceived = @"onCmdMessagesReceived";
static NSString *const ChatOnMessagesRead = @"onMessagesRead";
static NSString *const ChatOnMessagesDelivered = @"onMessagesDelivered";
static NSString *const ChatOnMessagesRecalled = @"onMessagesRecalled";

static NSString *const ChatOnConversationUpdate = @"onConversationUpdate";
static NSString *const ChatOnConversationHasRead = @"onConversationHasRead";



#pragma mark - EMMessageListener
static NSString *const ChatOnMessageProgressUpdate = @"onMessageProgressUpdate";
static NSString *const ChatOnMessageSuccess = @"onMessageSuccess";
static NSString *const ChatOnMessageError = @"onMessageError";
static NSString *const ChatOnMessageReadAck = @"onMessageReadAck";
static NSString *const ChatOnMessageDeliveryAck = @"onMessageDeliveryAck";


#pragma mark - EMConversationWrapper

static NSString *const ChatGetLatestMsg = @"getLatestMessage";
static NSString *const ChatGetLatestMsgFromOthers = @"getLatestMessageFromOthers";


#pragma mark - EMChatroomManagerWrapper

static NSString *const ChatJoinChatRoom = @"joinChatRoom";
static NSString *const ChatLeaveChatRoom = @"leaveChatRoom";
static NSString *const ChatGetChatroomsFromServer = @"fetchPublicChatRoomsFromServer";
static NSString *const ChatFetchChatRoomFromServer = @"fetchChatRoomInfoFromServer";
static NSString *const ChatGetChatRoom = @"getChatRoom";
static NSString *const ChatGetAllChatRooms = @"getAllChatRooms";

static NSString *const ChatGetChatroomMemberListFromServer = @"fetchChatRoomMembers";

static NSString *const ChatFetchChatroomAnnouncement = @"fetchChatRoomAnnouncement";

static NSString *const ChatChatroomChanged = @"onChatRoomChanged";

#pragma mark - HandleAction
static NSString *const ChatStartCallback = @"startCallback";

static NSString *const ChatConversationDeleteServerMessageWithTime = @"conversationDeleteServerMessageWithTime";
static NSString *const ChatUpdateUsingHttpsOnlySetting = @"updateUsingHttpsOnlySetting";
static NSString *const ChatUpdateDeleteMessageWhenLeaveRoomSetting = @"updateDeleteMessageWhenLeaveRoomSetting";
static NSString *const ChatUpdateRoomOwnerCanLeaveSetting = @"updateRoomOwnerCanLeaveSetting";
static NSString *const ChatUpdateAutoDownloadAttachmentThumbnailSetting = @"updateAutoDownloadAttachmentThumbnailSetting";
static NSString *const ChatUpdateRequireAckSetting = @"updateRequireAckSetting";
static NSString *const ChatUpdateDeliveryAckSetting = @"updateDeliveryAckSetting";
static NSString *const ChatUpdateSortMessageByServerTimeSetting = @"updateSortMessageByServerTimeSetting";
