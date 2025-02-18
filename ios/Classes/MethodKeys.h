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
//static NSString *const ChatLoginWithAgoraToken = @"loginWithAgoraToken";
static NSString *const ChatLogout = @"logout";
//static NSString *const ChatChangeAppKey = @"changeAppKey";

static NSString *const ChatUploadLog = @"uploadLog";
static NSString *const ChatCompressLogs = @"compressLogs";
//static NSString *const ChatKickDevice = @"kickDevice";
//static NSString *const ChatKickAllDevices = @"kickAllDevices";
//static NSString *const ChatGetLoggedInDevicesFromServer = @"getLoggedInDevicesFromServer";

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
//static NSString *const ChatResendMessage = @"resendMessage";
static NSString *const ChatAckMessageRead = @"ackMessageRead";
//static NSString *const ChatAckGroupMessageRead = @"ackGroupMessageRead";
static NSString *const ChatAckConversationRead = @"ackConversationRead";
static NSString *const ChatRecallMessage = @"recallMessage";
static NSString *const ChatGetConversation = @"getConversation";
//static NSString *const ChatGetThreadConversation = @"getThreadConversation";
//static NSString *const ChatMarkAllChatMsgAsRead = @"markAllChatMsgAsRead";
static NSString *const ChatGetUnreadMessageCount = @"getUnreadMessageCount";
//static NSString *const ChatUpdateChatMessage = @"updateChatMessage";
static NSString *const ChatDownloadAttachment = @"downloadAttachment";
static NSString *const ChatDownloadThumbnail = @"downloadThumbnail";
static NSString *const ChatDownloadMessageAttachmentInCombine = @"downloadMessageAttachmentInCombine";
static NSString *const ChatDownloadMessageThumbnailInCombine = @"downloadMessageThumbnailInCombine";
//static NSString *const ChatImportMessages = @"importMessages";
//static NSString *const ChatLoadAllConversations = @"loadAllConversations";
//static NSString *const ChatGetConversationsFromServer = @"getConversationsFromServer";

static NSString *const ChatDeleteConversation = @"deleteConversation";
//static NSString *const ChatFetchHistoryMessages = @"fetchHistoryMessages";
static NSString *const ChatFetchHistoryMessagesByOptions = @"fetchHistoryMessagesByOptions";
//static NSString *const ChatSearchChatMsgFromDB = @"searchChatMsgFromDB";
static NSString *const ChatGetMessage = @"getMessage";
//static NSString *const ChatAsyncFetchGroupAcks = @"asyncFetchGroupAcks";
static NSString *const ChatDeleteRemoteConversation = @"deleteRemoteConversation";
//static NSString *const ChatDeleteMessagesBeforeTimestamp = @"deleteMessagesBeforeTimestamp";

//static NSString *const ChatTranslateMessage = @"translateMessage";
//static NSString *const ChatFetchSupportedLanguages = @"fetchSupportLanguages";

//static NSString *const ChatAddReaction = @"addReaction";
//static NSString *const ChatRemoveReaction = @"removeReaction";
//static NSString *const ChatFetchReactionList = @"fetchReactionList";
//static NSString *const ChatFetchReactionDetail = @"fetchReactionDetail";
//static NSString *const ChatReportMessage = @"reportMessage";
//static NSString *const ChatFetchConversationsFromServerWithPage = @"fetchConversationsFromServerWithPage";
//static NSString *const ChatRemoveMessagesFromServerWithMsgIds = @"removeMessagesFromServerWithMsgIds";
static NSString *const ChatRemoveMessagesFromServerWithTs = @"removeMessagesFromServerWithTs";

static NSString *const GetConversationsFromServerWithCursor = @"getConversationsFromServerWithCursor";
static NSString *const GetPinnedConversationsFromServerWithCursor = @"getPinnedConversationsFromServerWithCursor";
static NSString *const PinConversation = @"pinConversation";
//static NSString *const modifyMessage = @"modifyMessage";
//static NSString *const downloadAndParseCombineMessage = @"downloadAndParseCombineMessage";


#pragma mark - EMChatManagerDelegate
static NSString *const ChatOnMessagesReceived = @"onMessagesReceived";
static NSString *const ChatOnCmdMessagesReceived = @"onCmdMessagesReceived";
static NSString *const ChatOnMessagesRead = @"onMessagesRead";
//static NSString *const ChatOnGroupMessageRead = @"onGroupMessageRead";
//static NSString *const ChatOnReadAckForGroupMessageUpdated = @"onReadAckForGroupMessageUpdated";
static NSString *const ChatOnMessagesDelivered = @"onMessagesDelivered";
static NSString *const ChatOnMessagesRecalled = @"onMessagesRecalled";

static NSString *const ChatOnConversationUpdate = @"onConversationUpdate";
static NSString *const ChatOnConversationHasRead = @"onConversationHasRead";

//static NSString *const ChatOnMessageReactionDidChange = @"messageReactionDidChange";

