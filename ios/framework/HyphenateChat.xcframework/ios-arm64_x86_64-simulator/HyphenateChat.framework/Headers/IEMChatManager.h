/**
 *  \~chinese
 *  @header IEMChatManager.h
 *  @abstract 聊天相关操作代理协议。
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMChatManager.h
 *  @abstract This protocol defines the operations of chat.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"
#import "EMChatManagerDelegate.h"
#import "EMConversation.h"

#import "EMChatMessage.h"
#import "EMTextMessageBody.h"
#import "EMLocationMessageBody.h"
#import "EMCmdMessageBody.h"
#import "EMFileMessageBody.h"
#import "EMImageMessageBody.h"
#import "EMVoiceMessageBody.h"
#import "EMVideoMessageBody.h"
#import "EMCustomMessageBody.h"
#import "EMCursorResult.h"

#import "EMFetchServerMessagesOption.h"

/**
 *  \~chinese
 *  漫游消息的拉取方向枚举类型。
 *
 *  \~english
 *  The directions in which historical messages are retrieved from the server.
 */
typedef NS_ENUM(NSUInteger, EMMessageFetchHistoryDirection) {
    EMMessageFetchHistoryDirectionUp  = 0,    /** \~chinese SDK 按消息中的时间戳的逆序查询。  \~english The SDK retrieves messages in the descending order of the timestamp included in them.*/
    EMMessageFetchHistoryDirectionDown        /** \~chinese SDK 按消息中的时间戳的正序查询。 \~english The SDK retrieves messages in the ascending order of the timestamp included in them. 
 **/
};


@class EMError;

/**
 *  \~chinese
 *  聊天相关操作代理协议。
 * 
 *  消息都是从本地数据库中加载，不是从服务端加载。
 *
 *  \~english
 *  This protocol that defines the operations of chat.
 * 
 *  Messages are loaded from the local database, not from the server.
 */
@protocol IEMChatManager <NSObject>

@required

#pragma mark - Delegate

/**
 *  \~chinese
 *  添加回调代理。
 *
 *  @param aDelegate  实现代理协议的对象。
 *  @param aQueue     执行代理方法的队列。若在主线程上运行 app，将该参数设置为空。
 *
 *  \~english
 *  Adds a delegate.
 *
 *  @param aDelegate  The object that implements the protocol.
 *  @param aQueue     (optional) The queue of calling delegate methods. If you want to run the app on the main thread, set this parameter as nil.
 */
- (void)addDelegate:(id<EMChatManagerDelegate> _Nullable)aDelegate
      delegateQueue:(dispatch_queue_t _Nullable)aQueue;

/**
 *  \~chinese
 *  移除回调代理。
 *
 *  @param aDelegate  要移除的代理。
 *
 *  \~english
 *  Removes a delegate.
 *
 *  @param aDelegate  The delegate to be removed.
 */
- (void)removeDelegate:(id<EMChatManagerDelegate> _Nonnull)aDelegate;

#pragma mark - Conversation

/**
 *  \~chinese
 *  获取本地所有会话。
 * 
 * 该方法会先从内存中获取，如果未找到任何会话，从本地数据库获取。
 *
 *  @result 会话列表，NSArray<EMConversation *> * 类型。
 *
 *  \~english
 *  Gets all local conversations. 
 * 
 * The SDK loads the conversations from the memory first. If no conversation is found in the memory, the SDK loads from the local database.
 *
 *  @result The conversation list of the NSArray<EMConversation *> * type.
 */
- (NSArray<EMConversation *> * _Nullable)getAllConversations;

