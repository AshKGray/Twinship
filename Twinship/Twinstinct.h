//
//  Twinstinct.h
//  Twinship
//
//  Created by Dipin Krishna on 24/03/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"

@interface Twinstinct : UIViewController<QBActionStatusDelegate> {
    NSTimer *timer;
    int countDown;
    NSInteger gameid;
    NSInteger existing;
    float progress;
    NSInteger requestInProgress;
    NSString *gender;
    NSString *email;
    NSString *key;
    NSString *randomNumber;
    NSInteger opponentID;
}

- (IBAction)showMenu:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *randTxt;
@property (weak, nonatomic) IBOutlet UITextField *inputTxt;
//@property (weak, nonatomic) IBOutlet UILabel *timerTxt;
@property (weak, nonatomic) IBOutlet UIButton *clicktoreveal;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *pleasewait;
@property (weak, nonatomic) IBOutlet UIButton *match;
@property (weak, nonatomic) IBOutlet UIButton *nomatch;
@property (weak, nonatomic) IBOutlet UIButton *inputBtn;
@property (weak, nonatomic) IBOutlet DACircularProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *tryAgain;
@property (weak, nonatomic) IBOutlet UIButton *endGame;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (weak, nonatomic) IBOutlet UIButton *mentallyFocus;
@property (weak, nonatomic) IBOutlet UIButton *twinIsThinking;
@property (weak, nonatomic) IBOutlet UIButton *shownumber;



- (IBAction)endGame:(id)sender;
- (IBAction)showNumber:(id)sender;

- (IBAction)inputBtnClicked:(id)sender;
- (IBAction)revealClicked:(id)sender;
- (IBAction)startClicked:(id)sender;
- (IBAction)tryAgain:(id)sender;
@end
