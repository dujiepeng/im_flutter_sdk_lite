/**
 *  \~chinese
 *  @header IEMChatroomManager.h
 *  @abstract 聊天室相关操作协议类。
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMChatroomManager.h
 *  @abstract This protocol defines the chat room operations.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"
#import "EMChatroomManagerDelegate.h"
#import "EMChatroomOptions.h"
#import "EMChatroom.h"
#import "EMPageResult.h"

#import "EMCursorResult.h"

@class EMError;

/**
 *  \~chinese
 *  管理聊天室的类。
 *
 *  \~english
 *  A class that manages the chatrooms.
 */
@protocol IEMChatroomManager <NSObject>

@required

#pragma mark - Delegate

/**
 *  \~chinese
 *  添加回调代理。
 *
 *  @param aDelegate  要添加的代理。
 *  @param aQueue     代理执行的队列。
 *
 *  \~english
 *  Adds the SDK delegate.
 *
 *  @param aDelegate  The delegate that you want to add: ChatroomManagerDelegate.
 *  @param aQueue     (Optional) The queue of calling the delegate methods. To run the app on the main thread, set this parameter as nil.
 */
- (void)addDelegate:(id<EMChatroomManagerDelegate> _Nonnull)aDelegate
      delegateQueue:(dispatch_queue_t _Nullable)aQueue;

/**
 *  \~chinese
 *  移除回调代理。
 *
 *  @param aDelegate  要移除的代理。
 *
 *  \~english
 *  Removes the delegate.
 *
 *  @param aDelegate  The delegate that you want to remove.
 */
- (void)removeDelegate:(id<EMChatroomManagerDelegate> _Nonnull)aDelegate;

#pragma mark - Fetch Chatrooms

/**
 *  \~chinese
 *  从服务器获取指定数目的聊天室。
 *
 *  同步方法，会阻塞当前线程。
 *
 *  @param aPageNum         获取第几页。
 *  @param aPageSize        获取多少条。
 *  @param pError           出错信息。
 *
 *  @result 获取的聊天室列表，详见 EMPageResult。
 *
 *  \~english
 *  Gets the specified number of chat rooms from the server.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aPageNum         The page number.
 *  @param aPageSize        The page size.
 *  @param pError           The error information if the method fails: Error.
 *
 *  @result The chat room list. See EMPageResult.
 */
- (EMPageResult<EMChatroom*> *_Nullable)getChatroomsFromServerWithPage:(NSInteger)aPageNum
                                                 pageSize:(NSInteger)aPageSize
                                                    error:(EMError **_Nullable)pError;

/**
 *  \~chinese
 *  从服务器获取指定数目的聊天室。
 * 
 *  异步方法。
 *
 *  @param aPageNum             获取第几页。
 *  @param aPageSize            获取多少条。
 *  @param aCompletionBlock      该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Gets the specified number of chat rooms from the server.
 * 
 *  This is an asynchronous method.
 *
 *  @param aPageNum         The page number.
 *  @param aPageSize        The page size.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method call fails.
 *
 */

- (void)getChatroomsFromServerWithPage:(NSInteger)aPageNum
                              pageSize:(NSInteger)aPageSize
                            completion:(void (^_Nullable)(EMPageResult<EMChatroom*> *_Nullable aResult, EMError *_Nullable aError))aCompletionBlock;

#pragma mark - Edit Chatroom

/**
 *  \~chinese
 *  加入一个聊天室。
 *
 *  同步方法，会阻塞当前线程。
 *
 *  @param aChatroomId  聊天室的 ID。
 *  @param pError       返回的错误信息。
 *
 *  @result  所加入的聊天室，详见 EMChatroom。
 *
 *  \~english
 *  Joins a chatroom.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId  The chatroom ID.
 *  @param pError       The error information if the method fails: Error.
 *
 *  @result  The chatroom instance.
 */
- (EMChatroom *)joinChatroom:(NSString * _Nonnull)aChatroomId
                       error:(EMError ** _Nullable)pError;

/**
 *  \~chinese
 *  加入聊天室。
 * 
 *  异步方法。
 *
 *  @param aChatroomId           聊天室的 ID。
 *  @param aCompletionBlock      该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *
 *  \~english
 *  Joins a chatroom.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId          The chatroom ID.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method call fails.
 *
 */
- (void)joinChatroom:(NSString *_Nonnull)aChatroomId
          completion:(void (^_Nullable)(EMChatroom *_Nullable aChatroom, EMError *_Nullable aError))aCompletionBlock;

/**
 *  \~chinese
 *  加入聊天室。
 *
 *  异步方法。
 *
 *  @param aChatroomId           聊天室 ID。
 *  @param ext                           扩展信息。
 *  @param leaveOtherRooms     加入聊天室时候，是否退出已加入的聊天室。
                                                  - `YES`：加入该聊天室时，退出其他聊天室。
                                                  - （默认）`NO`：加入该聊天室时，不退出其他聊天室。
 *  @param aCompletionBlock      该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 * \~english
 *  Joins the chat room.
 *
 *  This is an asynchronous method.
 *
 *  @param aChatroomId           The chat room ID.
 *  @param ext                           The extension information.
 *  @param leaveOtherRooms     Whether to leave all the currently joined chat rooms when joining a chat room.
                                                   - `YES`：Yes.  The user joins the chat room, while leaving all other chat rooms.
                                                   -  (Default) `NO`:  No. The user joins the chat room, without leaving all other chat rooms.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)joinChatroom:(NSString *_Nonnull)aChatroomId
                 ext:(NSString* _Nullable)ext
     leaveOtherRooms:(BOOL)leaveOtherRooms
          completion:(void (^_Nullable)(EMChatroom *_Nullable aChatroom, EMError *_Nullable aError))aCompletionBlock;


/**
 *  \~chinese
 *  退出聊天室。
 *
 *  同步方法，会阻塞当前线程。
 *
 *  @param aChatroomId  聊天室 ID。
 *  @param pError       错误信息。
 *
 *
 *  \~english
 *  Leaves a chatroom.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId  The chatroom ID.
 *  @param pError       The error information if the method fails: Error.
 *
 */
