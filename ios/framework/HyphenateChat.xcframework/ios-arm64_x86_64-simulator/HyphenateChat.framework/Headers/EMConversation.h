/**
 *  \~chinese
 *  @header EMConversation.h
 *  @abstract 聊天会话类。
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMConversation.h
 *  @abstract Chat conversation
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMMessageBody.h"
#import "EMCursorResult.h"

/**
 *  \~chinese
 *  会话枚举类型。
 *
 *  \~english
 *  The conversation types.
 */
typedef NS_ENUM(NSInteger, EMConversationType) {
    EMConversationTypeChat = 0,    /** \~chinese 单聊。  \~english One-to-one chat. */
    EMConversationTypeGroupChat,    /** \~chinese 群聊。  \~english Group chat.*/
    EMConversationTypeChatRoom,      /** \~chinese 聊天室。 \~english Chat room.*/
};

/**
 *  \~chinese
 *  消息搜索方向枚举类型。
 * 
 * 消息搜索基于消息中包含的 Unix 时间戳。每个消息中包含两个 Unix 时间戳：
 * - 消息创建的 Unix 时间戳；
 * - 服务器接收消息的 Unix 时间戳。
 * 消息搜索基于哪个 Unix 时间戳取决于 {@link EMOptions#sortMessageByServerTime} 的设置。
 *
 *  \~english
 *  The message search directions.
 * 
 * The message research is based on the Unix timestamp included in messages. Each message contains two Unix timestamps:
 * - The Unix timestamp when the message is created;
 * - The Unix timestamp when the message is received by the server.
 *
 * Which Unix timestamp is used for message search depends on the setting of {@link EMOptions#sortMessageByServerTime}.
 */
typedef NS_ENUM(NSInteger, EMMessageSearchDirection) {
    EMMessageSearchDirectionUp  = 0,    /** \~chinese 按消息中的时间戳的倒序搜索。  \~english Messages are retrieved in the descending order of the timestamp included in them.*/
    EMMessageSearchDirectionDown        /** \~chinese 按消息中的时间戳的顺序搜索。 \~english The Messages are retrieved in the ascending order of the timestamp included in them.*/
};

@class EMChatMessage;
@class EMError;

/**
 *  \~chinese
 *  聊天会话类。
 *
 *  \~english
 *  The chat conversation class.
 */
@interface EMConversation : NSObject

/**
 *  \~chinese
 *  会话 ID。
 *  - 单聊：会话 ID 为对方的用户 ID。
 *  - 群聊：会话 ID 为群组 ID。
 *  - 聊天室：会话 ID 为聊天室的 ID。
 *
 *  \~english
 *  The conversation ID.
*   - One-to-one chat: The conversation ID is the user ID of the peer user.
*   - Group chat: The conversation ID is the group ID.
*   - Chat room: The conversation ID is the chat room ID.
 */
@property (nonatomic, copy, readonly) NSString *conversationId;

/**
 *  \~chinese
 *  会话类型。
 *
 *  \~english
 *  The conversation type.
 */
@property (nonatomic, assign, readonly) EMConversationType type;

/**
 *  \~chinese
 *  会话中未读取的消息数量。
 *
 *  \~english
 *  The number of unread messages in the conversation.
 */
@property (nonatomic, assign, readonly) int unreadMessagesCount;

/**
 *  \~chinese
 *  会话中的消息数量。
 *
 *  \~english
 *  The message count in the conversation.
 */
@property (nonatomic, assign, readonly) int messagesCount;

/**
 *  \~chinese
 *  会话扩展属性。
 * 
 *  子区功能目前版本暂不可设置。
 *
 *  \~english
 *  The conversation extension attribute. 
 * 
 *  This attribute is not available for thread conversations.
 */
@property (nonatomic, copy)   NSDictionary *ext;

/*!
 *  \~chinese
 *  是否为 thread 会话：
 * - `YES`：是
 * - `NO`：否
 *
 *  \~english
 *  Whether the conversation is a thread conversation:
 * - `YES`：Yes
 * - `NO`：No
 */
@property (nonatomic, assign) BOOL isChatThread;

/*!
 *  \~chinese
 *  是否为置顶会话：
 * - `YES`：是
 * - `NO`：否
 *
 *  \~english
 *  Whether the conversation is pinned:
 * - `YES`：Yes
 * - `NO`：No
 */
@property (readonly) BOOL isPinned;

/*!
 *  \~chinese
 *  会话置顶的 UNIX 时间戳，单位为毫秒。未置顶时值为 `0`。
 *
 *  \~english
 *  The UNIX timestamp when the conversation is pinned. The unit is millisecond. This value is `0` when the conversation is not pinned.   
 */
@property (readonly) int64_t pinnedTime;

/*!
 *  \~chinese
 *  会话中的最新一条消息。
 *
 *  \~english
 *  The latest message in the conversation.
 */
@property (nonatomic, strong, readonly) EMChatMessage *latestMessage;

/**
 *  \~chinese
 *  收到的对方发送的最后一条消息。
 *
 *  @result 消息实例。
 *
 *  \~english
 *  Gets the last received message.
 *
 *  @result The message instance.
 */
- (EMChatMessage * _Nullable)lastReceivedMessage;

