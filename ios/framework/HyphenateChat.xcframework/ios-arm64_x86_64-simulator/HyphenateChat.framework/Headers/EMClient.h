/**
 *  @header EMClient.h
 *  @abstract SDK Client
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMClientDelegate.h"
#import "EMError.h"
#import "EMOptions.h"

#import "IEMChatManager.h"
#import "IEMChatroomManager.h"
#import "EMLogDelegate.h"

/**
 *  \~chinese
 *  检查类型的枚举。
 * 
 * 该方法为异步方法，如果出现报错，可以确认错误信息。
 *
 *  \~english
 *  This enum lists the server diagnostic tests which are run for the current user when you call EMClient::serviceCheckWithUsername.
 * 
 *  This is an asynchronous method. 
 * 
 * If there is an error, check the error code for the error information.
 */
typedef NS_ENUM(NSInteger, EMServerCheckType) {
  EMServerCheckAccountValidation = 0, /** \~chinese 账号检查类型，账号是否有效的检查。  \~english The check of the account validity. */
  EMServerCheckGetDNSListFromServer,  /** \~chinese 获取服务列表检查类型  \~english The check for DNS list retrieval from the server. */
  EMServerCheckGetTokenFromServer,    /** \~chinese 获取 token 检查类型  \~english The check for token retrieval from the server. */
  EMServerCheckDoLogin,               /** \~chinese 登录检查类型  \~english The login check. */
  EMServerCheckDoLogout,              /** \~chinese 登出检查类型  \~english The logout check. */
};

/**
 * \~chinese
 *  该类为 SDK 的入口类，负责登录登出及连接管理等，由此可以获得其他模块的入口，例如：群组模块 [EMClient sharedClient].groupManager。
 *
 * \~english
 *  This class is the entry of the Chat SDK, which is responsible for management of modules like login, logout, and connection. 
 * 
 * With this class, you can access other modules such as group [EMClient sharedClient].groupManager.
 *
 */
@interface EMClient : NSObject
{
}

/**
 *  \~chinese
 *  SDK 版本号。
 *
 *  \~english
 *  The SDK version number.
 */
@property(nonatomic, strong, readonly) NSString * _Nonnull version;

/**
 *  \~chinese
 *  当前登录账号。
 *
 *  \~english
 *  The ID of the user currently logged in to your chat app.
 */
@property(nonatomic, strong, readonly) NSString * _Nullable currentUsername;

/**
 *  \~chinese
 *  SDK 的设置选项。
 *
 *  \~english
 *  The SDK setting options. For example, whether to use HTTPs by default.
 */
@property(nonatomic, strong, readonly) EMOptions * _Nonnull options;

/**
 *  \~chinese
 *  聊天模块。
 *
 *  \~english
 *  The chat manager module.
 */
@property(nonatomic, strong, readonly) id<IEMChatManager> _Nullable chatManager;

/*!
 *  \~chinese
 *  聊天室模块。
 *
 *  \~english
 *  The chat room manager module.
 */
@property(nonatomic, strong, readonly) id<IEMChatroomManager> _Nullable roomManager;

/**
 *  \~chinese
 *  是否让用户自动使用上次登录的账号登录。
 * 
 * - `YES`：允许。
 * - `NO`：不允许。
 * 
 * 如果因密码错误或账号异常等原因登录失败，则该参数会被重置为 `NO`；如果你想使用自动登录，则需要重新将该参数设为 `YES`。
 *
 *  \~english
 *  Whether to allow a user to automatically log in to the chat server with the user ID used last time.
 * 
 * - `YES`：Yes.
 * - `NO`：No.
 * 
 *  If the login fails, for example, because of an incorrect password or a deactivated user account, this parameter will be reset to `NO`. In this case, you need to set it back to `YES` to allow automatic login.
 * 
 */
@property(nonatomic, readonly) BOOL isAutoLogin;

