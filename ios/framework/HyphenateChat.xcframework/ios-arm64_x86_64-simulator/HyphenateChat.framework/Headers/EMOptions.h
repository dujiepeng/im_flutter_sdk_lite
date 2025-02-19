/**
 *  \~chinese
 *  @header EMOptions.h
 *  @abstract SDK的设置选项
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMOptions.h
 *  @abstract SDK options
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"

/**
 *  \~chinese
 *  日志输出级别。
 *
 *  \~english
 *  The level of logs for output.
 */
typedef NS_ENUM(NSInteger, EMLogLevel)
{
    EMLogLevelDebug = 0, /** \~chinese 输出所有日志。 \~english All logs. */
    EMLogLevelWarning,   /** \~chinese 输出警告及错误。 \~english Warnings and errors. */
    EMLogLevelError      /** \~chinese 只输出错误。 \~english Errors only. */
} ;

/**
 *  \~chinese
 *  SDK 的设置选项。
 *
 *  \~english
 *  The SDK options.
 */
@interface EMOptions : NSObject

/**
 *  \~chinese
 *  app key，是项目的唯一标识。
 *
 *  \~english
 *  The app key, which is the unique identifier of the project.
 */
@property(nonatomic, copy, readonly) NSString *appkey;

/**
 *  \~chinese
 *  控制台是否输出日志。
 *  - `YES`：是；
 *  - （默认）`NO`：否。
 *
 *  \~english
 *  Whether to print logs on the Console.
 *  - `YES`: Yes.
 *  - (Default) `NO`: No.
 */
@property(nonatomic, assign) BOOL enableConsoleLog;

/**
 *  \~chinese
 * 日志级别：
 * - (默认)`EMLogLevelDebug`：所有等级的日志；
 * - `EMLogLevelWarning`：警告及错误；
 * - `EMLogLevelError`：错误。
 *
 *  \~english
 *  The log level.
 *  - `EMLogLevelDebug`: All logs;
 *  - `EMLogLevelWarning`: Warnings and errors.
 *  - `EMLogLevelError`: Errors.
 */
@property(nonatomic, assign) EMLogLevel logLevel;

/**
 *  \~chinese
 *  是否只使用 HTTPS 协议。
 *  - `YES`：是：
 *  - （默认）`NO`：否。
 *
 *  \~english
 *  Whether to only use the HTTPS protocol.
 *  - `YES`: Yes.
 *  - (Default) `NO`: No.
 */
@property(nonatomic, assign) BOOL usingHttpsOnly;

/**
 *  \~chinese
 *  是否自动登录。
 *  - （默认）`YES`：是；
 *  - `NO`：否。
 *
 *  该参数需要在 SDK 初始化前设置，否则不生效。
 *
 *  \~english
 *  Whether to enable automatic login. The default value is `YES`.
 *  - (Default) `YES`: Yes.
 *  - `NO`: No.
 *
 *  You need to set this parameter before the SDK is initialized; otherwise, the setting does not take effect.
 */
@property(nonatomic, assign) BOOL isAutoLogin;

/**
 *  \~chinese
 *  离开聊天室时是否删除所有消息。
 *  - （默认）`YES`：是；
 *  - `NO`：否。
 *
 *  \~english
 *  Whether to delete all the chat room messages when leaving the chat room.
 *  - (Default) `YES`: Yes.
 *  - `NO`: No.
 */
@property(nonatomic, assign) BOOL deleteMessagesOnLeaveChatroom;

/**
 *  \~chinese
 *  是否允许聊天室所有者离开。
 *  - （默认）`YES`：是；
 *  - `NO`：否。
 *
 *  \~english
 *  Whether to allow the chat room owner to leave the room.
 *  - (Default) `YES`: Yes.
 *  - `NO`: No.
 */
@property(nonatomic, assign) BOOL canChatroomOwnerLeave;

/**
 *  \~chinese
 *  是否自动下载图片和视频的缩略图及语音消息。
 *  - （默认）`YES`：是；
 *  - `NO`：否。
 *
 *  \~english
 *  Whether to automatically download thumbnails of images and videos and voice messages.
 *  - (Default) `YES`: Yes.
 *  - `NO`: No.
 */
@property(nonatomic, assign) BOOL autoDownloadThumbnail;

/**
 * \~chinese
 * 是否需要接收已读回执。
 *  - （默认）`YES`：是；
 *  - `NO`：否。
 *
 * \~english
 * Whether to receive the message read receipt.
 *  - (Default) `YES`: Yes.
 *  - `NO`: No.
 */
@property(nonatomic, assign) BOOL enableRequireReadAck;
/**
 *  \~chinese
 *  是否发送消息送达回执：
 *  - `YES`：SDK 收到单聊消息时会自动发送送达回执；
 *  - （默认）`NO`：否。
 *  \~english
 *  Whether to send the message delivery receipt.
 *  - `YES`: Upon the reception of a one-to-one message, the SDK automatically sends a delivery receipt.
 *  - `NO`: No.
 *
 */
@property(nonatomic, assign) BOOL enableDeliveryAck;

/**
 *  \~chinese
 *  从数据库加载消息时是否按服务器时间排序。
 *  - （默认）`YES`：按服务器时间排序；
 *  - `NO`：否。
 *
 *  \~english
 *  Whether to sort messages by the server's reception time when loading messages from the database.
 *  - (Default) `YES`: Yes. Messages are sorted by the time when the server receives them.
 *  - `NO`: No.
 *
 */
@property(nonatomic, assign) BOOL sortMessageByServerTime;

/**
 *  \~chinese
 * 是否自动上传或者下载消息中的附件。
 *  - （默认）`YES`：是；
 *  - `NO`：否。
 *
 *  \~english
 *  Whether to automatically upload or download the attachment in the message.
 *  - (Default) `YES`: Yes.
 *  - `NO`: No.
 */
@property(nonatomic, assign) BOOL isAutoTransferMessageAttachments;

/**
 *  \~chinese
 *  iOS 特有属性，APNs 推送证书的名称。
 *
 *  该参数只能在调用 `initializeSDKWithOptions` 时设置，且 app 运行过程中不可以修改。
 *
 *  \~english
 *  The certificate name of Apple Push Notification Service (APNs).
 *
 *  This attribute is specific to APNs.
 *
 *  This attribute can be set only when you call `initializeSDKWithOptions`. The attribute setting cannot be changed during app runtime.
 */
@property(nonatomic, copy) NSString *apnsCertName;

/**
 *  \~chinese
 *  加载会话时是否包括空会话。
 *
 *  - YES：包含。
 * - （默认）NO：不包含。
 *
 *  该属性只能在调用 `initializeSDKWithOptions` 时设置，而且 app 运行过程中不能修改该参数的设置。
 *
 *  \~english
 *  Whether to include empty conversations when the SDK loads conversations
 *  - `YES`: Empty conversations are included.
 * - (Default) `NO`: Empty conversations are excluded.
 *
 *  This attribute can be set only when you call the `initializeSDKWithOptions` method. The attribute setting cannot be changed during app runtime.
 */
@property(nonatomic) BOOL loadEmptyConversations;

/**
 *  \~chinese
 *  获取 SDK 选项实例。
 *
 *  @param aAppkey  App key。
 *
 *  @result SDK 设置项实例。
 *
 *  \~english
 *  Gets an SDK options instance.
 *
 *  @param aAppkey  The App Key.
 *
 *  @result  The SDK options instance.
 */
+ (instancetype _Nonnull)optionsWithAppkey:(NSString * _Nonnull)aAppkey;

@end