static NSString *const onMessageContentChanged = @"onMessageContentChanged";



#pragma mark - EMMessageListener
static NSString *const ChatOnMessageProgressUpdate = @"onMessageProgressUpdate";
static NSString *const ChatOnMessageSuccess = @"onMessageSuccess";
static NSString *const ChatOnMessageError = @"onMessageError";
static NSString *const ChatOnMessageReadAck = @"onMessageReadAck";
static NSString *const ChatOnMessageDeliveryAck = @"onMessageDeliveryAck";


#pragma mark - EMConversationWrapper

static NSString *const ChatGetUnreadMsgCount = @"getUnreadMsgCount";
//static NSString *const ChatMarkAllMsgsAsRead = @"markAllMessagesAsRead";
//static NSString *const ChatMarkMsgAsRead = @"markMessageAsRead";
//static NSString *const ChatSyncConversationExt = @"syncConversationExt";
//static NSString *const ChatRemoveMsg = @"removeMessage";
//static NSString *const ChatDeleteMessageByIds = @"deleteMessageByIds";
static NSString *const ChatGetLatestMsg = @"getLatestMessage";
static NSString *const ChatGetLatestMsgFromOthers = @"getLatestMessageFromOthers";
//static NSString *const ChatClearAllMsg = @"clearAllMessages";
//static NSString *const ChatDeleteMessagesWithTs = @"deleteMessagesWithTs";
//static NSString *const ChatInsertMsg = @"insertMessage";
//static NSString *const ChatAppendMsg = @"appendMessage";
//static NSString *const ChatUpdateConversationMsg = @"updateConversationMessage";

//static NSString *const ChatLoadMsgWithId = @"loadMsgWithId";
//static NSString *const ChatLoadMsgWithStartId = @"loadMsgWithStartId";
//static NSString *const ChatLoadMsgWithKeywords = @"loadMsgWithKeywords";
//static NSString *const ChatLoadMsgWithMsgType = @"loadMsgWithMsgType";
//static NSString *const ChatLoadMsgWithTime = @"loadMsgWithTime";
//static NSString *const ChatConversationMessageCount = @"messageCount";
//static NSString *const ChatRemoveMsgFromServerWithMsgList = @"removeMsgFromServerWithMsgList";
//static NSString *const ChatRemoveMsgFromServerWithTimeStamp = @"removeMsgFromServerWithTimeStamp";

#pragma mark - EMChatMessageWrapper
//static NSString *const ChatGetReactionList = @"getReactionList";
//static NSString *const ChatGroupAckCount = @"groupAckCount";
//static NSString *const ChatThread = @"chatThread";



#pragma mark - EMChatroomManagerWrapper

static NSString *const ChatJoinChatRoom = @"joinChatRoom";
static NSString *const ChatLeaveChatRoom = @"leaveChatRoom";
static NSString *const ChatGetChatroomsFromServer = @"fetchPublicChatRoomsFromServer";
static NSString *const ChatFetchChatRoomFromServer = @"fetchChatRoomInfoFromServer";
static NSString *const ChatGetChatRoom = @"getChatRoom";
static NSString *const ChatGetAllChatRooms = @"getAllChatRooms";
//static NSString *const ChatCreateChatRoom = @"createChatRoom";
//static NSString *const ChatDestroyChatRoom = @"destroyChatRoom";
//static NSString *const ChatChatRoomUpdateSubject = @"changeChatRoomSubject";
//static NSString *const ChatChatRoomUpdateDescription = @"changeChatRoomDescription";
static NSString *const ChatGetChatroomMemberListFromServer = @"fetchChatRoomMembers";
//static NSString *const ChatChatRoomMuteMembers = @"muteChatRoomMembers";
//static NSString *const ChatChatRoomUnmuteMembers = @"unMuteChatRoomMembers";
//static NSString *const ChatChangeChatRoomOwner = @"changeChatRoomOwner";
//static NSString *const ChatChatRoomAddAdmin = @"addChatRoomAdmin";
//static NSString *const ChatChatRoomRemoveAdmin = @"removeChatRoomAdmin";
//static NSString *const ChatGetChatroomMuteListFromServer = @"fetchChatRoomMuteList";
//static NSString *const ChatChatRoomRemoveMembers = @"removeChatRoomMembers";
//static NSString *const ChatChatRoomBlockMembers = @"blockChatRoomMembers";
//static NSString *const ChatChatRoomUnblockMembers = @"unBlockChatRoomMembers";
//static NSString *const ChatFetchChatroomBlockListFromServer = @"fetchChatRoomBlockList";
//static NSString *const ChatUpdateChatRoomAnnouncement = @"updateChatRoomAnnouncement";
static NSString *const ChatFetchChatroomAnnouncement = @"fetchChatRoomAnnouncement";