/**
 *  \~chinese
 *  用户是否已登录。
 *
 *  \~english
 * 
 * Whether the current user is already logged in to the chat server.
 *  
 * - `YES`：The current user is already logged in.
 * - `NO`：The current user is not logged in.
 */
@property(nonatomic, readonly) BOOL isLoggedIn;

/**
 *  \~chinese
 *  SDK 是否已连接聊天服务器。
 *
 *  \~english
 *  Whether the SDK is connected to the chat server.
 * 
 * - `YES`：Yes.
 * - `NO`：No.
 */
@property(nonatomic, readonly) BOOL isConnected;

/**
 *  \~chinese
 *  当前用户访问聊天服务器使用的 token。 
 * 
 * 用户第一次登录时需使用用户 ID 和密码，登录成功则返回 token，后续即可用 token 登录。
 *
 *  \~english
 *  The token used by the current user to access the chat server.
 * 
 * The user needs to use the user ID and password for the first login. If the login succeeds, a token is returned and the user can use it for subsequent logins.
 */
@property(nonatomic, readonly) NSString * _Nullable accessUserToken;

/**
 *  \~chinese
 *  Client 类是 chat 的入口，在调用任何其他方法前，需要先调用该方法创建一个 Client 实例。 
 *
 *  \~english
 *  Creates a Client instance. The Client class is the entry to the Chat SDK. You need to call this method to create a Client instance before calling any other methods.
 */
+ (instancetype _Nonnull )sharedClient;


/**
 *  \~chinese
 *  SDK 版本号。
 *
 *  \~english
 *  The SDK version number.
 */
- (NSString *)version;

#pragma mark - Delegate  

/**
 *  \~chinese
 *  添加回调代理。
 *
 *  @param aDelegate  要添加的代理。
 *  @param aQueue     执行代理方法的队列。
 *
 *  \~english
 *  Adds a delegate. 
 *
 *  @param aDelegate  The delegate that you want to add.
 *  @param aQueue     (optional) The queue of calling delegate methods. If you want to run the app on the main thread, set this parameter as `nil`. */
- (void)addDelegate:(id<EMClientDelegate>_Nonnull)aDelegate
      delegateQueue:(dispatch_queue_t _Nullable )aQueue;

/**
 *  \~chinese
 *  移除回调代理。
 *
 *  @param aDelegate  要移除的代理。
 *
 *  \~english
 *  Removes a delegate.
 *
 *  @param aDelegate  The delegate that you want to remove.
 */
- (void)removeDelegate:(id _Nonnull )aDelegate;

#pragma mark - Initialize SDK

/**
 *  \~chinese
 *  初始化 SDK。
 *
 *  @param aOptions  SDK 配置项。
 *
 *  @result 错误信息，包含调用失败的原因。
 *
 *  \~english
 *  Initializes the SDK.
 *
 *  @param aOptions   The SDK options.
 *
 *  @Result A description of the issue that caused this call to fail.
 */
- (EMError *_Nullable)initializeSDKWithOptions:(EMOptions * _Nonnull )aOptions;

#pragma mark - User Registration 
/**
 *  \~chinese
 *  注册用户。
 * 
 * 不推荐使用，建议后台通过 REST 注册。
 *
 *  同步方法，会阻塞当前线程.
 *
 *  @param aUsername  用户 ID，长度不超过 64 个字符。请确保你对该参数设值。支持的字符包括英文字母（a-z），数字（0-9），下划线（_），英文横线（-），英文句号（.）。该参数不区分大小写，大写字母会被自动转为小写字母。如果使用正则表达式设置该参数，则可以将表达式写为：^[a-zA-Z0-9_-]+$。
 *  @param aPassword  密码，长度不超过 64 个字符。请确保你对该参数设值。
 *
 *  @result EMError 错误信息，包含调用失败的原因。
 *
 *  \~english
 *  Registers a new user.
 *
 *  This method is not recommended and you are advised to call the RESTful API to register a new user.
 * 
 *
 *  After you call `initializeSDKWithOptions` and register your app in the console, the app has access to all the features registered inside your chat network. You add and remove users inside your chat network; depending on how you implement your app, you control the people each user can see inside your network.
 *
 *  This is a synchronous method and blocks the current thread. To ensure the registration reliability, we recommend using the RESTful API to register new chat users.
 *
 *  @param aUsername  The user ID. The maximum length is 64 characters. Ensure that you set this parameter. Supported characters include the 26 English letters (a-z), the ten numbers (0-9), the underscore (_), the hyphen (-), and the English period (.). This parameter is case insensitive, and upper-case letters are automatically changed to low-case ones. If you want to set this parameter as a regular expression, set it as ^[a-zA-Z0-9_-]+$.
 *  @param aPassword   The password. The maximum length is 64 characters. Ensure that you set this parameter.
 *
 *  @result A description of the issue that caused this call to fail.
 */