/**
 *  \~chinese
 * 分页从服务器获取获取会话列表。
 * 
 * SDK 按照会话活跃时间（会话的最后一条消息的时间戳）倒序返回会话列表。
 * 
 * 若会话中没有消息，则 SDK 按照会话创建时间的倒序返回会话列表。
 *
 *  @param cursor 查询的开始位置。若传入 `nil` 或 `@""`，SDK 从最新活跃的会话开始获取。
 *  @param pageSize 每页期望返回的会话数量。取值范围为 [1,50]。
 *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 * Get the list of conversations from the server with pagination.
 * 
 * The SDK retrieves the list of conversations in the reverse chronological order of their active time (the timestamp of the last message). 
 *
 * If there is no message in the conversation, the SDK retrieves the list of conversations in the reverse chronological order of their creation time.
 *
 *  @param cursor The position from which to start getting data. If you pass in `nil` or `@""`, the SDK retrieves conversations from the latest active one.
 *  @param pageSize The number of conversations that you expect to get on each page. The value range is [1,50].
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)getConversationsFromServerWithCursor:(nullable NSString *)cursor pageSize:(UInt8)pageSize completion:(nonnull void (^)(EMCursorResult<EMConversation *> * _Nullable result, EMError * _Nullable error))completionBlock;

/**
 *  \~chinese
 *  分页从服务器获取置顶会话。
 * 
 *  SDK 按照会话的置顶时间的倒序返回会话列表。
 *
 *  @param cursor 查询的开始位置。若传 `nil` 或 `@""`，SDK 从最新置顶的会话开始查询。
 *  @param pageSize 每页期望返回的会话数量。取值范围为 [1,50]。
 *  @param completionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Gets the list of pinned conversations from the server with pagination.
 * 
 *  The SDK returns the pinned conversations in the reverse chronological order of their pinning.
 *
 *  @param cursor The position from which to start getting data. If you pass in `nil` or `@""`, the SDK retrieves conversations from the latest pinned one.
 *  @param pageSize The number of conversations that you expect to get on each page. The value range is [1,50].
 *  @param completionBlock The completion block, which contains the error message if the method fails.
 */
- (void)getPinnedConversationsFromServerWithCursor:(nullable NSString *)cursor pageSize:(UInt8)limit completion:(nonnull void (^)(EMCursorResult<EMConversation *> * _Nullable result, EMError * _Nullable error))completionBlock;

/**
 *  \~chinese
 *  设置是否置顶会话。
 * 
 *  @param conversationId 会话 ID。
 *  @param isPinned 是否置顶会话：
 *       - YES：置顶；
 *       - NO：取消置顶。
 *  @param callback 设置是否置顶会话的结果回调。
 *
 *  \~english
 *  Sets whether to pin a conversation.
 *
 *  @param conversationId  The conversation ID.
 *  @param isPinned Whether to pin a conversation: 
	 *                - `true`：Yes. 
	 *              	- `false`: No. The conversation is unpinned.
 *  @param completionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)pinConversation:(nonnull NSString *)conversationId isPinned:(BOOL)isPinned completionBlock:(nullable void(^)(EMError * _Nullable error))completionBlock;

/**
 *  \~chinese
 *  从本地数据库中获取一个已存在的会话。
 *
 *  @param aConversationId  会话 ID。
 *
 *  @result 会话对象。
 *
 *  \~english
 *  Gets a conversation from the local database. 
 *
 *  @param aConversationId  The conversation ID.
 *
 *  @result The conversation object.
 */
- (EMConversation *_Nullable)getConversationWithConvId:(NSString * _Nullable)aConversationId;

/**
 *  \~chinese
 *  获取一个会话。
 *
 *  @param aConversationId  会话 ID。
 *  @param aType            会话类型。
 *  @param aIfCreate        若该会话不存在是否创建：
 *                          - `YES`：是；
 *                          - `NO`：否。
 *
 *  @result 会话对象。
 *
 *  \~english
 *  Gets a conversation from the local database.
 *
 *  @param aConversationId  The conversation ID.
 *  @param aType            The conversation type. 
 *  @param aIfCreate        Whether to create the conversation if it does not exist:
 *                          - `YES`: Yes;
 *                          - `NO`: No.
 * 
 *  @result The conversation object.
 */
- (EMConversation *_Nullable)getConversation:(NSString *_Nonnull)aConversationId
                               type:(EMConversationType)aType
                   createIfNotExist:(BOOL)aIfCreate;

/**
 *  \~chinese
 *  从本地数据库中删除一个会话。
 *
 *  @param aConversationId      会话 ID。
 *  @param aIsDeleteMessages    是否删除会话中的消息。
 * - `YES`: 是；
 * - `NO`: 否。
 *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Deletes a conversation from the local database.
 * 
 *  @param aConversationId      The conversation ID.
 *  @param aIsDeleteMessages    Whether to delete the messages in the conversation.
 *  - `YES`: Yes;
 *  - `NO`: No.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method call fails.
 *
 */
- (void)deleteConversation:(NSString * _Nonnull)aConversationId
          isDeleteMessages:(BOOL)aIsDeleteMessages
                completion:(void (^_Nullable)(NSString * _Nullable aConversationId, EMError *_Nullable aError))aCompletionBlock;