- (void)leaveChatroom:(NSString *_Nonnull)aChatroomId
                error:(EMError **_Nullable)pError;

/**
 *  \~chinese
 *  退出聊天室。
 * 
 *  异步方法。
 *
 *  @param aChatroomId          聊天室 ID。
 *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *
 *  \~english
 *  Leaves a chatroom.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId          The chatroom ID.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method call fails.
 *
 */
- (void)leaveChatroom:(NSString *_Nonnull)aChatroomId
           completion:(void (^_Nullable)(EMError *_Nullable aError))aCompletionBlock;

#pragma mark - Fetch

/**
 *  \~chinese
 *  获取指定的聊天室。
 *
 *  同步方法，会阻塞当前线程。
 *
 *  @param aChatroomId           聊天室 ID。
 *  @param pError                错误信息。
 *
 *  @result  聊天室实例，详见 EMChatroom。
 *
 *  \~english
 *  Fetches the specific chatroom.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId           The chatroom ID.
 *  @param pError                The error information if the method fails: Error.
 *
 *  @result The chatroom instance. See EMChatroom.
 */
- (EMChatroom *_Nullable)getChatroomSpecificationFromServerWithId:(NSString *_Nonnull)aChatroomId
                                                            error:(EMError *_Nullable*)pError;

/**
 *  \~chinese
 *  获取聊天室详情。
 *
 *  异步方法。
 * 
 *  @param aChatroomId           聊天室 ID
 *  @param aCompletionBlock      该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Fetches the chat room specifications.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId           The chatroom ID.
 *  @param aCompletionBlock      The completion block, which contains the error message if the method call fails.
 *
 */
- (void)getChatroomSpecificationFromServerWithId:(NSString *_Nonnull)aChatroomId
                                      completion:(void (^_Nullable)(EMChatroom *_Nullable aChatroom, EMError *_Nullable aError))aCompletionBlock;

/**
 *  \~chinese
 *  获取聊天室成员列表。
 * 
 *  同步方法，会阻塞当前线程。
 *
 *  @param aChatroomId      聊天室 ID。
 *  @param aCursor          游标，首次调用传空。
 *  @param aPageSize        获取多少条。
 *  @param pError           错误信息。
 *
 *  @result   聊天室成员列表和游标。
 *
 *  \~english
 *  Gets the list of chatroom members from the server.
 * 
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aCursor          The cursor. Set this parameter as nil when you call this method for the first time.
 *  @param aPageSize        The page size.
 *  @param pError           The error information if the method fails: Error.
 *
 *  @result    The list of chatroom members and the cursor.
 *
 */
- (EMCursorResult<NSString*> *_Nullable)getChatroomMemberListFromServerWithId:(NSString *_Nonnull)aChatroomId
                                                            cursor:(NSString *_Nullable)aCursor
                                                          pageSize:(NSInteger)aPageSize
                                                             error:(EMError **_Nullable)pError;

/**
 *  \~chinese
 *  获取聊天室成员列表。
 * 
 *  异步方法。
 *
 *  @param aChatroomId      聊天室 ID。
 *  @param aCursor          游标，首次调用传空。
 *  @param aPageSize        获取多少条。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *
 *  \~english
 *  Gets the list of chatroom members from the server.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aCursor          The cursor. Set this parameter as nil when you call this method for the first time.
 *  @param aPageSize        The page size.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)getChatroomMemberListFromServerWithId:(NSString *_Nonnull)aChatroomId
                                       cursor:(NSString *_Nullable)aCursor
                                     pageSize:(NSInteger)aPageSize
                                   completion:(void (^_Nullable)(EMCursorResult<NSString*> *_Nullable aResult, EMError *_Nullable aError))aCompletionBlock;

/**
 *  \~chinese
 *  获取聊天室公告。
 * 
 *  同步方法，会阻塞当前线程。
 *
 *  @param aChatroomId      聊天室 ID。
 *  @param pError           错误信息。
 *
 *  @result    聊天室公告。
 *
 *  \~english
 *  Gets the announcement of a chatroom from the server.
 * 
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param pError           The error information if the method fails: Error.
 *
 *  @result    The announcement of chatroom.
 */
- (NSString *_Nullable)getChatroomAnnouncementWithId:(NSString *_Nonnull)aChatroomId
                                               error:(EMError **_Nullable )pError;

/**
 *  \~chinese
 *  获取聊天室公告。
 * 
 *  异步方法。
 *
 *  @param aChatroomId      聊天室 ID。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Gets the announcement of a chatroom from the server.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)getChatroomAnnouncementWithId:(NSString *_Nonnull)aChatroomId
                           completion:(void (^_Nullable)(NSString *_Nullable aAnnouncement, EMError *_Nullable aError))aCompletionBlock;

@end