- (EMError *_Nullable)registerWithUsername:(NSString * _Nonnull)aUsername
                                  password:(NSString * _Nonnull)aPassword;

/**
 *  \~chinese
 *  注册用户。
 *
 *  不推荐使用，建议后台通过 REST 注册。
 *
 *  异步方法。
 *
 *  @param aUsername  用户 ID，长度不超过 64 个字符。请确保你对该参数设值。支持的字符包括英文字母（a-z），数字（0-9），下划线（_），英文横线（-），英文句号（.）。该参数不区分大小写，大写字母会被自动转为小写字母。如果使用正则表达式设置该参数，则可以将表达式写为：^[a-zA-Z0-9_-]+$。
 *  @param aPassword  密码，长度不超过 64 个字符。请确保你对该参数设值。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Registers a new user.
 *
 *  This is an asynchronous method. This method is not recommended and you are advised to call the RESTful API to register a user.
 *
 *  To ensure registration reliability, we recommend using the RESTful API to register new chat users.
 *
 *  @param aUsername        The user ID. The maximum length is 64 characters. Ensure that you set this parameter. Supported characters include the 26 English letters (a-z), the ten numbers (0-9), the underscore (_), the hyphen (-), and the English period (.). This parameter is case insensitive, and upper-case letters are automatically changed to low-case ones. If you want to set this parameter as a regular expression, set it as ^[a-zA-Z0-9_-]+$.
 *  @param aPassword        The password. The maximum length is 64 characters. Ensure that you set this parameter.
 *  @param aCompletionBlock The completion block, which contains the username and the error message if the method fails.
 *
 */
- (void)registerWithUsername:(NSString *_Nonnull)aUsername
                    password:(NSString *_Nonnull)aPassword
                  completion:(void (^_Nullable)(NSString * _Nonnull aUsername, EMError * _Nullable aError))aCompletionBlock;

#pragma mark - Login

/**
 *  \~chinese
 *  用户使用密码登录服务器。
 *
 *  推荐使用 token 登录聊天服务器。
 *
 *  同步方法，会阻塞当前线程。
 *
 *  @param aUsername  用户 ID，长度不超过 64 个字符。请确保你对该参数设值。支持的字符包括英文字母（a-z），数字（0-9），下划线（_），英文横线（-），英文句号（.）。该参数不区分大小写，大写字母会被自动转为小写字母。如果使用正则表达式设置该参数，则可以将表达式写为：^[a-zA-Z0-9_-]+$。
 *  @param aPassword  密码，长度不超过 64 个字符。请确保你对该参数设值。
 *
 *  @result 登录成功则返回 `nil`，失败则返回错误信息，包含调用失败的原因。
 *
 *  \~english
 *  Logs in to the chat server with a password.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  It is recommended that you log in to the chat service with a token.
 *
 *  @param aUsername  The user ID. The maximum length is 64 characters. Ensure that you set this parameter. Supported characters include the 26 English letters (a-z), the ten numbers (0-9), the underscore (_), the hyphen (-), and the English period (.). This parameter is case insensitive, and upper-case letters are automatically changed to low-case ones. If you want to set this parameter as a regular expression, set it as ^[a-zA-Z0-9_-]+$.
 *  @param aPassword  The password. The maximum length is 64 characters. Ensure that you set this parameter.
 *
 *  @result If the login succeeds, the SDK returns `nil`; otherwise, the SDK returns the description of the issue that causes the call to fail. 
 */
