//
//  ChatRoom.h
//  Twinship
//
//  Created by Dipin Krishna on 15/12/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ChatMessage.h"

@interface ChatRoom : UIViewController <QBChatDelegate, QBActionStatusDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate> {
    NSInteger userid;
    NSInteger opponentID;
    NSString *name;
    NSString *userLogin;
    NSString *opponentName;
    NSString *gender;
    NSString *twin_gender;
    int loggedin;
    
    NSInteger chatSoundOff;
    NSInteger callSoundOff;
    
    NSMutableArray *chatMessages;
    
    //VIDEO CHAT
    IBOutlet UIButton *callButton;
    __weak IBOutlet UIButton *endButton;
    IBOutlet UILabel *ringigngLabel;
    IBOutlet UIActivityIndicatorView *callingActivityIndicator;
    IBOutlet UIActivityIndicatorView *startingCallActivityIndicator;
    IBOutlet UIImageView *opponentVideoView;
    IBOutlet UIImageView *myVideoView;
    IBOutlet UISegmentedControl *audioOutput;
    IBOutlet UISegmentedControl *videoOutput;
    
    AVAudioPlayer *ringingPlayer;
    
    //
    NSUInteger videoChatOpponentID;
    enum QBVideoChatConferenceType videoChatConferenceType;
    NSString *sessionID;
    
}
@property (weak, nonatomic) IBOutlet UITableView *chatTable;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;

@property (nonatomic, strong) QBUUser *opponent;
@property (weak, nonatomic) IBOutlet UIView *videoChatView;

- (IBAction)callBtnClicked:(id)sender;
- (IBAction)browsePicture:(id)sender;

- (IBAction)showMenu:(id)sender;

// VIDEO CHAT
//@property (retain) NSNumber *opponentID;
@property (retain) QBVideoChat *videoChat;
@property (retain) UIAlertView *callAlert;

- (IBAction)call:(id)sender;
- (void)reject;
- (void)accept;

@end