/**
 *  \~chinese
 *  插入一条消息在 SDK 本地数据库
 * 
 *  消息的会话 ID 应与会话的 ID 保持一致。
 * 
 * 消息会根据消息里的时间戳被插入 SDK 本地数据库，SDK 会更新会话的 `latestMessage` 等属性。
 *
 *  @param aMessage 消息实例。
 *  @param pError   错误信息。
 *
 *  \~english
 *  Inserts a message to a conversation in the local database.
 * 
 *  To insert the message correctly, ensure that the conversation ID of the message is the same as that of the conversation.
 * 
 *  The message is inserted based on timestamp and the SDK will automatically update attributes of the conversation, including `latestMessage`.
 * 
 *
 *  @param aMessage The message instance.
 *  @param pError   The error information if the method fails: Error.
 */
- (void)insertMessage:(EMChatMessage *_Nonnull)aMessage
                error:(EMError ** _Nullable)pError;

/**
 *  \~chinese
 *  插入一条消息到 SDK 本地数据库会话尾部。
 * 
 * 消息的 conversationId 应该和会话的 conversationId 一致。
 * 
 * 消息会被插入 SDK 本地数据库，并且更新会话的 `latestMessage` 等属性。
 *
 *  @param aMessage 消息实例。
 *  @param pError   错误信息。
 *
 *  \~english
 *  Inserts a message to the end of a conversation in local database. 
 * 
 * To insert the message correctly, ensure that the conversation ID of the message is the same as that of the conversation.
 * 
 * After a message is inserted, the SDK will automatically update attributes of the conversation, including `latestMessage`.
 *
 *  @param aMessage The message instance.
 *  @param pError   The error information if the method fails: Error.
 *
 */
- (void)appendMessage:(EMChatMessage *_Nonnull)aMessage
                error:(EMError **_Nullable)pError;

/**
 *  \~chinese
 *  从 SDK 本地数据库删除一条消息。
 *
 *  @param aMessageId   要删除的 ID。
 *  @param pError       错误信息。
 *
 *  \~english
 *  Deletes a message from the local database.
 *
 *  @param aMessageId   The ID of the message to be deleted.
 *  @param pError       The error information if the method fails: Error.
 *
 */
- (void)deleteMessageWithId:(NSString *_Nonnull)aMessageId
                      error:(EMError ** _Nullable)pError;

/**
 *  \~chinese
 *  清除内存和数据库中指定会话中的消息。
 *
 *  @param pError       错误信息。
 *
 *  \~english
 *  Deletes all the messages in the conversation from the memory and local database.
 *
 *  @param pError       The error information if the method fails: Error.
 */
- (void)deleteAllMessages:(EMError ** _Nullable)pError;

/**
 *  \~chinese
 *  从会话中删除消息（包括本地存储和服务器存储）。
 * 
 *  @param beforeTimeStamp   UNIX 时间戳，单位为毫秒。若消息的 UNIX 时间戳小于设置的值，则会被删除。
 *  @param completion   该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Removes messages from the conversation by message ID.
 * 
 * This method deletes messages from both local storage and server.
 *
 *  @param messageIds   The message timestamp in millisecond. Messages with the timestamp smaller than the specified one will be removed from the current conversation.
 *  @param completion   The completion block, which contains the error message if the method fails.
 *
 */
- (void)removeMessagesFromServerWithTimeStamp:(NSTimeInterval)beforeTimeStamp completion:(void (^ _Nullable)(EMError * _Nullable aError))aCompletionBlock;


/**
 *  \~chinese
 *  更新 SDK 本地数据库的消息。
 * 
 * 消息更新时，消息 ID 不会修改。
 *
 * 消息更新后，SDK 会自动更新会话的 `latestMessage` 等属性。
 *
 *  @param aMessage 要更新的消息。
 *  @param pError   错误信息。
 *
 *  \~english
 *  Updates a message in the local database. 
 * 
 *  After you update a message, the message ID remains unchanged and the SDK automatically updates attributes of the conversation, like `latestMessage`.
 *
 *  @param aMessage The message to be updated.
 *  @param pError   The error information if the method fails: Error.
 *
 */
- (void)updateMessageChange:(EMChatMessage *_Nonnull)aMessage
                      error:(EMError ** _Nullable)pError;

/**
 *  \~chinese
 *  从本地数据库中删除指定时间段内的消息。
 *
 *  @param aStartTimestamp  删除消息的起始时间。UNIX 时间戳，单位为毫秒。
 *  @param aEndTimestamp    删除消息的结束时间。UNIX 时间戳，单位为毫秒。
 *  @return EMError         消息是否删除成功：
                            - 若操作成功，返回 `nil`。
                            - 若操作失败，返回错误原因，例如参数错误或数据库操作失败。
 *
 *  \~english
 *  Deletes messages sent or received in a certain period from the local database.
 *
 *  @param aStartTimestamp  The starting UNIX timestamp for message deletion. The unit is millisecond.
 *  @param aEndTimestamp    The end UNIX timestamp for message deletion. The unit is millisecond.
 *  @return EMError         Whether the message deletion succeeds:
 *                          - If the operation succeeds, the SDK returns `nil`.
 *                          - If the operation fails, the SDK returns the failure reason such as the parameter error or database operation failure.
 *
 */
- (EMError* _Nullable)removeMessagesStart:(NSInteger)aStartTimestamp
                                       to:(NSInteger)aEndTimestamp;
@end