- (EMError *_Nullable)loginWithUsername:(NSString *_Nonnull)aUsername
                               password:(NSString *_Nonnull)aPassword;

/**
 *  \~chinese
 *  用户使用密码登录聊天服务器。
 *
 *  异步方法。
 *
 *  推荐使用 token 登录聊天服务器。
 *
 *  @param aUsername        用户 ID，长度不超过 64 个字符。请确保你对该参数设值。支持的字符包括英文字母（a-z），数字（0-9），下划线（_），英文横线（-），英文句号（.）。该参数不区分大小写，大写字母会被自动转为小写字母。如果使用正则表达式设置该参数，则可以将表达式写为：^[a-zA-Z0-9_-]+$。
 *  @param aPassword        密码，长度不超过 64 个字符。请确保你对该参数设值。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Logs in to the chat server with a password.
 *
 *  This is an asynchronous method.
 *
 *  It is recommended that you log in to the chat service with a token.
 *
 *  @param aUsername        The user ID. The maximum length is 64 characters. Ensure that you set this parameter. Supported characters include the 26 English letters (a-z), the ten numbers (0-9), the underscore (_), the hyphen (-), and the English period (.). This parameter is case insensitive, and upper-case letters are automatically changed to low-case ones. If you want to set this parameter as a regular expression, set it as ^[a-zA-Z0-9_-]+$.
 *  @param aPassword        The password. The maximum length is 64 characters. Ensure that you set this parameter.
 *  @param aCompletionBlock The completion block, which contains the username and the error message if the method fails.
 *
 */
- (void)loginWithUsername:(NSString *_Nonnull)aUsername
                 password:(NSString *_Nonnull)aPassword
               completion:(void (^_Nullable)(NSString * _Nonnull aUsername, EMError *_Nullable aError))aCompletionBlock;

/**
 *  \~chinese
 *  用户使用 token 登录。
 * 
 *  该方法支持自动登录。
 *
 *  同步方法，会阻塞当前线程。
 *
 *  @param aUsername  用户 ID，长度不超过 64 个字符。请确保你对该参数设值。支持的字符包括英文字母（a-z），数字（0-9），下划线（_），英文横线（-），英文句号（.）。该参数不区分大小写，大写字母会被自动转为小写字母。如果使用正则表达式设置该参数，则可以将表达式写为：^[a-zA-Z0-9_-]+$。
 *  @param aToken     登录 Token。
 *
 *  @result 登录成功则返回 `nil`，失败则返回错误信息，包含调用失败的原因。
 *
 *  \~english
 *  Logs in to the chat server with a token.
 * 
 *  This method does not support automatic login.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aUsername  The user ID. The maximum length is 64 characters. Ensure that you set this parameter. Supported characters include the 26 English letters (a-z), the ten numbers (0-9), the underscore (_), the hyphen (-), and the English period (.). This parameter is case insensitive, and upper-case letters are automatically changed to low-case ones. If you want to set this parameter as a regular expression, set it as ^[a-zA-Z0-9_-]+$.
 *  @param aToken     The token for login to the chat server.
 *
 *  @result If the login succeeds, the SDK returns `nil`; otherwise, the SDK returns the description of the issue that causes the call to fail. 
 */
- (EMError *_Nullable)loginWithUsername:(NSString *_Nonnull)aUsername
                                  token:(NSString *_Nonnull)aToken;