//static NSString *const ChatAddMembersToChatRoomWhiteList = @"addMembersToChatRoomWhiteList";
//static NSString *const ChatRemoveMembersFromChatRoomWhiteList = @"removeMembersFromChatRoomWhiteList";
//static NSString *const ChatFetchChatRoomWhiteListFromServer = @"fetchChatRoomWhiteListFromServer";
//static NSString *const ChatIsMemberInChatRoomWhiteListFromServer = @"isMemberInChatRoomWhiteListFromServer";

//static NSString *const ChatMuteAllChatRoomMembers = @"muteAllChatRoomMembers";
//static NSString *const ChatUnMuteAllChatRoomMembers = @"unMuteAllChatRoomMembers";
//static NSString *const ChatFetchChatRoomAttributes = @"fetchChatRoomAttributes";
//static NSString *const ChatSetChatRoomAttributes = @"setChatRoomAttributes";
//static NSString *const ChatRemoveChatRoomAttributes  = @"removeChatRoomAttributes";

static NSString *const ChatChatroomChanged = @"onChatRoomChanged";

#pragma mark - HandleAction
static NSString *const ChatStartCallback = @"startCallback";


// 450
//static NSString *const getPinInfo = @"getPinInfo";
//static NSString *const pinnedMessages = @"pinnedMessages";
//static NSString *const onMessagePinChanged = @"onMessagePinChanged";
//static NSString *const addRemoteAndLocalConversationsMark = @"addRemoteAndLocalConversationsMark";
//static NSString *const deleteRemoteAndLocalConversationsMark = @"deleteRemoteAndLocalConversationsMark";
//static NSString *const fetchConversationsByOptions = @"fetchConversationsByOptions";
//static NSString *const deleteAllMessageAndConversation = @"deleteAllMessageAndConversation";
//static NSString *const pinMessage = @"pinMessage";
//static NSString *const unpinMessage = @"unpinMessage";
//static NSString *const fetchPinnedMessages = @"fetchPinnedMessages";


// 460
static NSString *const onMessagesRecalledInfo = @"onMessagesRecalledInfo";

#pragma mark 481
//static NSString *const ChatConversationRemindType = @"conversationRemindType";
//static NSString *const ChatConversationSearchMsgsByOptions = @"conversationSearchMsgsByOptions";
//static NSString *const ChatConversationGetLocalMessageCount = @"conversationGetLocalMessageCount";
//static NSString *const ChatConversationDeleteServerMessageWithIds = @"conversationDeleteServerMessageWithIds";
static NSString *const ChatConversationDeleteServerMessageWithTime = @"conversationDeleteServerMessageWithTime";
//static NSString *const ChatSearchMsgsByOptions = @"searchMsgsByOptions";
//static NSString *const ChatSyncSilentModels = @"syncSilentModels";
//static NSString *const ChatClearAllGroupsFromDB = @"clearAllGroupsFromDB";
static NSString *const ChatUpdateUsingHttpsOnlySetting =
    @"updateUsingHttpsOnlySetting";
//static NSString *const ChatUpdateLoginExtensionInfo = @"updateLoginExtensionInfo";
//static NSString *const ChatUpdateDeleteMessagesWhenLeaveGroupSetting =
//    @"updateDeleteMessagesWhenLeaveGroupSetting";
static NSString *const ChatUpdateDeleteMessageWhenLeaveRoomSetting =
    @"updateDeleteMessageWhenLeaveRoomSetting";
static NSString *const ChatUpdateRoomOwnerCanLeaveSetting =
    @"updateRoomOwnerCanLeaveSetting";
//static NSString *const ChatUpdateAutoAcceptGroupInvitationSetting =
//    @"updateAutoAcceptGroupInvitationSetting";
//static NSString *const ChatUpdateAcceptInvitationAlways = @"acceptInvitationAlways";
static NSString *const ChatUpdateAutoDownloadAttachmentThumbnailSetting =
    @"updateAutoDownloadAttachmentThumbnailSetting";
static NSString *const ChatUpdateRequireAckSetting = @"updateRequireAckSetting";
static NSString *const ChatUpdateDeliveryAckSetting = @"updateDeliveryAckSetting";
static NSString *const ChatUpdateSortMessageByServerTimeSetting =
    @"updateSortMessageByServerTimeSetting";
//static NSString *const ChatUpdateMessagesReceiveCallbackIncludeSendSetting =
//    @"updateMessagesReceiveCallbackIncludeSendSetting";
//static NSString *const ChatUpdateRegradeMessagesSetting =
//    @"updateRegradeMessagesSetting";
//static NSString *const bindDeviceToken = @"bindDeviceToken";


// 4.10
//static NSString *const onOfflineMessageSyncStart = @"onOfflineMessageSyncStart";
//static NSString *const onOfflineMessageSyncFinish = @"onOfflineMessageSyncFinish";
//static NSString *const getMessageCount = @"getMessageCount";
//static NSString *const isMemberInGroupMuteList = @"isMemberInGroupMuteList";


// shengwang
//static NSString *const changeAppId = @"changeAppId";
