//
//  ChatCell.h
//  Twinship
//
//  Created by Dipin Krishna on 02/03/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell {
    
}

@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *opponentGender;
@property (nonatomic, strong) NSString *opponentName;
@property (nonatomic, strong) NSString *messageID;
@property (nonatomic) int isOpponent;
@property (nonatomic, strong) NSString *chatMessage;
@property (nonatomic) int isText;
@property (nonatomic) int isImage;
@property (nonatomic) int isVideo;
@property (nonatomic) int loaded;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSDate *datetime;

@property (nonatomic, retain) IBOutlet UITableViewCell *myCell;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *picView;
@property (strong, nonatomic) IBOutlet UIImageView *videoView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (strong, nonatomic) UILabel *dateLabel;

- (void)configureCell;
+ (CGFloat)heightForCellWithMessage:(NSString *)message;
@end