/**
 *  \~chinese
 *  用户使用 token 登录。
 *
 *  异步方法。该方法支持自动登录。
 *
 *  @param aUsername        用户 ID，长度不超过 64 个字符。请确保你对该参数设值。支持的字符包括英文字母（a-z），数字（0-9），下划线（_），英文横线（-），英文句号（.）。该参数不区分大小写，大写字母会被自动转为小写字母。如果使用正则表达式设置该参数，则可以将表达式写为：^[a-zA-Z0-9_-]+$。
 *  @param aToken           登录 Token。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 * Logs in to the chat server with a token.  
 * 
 * This is an asynchronous method. This method supports automatic login.
 *
 *  @param aUsername        The user ID. The maximum length is 64 characters. Ensure that you set this parameter. Supported characters include the 26 English letters (a-z), the ten numbers (0-9), the underscore (_), the hyphen (-), and the English period (.). This parameter is case insensitive, and upper-case letters are automatically changed to low-case ones. If you want to set this parameter as a regular expression, set it as ^[a-zA-Z0-9_-]+$.
 *  @param aToken           The token for login to the chat server.
 *  @param aCompletionBlock The completion block, which contains the user ID and the error message if the method fails.
 *
 */
- (void)loginWithUsername:(NSString *_Nonnull)aUsername
                    token:(NSString *_Nonnull)aToken
               completion:(void (^_Nullable)(NSString * _Nonnull aUsername, EMError *_Nullable aError))aCompletionBlock;

/**
 *  \~chinese
 *  更新用户 token。
 * 
 *  当用户在 token 登录状态时，且在 ClientDelegate 回调中收到 token 即将过期的回调通知，可以调用该 API 更新 token，避免因 token 失效产生的未知问题。
 *
 *  同步方法，会阻塞当前线程。    
 *
 *  @param newToken 新的 token。
 *
 *  @result 返回结果，如果有错误会返回错误信息。
 *
 *  \~english
 *  Renews the user token when the current token expires.
 *
 *  If you are logged in with an Chat user token and you are notified via the ClientDelegate callback that the token is about to expire, you can call this method to renew the token to prevent unknown issues caused by an invalid token.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param newToken The new Chat token。
 *
 *  @result The result which contains the description of the cause to the failure if call fails.
 */
- (EMError *_Nullable)renewToken:(NSString *_Nonnull)newToken;

/**
 *  \~chinese
 *  更新用户 token。
 *
 *  当用户在 token 登录状态时，且在 ClientDelegate 回调中收到 token 即将过期的回调通知，可以调用该 API 更新 token，避免因 token 失效产生的未知问题。
 *
 *  异步方法。
 *
 *  @param newToken 新的 token。
 *
 *  @result 返回结果，如果有错误会返回错误信息。
 *
 *  \~english
 *  Renews the user token when the current token expires.
 *
 *  If you are logged in with an Chat user token and you are notified via the ClientDelegate callback that the token is about to expire, you can call this method to renew the token to prevent unknown issues caused by an invalid token.
 *
 *  This is an asynchronous method.
 *
 *  @param newToken The new Chat token。
 *
 *  @result The result which contains the description of the cause to the failure if call fails.
 */
- (void)renewToken:(NSString *_Nonnull)newToken completion:(void (^_Nullable)(EMError* _Nullable aError))aCompletionBlock;

#pragma mark - Logout

/**
 *  \~chinese
 *  用户登出聊天服务器。
 *
 *  同步方法，会阻塞当前线程。
 *
 *  @param aIsUnbindDeviceToken 是否解除账号与设备绑定。
 *  - `YES`：表示解除绑定。成功解绑后，用户登出账号后设备将不再收到消息推送。若解绑失败，SDK 会返回错误信息，包含调用失败的原因。
 *  - `NO`：表示不解除绑定。
 *
 *  @result EMError 错误信息，包含失败原因。
 *
 *  \~english
 *  Logs out of the chat server.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aIsUnbindDeviceToken Whether to unbind the user ID from the device.
 *  - `Yes`：Yes. Once the user ID is unbound from the device, the user device stops receiving push notifications from the Apple Push Notifications service.
 *    If the unbinding fails, the SDK returns an error that includes the reason for the failure.
 *  - `NO`：No.
 *
 *  @result A description of the issue that caused this call to fail.
 */