/*!
  *  \~chinese
  *  删除服务器会话。
  *
  *  @param aConversationId      会话 ID。
  *  @param aConversationType    会话类型。
  *  @param aIsDeleteMessages    是否同时删除会话中的消息。
  *   - `YES`: 是；
  *   - `NO`: 否。
  *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
  *
  *  \~english
  *  Deletes a conversation from the server.
  *
  *  @param aConversationId      The conversation ID.
  *  @param aConversationType    The conversation type.
  *  @param aIsDeleteMessages    Whether to delete the related messages with the conversation.
  *                          - `YES`: Yes;
  *                          - `NO`: No.
  *  @param aCompletionBlock     The completion block, which contains the error message if the method call fails.
  *
  */
 - (void)deleteServerConversation:(NSString * _Nonnull)aConversationId
                 conversationType:(EMConversationType)aConversationType
           isDeleteServerMessages:(BOOL)aIsDeleteServerMessages
                       completion:(void (^_Nullable)(NSString * _Nullable aConversationId, EMError * _Nullable aError))aCompletionBlock;

#pragma mark - Message

/**
 *  \~chinese
 *  获取指定的消息。
 * 
 *  @param  aMessageId   消息 ID。
 * 
 *  @result   获取到的消息。
 *
 *  \~english
 *  Gets the specified message.
 *
 *  @param aMessageId    The message ID.
 *  @result EMChatMessage     The message content.
 */
- (EMChatMessage * _Nullable)getMessageWithMessageId:(NSString * _Nonnull)aMessageId;

/**
 *  \~chinese
 *  发送消息已读回执。
 *
 *  异步方法。
 *
 *  @param aMessage             消息 ID。
 *  @param aUsername            已读回执的接收方。
 *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Sends the read receipt for a message.
 * 
 *  This is an asynchronous method.
 *
 *  @param aMessageId           The message ID.
 *  @param aUsername            The user ID of the recipient of the read receipt.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)sendMessageReadAck:(NSString * _Nonnull)aMessageId
                    toUser:(NSString * _Nonnull)aUsername
                completion:(void (^_Nullable)(EMError *_Nullable aError))aCompletionBlock;

/**
 *  \~chinese
 *  发送会话已读回执。
 *  
 *  该方法仅适用于单聊会话。
 *  
 *  发送会话已读回执会通知服务器将指定的会话未读消息数置为 0。调用该方法后对方会收到 onConversationRead 回调。
 * 
 *  对话方（包含多端多设备）将会在回调方法 EMChatManagerDelegate onConversationRead(String, String) 中接收到回调。
 *
 *  为了减少调用次数，我们建议在进入聊天页面有大量未读消息时调用该方法，在聊天过程中调用 `sendMessageReadAck` 方法发送消息已读回执。
 *  
 *
 *  异步方法。
 *
 *  @param conversationId         会话 ID。
 *  @param aCompletionBlock       该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Sends the conversation read receipt to the server.
 * 
 *  This method applies to one-to-one chats only.
 * 
 *  This method call notifies the server to set the number of unread messages of the specified conversation as 0, and triggers the onConversationRead callback on the recipient's client.
 *
 *  To reduce the number of method calls, we recommend that you call this method when the user enters a conversation with many unread messages, and call `sendMessageReadAck` during a conversation to send the message read receipts.
 * 
 *  This is an asynchronous method.
 * 
 *  @param conversationId          The conversation ID.
 *  @param aCompletionBlock        The completion block, which contains the error message if the method fails.
 * 
 */
- (void)ackConversationRead:(NSString * _Nonnull)conversationId
                 completion:(void (^_Nullable)(EMError *_Nullable aError))aCompletionBlock;

