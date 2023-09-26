//
//  ChatService.h
//  sample-chat
//
//  Created by Igor Khomenko on 10/21/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNotificationDidReceiveNewMessage @"kNotificationDidReceiveNewMessage"
#define kNotificationDidReceiveNewMessageFromRoom @"kNotificationDidReceiveNewMessageFromRoom"
#define kNotificationDidReceiveCallRequestFromUser @"kNotificationDidReceiveCallRequestFromUser"
#define kNotificationCallDidStartWithUser @"kNotificationCallDidStartWithUser"
#define kNotificationCallDidStopByUser @"kNotificationCallDidStopByUser"
#define kNotificationCallDidAcceptByUser @"kNotificationCallDidAcceptByUser"
#define kNotificationCallDidRejectByUser @"kNotificationCallDidRejectByUser"
#define kNotificationCallUserDidNotAnswer @"kNotificationCallUserDidNotAnswer"

#define kMessage @"message"
#define kRoomName @"roomName"
#define kUserID @"userID"
#define kCType @"conferenceType"
#define kSessionID @"sessionID"

@interface ChatService : NSObject

+ (instancetype)instance;

- (void)loginWithUser:(QBUUser *)user completionBlock:(void(^)())completionBlock;

- (void)sendMessage:(QBChatMessage *)message;

- (void)sendMessage:(NSString *)message toRoom:(QBChatRoom *)chatRoom;
- (void)createOrJoinRoomWithName:(NSString *)roomName completionBlock:(void(^)(QBChatRoom *))completionBlock;
- (void)joinRoom:(QBChatRoom *)room completionBlock:(void(^)(QBChatRoom *))completionBlock;
- (void)leaveRoom:(QBChatRoom *)room;
- (void)requestRoomsWithCompletionBlock:(void(^)(NSArray *))completionBlock;

@end