- (EMError *_Nullable)logout:(BOOL)aIsUnbindDeviceToken;

/**
 *  \~chinese
 *  登出聊天服务器。
 *
 *  异步方法。
 *
 *  @param aIsUnbindDeviceToken 是否解除账号与设备绑定。
 *  - `YES`：表示解除绑定。成功解绑后，用户登出账号后设备将不再收到消息推送。若解绑失败，SDK 会返回错误信息，包含调用失败的原因。
 *  - `NO`：表示不解除绑定。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Logs out of the chat server.
 *
 *  This is an asynchronous method.
 *
 *  @param aIsUnbindDeviceToken   Whether to unbind the user ID from the device.
 *  - `Yes`：Yes. Once the user ID is unbound from the device, the user device stops receiving push notifications from the Apple Push Notifications service.
 *    If the unbinding fails, the SDK returns an error that includes the reason for the failure.
 *  - `NO`：No.
 *  @param aCompletionBlock  The completion block, which contains the token and the error message if the method fails.
 *
 */
- (void)logout:(BOOL)aIsUnbindDeviceToken
    completion:(void (^_Nullable)(EMError * _Nullable aError))aCompletionBlock;

#pragma mark - APNs

/**
 *  \~chinese
 *  绑定 device token。
 *
 *  Device token 用于苹果 APNS 推送。
 *
 *  同步方法，会阻塞当前线程。
 *
 *  @param aDeviceToken  要绑定的 token。
 *
 *  @result 绑定成功则返回 `nil`，失败则返回错误信息，包含调用失败的原因。

 *
 *  \~english
 *  Binds the device token.
 * 
 *  Device token binding is required to enable Apple Push Notification Service.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aDeviceToken  The device token to bind.
 *
 *  @Result If the binding succeeds, the SDK returns `nil`; otherwise, the SDK returns the description of the issue that causes the call to fail. 
 */
- (EMError *_Nullable)bindDeviceToken:(NSData *_Nonnull)aDeviceToken;

/**
 *  \~chinese
 *  注册 device token。
 *
 *  Device token 用于苹果 APNS 推送。
 *
 *  异步方法。
 *
 *  @param aDeviceToken     要绑定的 token。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Registers the device token.
 * 
 *  Device token binding is required to enable Apple push notification service.
 * 
 *  This is an asynchronous method.
 *
 *  @param aDeviceToken         The device token to bind.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)registerForRemoteNotificationsWithDeviceToken:(NSData *_Nonnull)aDeviceToken
                                           completion:(void (^_Nullable)(EMError *_Nullable aError))aCompletionBlock;

#pragma mark - Log

/**
 *  \~chinese
 *  上传日志到聊天服务器。
 *
 *  同步方法，会阻塞当前线程。
 *
 *  @result 上传成功则返回 `nil`，失败则返回错误信息，包含调用失败的原因。
 *
 *  \~english
 *  Uploads the log to the chat server.
 * 
 *  The information in the debug log is used by our engineers to fix errors and improve system performance.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @result If the upload succeeds, the SDK returns `nil`; otherwise, the SDK returns the description of the issue that causes the call to fail. 
 */
- (EMError *_Nullable)uploadLogToServer;

/**
 *  \~chinese
 *  上传日志到聊天服务器。
 *
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Uploads the debug log to the chat server.
 *
 *  @param aCompletionBlock     The completion block, which contains the token and the error message if the method fails.
 */
- (void)uploadDebugLogToServerWithCompletion:(void (^_Nullable)(EMError *_Nullable aError))aCompletionBlock;

/**
 *  \~chinese
 *  将日志文件压缩成 .gz 文件。
 * 
 *  强烈建议压缩文件不再使用时将其删除。
 *
 *  同步方法，会阻塞当前线程。
 *
 *  @param pError 错误信息，包含调用失败的原因。
 *
 *  @result NSString 压缩文件的路径。
 *
 *  \~english
 *  Compresses the debug logs into a gzip archive (.gz).
 * 
 *  You are strongly advised to delete this debug archive once it is no longer used.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param pError  A description of the issue that caused this call to fail.
 *
 *  @result NSString The full file path of the debug archive.
 */