/**
 *  \~chinese
 *  撤回一条消息。
 *
 *  异步方法。
 *
 *  @param aMessageId           消息 ID。
 *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Recalls a message.
 *
 *  This is an asynchronous method.
 *
 *  @param aMessageId           The message ID
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)recallMessageWithMessageId:(NSString *_Nonnull)aMessageId
                        completion:(void (^_Nullable)(EMError *_Nullable aError))aCompletionBlock;


/**
 *  \~chinese
 *  发送消息。
 * 
 *  异步方法。
 *
 *  @param aMessage         消息。
 *  @param aProgressBlock   附件上传进度回调 block。进度值范围为 [0,100]。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Sends a message.
 * 
 *  This is an asynchronous method.
 *
 *  @param aMessage             The message instance.
 *  @param aProgressBlock       The callback block of attachment upload progress. The progress value range is [0,100].
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)sendMessage:(EMChatMessage *_Nonnull)aMessage
           progress:(void (^_Nullable)(int progress))aProgressBlock
         completion:(void (^_Nullable)(EMChatMessage *_Nullable message, EMError *_Nullable error))aCompletionBlock;


/**
 *  \~chinese
 *  下载缩略图（图片缩略图或视频的第一帧图片）。
 * 
 *  SDK 会自动下载缩略图。如果自动下载失败，你可以调用该方法下载缩略图。
 *
 *  @param aMessage            消息对象。
 *  @param aProgressBlock      附件下载进度回调 block。进度值的范围为 [0,100]。
 *  @param aCompletionBlock    该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Downloads the message thumbnail (the thumbnail of an image or the first frame of a video).
 * 
 *  The SDK automatically downloads the thumbnail. If the auto-download fails, you can call this method to manually download the thumbnail.
 *
 *  @param aMessage             The message object.
 *  @param aProgressBlock       The callback block of attachment download progress. The progress value range is [0,100].
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)downloadMessageThumbnail:(EMChatMessage *_Nonnull)aMessage
                        progress:(void (^_Nullable)(int progress))aProgressBlock
                      completion:(void (^_Nullable)(EMChatMessage *_Nullable message, EMError *_Nullable error))aCompletionBlock;

/**
 *  \~chinese
 *  下载消息附件（语音、视频、图片原图、文件）。
 * 
 *  SDK 会自动下载语音消息。如果自动下载失败，你可以调用该方法。
 *
 *  异步方法。
 *
 *  @param aMessage            消息。
 *  @param aProgressBlock      附件下载进度回调 block。进度值的范围为 [0,100]。
 *  @param aCompletionBlock    该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Downloads message attachment (voice, video, image or file). 
 *  
 *  The SDK automatically downloads voice messages. If the automatic download fails, you can call this method to download voice messages manually.
 *
 *  This is an asynchronous method.
 * 
 *  @param aMessage             The message object.
 *  @param aProgressBlock       The callback block of attachment download progress. The progress value range is [0,100].
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)downloadMessageAttachment:(EMChatMessage *_Nonnull)aMessage
                         progress:(void (^_Nullable)(int progress))aProgressBlock
                       completion:(void (^_Nullable)(EMChatMessage *_Nullable message, EMError *_Nullable error))aCompletionBlock;


/**
 *  \~chinese
 *  从会话中删除消息（包括本地存储和服务器）。
 * 
 *  @param conversation 会话对象 EMConversation。
 *  @param beforeTimeStamp   指定的时间戳，单位为毫秒。该时间戳之前的消息会被删除。
 *  @param completion    该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Removes messages in a conversation (from both local storage and the server).
 *
 *  @param conversation The EMConversation object.
 *  @param messageIds   The specified Unix timestamp in miliseconds. Messages with a timestamp before the specified one will be removed from the conversation.
 *  @param completion   The completion block, which contains the error message if the method fails.
 *
 */
- (void)removeMessagesFromServerWithConversation:(EMConversation *_Nonnull)conversation timeStamp:(NSTimeInterval)beforeTimeStamp completion:(void (^ _Nullable)(EMError * _Nullable aError))aCompletionBlock;


NS_ASSUME_NONNULL_BEGIN

/**
 *  \~chinese
 *  根据消息拉取参数配置接口（`EMFetchServerMessagesOption`）从服务器分页获取指定会话的历史消息。
 *
 *  @param conversationId 会话 ID。
 *  @param type 会话类型，只支持单聊（`EMConversationTypeChat`）和群组（`EMConversationTypeGroupChat`）。
 *  @param cursor 查询的起始游标位置。
 *  @param pageSize 每页期望获取的消息条数。取值范围为 [1,50]。
 *  @param option  查询历史消息的参数配置接口，详见 {@link EMFetchServerMessagesOption}。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *
 *  @param conversationId The conversation ID, which is the user ID of the peer user for one-to-one chat, but the group ID for group chat.
 *  @param type The conversation type. You can set this parameter only to `EMConversationTypeChat` (one-to-one chat) or `EMConversationTypeGroupChat` (group chat).
 *  @param cursor The cursor position from which to start querying data.
 *  @param pageSize The number of messages that you expect to get on each page. The value range is [1,50].
 *  @param option  The parameter configuration class for pulling historical messages from the server. See {@link EMFetchServerMessagesOption}.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)fetchMessagesFromServerBy:(NSString* )conversationId
                 conversationType:(EMConversationType)type
                           cursor:(NSString* _Nullable)cursor
                         pageSize:(NSUInteger)pageSize
                           option:(EMFetchServerMessagesOption* _Nullable)option
                       completion:(void (^_Nullable)(EMCursorResult<EMChatMessage*>* _Nullable result, EMError* _Nullable aError))aCompletionBlock;

NS_ASSUME_NONNULL_END
@end
