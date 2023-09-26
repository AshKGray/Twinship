//
//  ChatRoom.m
//  Twinship
//
//  Created by Dipin Krishna on 15/12/13.
//  Copyright (c) 2013 Dipin Krishna. All rights reserved.
//

#import "ChatRoom.h"
#import "ChatCell.h"
#import "AppDelegate.h"
#import "Menu.h"

@interface ChatRoom ()  <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *chatmessages;
@property (nonatomic, weak) IBOutlet UITextField *messageTextField;
@property (nonatomic, weak) IBOutlet UIButton *sendMessageButton;
@property (nonatomic, weak) IBOutlet UITableView *messagesTableView;

- (IBAction)sendClicked:(id)sender;

@end

@implementation ChatRoom {
    UIButton *_btn1;
    UIButton *_btn2;
    UIButton *_btn3;
    UIButton *_btn4;
    UIButton *_btn5;
    UIButton *_btn6;
    UIButton *_btn7;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBarController.moreNavigationController setNavigationBarHidden:YES animated:NO];
    [self hideTabBar];
    self.messagesTableView.transform = CGAffineTransformMakeRotation(-M_PI);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoTwinstinct)
                                                 name:@"GOTOTWINSTINCT" object:nil];
    
    
    //UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"img_chatbg.png"]];
    //self.messagesTableView.backgroundColor = background;
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_chatbg.png"]];
    [tempImageView setFrame:self.messagesTableView.frame];
    
    self.messagesTableView.backgroundView = tempImageView;
    loggedin = 0;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    userid = [prefs integerForKey:@"userid"];
    userLogin = [NSString stringWithFormat:@"twinship_%ld", (long)userid];
    opponentID = [prefs integerForKey:@"opponentID"];
    name = [prefs objectForKey:@"name"];
    opponentName = [prefs objectForKey:@"twin_name"];
    gender = [prefs objectForKey:@"gender"];
    twin_gender = [prefs objectForKey:@"twin_gender"];
    chatSoundOff = [prefs integerForKey:@"chatSoundOff"];
    callSoundOff = [prefs integerForKey:@"callSoundOff"];
    
    [self authenticate];
    
    self.opponent = [QBUUser user];
    self.opponent.ID = opponentID;
    self.opponent.fullName = opponentName;
    self.opponent.login = opponentName;
    
    //[self.messagesTableView registerNib:[UINib nibWithNibName:@"ChatCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ReuseCellID"];
    
    /*
     if(self.opponent != nil){
     self.chatmessages = [[LocalStorageService shared] messageHistoryWithUserID:self.opponent.ID];
     }else{
     self.chatmessages = [NSMutableArray array];
     }
     */
    
    self.chatmessages = [NSMutableArray array];
    
    self.messagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //VIDEO CHAT
    //opponentVideoView.layer.borderWidth = 1;
    //opponentVideoView.layer.borderColor = [[UIColor grayColor] CGColor];
    //opponentVideoView.layer.cornerRadius = 5;
    
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //navBar.topItem.title = appDelegate.currentUser == 1 ? @"User 1" : @"User 2";
    //[callButton setTitle:appDelegate.currentUser == 1 ? @"Call User2" : @"Call User1" forState:UIControlStateNormal];
    
    if(!QB_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        audioOutput.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
        audioOutput.frame = CGRectMake(audioOutput.frame.origin.x-15, audioOutput.frame.origin.y, audioOutput.frame.size.width+50, audioOutput.frame.size.height);
        videoOutput.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    NSLog(@"WILL APPEAR");
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    // Set chat notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidReceiveMessageNotification:)
                                                 name:kNotificationDidReceiveNewMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidReceiveCallNotification:)
                                                 name:kNotificationDidReceiveCallRequestFromUser object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CallDidStartWithUserNotification:)
                                                 name:kNotificationCallDidStartWithUser object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CallDidStopByUserNotification:)
                                                 name:kNotificationCallDidStopByUser object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CallDidAcceptByUserNotification:)
                                                 name:kNotificationCallDidAcceptByUser object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CallDidRejectByUserNotification:)
                                                 name:kNotificationCallDidRejectByUser object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CallUserDidNotAnswerNotification:)
                                                 name:kNotificationCallUserDidNotAnswer object:nil];
    
    // Set title
    if(self.opponent != nil){
        self.title = self.opponent.login;
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    if (loggedin) {
        [self authenticate];
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    chatSoundOff = [prefs integerForKey:@"chatSoundOff"];
    callSoundOff = [prefs integerForKey:@"callSoundOff"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}


- (void)authenticate
{
    loggedin = 0;
    QBASessionCreationRequest *extendedAuthRequest = [QBASessionCreationRequest request];
    extendedAuthRequest.userLogin = userLogin;
    extendedAuthRequest.userPassword = @CHAT_PASSWORD;
    
    [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox queries delegate
- (void)completedWithResult:(Result *)result{
    
    if([result isKindOfClass:QBCFileUploadTaskResult.class]){
        
        if(result.success) {
            // get uploaded file ID
            QBCFileUploadTaskResult *res = (QBCFileUploadTaskResult *)result;
            NSUInteger uploadedFileID = res.uploadedBlob.ID;
            
            QBChatMessage *message = [[QBChatMessage alloc] init];
            message.recipientID = self.opponent.ID;
            message.senderNick = name;
            [message setCustomParameters:@{@"fileID": @(uploadedFileID)}];
            [[ChatService instance] sendMessage:message];
            
            NSLog(@"File Sent");
            /*
             ChatMessage *chatmessage = [[ChatMessage alloc] init];
             chatmessage.isOpponent = 0;
             chatmessage.isText = 0;
             chatmessage.isImage = 1;
             chatmessage.loaded = 1;
             [self.chatmessages insertObject:chatmessage atIndex:0];
             // Reload table
             [self.messagesTableView reloadData];
             */
        } else {
            [self alertStatus:@"Image was not delivered." :@"Failed!" :0];
        }
        
    }
    // Create session result
    else if(result.success && [result isKindOfClass:QBAAuthSessionCreationResult.class]){
        // You have successfully created the session
        QBAAuthSessionCreationResult *res = (QBAAuthSessionCreationResult *)result;
        
        // Sign In to QuickBlox Chat
        QBUUser *currentUser = [QBUUser user];
        currentUser.login = userLogin;
        currentUser.fullName = name;
        currentUser.ID = res.session.userID; // your current user's ID
        currentUser.password = @CHAT_PASSWORD; // your current user's password
        
        // set Chat delegate
        [QBChat instance].delegate = self;
        
        // login to Chat
        [[QBChat instance] loginWithUser:currentUser];
        //NSLog(@"%hhd",[[QBChat instance] loginWithUser:currentUser]);
        [LocalStorageService shared].currentUser = currentUser;
        
        // Subscribe Users to Push Notifications
        [QBMessages TUnregisterSubscriptionWithDelegate:self]; //Unsubscribe
        [QBMessages TRegisterSubscriptionWithDelegate:self];
        
        // Subscribe User to Push Notifications result
    }else if([result isKindOfClass:QBMRegisterSubscriptionTaskResult.class]){
        // Now you can receive Push Notifications!
        
    } else if(result.success && [result isKindOfClass:QBCFileDownloadTaskResult.class]){
        // extract image
        QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
        UIImage *image = [UIImage imageWithData:res.file];
        //NSLog(@"Message Recieved: %@", message.senderNick);
        //[self.chatmessages insertObject:message atIndex:0];
        
        ChatMessage *chatmessage = [[ChatMessage alloc] init];
        double CurrentTime = CACurrentMediaTime();
        chatmessage.messageID = [NSString stringWithFormat:@"FILE_%d", (int)CurrentTime];
        chatmessage.isOpponent = 1;
        chatmessage.isText = 0;
        chatmessage.isImage = 1;
        chatmessage.loaded = 1;
        chatmessage.image = image;
        [self.chatmessages insertObject:chatmessage atIndex:0];
        
        /*
        [self.library saveImage:image
                        toAlbum:@"Twinship"
                     completion:nil
                        failure:nil];
         */
        
        // SAVE THE IMAGE
        [self saveImage:image withName:[NSString stringWithFormat:@"%d", (int)CurrentTime]];
        
        
        // Reload table
        [self.messagesTableView reloadData];
        
    }else{
        NSLog(@"Errors=%@", result.errors);
    }
}

#pragma mark -
#pragma mark QBChatDelegate

// Chat delegate
-(void) chatDidLogin{
    // set Chat delegate
    //[QBChat instance].delegate = self;
    
    // You have successfully signed in to QuickBlox Chat
    [NSTimer scheduledTimerWithTimeInterval:30 target:[QBChat instance] selector:@selector(sendPresence) userInfo:nil repeats:YES];
    
    [self.sendMessageButton setEnabled:YES];
    [self.moreBtn setEnabled:YES];
    [self.callBtn setEnabled:YES];
    
    loggedin = 1;
    
    QBChatMessage *message = [[QBChatMessage alloc] init];
    message.recipientID = self.opponent.ID;
    message.text = @"";
    message.senderNick = name;
    [[ChatService instance] sendMessage:message];
}

-(void) chatTURNServerDidDisconnect {
    // login to Chat
    [self.sendMessageButton setEnabled:NO];
    [self authenticate];
}

- (void)chatDidReceiveMessage:(QBChatMessage *)message{
    // play sound notification
    //[self playNotificationSound];
    
    // save message to history
    //[[LocalStorageService shared] saveMessageToHistory:message withUserID:message.senderID];
    
    // notify observers
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidReceiveNewMessage
                                                        object:nil userInfo:@{kMessage: message}];
}

#pragma mark
#pragma mark Actions

- (IBAction)sendClicked:(id)sender{
    if(self.messageTextField.text.length == 0){
        return;
    }
    
    NSString * msgTxt = self.messageTextField.text;
    
    // send message
    QBChatMessage *message = [[QBChatMessage alloc] init];
    message.recipientID = self.opponent.ID;
    message.text = msgTxt;
    message.senderNick = name;
    
    
    //NSLog(@"MEsg count: %ld", (unsigned long)[self.chatmessages count]);
    // save message to history
    //[[LocalStorageService shared] saveMessageToHistory:message withUserID:message.recipientID];
    
    //NSLog(@"MEsg count: %ld", (unsigned long)[self.chatmessages count]);
    
    ChatMessage *chatmessage = [[ChatMessage alloc] init];
    chatmessage.messageID = message.ID;
    chatmessage.chatMessage = msgTxt;
    chatmessage.isOpponent = 0;
    chatmessage.isText = 1;
    chatmessage.datetime = message.datetime;
    
    [self.chatmessages insertObject:chatmessage atIndex:0];
    //NSLog(@"MEsg count: %ld", (unsigned long)[self.chatmessages count]);
    
    // Reload table
    [self.messagesTableView reloadData];
    if(self.chatmessages.count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    [[ChatService instance] sendMessage:message];
    [QBMessages TSendPushWithText:message.text toUsers:[NSString stringWithFormat:@"%ld",(long)opponentID] delegate:self];
    
    // Clean text field
    [self.messageTextField setText:nil];
}


#pragma mark
#pragma mark Chat Notifications

- (void)chatDidReceiveMessageNotification:(NSNotification *)notification{
    QBChatMessage *message = notification.userInfo[kMessage];
    NSUInteger fileID = [message.customParameters[@"fileID"] integerValue];
    if ([message.text length] > 0) {
        NSLog(@"Message Recieved: %@", message.text);
        
        ChatMessage *chatmessage = [[ChatMessage alloc] init];
        chatmessage.messageID = message.ID;
        chatmessage.chatMessage = message.text;
        chatmessage.isOpponent = 1;
        chatmessage.isText = 1;
        chatmessage.datetime = message.datetime;
        
        [self.chatmessages insertObject:chatmessage atIndex:0];
        // Reload table
        [self.messagesTableView reloadData];
        
        if(self.chatmessages.count > 0){
            [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    } else if (fileID) {
        // download file by ID
        /*
         ChatMessage *chatmessage = [[ChatMessage alloc] init];
         chatmessage.messageID = message.ID;
         chatmessage.isOpponent = 1;
         chatmessage.isText = 0;
         chatmessage.isImage = 1;
         chatmessage.loaded = 0;
         chatmessage.datetime = message.datetime;
         [self.chatmessages insertObject:chatmessage atIndex:0];
         [self.messagesTableView reloadData];
         */
        
        [QBContent TDownloadFileWithBlobID:fileID delegate:self];
        
    }
    
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"chatmessages count : %lu", (unsigned long)[self.chatmessages count]);
	return [self.chatmessages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //QBChatMessage *message = (QBChatMessage *)self.chatmessages[indexPath.row];
    ChatMessage *message = (ChatMessage *)self.chatmessages[indexPath.row];
    
    NSString *ChatMessageCellIdentifier = [NSString stringWithFormat:@"cell_%@", message.messageID] ;
    
    ChatCell *cell = (ChatCell *) [tableView dequeueReusableCellWithIdentifier:ChatMessageCellIdentifier];
    
    if(cell == nil){
        //NSLog(@"New Cell");
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatMessageCellIdentifier];
        
        cell.transform = CGAffineTransformMakeRotation(M_PI);
        cell.opponentName = opponentName;
        cell.gender = gender;
        
    }
    
    cell.isImage = message.isImage;
    cell.loaded = message.loaded;
    cell.isText = message.isText;
    cell.image = message.image;
    cell.chatMessage = message.chatMessage;
    cell.messageID = message.messageID;
    cell.isOpponent = message.isOpponent;
    cell.datetime = message.datetime;
    
    [cell configureCell];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //QBChatMessage *chatMessage = (QBChatMessage *)[self.chatmessages objectAtIndex:indexPath.row];
    ChatMessage *chatMessage = (ChatMessage *)[self.chatmessages objectAtIndex:indexPath.row];
    if (chatMessage.isText) {
        CGFloat cellHeight = [ChatCell heightForCellWithMessage:chatMessage.chatMessage];
        return cellHeight;
    } else if (chatMessage.isImage) {
        return 160;
    }
    return 160;
}


#pragma mark
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark
#pragma mark Keyboard notifications

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-220, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
    /*
     [UIView animateWithDuration:0.3 animations:^{
     self.messageTextField.transform = CGAffineTransformMakeTranslation(0, -415);
     self.sendMessageButton.transform = CGAffineTransformMakeTranslation(0, -415);
     }];
     */
    
    return  TRUE;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+220, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
    return  TRUE;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
    alertView.tag = tag;
    
    [alertView show];
}

- (IBAction)callBtnClicked:(id)sender {
    //[self alertStatus:@"Are you sure?" :@"Temp Logout!" :101];
    if(self.videoChatView.hidden) {
        [self.videoChatView setHidden:NO];
    }else {
        
        [self.videoChatView setHidden:YES];
    }
}

/*
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
 
 //  the user clicked one of the OK/Cancel buttons
 if(alertView.tag == 101)     // check alert by tag
 {
 
 if (buttonIndex == 0)
 
 {
 NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
 [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
 [self performSegueWithIdentifier:@"chat_logout" sender:self];
 }
 
 else
 
 {
 NSLog(@"cancel");
 }
 }
 }*/


- (IBAction)browsePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)logOut:(id)sender {
    [self alertStatus:@"Are you sure?" :@"Logout!" :201];
}

- (IBAction)showMenu:(id)sender {
    //[self alertStatus:@"Are you sure?" :@"Temp Logout!" :201];
    NSArray *menuItems =
    @[
      [MenuItem menuItem:@"Chat"
                   image:nil
                  target:nil
                  action:NULL],
      
      [MenuItem menuItem:@"Twinstinct"
                   image:[UIImage imageNamed:@"img_t"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Twinspirational Moments"
                   image:[UIImage imageNamed:@"img_m"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Twincidence"
                   image:[UIImage imageNamed:@"img_i"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Twinterests"
                   image:[UIImage imageNamed:@"img_in"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Plans and Events"
                   image:[UIImage imageNamed:@"img_pe"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      [MenuItem menuItem:@"Settings"
                   image:[UIImage imageNamed:@"img_s"]
                  target:self
                  action:@selector(pushMenuItem:)],
      
      ];
    
    MenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [Menu showMenuInView:self.view
                fromRect:((UIButton*)sender).frame
               menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    //NSLog(@"%@", ((MenuItem*)sender).title);
    NSString *title = ((MenuItem*)sender).title;
    if ([title isEqualToString: @"Twinstinct"]) {
        self.tabBarController.selectedIndex = 1;
    } else if ([title isEqualToString: @"Twinspirational Moments"]) {
        self.tabBarController.selectedIndex = 2;
    } else if ([title isEqualToString: @"Twincidence"]) {
        self.tabBarController.selectedIndex = 3;
    } else if ([title isEqualToString: @"Twinterests"]) {
        self.tabBarController.selectedIndex = 4;
    } else if ([title isEqualToString: @"Plans and Events"]) {
        self.tabBarController.selectedIndex = 5;
    } else if ([title isEqualToString: @"Settings"]) {
        self.tabBarController.selectedIndex = 6;
    } else if ([title isEqualToString: @"Chat"]) {
        self.tabBarController.selectedIndex = 0;
    }
}

- (void) gotoTwinstinct {
    self.tabBarController.selectedIndex = 1;
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSString *imageName = [imagePath lastPathComponent];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    /*
     [self.library saveImage:image
     toAlbum:@"Twinship"
     completion:nil
     failure:nil];
     */
    double CurrentTime = CACurrentMediaTime();
    [self saveImage:image withName:[NSString stringWithFormat:@"%d", (int)CurrentTime]];
    
    // Upload pic to Content module
    NSData *imagedata = UIImageJPEGRepresentation(image, 0.7);
    //
    [QBContent TUploadFile:imagedata fileName:imageName contentType:@"image/jpeg" isPublic:NO delegate:self];
    
    ChatMessage *chatmessage = [[ChatMessage alloc] init];
    chatmessage.messageID = [NSString stringWithFormat:@"FILE_%d", (int)CurrentTime];
    chatmessage.isOpponent = 0;
    chatmessage.isText = 0;
    chatmessage.isImage = 1;
    chatmessage.loaded = 1;
    chatmessage.image = image;
    [self.chatmessages insertObject:chatmessage atIndex:0];
    [self.messagesTableView reloadData];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
}

- (void)hideTabBar {
    [self.tabBarController.tabBar setHidden:YES];
    [self.tabBarController.moreNavigationController setNavigationBarHidden:YES animated:NO];
}


// VIDEO CHAT


- (IBAction)audioOutputDidChange:(UISegmentedControl *)sender{
    if(self.videoChat != nil){
        self.videoChat.useHeadphone = sender.selectedSegmentIndex;
    }
}

- (IBAction)videoOutputDidChange:(UISegmentedControl *)sender{
    if(self.videoChat != nil){
        self.videoChat.useBackCamera = sender.selectedSegmentIndex;
    }
}

- (IBAction)call:(id)sender{
    // Call
    if([sender tag] == 101){
        //callButton.tag = 102;
        
        // Setup video chat
        //
        if(self.videoChat == nil){
            self.videoChat = [[QBChat instance] createAndRegisterVideoChatInstance];
            self.videoChat.viewToRenderOpponentVideoStream = opponentVideoView;
            self.videoChat.viewToRenderOwnVideoStream = myVideoView;
        }
        
        // Set Audio & Video output
        //
        self.videoChat.useHeadphone = audioOutput.selectedSegmentIndex;
        self.videoChat.useBackCamera = videoOutput.selectedSegmentIndex;
        
        // Call user by ID
        //
        [QBChat instance].delegate = self;
        [self.videoChat callUser:opponentID conferenceType:QBVideoChatConferenceTypeAudioAndVideo];
        
        callButton.hidden = YES;
        endButton.hidden = NO;
        ringigngLabel.hidden = NO;
        ringigngLabel.text = @"Calling...";
        //ringigngLabel.frame = CGRectMake(128, 375, 90, 37);
        //callingActivityIndicator.hidden = NO;
        
        [startingCallActivityIndicator setHidden:NO];
        [startingCallActivityIndicator startAnimating];
        
        // Finish
    }else{
        //callButton.tag = 101;
        //callButton.imageView.image = [UIImage imageNamed:@"acceptcall"];
        ringigngLabel.text = @"Ending...";
        [endButton setEnabled:FALSE];
        
        // Finish call
        //
        [self.videoChat finishCall];
        
        myVideoView.hidden = YES;
        //opponentVideoView.layer.contents = (id)[[UIImage imageNamed:@"person.png"] CGImage];
        //opponentVideoView.image = [UIImage imageNamed:@"person.png"];
        //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //[callButton setTitle:appDelegate.currentUser == 1 ? @"Call User2" : @"Call User1" forState:UIControlStateNormal];
        
        opponentVideoView.layer.contents = nil;
        opponentVideoView.image = nil;
        
        opponentVideoView.layer.borderWidth = 1;
        
        startingCallActivityIndicator.hidden = YES;
        [startingCallActivityIndicator stopAnimating];
        
        
        // release video chat
        //
        [[QBChat instance] unregisterVideoChatInstance:self.videoChat];
        self.videoChat = nil;
        ringigngLabel.hidden = YES;
        
        endButton.hidden = YES;
        [endButton setEnabled:TRUE];
        callButton.hidden = NO;
    }
}

- (void)reject{
    // Reject call
    //
    if(self.videoChat == nil){
        self.videoChat = [[QBChat instance] createAndRegisterVideoChatInstanceWithSessionID:sessionID];
    }
    [self.videoChat rejectCallWithOpponentID:videoChatOpponentID];
    //
    //
    [[QBChat instance] unregisterVideoChatInstance:self.videoChat];
    self.videoChat = nil;
    
    // update UI
    callButton.imageView.image = [UIImage imageNamed:@"acceptcall"];
    callButton.hidden = NO;
    ringigngLabel.hidden = YES;
    ringingPlayer = nil;
}

- (void)accept{
    NSLog(@"accept");
    
    [self.videoChatView setHidden:NO];
    
    [QBChat instance].delegate = self;
    // Setup video chat
    //
    if(self.videoChat == nil){
        self.videoChat = [[QBChat instance] createAndRegisterVideoChatInstanceWithSessionID:sessionID];
        self.videoChat.viewToRenderOpponentVideoStream = opponentVideoView;
        self.videoChat.viewToRenderOwnVideoStream = myVideoView;
    }
    
    // Set Audio & Video output
    //
    self.videoChat.useHeadphone = audioOutput.selectedSegmentIndex;
    self.videoChat.useBackCamera = videoOutput.selectedSegmentIndex;
    
    // Accept call
    //
    [self.videoChat acceptCallWithOpponentID:videoChatOpponentID conferenceType:videoChatConferenceType];
    
    ringigngLabel.hidden = YES;
    callButton.hidden = YES;
    //[callButton setTitle:@"Hang up" forState:UIControlStateNormal];
    //callButton.imageView.image = [UIImage imageNamed:@"rejectcall"];
    endButton.hidden = NO;
    //callButton.tag = 102;
    
    opponentVideoView.layer.borderWidth = 0;
    
    [startingCallActivityIndicator setHidden:NO];
    [startingCallActivityIndicator startAnimating];
    
    myVideoView.hidden = NO;
    
    ringingPlayer = nil;
}

- (void)hideCallAlert{
    [self.callAlert dismissWithClickedButtonIndex:-1 animated:YES];
    self.callAlert = nil;
    
    //callButton.hidden = NO;
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    ringingPlayer = nil;
}


#pragma mark -
#pragma mark QBChatDelegate
//
// VideoChat delegate

//-(void) chatDidReceiveCallRequestFromUser:(NSUInteger)userID withSessionID:(NSString *)_sessionID conferenceType:(enum QBVideoChatConferenceType)conferenceType{
- (void)chatDidReceiveCallNotification:(NSNotification *)notification{
    
    
    NSLog(@"chatDidReceiveCallRequestFromUser");
    
    // save  opponent data
    //videoChatOpponentID = userID;
    //videoChatConferenceType = conferenceType;
    //sessionID = _sessionID;//[_sessionID retain];
    
    videoChatOpponentID = opponentID;
    videoChatConferenceType = QBVideoChatConferenceTypeAudioAndVideo;
    sessionID = notification.userInfo[kMessage];
    
    
    
    callButton.hidden = YES;
    
    // show call alert
    //
    if (self.callAlert == nil) {
        //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *message = [NSString stringWithFormat:@"%@ is calling. Would you like to answer?", opponentName];
        self.callAlert = [[UIAlertView alloc] initWithTitle:@"Call" message:message delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Accept", nil];
        [self.callAlert show];
    }
    
    // hide call alert if opponent has canceled call
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideCallAlert) object:nil];
    [self performSelector:@selector(hideCallAlert) withObject:nil afterDelay:4];
    
    // play call music
    //
    if (!callSoundOff) {
        if(ringingPlayer == nil){
            NSString *path =[[NSBundle mainBundle] pathForResource:@"ringing" ofType:@"wav"];
            NSURL *url = [NSURL fileURLWithPath:path];
            ringingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
            ringingPlayer.delegate = self;
            [ringingPlayer setVolume:1.0];
            [ringingPlayer play];
        }
    }
    
}

//-(void) chatCallUserDidNotAnswer:(NSUInteger)userID{
- (void)CallUserDidNotAnswerNotification:(NSNotification *)notification{
    NSLog(@"chatCallUserDidNotAnswer");
    
    endButton.hidden = YES;
    callButton.hidden = NO;
    ringigngLabel.hidden = YES;
    callingActivityIndicator.hidden = YES;
    [startingCallActivityIndicator setHidden:YES];
    [startingCallActivityIndicator stopAnimating];
    //callButton.tag = 101;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twinship VideoChat" message:@"User isn't answering. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

//-(void) chatCallDidRejectByUser:(NSUInteger)userID{
- (void)CallDidRejectByUserNotification:(NSNotification *)notification{
    NSLog(@"chatCallDidRejectByUser");
    
    endButton.hidden = YES;
    callButton.hidden = NO;
    ringigngLabel.hidden = YES;
    callingActivityIndicator.hidden = YES;
    
    //callButton.tag = 101;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twinship VideoChat" message:@"User has rejected your call." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

//-(void) chatCallDidAcceptByUser:(NSUInteger)userID{
- (void)CallDidAcceptByUserNotification:(NSNotification *)notification{
    NSLog(@"chatCallDidAcceptByUser");
    
    ringigngLabel.hidden = YES;
    callingActivityIndicator.hidden = YES;
    
    opponentVideoView.layer.borderWidth = 0;
    
    endButton.hidden = NO;
    callButton.hidden = NO;
    //[callButton setTitle:@"Hang up" forState:UIControlStateNormal];
    //callButton.tag = 102;
    
    myVideoView.hidden = NO;
    
    [startingCallActivityIndicator setHidden:NO];
    [startingCallActivityIndicator startAnimating];
}

//-(void) chatCallDidStopByUser:(NSUInteger)userID status:(NSString *)status{
- (void)CallDidStopByUserNotification:(NSNotification *)notification{
    //NSLog(@"chatCallDidStopByUser %d purpose %@", userID, status);
    NSString *status = notification.userInfo[kMessage];
    
    if([status isEqualToString:kStopVideoChatCallStatus_OpponentDidNotAnswer]){
        
        self.callAlert.delegate = nil;
        [self.callAlert dismissWithClickedButtonIndex:0 animated:YES];
        self.callAlert = nil;
        
        ringigngLabel.hidden = YES;
        
        ringingPlayer = nil;
        
    }else{
        myVideoView.hidden = YES;
        //opponentVideoView.layer.contents = (id)[[UIImage imageNamed:@"person.png"] CGImage];
        //opponentVideoView.layer.borderWidth = 1;
        //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //[callButton setTitle:appDelegate.currentUser == 1 ? @"Call User2" : @"Call User1" forState:UIControlStateNormal];
        //callButton.tag = 101;
    }
    
    ringigngLabel.hidden = YES;
    endButton.hidden = YES;
    callButton.hidden = NO;
    
    // release video chat
    //
    [[QBChat instance] unregisterVideoChatInstance:self.videoChat];
    self.videoChat = nil;
}

- (void)CallDidStartWithUserNotification:(NSNotification *)notification{
    [startingCallActivityIndicator setHidden:YES];
    [startingCallActivityIndicator stopAnimating];
    ringigngLabel.hidden = YES;
}

- (void)didStartUseTURNForVideoChat{
    //    NSLog(@"_____TURN_____TURN_____");
}





-(void) chatDidReceiveCallRequestFromUser:(NSUInteger)userID withSessionID:(NSString *)t_sessionID conferenceType:(enum QBVideoChatConferenceType)conferenceType{
    
    
    NSLog(@"INCOMING CALL");
    //NSInteger userid = userID;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidReceiveCallRequestFromUser
                                                        object:nil userInfo:@{kMessage: t_sessionID}];
}

- (void)chatCallDidStartWithUser:(NSUInteger)userID sessionID:(NSString *)t_sessionID{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCallDidStartWithUser
                                                        object:nil userInfo:@{kSessionID: t_sessionID}];
}

-(void) chatCallDidStopByUser:(NSUInteger)userID status:(NSString *)status{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCallDidStopByUser
                                                        object:nil userInfo:@{kSessionID: status}];
}

-(void) chatCallDidAcceptByUser:(NSUInteger)userID{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCallDidAcceptByUser
                                                        object:nil userInfo:@{}];
}

-(void) chatCallDidRejectByUser:(NSUInteger)userID{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCallDidRejectByUser
                                                        object:nil userInfo:@{}];
}

-(void) chatCallUserDidNotAnswer:(NSUInteger)userID{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCallUserDidNotAnswer
                                                        object:nil userInfo:@{}];
}






#pragma mark -
#pragma mark UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 201)     // check alert by tag
    {
        
        if (buttonIndex == 0)
            
        {
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            [self performSegueWithIdentifier:@"chat_logout" sender:self];
        }
        
        else
            
        {
            NSLog(@"cancel");
        }
    } else {
        switch (buttonIndex) {
                // Reject
            case 0:
                [self reject];
                break;
                // Accept
            case 1:
                [self accept];
                break;
                
            default:
                break;
        }
        
        self.callAlert = nil;
    }
}




- (void)saveImage:(UIImage*)image withName:(NSString*)imageName {
    
    NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    
    //NSLog(@"image saved: %@ at %@", imageData, fullPath);
    
}

@end