- (NSString *_Nullable)getLogFilesPath:(EMError **_Nullable)pError;

/**
 *  \~chinese
 *  将日志文件压缩成 .gz 文件。
 * 
 *  强烈建议压缩文件不再使用时将其删除。
 *
 *  异步方法。
 *
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Compresses the debug logs into a gzip archive (.gz).
 * 
 *  You are strongly advised to delete this debug archive once it is no longer used.
 *
 *  This is an asynchronous method.
 *
 *  @param aCompletionBlock     The completion block, which contains the token and the error message if the method fails.
 */
- (void)getLogFilesPathWithCompletion:(void (^_Nullable)(NSString *_Nullable aPath, EMError * _Nullable aError))aCompletionBlock;

/**
 *  \~chinese
 *  输出日志信息到日志文件。
 * 
 *  该方法需要在 SDK 初始化之后调用。
 *
 *  同步方法，会阻塞当前线程。
 *
 *  @param aLog 要输出的日志信息。
 *
 *  \~english
 *  Outputs logs to a log file. 
 * 
 *  You can call this method after the SDK is initialized.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aLog The log information to output.
 */
- (void)log:(NSString *_Nonnull)aLog;

/**
 *  \~chinese
 *  添加日志回调代理。
 *
 *  @param aDelegate  要添加的代理。
 *  @param aQueue     执行代理方法的队列。
 *
 *  \~english
 *  Adds the log callback delegate.
 *
 *  @param aDelegate  The delegate that you want to add.
 *  @param aQueue     The queue of calling delegate methods.
 */
- (void)addLogDelegate:(id<EMLogDelegate>_Nonnull)aDelegate
         delegateQueue:(dispatch_queue_t _Nullable )aQueue NS_SWIFT_NAME(addLog(delegate:queue:));

/**
 *  \~chinese
 *  移除日志回调代理。
 *
 *  @param aDelegate  要移除的代理。
 *
 *  \~english
 *  Removes the log callback delegate.
 *
 *  @param aDelegate  The log callback delegate that you want to delete.
 */
- (void)removeLogDelegate:(id<EMLogDelegate>_Nonnull)aDelegate NS_SWIFT_NAME(removeLog(delegate:));

#pragma mark - iOS


/**
 *  \~chinese
 *  iOS 专用，程序进入后台时，需要调用此方法断开连接。
 *
 *  @param aApplication  当前应用程序实例。
 *
 *  \~english
 *  Disconnects from the chat server when the app is switched to the background.
 * 
 *  This method is specific to the iOS platform.
 *
 *  @param aApplication  The current application instance.
 */
- (void)applicationDidEnterBackground:(id _Nonnull )aApplication;

/**
 *  \~chinese
 *  iOS 专用，程序进入前台时，需要调用此方法进行重连。
 *
 *  @param aApplication  当前应用程序实例。
 *
 *  \~english
 *  Reconnects to the server when your app returns to the foreground.
 * 
 *  This method is specific to the iOS platform.
 *
 *  @param aApplication  The current application instance.
 */
- (void)applicationWillEnterForeground:(id _Nonnull )aApplication;

/**
 *  \~chinese
 *  iOS 专用，程序在前台收到 APNS 时，需要调用此方法。
 *
 *  @param application  当前应用程序实例。
 *  @param userInfo     推送内容。
 *
 *  \~english
 *  Occurs when the device receives an APNs notification when your app is running in the foreground.
 * 
 *  This event is specific to the iOS platform.
 *
 *  @param application  The current application instance.
 *  @param userInfo     The push content.
 */
- (void)application:(id _Nonnull)application didReceiveRemoteNotification:(NSDictionary * _Nullable)userInfo;
@end
